// functions/thumbnail/index.ts
// Consumes messages from the `thumbnails` SQS queue.
// Produces a 96x96 JPEG thumbnail and marks the upload complete in DynamoDB.
import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';
import { DynamoDBClient, UpdateItemCommand } from '@aws-sdk/client-dynamodb';
import sharp from 'sharp';

const s3 = new S3Client();
const ddb = new DynamoDBClient();

const BUCKET = process.env.IMAGES_BUCKET!;
const TABLE = process.env.UPLOADS_TABLE!;

interface SQSMessage {
  body: string;
}

interface ThumbnailPayload {
  uploadId: string;
  variants: Record<string, string>;
}

export const handler = async (event: { Records: SQSMessage[] }): Promise<{ success: true }> => {
  for (const record of event.Records) {
    const payload = JSON.parse(record.body) as ThumbnailPayload;
    const { uploadId } = payload;

    const originalKey = `${uploadId}/medium.jpg`;
    const get = await s3.send(
      new (await import('@aws-sdk/client-s3')).GetObjectCommand({ Bucket: BUCKET, Key: originalKey }),
    );
    if (!get.Body) throw new Error('no body');
    const buf = Buffer.from(await get.Body.transformToByteArray());

    const thumb = await sharp(buf).resize({ width: 96, height: 96, fit: 'cover' }).jpeg({ quality: 75 }).toBuffer();

    await s3.send(
      new PutObjectCommand({
        Bucket: BUCKET,
        Key: `${uploadId}/thumb.jpg`,
        Body: thumb,
        ContentType: 'image/jpeg',
      }),
    );

    await ddb.send(
      new UpdateItemCommand({
        TableName: TABLE,
        Key: { uploadId: { S: uploadId } },
        UpdateExpression: 'SET #s = :s, thumbnailKey = :k',
        ExpressionAttributeNames: { '#s': 'status' },
        ExpressionAttributeValues: {
          ':s': { S: 'complete' },
          ':k': { S: `${uploadId}/thumb.jpg` },
        },
      }),
    );
  }

  return { success: true };
};
// functions/resize/index.ts
// Triggered by S3 ObjectCreated on raw/ prefix. Produces medium + large variants,
// then enqueues a message to the `thumbnails` SQS queue.
import { S3Client, GetObjectCommand, PutObjectCommand } from '@aws-sdk/client-s3';
import { SQSClient, SendMessageCommand } from '@aws-sdk/client-sqs';
import { DynamoDBClient, UpdateItemCommand } from '@aws-sdk/client-dynamodb';
import sharp from 'sharp';

const s3 = new S3Client();
const sqs = new SQSClient();
const ddb = new DynamoDBClient();

const BUCKET = process.env.IMAGES_BUCKET!;
const QUEUE_URL = process.env.THUMBNAIL_QUEUE_URL!;
const TABLE = process.env.UPLOADS_TABLE!;

interface S3EventRecord {
  s3: { object: { key: string } };
}

const VARIANTS = [
  { suffix: 'medium', width: 800 },
  { suffix: 'large', width: 1600 },
];

export const handler = async (event: { Records: S3EventRecord[] }): Promise<{ processed: number }> => {
  let processed = 0;

  for (const record of event.Records) {
    const key = record.s3.object.key; // "<uploadId>/original"
    const uploadId = key.split('/')[0];

    const original = await s3.send(new GetObjectCommand({ Bucket: BUCKET, Key: key }));
    if (!original.Body) throw new Error('empty body from S3');
    const buf = Buffer.from(await original.Body.transformToByteArray());

    const variants: Record<string, string> = {};
    for (const v of VARIANTS) {
      const out = await sharp(buf).resize({ width: v.width }).jpeg({ quality: 82 }).toBuffer();
      const outKey = `${uploadId}/${v.suffix}.jpg`;
      await s3.send(new PutObjectCommand({ Bucket: BUCKET, Key: outKey, Body: out, ContentType: 'image/jpeg' }));
      variants[v.suffix] = outKey;
    }

    await sqs.send(
      new SendMessageCommand({
        QueueUrl: QUEUE_URL,
        MessageBody: JSON.stringify({ uploadId, variants }),
      }),
    );

    await ddb.send(
      new UpdateItemCommand({
        TableName: TABLE,
        Key: { uploadId: { S: uploadId } },
        UpdateExpression: 'SET #s = :s',
        ExpressionAttributeNames: { '#s': 'status' },
        ExpressionAttributeValues: { ':s': { S: 'resized' } },
      }),
    );

    processed++;
  }

  return { processed };
};
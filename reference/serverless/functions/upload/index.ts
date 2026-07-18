// functions/upload/index.ts
// Receives multipart upload via API Gateway, writes raw object to S3.
import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';
import { DynamoDBClient, UpdateItemCommand, ConditionalCheckFailedException } from '@aws-sdk/client-dynamodb';
import { randomUUID } from 'node:crypto';

const s3 = new S3Client();
const ddb = new DynamoDBClient();

const BUCKET = process.env.RAW_BUCKET!;
const TABLE = process.env.UPLOADS_TABLE!;

interface ApiGatewayEvent {
  body?: string;
  isBase64Encoded?: boolean;
  headers?: Record<string, string>;
}

export const handler = async (event: ApiGatewayEvent): Promise<{ statusCode: number; body: string }> => {
  if (!event.body) {
    return { statusCode: 400, body: JSON.stringify({ error: 'NO_BODY' }) };
  }

  const uploadId = randomUUID();
  const buffer = Buffer.from(event.body, event.isBase64Encoded ? 'base64' : 'utf8');

  if (buffer.byteLength > 10 * 1024 * 1024) {
    return { statusCode: 413, body: JSON.stringify({ error: 'FILE_TOO_LARGE' }) };
  }

  await s3.send(
    new PutObjectCommand({
      Bucket: BUCKET,
      Key: `${uploadId}/original`,
      Body: buffer,
      ContentType: event.headers?.['content-type'] ?? 'application/octet-stream',
    }),
  );

  try {
    await ddb.send(
      new UpdateItemCommand({
        TableName: TABLE,
        Key: { uploadId: { S: uploadId } },
        UpdateExpression: 'SET #s = :s, createdAt = :now',
        ConditionExpression: 'attribute_not_exists(uploadId)',
        ExpressionAttributeNames: { '#s': 'status' },
        ExpressionAttributeValues: { ':s': { S: 'uploaded' }, ':now': { S: new Date().toISOString() } },
      }),
    );
  } catch (ConditionalCheckFailedException) {
    return { statusCode: 409, body: JSON.stringify({ error: 'IDEMPOTENCY_CONFLICT' }) };
  }

  return {
    statusCode: 202,
    body: JSON.stringify({ uploadId, status: 'uploaded' }),
  };
};
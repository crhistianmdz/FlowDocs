// shared/utils/index.ts
// Framework-agnostic helpers used across all Lambda functions.
import crypto from 'node:crypto';

export function randomId(): string {
  return crypto.randomUUID();
}

export function parseS3Key(key: string): { uploadId: string; filename: string } {
  const [uploadId, filename] = key.split('/');
  return { uploadId, filename };
}

export function nowIso(): string {
  return new Date().toISOString();
}
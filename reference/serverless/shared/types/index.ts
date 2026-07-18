// shared/types/index.ts
export type UploadStatus = 'uploaded' | 'resized' | 'complete' | 'failed';

export interface UploadMetadata {
  uploadId: string;
  status: UploadStatus;
  createdAt: string;
  thumbnailKey?: string;
}

export interface ThumbnailPayload {
  uploadId: string;
  variants: Record<string, string>;
}
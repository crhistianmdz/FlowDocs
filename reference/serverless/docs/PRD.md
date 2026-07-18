# PRD — ImageProcessor

## 1. System Overview

- **Project**: ImageProcessor
- **Architecture**: Serverless (event-driven, AWS)
- **Description**: API users upload images to; backend automatically resizes, generates thumbnails, and stores metadata in DynamoDB. Fully asynchronous after the initial upload HTTP call.

---

## 2. Functional Requirements

### Main Use Cases
1. **Upload**: client POSTs image (≤10MB) → returns `uploadId`.
2. **Resize**: triggered by S3 event on `raw/` prefix → produces `medium/` + `large/`.
3. **Thumbnail**: SQS message per resized image → produces `thumb/` (96x96).
4. **Status**: client polls `/status/:uploadId` for completion.

### Exemplary User Flow
1. Client → POST `/upload` (multipart) → API Gateway → upload lambda → writes `raw/<uploadId>/<file>` to S3 → returns `{ uploadId }`.
2. S3 emits `ObjectCreated` → resize lambda writes `medium/`, `large/` → puts SQS message.
3. thumbnail lambda consumes SQS → writes `thumb/` → marks upload complete.

---

## 3. Testing
- **Unit**: Vitest per function handler (mock AWS SDK).
- **Integration**: localstack + `sls invoke`.
- **E2E**: staging cycle: upload → wait → GET `/status` returns complete.

---

## 4. Edge Cases
1. Image corrupted → resize throws → DLQ, mark status `failed`.
2. Duplicate `uploadId` retry → idempotent via Dynamo conditional write.
3. Cold start on thumbnail during burst → provisioned concurrency 2.

---

## 5. Non-Functional Requirements
- **Cost**: < $50/mo at 100k uploads.
- **Performance**: p50 upload ack < 800ms; thumbnail p95 < 5s.
- **Security**: signed URLs; API key + IAM role per function.

---

## Success Indicators
- 99.9% of uploads fully processed within 30s.
- Zero silent DLQ drops.

---

**Last Updated**: 2026-07-18
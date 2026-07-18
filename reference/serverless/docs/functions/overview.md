# Functions Overview

| Function  | Trigger                          | Runtime     | Memory | Timeout | Purpose                             |
|-----------|----------------------------------|-------------|-------:|--------:|-------------------------------------|
| upload    | HTTP POST /upload (API Gateway)   | nodejs20.x  | 512 MB | 30s     | Accept multipart, write to S3 raw/  |
| resize    | S3 ObjectCreated (raw/ prefix)    | nodejs20.x  | 1 GB   | 60s     | Produce medium/ + large/ variants   |
| thumbnail | SQS `thumbnails` queue            | nodejs20.x  | 512 MB | 15s     | Produce 96x96 thumbnail             |

## Events Flow

```
[Client POST /upload]
        │
        ▼
   [upload lambda] ──writes──> s3://images/raw/<uploadId>/<file>
                                       │
                                       │ S3 ObjectCreated
                                       ▼
                              [resize lambda]
                                       │
                                       ├─ writes s3://images/medium/...
                                       ├─ writes s3://images/large/...
                                       └─ enqueue SQS: thumbnails
                                                  │
                                                  ▼
                                          [thumbnail lambda]
                                                  │
                                                  ├─ writes s3://images/thumb/...
                                                  └─ DynamoDB: status=complete
```

## DLQ Strategy
- All functions → per-target SQS DLQ retained 14 days.
- DLQ → SNS → ops alert email on non-zero depth.

---

**Last Updated**: 2026-07-18
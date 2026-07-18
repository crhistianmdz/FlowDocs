# RFC — ImageProcessor

Proposals under discussion. One file per RFC (`NNN-title.md`).

## Open RFCs

### RFC-001: DynamoDB vs Aurora Serverless v2 for upload metadata
- **Status**: In Review
- **Author**: @infra-lead
- **Date**: 2026-04-05
- **Summary**: DynamoDB single-table for upload metadata vs Aurora Serverless v2 (Postgres). DynamoDB chosen tentatively for zero-admin scaling. Aurora considered for relational query patterns not present here.
- **Decision pending**: wise to wait for thumbnail completion to finalize access patterns.

### RFC-002: Use Step Functions for orchestration?
- **Status**: Draft
- **Summary**: Replace SQS+SNS chaining with a Step Function workflow per upload. Trade-off: clearer state machine vs more ops overhead + higher cost at low volume.

---

> When an RFC is approved → record as ADR (add `docs/architecture/adr/` if it grows).
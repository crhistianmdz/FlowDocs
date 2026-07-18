# Agent Context — ImageProcessor (Serverless)

## Project

- **Name**: ImageProcessor
- **Type**: Serverless (event-driven, AWS Lambda)
- **Created**: 2026-04-01
- **Owner**: @infra-lead

## Stack

| Layer       | Tech                          |
|-------------|-------------------------------|
| Provider    | AWS (Lambda, S3, SQS, SNS)    |
| Runtime     | Node.js 20.x                  |
| IaC         | Terraform 1.x                 |
| Framework   | Serverless Framework 3        |
| Language    | TypeScript                    |
| Observability | CloudWatch + OpenTelemetry  |

## Functions

| Function   | Path                    | Trigger                    | Owner      | Status |
|------------|-------------------------|----------------------------|------------|--------|
| upload     | `functions/upload/`       | HTTP (API Gateway)         | @api-lead  | ✅     |
| resize     | `functions/resize/`       | S3 `ObjectCreated` event   | @img-lead  | 🔄     |
| thumbnail  | `functions/thumbnail/`    | SQS `thumbnails` queue      | @img-lead  | ⏳     |

## Sources of Truth

- **PRD**: `docs/PRD.md`
- **RFCs**: `docs/RFC.md` (or `docs/architecture/rfc/` when many)
- **Function docs**: `functions/<fn>/docs/HU-XXX-*.md`
- **Events flow**: `docs/functions/events-flow.md`
- **IaC**: `infrastructure/terraform/`

## Rules

- Each function must be **independently deployable**.
- Cross-function dependencies → SQS/SNS, NOT direct imports.
- No persistent state in function memory (idempotent handlers).
- Cold-start sensitive functions keep warm provisioned concurrency (config here, not in code).

---

**Last Updated**: 2026-07-18
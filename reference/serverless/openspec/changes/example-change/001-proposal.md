# Proposal — add retry + DLQ alerts for thumbnail

## Intent
Operational improvement: surface DLQ depth to ops via SNS email so failures are not silently dropped.

## Scope
- Wire CloudWatch alarm (already in main.tf) to existing ops SNS topic.
- Document remediation runbook.
- Add unit test that simulates failed message → DLQ receives.

## Approach
Reuse variables.alert_topic_arn — no new infra; terraform apply wires it.

## Risks
- Alert spam if intrinsic; mitigate with 1-min period + threshold 0 + datapoints 3.

## Out of scope
- Slack alert integration (Phase 2).
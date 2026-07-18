# Spec — DLQ alerting for thumbnail

## Requirements

### REQ-1 CloudWatch alarm
- Alarm `thumb-dlq-depth` > 0 over 60s triggers SNS publish.

### REQ-2 Remediation runbook
- `docs/functions/thumbnail-dlq.md` describing inspection and redrive commands.

## Scenarios

### Scenario: failed thumbnail
- GIVEN thumbnail lambda raises for 3 attempts
- WHEN SQS rejects all → message lands in thumbnail_dlq
- THEN alarm fires within 60s → SNS sends email

### Scenario: false alarm
- GIVEN transient spike cleared by re-drive
- WHEN queue empties within 3 datapoints
- THEN alarm clears automatically
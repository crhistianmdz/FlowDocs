# Design — DLQ alerting

## Wire
main.tf already has:
```
aws_cloudwatch_metric_alarm.thumb_dlq
  alarm_actions = [var.alert_topic_arn]
```
No new infra; only `tfvars` per stage.

## Decisions
- Reuse existing SNS topic for DLQ alerts (avoid topic fragmentation).
- Add runbook at `docs/functions/thumbnail-dlq.md`.
- Add Vitest case that mocks SQS redrive.

## Open questions
- Should redrive be automated via Lambda when alarm fires? Prefer manual initially (avoids feedback loops).
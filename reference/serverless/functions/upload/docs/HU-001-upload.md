# HU-001: Upload endpoint (upload function)

## Información General
- **ID**: HU-001
- **Prioridad**: P0
- **Function**: upload
- **Estimado**: 1 día

## User Story

**Como** cliente autenticado
**Quiero** subir una imagen (≤10MB) vía HTTP
**Para** disparar el pipeline de procesamiento asíncrono

## Criterios de Aceptación

### Funcionales
- [ ] POST `/upload` (API Gateway) → multipart body
- [ ] Genera `uploadId` UUID
- [ ] Escribe `s3://images/<uploadId>/original`
- [ ] Inserta DynamoDB row idempotente (ConditionExpression)
- [ ] Retorna 202 `{ uploadId, status: 'uploaded' }`

### No Funcionales
- [ ] p95 ack < 800ms (excluyendo red)
- [ ] Timeout 30s; Memory 512MB
- [ ] Cobertura ≥80% handler (Vitest + AWS SDK mock)
- [ ] Idempotency: retry con mismo `uploadId` → 409 (condición falla)

## Triggers & Resources

| Resource          | Value                                  |
|-------------------|---------------------------------------|
| Trigger           | HTTP POST /upload (API Gateway)       |
| DLQ               | `upload-dlq` (SQS)                     |
| S3 bucket         | env `RAW_BUCKET` (alias IMAGES_BUCKET) |
| DynamoDB          | env `UPLOADS_TABLE`                    |

## Dependencies
- [ ] Terraform: bucket + table provisionados
- [ ] API Gateway + /upload route

## Definition of Done
- [ ] Implementado + tests
- [ ] `serverless.yml` actualizado
- [ ] Terraform repos provisionados en staging
- [ ] E2E manual en staging OK

---

**Created**: 2026-04-03
**Author**: @api-lead
**Status**: ✅ Done
# HU-002: Resize images on S3 event (resize function)

## Información General
- **ID**: HU-002
- **Prioridad**: P0
- **Function**: resize
- **Estimado**: 2 días

## User Story

**Como** pipeline serverless
**Quiero** reaccionar a subidas nuevas en `raw/` y producir variantes medium/large
**Para** que la app web y mobile puedan servir imágenes optimizadas

## Criterios de Aceptación

### Funcionales
- [ ] Triggered por S3 `ObjectCreated` en key `<uploadId>/original`
- [ ] Produce `medium.jpg` (800px) y `large.jpg` (1600px) en JPEG calidad 82
- [ ] Encola mensaje SQS `thumbnails` con `{ uploadId, variants }`
- [ ] Marca DynamoDB status `resized`
- [ ] Maneja batches (múltiples Records/event)

### No Funcionales
- [ ] Memory 1024MB; timeout 60s
- [ ] p95 por imagen < 3s
- [ ] Cobertura ≥80%
- [ ] Tolerante: imagen inválida → captura error, no rompe batch

## Triggers & Resources

| Resource      | Value                                  |
|---------------|----------------------------------------|
| Trigger       | S3 event `ObjectCreated:raw/`          |
| DLQ           | `resize-dlq`                           |
| Reads         | `IMAGES_BUCKET` (raw prefix)          |
| Writes        | `IMAGES_BUCKET` (medium, large)       |
| Emits         | SQS `THUMBNAIL_QUEUE_URL`             |
| Updates       | DynamoDB `UPLOADS_TABLE`              |

## Dependencies
- [ ] HU-001 upload desplegado (genera los objetos)
- [ ] SQS `thumbnails` + DLQ provisionados
- [ ] Lambda layer con `sharp` instalado

## Definition of Done
- [ ] Implementado + tests (mock S3/SQS)
- [ ] `serverless.yml` event mapping
- [ ] E2E en staging: upload → medio + large visibles en S3

---

**Created**: 2026-04-08
**Author**: @img-lead
**Status**: 🔄 In Progress
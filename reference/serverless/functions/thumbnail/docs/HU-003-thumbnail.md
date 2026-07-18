# HU-003: Thumbnail generation (thumbnail function)

## Información General
- **ID**: HU-003
- **Prioridad**: P1
- **Function**: thumbnail
- **Estimado**: 1 día

## User Story

**Como** app web/mobile
**Quiero** un thumbnail 96x96 por imagen
**Para** mostrar grilla de previews sin bajar imagenes grandes

## Criterios de Aceptación

### Funcionales
- [ ] Consume SQS `thumbnails` (batch hasta 10 mensajes)
- [ ] Lee `medium.jpg` (ya optimizado) y produce `thumb.jpg` (96x96 cover, JPEG q75)
- [ ] Marca DynamoDB status `complete` + `thumbnailKey`
- [ ] Idempotente: mensaje duplicado → reescribe thumbnail (no falla)

### No Funcionales
- [ ] Memory 512MB; timeout 15s
- [ ] p95 < 2s por thumb
- [ ] Provisioned concurrency 2 (burst-tolerant)
- [ ] Cobertura ≥80%

## Triggers & Resources

| Resource      | Value                                  |
|---------------|----------------------------------------|
| Trigger       | SQS `thumbnails` (batch 10)            |
| DLQ           | `thumbnail-dlq`                        |
| Reads         | `IMAGES_BUCKET` (medium)              |
| Writes        | `IMAGES_BUCKET` (thumb)               |
| Updates       | DynamoDB `UPLOADS_TABLE` status=complete |

## Dependencies
- [ ] HU-002 resize produce `medium.jpg`
- [ ] SQS `thumbnails` + queue policy

## Definition of Done
- [ ] Implementado + tests
- [ ] Provisioned concurrency configurado
- [ ] E2E: upload → … → DynamoDB `complete` < 30s

---

**Created**: 2026-05-02
**Author**: @img-lead
**Status**: 📋 Backlog
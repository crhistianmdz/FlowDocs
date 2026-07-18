# HU-002: Reservar stock al crear pedido (inventory-service)

## Información General
- **ID**: HU-002
- **Prioridad**: P0
- **Módulo**: inventory-service
- **Estimado**: 3 días

## User Story

**Como** servicio `orders-service`
**Quiero** reservar stock de varios productos en una sola transacción
**Para** garantizar que un pedido confirmado tiene inventario disponible

## Criterios de Aceptación

### Funcionales
- [ ] POST `/api/inventory/reserve` valida token via `auth-service`
- [ ] Reserva atómica (todo o nada) con retry por `version` conflict
- [ ] `expires_at` = ahora + 5min
- [ ] POST `/api/inventory/reserve/release` libera reserva → status `released`
- [ ] Evento `stock.low` cuando `available < min_threshold` (configurable)

### No Funcionales
- [ ] p95 < 200ms local
- [ ] Cobertura ≥80% (`go test ./...`)
- [ ] Pact contract con `orders-service`

## Dependencies
- [ ] auth-service `verify` deployado en staging
- [ ] RabbitMQ disponible

## Endpoint Reference

| Method | Endpoint                      |
|--------|-------------------------------|
| POST   | /api/inventory/reserve         |
| POST   | /api/inventory/reserve/release |

**Ver**: `inventory-service/API/endpoints.md` y `SHARED/contratos.md`.

## Definition of Done
- [ ] Implementado + tests ≥80%
- [ ] Docs API/schema actualizadas
- [ ] Deploy staging + contract test contra orders-service

---

**Created**: 2026-02-20
**Author**: @inv-lead
**Status**: 🔄 In Progress
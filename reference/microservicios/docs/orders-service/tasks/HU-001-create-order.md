# HU-001: Crear pedido (orders-service)

## Información General
- **ID**: HU-001
- **Prioridad**: P0
- **Módulo**: orders-service
- **Estimado**: 4 días

## User Story

**Como** cliente autenticado
**Quiero** crear un pedido de varios productos
**Para** recibir delivery en mi dirección

## Criterios de Aceptación

### Funcionales
- [ ] POST `/api/orders` valida JWT via `auth-service/verify`
- [ ] Reserva stock via `inventory-service/reserve`
- [ ] Persiste order + order_items en `orders_db`
- [ ] Publica `order.created` en RabbitMQ
- [ ] Si reserve falla (409) → no persistir, retornar `INSUFFICIENT_STOCK`
- [ ] Si auth-service caído (breaker abierto) → 503 `UPSTREAM_DOWN`

### No Funcionales
- [ ] p95 < 600ms (incluye 2 sync calls)
- [ ] Cobertura ≥80% en `orders.service.ts`
- [ ] Idempotency: mismo `X-Request-ID` no crea duplicados
- [ ] Pact contracts con auth e inventory

## Contracts Required

| From | To                 | Contract        |
|------|--------------------|-----------------|
|orders| auth-service       | JWT validation  |
|orders| inventory-service | reserve / release |

**See**: `SHARED/contratos.md`.

## DB Changes
- [ ] Ya existe `orders`, `order_items` (no migration).

## Dependencies
- [ ] auth-service `verify` HU done
- [ ] inventory-service `reserve` HU done
- [ ] RabbitMQ disponible

## Definition of Done
- [ ] Implementado + tests ≥80%
- [ ] Pact contract tests con ambos dependants
- [ ] Deploy staging + E2E del flujo completo

---

**Created**: 2026-03-01
**Author**: @orders-lead
**Status**: 📋 Backlog
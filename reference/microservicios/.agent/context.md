# Agent Context — Delivery Platform (Microservices)

## Project

- **Name**: DeliveryPlatform
- **Type**: Microservices (multi-module)
- **Created**: 2026-02-01
- **Owner**: @architecture-team

## Stack (per service)

| Layer     | Technology |
|-----------|------------|
| Runtime   | Node.js 20 / Go 1.21 |
| Framework | Express / Gin |
| DB        | PostgreSQL (per service, isolated) |
| Messaging | RabbitMQ (async events) |
| Discovery | Docker DNS + Consul (staging+) |
| Testing   | Vitest / go test |

## Modules

| Service            | Path                       | Owner     | Stack      | Status     |
|--------------------|----------------------------|-----------|------------|------------|
| **auth-service**      | `docs/auth-service/`         | @auth-lead  | Node/Express | ✅ Stable   |
| **inventory-service**| `docs/inventory-service/`   | @inv-lead   | Go/Gin      | 🔄 Active   |
| **orders-service**    | `docs/orders-service/`       | @orders-lead| Node/Express | ⏳ Pending   |

## Sources of Truth

- **PRD**: `docs/SHARED/PRD.md`
- **Architecture**: `docs/SHARED/arquitectura.md`
- **Contracts**: `docs/SHARED/contratos.md`
- **Per-service docs**: `docs/<service>/README.md`
- **Tasks (per service)**: `docs/<service>/tasks/`

## Rules

- No service shares a DB. Cross-service reads go through contracts.
- Breaking a contract requires full RFC + deprecation window (30 days).
- Each service owns its deployment pipeline.

---

**Last Updated**: 2026-07-18
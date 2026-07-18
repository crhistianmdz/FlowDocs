# orders-service

## Overview

Orders service owns the order lifecycle for DeliveryPlatform. It orchestrates calls to `auth-service` (verify) and `inventory-service` (reserve/release stock), persists orders in its own DB, and publishes lifecycle events to RabbitMQ.

---

## Responsibilities

- [ ] Create order (validate caller, reserve stock)
- [ ] Update order status (`pending → confirmed → shipped → delivered | cancelled`)
- [ ] Release stock reservation on cancel
- [ ] Publish events: `order.created`, `order.shipped`, `order.cancelled`

---

## Tech Stack

| Layer     | Technology |
|-----------|------------|
| Language  | Node.js 20 |
| Framework | Express 4 |
| DB        | PostgreSQL 15 (`orders_db`) |
| Messaging | RabbitMQ  |
| Testing   | Vitest    |

---

## API Endpoints

**Full**: `API/endpoints.md`

| Method | Endpoint                     | Description       | Auth |
|--------|------------------------------|-------------------|------|
| GET    | /api/orders                  | List orders       | ✅   |
| POST   | /api/orders                  | Create order      | ✅   |
| GET    | /api/orders/:id              | Get by id         | ✅   |
| PATCH  | /api/orders/:id/status       | Update status     | ✅ admin |
| POST   | /api/orders/:id/cancel       | Cancel + release  | ✅   |

---

## DB Schema

**Full**: `DB/schema.md`

| Table       | Description |
|-------------|-------------|
| orders      | Order headers |
| order_items | Order lines |

---

## Module Dependencies

| Depends On            | Service           | Purpose                       |
|-----------------------|-------------------|-------------------------------|
| auth-service          | verify JWT        | `GET /api/auth/verify`       |
| inventory-service     | reserve stock     | `POST /api/inventory/reserve` |
| inventory-service     | release stock     | `POST /reserve/release`       |
| RabbitMQ              | publish events    | `order.created`, `order.cancelled` |

**See**: `docs/SHARED/contratos.md`.

---

## Local Dev

```bash
npm install
npm run dev          # :3003
npm test
```

### Env
```
DATABASE_URL=postgresql://user:pass@localhost:5432/orders_db
AUTH_SERVICE_URL=http://localhost:3001
INVENTORY_SERVICE_URL=http://localhost:3002
RABBIT_URL=amqp://guest:guest@localhost:5672/
PORT=3003
```

---

## Owner

| Role          | Person       |
|---------------|--------------|
| Primary Owner | @orders-lead |
| Reviewers     | @tech-lead   |

---

**Last Updated**: 2026-07-18
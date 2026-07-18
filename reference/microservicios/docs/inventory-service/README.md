# inventory-service

## Overview

Inventory service manages the product catalogue per restaurant and real-time stock — including reservation lifecycle used by `orders-service`. Written in Go/Gin.

---

## Responsibilities

- [ ] CRUD de productos (por restaurante)
- [ ] Stock check
- [ ] Reservar stock (`POST /api/inventory/reserve`)
- [ ] Liberar reservas (timeout 5min o release explícito)
- [ ] Publicar evento `stock.low`

---

## Tech Stack

| Layer     | Technology |
|-----------|------------|
| Language  | Go 1.21    |
| Framework | Gin        |
| DB        | PostgreSQL 15 (`inventory_db`) |
| Testing   | go test    |
| Messaging | RabbitMQ   |

---

## API Endpoints

**Full**: `API/endpoints.md`

| Method | Endpoint                        | Description           | Auth |
|--------|---------------------------------|-----------------------|------|
| GET    | /api/inventory/products         | List products         | ✅   |
| POST   | /api/inventory/products         | Create product        | ✅ admin |
| POST   | /api/inventory/reserve          | Reserve stock         | ✅   |
| POST   | /api/inventory/reserve/release  | Release reservation   | ✅   |

---

## DB Schema

**Full**: `DB/schema.md`

| Table        | Description            | ~Rows  |
|--------------|------------------------|--------|
| products     | Catalogue              | 10K+   |
| stock        | Stock per product      | per-store |
| reservations | Pending stock holds    | 1K+    |

---

## Module Dependencies

| Depends On         | Service         | Contract                  | Purpose          |
|--------------------|-----------------|---------------------------|------------------|
| auth-service       | verify          | `GET /api/auth/verify`    | Validate caller  |
| RabbitMQ           | —               | publish `stock.low`       | Event outflow    |

Downstream: `orders-service`, `web-frontend`. See `docs/SHARED/contratos.md`.

---

## Local Dev

```bash
go mod download
go run main.go                # :3002
go test ./...
```

### Env
```
DATABASE_URL=postgresql://user:pass@localhost:5432/inventory_db
RABBIT_URL=amqp://guest:guest@localhost:5672/
PORT=3002
```

### Docker
```bash
docker-compose up inventory-service
```

---

## Owner

| Role          | Person    |
|---------------|-----------|
| Primary Owner | @inv-lead |
| Reviewers     | @tech-lead |

---

**Last Updated**: 2026-07-18
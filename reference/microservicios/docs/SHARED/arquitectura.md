# Arquitectura — DeliveryPlatform

## Diagrama de Sistema

```
                         +------------------+
                         |   API Gateway    |  (NGINX / Traefik, puerto 8080)
                         +--------+---------+
                                  |
        +-------------------------+-------------------------+
        |                         |                         |
+-------v------+           +------v------+          +--------v----+
| auth-service |           | orders-svc  |          | inventory-s |
|  (Express)   |           |  (Express)  |          |   (Go/Gin)  |
|  :3001       |           |  :3003      |          |  :3002      |
+--------------+           +---+---------+          +-------------+
  DB: auth_db                   |                          DB: inventory_db
                                 |  sync calls
                          verify JWT -----> auth
                          reserve stock ---> inventory
                                 |
                          publish: order.created, order.shipped (RabbitMQ)
```

## Mensajería (RabbitMQ)

| Evento            | Publicado por   | Consumidores                    |
|-------------------|-----------------|--------------------------------|
| `order.created`   | orders-service  | inventory-service (release pending), delivery (Phase 2) |
| `order.shipped`   | orders-service  | delivery-service (Phase 2)     |
| `stock.low`       | inventory-service | orders-service (disable COD option) |

## Shared Dependencies

- **PostgreSQL**: una DB por servicio (`auth_db`, `orders_db`, `inventory_db`) — sin compartir.
- **RabbitMQ**: broker común.
- **OpenTelemetry Collector**: export traces a Jaeger.

## Principios
1. Cada servicio posee su DB y su pipeline.
2. Lecturas cross-service → contrato síncrono (HTTP) o evento asíncrono.
3. Breaking changes de contrato → ventana de 30 días (ver `contratos.md`).

---

**Last Updated**: 2026-07-18
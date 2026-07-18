# Design — async order confirmation

## Architecture

```
[PATCH /status confirmed] ─ orders.service
        ├─ update orders_db (status=confirmed)
        └─ publish RabbitMQ exchange orders.events, key=order.confirmed
                                  │
                                  ▼
                  inventory-service consumer
        └─ UPDATE reservations SET status='confirmed' WHERE order_id=?
```

## Decisions
- **Exchange**: `orders.events` (topic, durable).
- **Routing key**: `order.confirmed`.
- **Queue**: `inventory.order.confirmed` with dead-letter `inventory.order.dlx`.
- **Idempotency**: consumer upserts; `UPDATE ... WHERE status='pending'` short-circuits dups.
- **Retry**: 3 attempts with exponential backoff; then DLQ + ops alert.

## Open questions
- Should delivery-service (Phase 2) share the queue or its own? Recommend its own queue keyed on `order.*`.

## Risks
- RabbitMQ becomes single point of failure → already mitigated by federation in Phase 2 design.
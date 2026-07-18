# Spec — async order confirmation

## Requirements

### REQ-1 Publish order.confirmed
- orders-service publishes `{ orderId, reservationId, customerId, total }` to `orders.events` exchange.
- Published only on PATCH `/status` → confirmed.

### REQ-2 Inventory consumes
- inventory-service listens, transitions matching reservation to `confirmed`.
- Idempotent: duplicate `orderId` no-ops.

### REQ-3 Latency budget
- End-to-end (publish → inventory confirmation update) < 1s p95.

## Scenarios

### Scenario: happy path
- WHEN PATCH /orders/:id/status { status: confirmed }
- THEN publish order.confirmed
- AND inventory-service transitions reservation → confirmed within 1s

### Scenario: duplicate event
- WHEN order.confirmed redelivered
- THEN inventory-service sees reservation already confirmed → no-op

### Scenario: inventory unreachable
- WHEN consumer offline 5 min
- THEN event queued; on reconnect, processes in order
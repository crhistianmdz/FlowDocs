# Proposal — split confirm step into async event

## Intent
Move order confirmation from synchronous `PATCH /status` into an async `order.confirmed` event consumed by inventory + delivery, to cut latency on the critical customer path.

## Scope
- orders-service publishes `order.confirmed` on checkout.
- inventory-service releases pending reservation → confirmed `reservations`.
- (Phase 2) delivery-service consumes to plan dispatch.

## Approach
- Use existing RabbitMQ exchange `orders.events`.
- Keep `PATCH /status` as fallback for manual ops.

## Risks
- At-least-once delivery → consumers idempotent by `order_id`.
- Backpressure under high order volume.

## Out of scope
- Payments-service integration.

---

**Status**: Draft
**Author**: @orders-lead
**Date**: 2026-07-18
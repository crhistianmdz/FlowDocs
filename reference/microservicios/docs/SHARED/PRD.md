# PRD — DeliveryPlatform

## 1. System Overview

- **Project**: DeliveryPlatform
- **Architecture**: Microservices (auth, inventory, orders)
- **Review Date**: July 2026
- **Description**: Multi-service platform for managing restaurant delivery: user auth, product inventory per restaurant, and order lifecycle with stock reservations and inter-service delivery dispatch.

---

## 2. Functional Requirements

### Main Use Cases
1. **Auth**: login, refresh, `me`, role/permission verification.
2. **Inventory**: list products with stock, reserve stock, release reservation.
3. **Orders**: create order (calls auth + inventory), update status (pending → confirmed → shipped → delivered / cancelled).

### Exemplary User Flow
1. Customer → POST `/auth/login` → JWT.
2. Customer → GET `/inventory/products` → sees available products.
3. Customer → POST `/orders` → orders-service validates JWT via auth-service, reserves stock via inventory-service, persists order.
4. On confirm → event `order.shipped` on RabbitMQ → emits to delivery dispatch.

---

## 3. Testing and Validation

1. **Unit**: per service ≥80%.
2. **Contract**: Pact tests across all service pairs.
3. **Integration**: Testcontainers spin-up per service + RabbitMQ.
4. **E2E**: staging pipeline runs the full customer flow daily.

---

## 4. Edge Cases
1. Inventory-service down during order create → circuit breaker → order fails fast with 503.
2. JWT expired mid-flow → silent refresh via auth-service.
3. Double-reserve stock (race) → optimistic `version` column + retry.

---

## 5. Roadmap
1. **MVP**: auth, inventory, orders + contracts → Q1 2026.
2. **Phase 2**: delivery-service, payments-service → Q2 2026.

---

## 6. Non-Functional Requirements
- **Scalability**: each service independent horizontal scale.
- **Performance**: p95 < 400ms for cross-service synchronous flows.
- **Security**: JWT verified per service; no shared session store.
- **Observability**: OpenTelemetry traces across services.

---

## Success Indicators
- >95% orders processed end-to-end < 2s.
- Zero cross-service DB reads in production (verified via audit).

---

**Last Updated**: 2026-07-18
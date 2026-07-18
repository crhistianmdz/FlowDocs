# Inter-Service Contracts — DeliveryPlatform

This document defines how services communicate. **Breaking changes require new version**.

---

## Contract Versioning

| Version | Status     | Deprecation | Notes                |
|---------|------------|-------------|----------------------|
| v1      | ✅ Current | —           | Stable since Feb 2026 |

**Breaking Change Policy**: new version (v1→v2), 30-day overlap, all teams migrate before deprecation.

---

## orders-service → auth-service

### Contract: JWT Validation

**Purpose**: Verify caller's JWT before accepting an order request.

**From**: `orders-service`
**To**: `auth-service`

**Endpoint**:
```
GET /api/auth/verify
```

**Headers**:
```
Authorization: Bearer <JWT>
X-Request-ID: <uuid>
```

**Response (200 OK)**:
```json
{
  "valid": true,
  "user": {
    "id": "string",
    "email": "string",
    "role": "customer | admin",
    "idEmpresa": 1
  }
}
```

**Error (401 Unauthorized)**:
```json
{ "valid": false, "error": { "code": "UNAUTHORIZED", "message": "Invalid or missing JWT" } }
```

**Retry Policy**: 3 retries, exponential (1s, 2s, 4s), timeout 2s. Circuit breaker opens after 5 consecutive failures (60s cooldown) → orders-service returns 503 to client.

---

## orders-service → inventory-service

### Contract: Stock Check & Reserve

**Purpose**: Reserve product stock at order creation time.

**Endpoint**:
```
POST /api/inventory/reserve
```

**Request**:
```json
{
  "orderId": "uuid",
  "items": [
    { "productId": "uuid", "quantity": 2 },
    { "productId": "uuid", "quantity": 1 }
  ]
}
```

**Response (200 OK)**:
```json
{
  "success": true,
  "reservationId": "uuid",
  "expiresAt": "ISO8601+5min"
}
```

**Errors**:

| Code                   | HTTP | Meaning                     |
|------------------------|------|-----------------------------|
| `VALIDATION_ERROR`     | 400  | Malformed request           |
| `INSUFFICIENT_STOCK`   | 409  | One or more products short  |
| `INTERNAL_ERROR`       | 500  | Server error                |

### Release Reservation

```
POST /api/inventory/reserve/release
{ "reservationId": "uuid" }
```
**Response**: 204 No Content.

---

## All Contracts Summary

| From             | To                 | Contract          | Endpoint                                | Version |
|------------------|--------------------|-------------------|------------------------------------------|---------|
| orders-service   | auth-service       | JWT Validation    | `GET /api/auth/verify`                   | v1      |
| orders-service   | inventory-service  | Reserve Stock     | `POST /api/inventory/reserve`            | v1      |
| orders-service   | inventory-service  | Release Stock     | `POST /api/inventory/reserve/release`    | v1      |
| web-frontend     | auth-service       | Login             | `POST /api/auth/login`                   | v1      |
| web-frontend     | orders-service     | Create Order      | `POST /api/orders`                       | v1      |
| web-frontend     | inventory-service  | List Products     | `GET /api/inventory/products`            | v1      |

---

## Shared DTOs

### UserDTO (auth-service)
```typescript
interface UserDTO {
  id: string;
  email: string;
  role: 'customer' | 'admin';
  idEmpresa: number;
  permissions: string[];
}
```

### ProductDTO (inventory-service)
```typescript
interface ProductDTO {
  id: string;
  name: string;
  price: number;
  stock: number;
  categoryId: string;
  isActive: boolean;
}
```

### OrderDTO (orders-service)
```typescript
interface OrderDTO {
  id: string;
  orderNumber: string;
  customerId: string;
  status: 'pending' | 'confirmed' | 'shipped' | 'delivered' | 'cancelled';
  items: { productId: string; quantity: number; unitPrice: number }[];
  total: number;
  createdAt: string;
}
```

---

## Testing Strategy
- **Pact** contract tests on every PR.
- **Consumer tests** mock responses against contract.
- **Integration tests** on staging run real cross-service calls.

---

**Last Updated**: 2026-07-18
**Maintained By**: @architecture-team
# Inter-Module Contracts

This document defines how modules/services communicate with each other.

---

## Contract Versioning

| Version | Status | Deprecation Date | Notes |
|---------|--------|------------------|-------|
| v1 | ✅ Current | — | Latest stable |
| v0 | ⚠️ Deprecated | YYYY-MM-DD | Initial version |

**Breaking Change Policy**:
- Breaking changes require new version (v1 → v2)
- Old versions supported for 30 days after deprecation
- All teams must migrate before deprecation date

---

## Service A → Service B

### Contract: [Contract Name]

**Purpose**: [What this contract enables]

**From Module**: `module-a`  
**To Module**: `module-b`

---

### Endpoint

```
POST /api/v1/module-b/action
```

---

### Request

**Headers**:
```
Authorization: Bearer <JWT>
Content-Type: application/json
X-Request-ID: <uuid>
```

**Body**:
```json
{
  "field1": "string",
  "field2": "number",
  "field3": ["string"]
}
```

---

### Response

**Success (200 OK)**:
```json
{
  "success": true,
  "data": {
    "result": "string"
  }
}
```

**Error (400 Bad Request)**:
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "field1 is required"
  }
}
```

**Error (401 Unauthorized)**:
```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid or missing JWT"
  }
}
```

---

### Error Handling

| Error Code | Meaning | Action |
|------------|---------|--------|
| `VALIDATION_ERROR` | Request body invalid | Fix request, retry |
| `UNAUTHORIZED` | JWT invalid/missing | Refresh token, retry |
| `FORBIDDEN` | Insufficient permissions | Contact admin |
| `NOT_FOUND` | Resource doesn't exist | Check ID |
| `INTERNAL_ERROR` | Server error | Retry with backoff |

---

### Retry Policy

```
Max Retries: 3
Backoff: Exponential (1s, 2s, 4s)
Timeout: 5s per request
```

---

### Example (cURL)

```bash
curl -X POST http://localhost:3002/api/v1/module-b/action \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{"field1": "value", "field2": 42, "field3": ["a", "b"]}'
```

---

### Example (TypeScript)

```typescript
const response = await fetch('http://localhost:3002/api/v1/module-b/action', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${accessToken}`,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    field1: 'value',
    field2: 42,
    field3: ['a', 'b'],
  }),
});

if (!response.ok) {
  const error = await response.json();
  throw new Error(error.error.message);
}

const data = await response.json();
```

---

## All Contracts Summary

| From | To | Contract | Endpoint | Version |
|------|-----|----------|----------|---------|
| orders-service | auth-service | JWT Validation | `GET /api/auth/verify` | v1 |
| orders-service | inventory-service | Stock Check | `GET /api/inventory/stock/:id` | v1 |
| orders-service | inventory-service | Reserve Stock | `POST /api/inventory/reserve` | v1 |
| frontend-web | auth-service | Login | `POST /api/auth/login` | v1 |
| frontend-web | orders-service | Create Order | `POST /api/orders` | v1 |
| frontend-web | inventory-service | List Products | `GET /api/inventory/products` | v1 |

---

## Shared DTOs

### User DTO (from auth-service)

```typescript
interface UserDTO {
  id: string;
  email: string;
  role: 'admin' | 'user' | 'mesero' | 'cocina' | 'repartidor';
  idEmpresa: number;
  permissions: string[];
}
```

### Product DTO (from inventory-service)

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

### Order DTO (from orders-service)

```typescript
interface OrderDTO {
  id: string;
  orderNumber: string;
  customerId: string;
  status: 'pending' | 'confirmed' | 'preparing' | 'ready' | 'in_transit' | 'delivered' | 'cancelled';
  items: OrderItemDTO[];
  total: number;
  createdAt: string;
}
```

---

## Testing Contracts

### Contract Testing Strategy

1. **Provider Tests** (service that exposes API):
   - Verify endpoint behavior matches contract
   - Run on every PR

2. **Consumer Tests** (service that consumes API):
   - Mock responses based on contract
   - Verify consumer handles all response types

3. **Integration Tests** (end-to-end):
   - Test actual service-to-service communication
   - Run on staging before deploy

### Tools

- **Pact**: Contract testing framework
- **Postman**: Manual API testing
- **Swagger**: API documentation

---

## Breaking Changes Process

1. **Announce** change in team chat + issue tracker
2. **Create** new version of contract (v1 → v2)
3. **Support** both versions for 30 days
4. **Notify** teams using old version
5. **Deprecate** old version after migration
6. **Remove** old version code

---

**Last Updated**: YYYY-MM-DD  
**Maintained By**: @architecture-team  
**Reviewers**: @tech-leads

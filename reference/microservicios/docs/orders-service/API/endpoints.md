# orders-service API Endpoints

## POST /api/orders

Create new order. Orchestrates: verify JWT (auth-service) → reserve stock (inventory-service) → persist.

**Headers**: `Authorization: Bearer <JWT>`

**Request**:
```json
{
  "items": [
    { "productId": "uuid", "quantity": 2 },
    { "productId": "uuid", "quantity": 1 }
  ],
  "deliveryAddress": {
    "street": "Av. Corrientes 123",
    "city": "Buenos Aires",
    "postalCode": "1043"
  },
  "notes": "ring once"
}
```

**Response 201**:
```json
{
  "id": "uuid",
  "orderNumber": "ORD-2026-043",
  "status": "pending",
  "subtotal": 28.50,
  "tax": 4.56,
  "total": 33.06,
  "reservationId": "uuid",
  "createdAt": "2026-05-29T18:00:00Z"
}
```

| Code | Error               | When                             |
|------|---------------------|----------------------------------|
| 401  | `UNAUTHORIZED`      | JWT invalid / auth-service down (503 if breaker open) |
| 409  | `INSUFFICIENT_STOCK`| Inventory reserve failed         |
| 503  | `UPSTREAM_DOWN`     | auth or inventory unavailable    |

---

## GET /api/orders

**Query**: `page`, `limit`, `status`, `from`, `to`

**Response 200**: paginated `data: OrderDTO[]` with `meta`. (See `SHARED/contratos.md` for `OrderDTO`.)

---

## GET /api/orders/:id

**Response 200**: single `OrderDTO`.
**Response 404**: `{ "error": { "code": "NOT_FOUND" } }`.

---

## PATCH /api/orders/:id/status

**Request**: `{ "status": "shipped" }`

Transitions allowed: `pending → confirmed → shipped → delivered`. `cancelled` allowed from `pending | confirmed`.

**Response 200**: updated order.

---

## POST /api/orders/:id/cancel

Releases stock reservation. Publishes `order.cancelled`.

**Response 204**.

---

**Last Updated**: 2026-07-18
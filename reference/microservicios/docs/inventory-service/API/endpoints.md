# inventory-service API Endpoints

## GET /api/inventory/products

**Query**: `page`, `limit`, `search`, `restaurantId`, `inStock`

**Response 200**:
```json
{
  "data": [
    { "id": "uuid", "name": "Margherita Pizza", "price": 8.50, "stock": 42, "categoryId": "uuid", "isActive": true }
  ],
  "meta": { "total": 128, "page": 1, "limit": 25, "totalPages": 6 }
}
```

---

## POST /api/inventory/products

**Request**:
```json
{ "name": "Margherita Pizza", "price": 8.50, "stock": 50, "categoryId": "uuid", "restaurantId": 1 }
```
**Response 201**: created product.

---

## POST /api/inventory/reserve

**Headers**: `Authorization: Bearer <JWT>`, `X-Request-ID: <uuid>`

**Request**:
```json
{
  "orderId": "uuid",
  "items": [ { "productId": "uuid", "quantity": 2 } ]
}
```

**Response 200**:
```json
{ "success": true, "reservationId": "uuid", "expiresAt": "ISO8601+5min" }
```

| Code | Error                         | When                       |
|------|-------------------------------|----------------------------|
| 409  | `INSUFFICIENT_STOCK`         | Product short             |
| 400  | `VALIDATION_ERROR`           | Bad body                  |

---

## POST /api/inventory/reserve/release

**Request**: `{ "reservationId": "uuid" }`
**Response**: 204 No Content.

---

**Last Updated**: 2026-07-18
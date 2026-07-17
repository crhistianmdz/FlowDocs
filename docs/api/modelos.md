# Models — Generic Examples

> These are generic reference examples. Copy and adapt according to your project.

---

## User (Domain Model)

### Structure

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique identifier |
| email | string | Yes | Unique email |
| name | string | Yes | Full name |
| role | enum | Yes | admin, user, guest |
| avatarUrl | string | No | Profile image URL |
| createdAt | timestamp | Yes | Creation date |
| updatedAt | timestamp | Yes | Last modification |
| isActive | boolean | Yes | Whether the account is active |

### JSON Example

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "name": "John Doe",
  "role": "user",
  "avatarUrl": "https://cdn.example.com/avatars/550e840.jpg",
  "createdAt": "2026-01-15T10:30:00Z",
  "updatedAt": "2026-05-20T14:22:00Z",
  "isActive": true
}
```

---

## Product

### Structure

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique identifier |
| name | string | Yes | Product name |
| description | string | No | Long description |
| price | decimal | Yes | Unit price |
| stock | integer | Yes | Inventory quantity |
| minStock | integer | No | Minimum stock threshold |
| categoryId | UUID | No | FK to Category |
| imageUrl | string | No | Image URL |
| isActive | boolean | Yes | Whether it's available |
| createdAt | timestamp | Yes | Creation date |
| updatedAt | timestamp | Yes | Last modification |

### JSON Example

```json
{
  "id": "660e8400-e29b-41d4-a716-446655440001",
  "name": "Blue long sleeve shirt",
  "description": "100% cotton shirt, size M",
  "price": 29.99,
  "stock": 150,
  "minStock": 20,
  "categoryId": "770e8400-e29b-41d4-a716-446655440002",
  "imageUrl": "https://cdn.example.com/products/660e840.jpg",
  "isActive": true,
  "createdAt": "2026-02-10T08:00:00Z",
  "updatedAt": "2026-05-25T09:15:00Z"
}
```

---

## Order

### Structure

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique identifier |
| orderNumber | string | Yes | Human-readable number (e.g., ORD-2026-001) |
| customerId | UUID | Yes | FK to User (customer) |
| status | enum | Yes | pending, confirmed, shipped, delivered, cancelled |
| subtotal | decimal | Yes | Subtotal before tax |
| tax | decimal | Yes | Tax amount |
| total | decimal | Yes | Total with tax |
| shippingAddress | Address | Yes | Shipping address |
| notes | string | No | Additional notes |
| createdAt | timestamp | Yes | Order date |
| updatedAt | timestamp | Yes | Last modification |

### JSON Example

```json
{
  "id": "880e8400-e29b-41d4-a716-446655440003",
  "orderNumber": "ORD-2026-042",
  "customerId": "550e8400-e29b-41d4-a716-446655440000",
  "status": "shipped",
  "subtotal": 89.97,
  "tax": 14.40,
  "total": 104.37,
  "shippingAddress": {
    "street": "123 Main Street",
    "city": "New York",
    "state": "NY",
    "postalCode": "10001",
    "country": "US"
  },
  "notes": "Leave at door",
  "createdAt": "2026-05-28T16:45:00Z",
  "updatedAt": "2026-05-29T08:20:00Z"
}
```

---

## Address (Value Object)

### Structure

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| street | string | Yes | Street and number |
| city | string | Yes | City |
| state | string | No | State/Province |
| postalCode | string | Yes | Postal code |
| country | string | Yes | ISO country code |

### JSON Example

```json
{
  "street": "123 Main Street",
  "city": "New York",
  "state": "NY",
  "postalCode": "10001",
  "country": "US"
}
```

---

## Common Enums

### UserRole

```
admin   — Administrator with full access
user    — Standard user
guest   — Guest user (read-only)
```

### OrderStatus

```
pending    — Order created, awaiting confirmation
confirmed  — Confirmed, being prepared
shipped    — Shipped to customer
delivered  — Delivered
cancelled  — Cancelled
```

### PaymentStatus

```
pending    — Payment pending
paid       — Paid
failed     — Payment failed
refunded   — Refunded
```

---

## How to Use These Examples

1. **Copy** the model that resembles your case
2. **Adapt** fields, types, and enumerations
3. **Add** fields specific to your business
4. **Maintain** consistency with the defined enums

For more details on API contracts, see `endpoints.md`.

# API Endpoints — Generic Examples

> These are generic examples for reference. Copy and adapt to your project.

---

## Authentication

### POST /api/auth/login

**Description**: Authenticate user with credentials.

**Request Body**:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (200 OK)**:
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "dGhpcyBpcyBhIHJlZnJlc2ggdG9rZW4...",
  "user": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "user@example.com",
    "name": "John Doe",
    "role": "user"
  }
}
```

**Error Responses**:
| Code | Body | Description |
|------|------|-------------|
| 400 | `{ "error": "Invalid email format" }` | Invalid email |
| 401 | `{ "error": "Invalid credentials" }` | Wrong credentials |
| 403 | `{ "error": "Account disabled" }` | Account disabled |

---

### POST /api/auth/refresh

**Description**: Get new access token using refresh token.

**Request**: Cookie `refreshToken` (httpOnly)

**Response (200 OK)**:
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Error Responses**:
| Code | Body | Description |
|------|------|-------------|
| 401 | `{ "error": "Invalid or expired refresh token" }` | Invalid token |

---

### GET /api/auth/me

**Description**: Get authenticated user information.

**Headers**: `Authorization: Bearer <accessToken>`

**Response (200 OK)**:
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "name": "John Doe",
  "role": "user",
  "createdAt": "2026-01-15T10:30:00Z"
}
```

---

## Users

### GET /api/users

**Description**: List users (admin only).

**Headers**: `Authorization: Bearer <accessToken>`

**Query Params**:
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| page | number | 1 | Page |
| limit | number | 25 | Items per page |
| search | string | - | Search by name/email |
| role | string | - | Filter by role |

**Response (200 OK)**:
```json
{
  "data": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "email": "user@example.com",
      "name": "John Doe",
      "role": "user",
      "isActive": true,
      "createdAt": "2026-01-15T10:30:00Z"
    }
  ],
  "meta": {
    "total": 42,
    "page": 1,
    "limit": 25,
    "totalPages": 2
  }
}
```

---

### POST /api/users

**Description**: Create new user (admin only).

**Request Body**:
```json
{
  "email": "new@example.com",
  "name": "Jane Smith",
  "password": "securePass123",
  "role": "user"
}
```

**Response (201 Created)**:
```json
{
  "id": "990e8400-e29b-41d4-a716-446655440099",
  "email": "new@example.com",
  "name": "Jane Smith",
  "role": "user",
  "createdAt": "2026-05-29T12:00:00Z"
}
```

---

### GET /api/users/{id}

**Description**: Get user by ID.

**Response (200 OK)**:
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "name": "John Doe",
  "role": "user",
  "isActive": true,
  "createdAt": "2026-01-15T10:30:00Z",
  "updatedAt": "2026-05-20T14:22:00Z"
}
```

**Error Responses**:
| Code | Body | Description |
|------|------|-------------/
| 404 | `{ "error": "User not found" }` | User does not exist |

---

### PATCH /api/users/{id}

**Description**: Partially update user.

**Request Body** (partial):
```json
{
  "name": "John Doe Updated",
  "isActive": false
}
```

**Response (200 OK)**:
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "name": "John Doe Updated",
  "role": "user",
  "isActive": false,
  "updatedAt": "2026-05-29T14:00:00Z"
}
```

---

## Products

### GET /api/products

**Description**: List products.

**Query Params**:
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| page | number | 1 | Page |
| limit | number | 25 | Items per page |
| category | UUID | - | Filter by category |
| search | string | - | Search by name |
| minPrice | number | - | Minimum price |
| maxPrice | number | - | Maximum price |
| inStock | boolean | - | Only products in stock |

**Response (200 OK)**:
```json
{
  "data": [
    {
      "id": "660e8400-e29b-41d4-a716-446655440001",
      "name": "Blue long sleeve shirt",
      "price": 29.99,
      "stock": 150,
      "categoryId": "770e8400-e29b-41d4-a716-446655440002",
      "isActive": true
    }
  ],
  "meta": {
    "total": 128,
    "page": 1,
    "limit": 25,
    "totalPages": 6
  }
}
```

---

### POST /api/products

**Description**: Create new product.

**Request Body**:
```json
{
  "name": "Black slim fit pants",
  "description": "Denim pants, size 32",
  "price": 49.99,
  "stock": 75,
  "categoryId": "770e8400-e29b-41d4-a716-446655440002",
  "minStock": 10,
  "imageUrl": "https://cdn.example.com/products/661e8400.jpg"
}
```

**Response (201 Created)**:
```json
{
  "id": "661e8400-e29b-41d4-a716-446655440001",
  "name": "Black slim fit pants",
  "description": "Denim pants, size 32",
  "price": 49.99,
  "stock": 75,
  "categoryId": "770e8400-e29b-41d4-a716-446655440002",
  "isActive": true,
  "createdAt": "2026-05-29T15:00:00Z"
}
```

---

### POST /api/products/bulk

**Description**: Bulk product upload.

**Content-Type**: `multipart/form-data`

**Request**:
| Field | Type | Required | Description |
|-------|------|---------|-------------|
| file | File | Yes | Excel or CSV with products |
| validateOnly | boolean | No | Validate without saving |

**Response (200 OK)**:
```json
{
  "success": 95,
  "errors": [
    {
      "row": 5,
      "message": "Invalid price format",
      "data": { "name": "Product X", "price": "abc" }
    },
    {
      "row": 12,
      "message": "Missing required field: name",
      "data": { "price": 19.99 }
    }
  ]
}
```

---

## Orders

### GET /api/orders

**Description**: List orders for current user.

**Query Params**:
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| status | string | - | Filter by status |
| from | date | - | Start date |
| to | date | - | End date |

**Response (200 OK)**:
```json
{
  "data": [
    {
      "id": "880e8400-e29b-41d4-a716-446655440003",
      "orderNumber": "ORD-2026-042",
      "status": "shipped",
      "total": 104.37,
      "createdAt": "2026-05-28T16:45:00Z"
    }
  ],
  "meta": {
    "total": 15,
    "page": 1,
    "limit": 25,
    "totalPages": 1
  }
}
```

---

### POST /api/orders

**Description**: Create new order.

**Request Body**:
```json
{
  "items": [
    { "productId": "660e8400-e29b-41d4-a716-446655440001", "quantity": 2 },
    { "productId": "661e8400-e29b-41d4-a716-446655440002", "quantity": 1 }
  ],
  "shippingAddress": {
    "street": "123 Main Street",
    "city": "New York",
    "state": "NY",
    "postalCode": "10001",
    "country": "US"
  },
  "notes": "Leave at doorman"
}
```

**Response (201 Created)**:
```json
{
  "id": "990e8400-e29b-41d4-a716-446655440099",
  "orderNumber": "ORD-2026-043",
  "status": "pending",
  "subtotal": 109.97,
  "tax": 17.60,
  "total": 127.57,
  "createdAt": "2026-05-29T18:00:00Z"
}
```

---

### PATCH /api/orders/{id}/status

**Description**: Update order status (admin only).

**Request Body**:
```json
{
  "status": "shipped",
  "trackingNumber": "TRACK123456789"
}
```

**Response (200 OK)**:
```json
{
  "id": "880e8400-e29b-41d4-a716-446655440003",
  "orderNumber": "ORD-2026-042",
  "status": "shipped",
  "trackingNumber": "TRACK123456789",
  "updatedAt": "2026-05-29T10:00:00Z"
}
```

---

## Global Error Codes

| Code | Meaning | When it occurs |
|------|---------|---------------|
| 400 | Bad Request | Data validation failed |
| 401 | Unauthorized | Missing or invalid token |
| 403 | Forbidden | No permissions for this resource |
| 404 | Not Found | Resource does not exist |
| 409 | Conflict | Duplicate resource (e.g: email already registered) |
| 422 | Unprocessable Entity | Valid data but cannot be processed |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Unexpected server error |

---

## How to Use These Examples

1. **Copy** the endpoint that resembles your API
2. **Adapt** paths, resource names, and fields
3. **Maintain** consistency in request/response format
4. **Use** global error codes for standard errors

For data models, see `modelos.md`.
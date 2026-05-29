# API Endpoints — Ejemplos Genéricos

> Estos son ejemplos genéricos para referencia. Copiar y adaptar según tu proyecto.

---

## Autenticación

### POST /api/auth/login

**Descripción**: Autenticar usuario con credenciales.

**Request Body**:
```json
{
  "email": "usuario@ejemplo.com",
  "password": "contraseña123"
}
```

**Response (200 OK)**:
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "dGhpcyBpcyBhIHJlZnJlc2ggdG9rZW4...",
  "user": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "usuario@ejemplo.com",
    "name": "Juan Pérez",
    "role": "user"
  }
}
```

**Error Responses**:
| Code | Body | Descripción |
|------|------|-------------|
| 400 | `{ "error": "Invalid email format" }` | Email no válido |
| 401 | `{ "error": "Invalid credentials" }` | Credenciales incorrectas |
| 403 | `{ "error": "Account disabled" }` | Cuenta desactivada |

---

### POST /api/auth/refresh

**Descripción**: Obtener nuevo access token usando refresh token.

**Request**: Cookie `refreshToken` (httpOnly)

**Response (200 OK)**:
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Error Responses**:
| Code | Body | Descripción |
|------|------|-------------|
| 401 | `{ "error": "Invalid or expired refresh token" }` | Token inválido |

---

### GET /api/auth/me

**Descripción**: Obtener información del usuario autenticado.

**Headers**: `Authorization: Bearer <accessToken>`

**Response (200 OK)**:
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "usuario@ejemplo.com",
  "name": "Juan Pérez",
  "role": "user",
  "createdAt": "2026-01-15T10:30:00Z"
}
```

---

## Usuarios

### GET /api/users

**Descripción**: Listar usuarios (admin only).

**Headers**: `Authorization: Bearer <accessToken>`

**Query Params**:
| Param | Type | Default | Descripción |
|-------|------|---------|-------------|
| page | number | 1 | Página |
| limit | number | 25 | Items por página |
| search | string | - | Buscar por nombre/email |
| role | string | - | Filtrar por rol |

**Response (200 OK)**:
```json
{
  "data": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "email": "usuario@ejemplo.com",
      "name": "Juan Pérez",
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

**Descripción**: Crear nuevo usuario (admin only).

**Request Body**:
```json
{
  "email": "nuevo@ejemplo.com",
  "name": "María García",
  "password": "securePass123",
  "role": "user"
}
```

**Response (201 Created)**:
```json
{
  "id": "990e8400-e29b-41d4-a716-446655440099",
  "email": "nuevo@ejemplo.com",
  "name": "María García",
  "role": "user",
  "createdAt": "2026-05-29T12:00:00Z"
}
```

---

### GET /api/users/{id}

**Descripción**: Obtener usuario por ID.

**Response (200 OK)**:
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "usuario@ejemplo.com",
  "name": "Juan Pérez",
  "role": "user",
  "isActive": true,
  "createdAt": "2026-01-15T10:30:00Z",
  "updatedAt": "2026-05-20T14:22:00Z"
}
```

**Error Responses**:
| Code | Body | Descripción |
|------|------|-------------|
| 404 | `{ "error": "User not found" }` | Usuario no existe |

---

### PATCH /api/users/{id}

**Descripción**: Actualizar usuario parcialmente.

**Request Body** (partial):
```json
{
  "name": "Juan Pérez Actualizado",
  "isActive": false
}
```

**Response (200 OK)**:
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "usuario@ejemplo.com",
  "name": "Juan Pérez Actualizado",
  "role": "user",
  "isActive": false,
  "updatedAt": "2026-05-29T14:00:00Z"
}
```

---

## Productos

### GET /api/products

**Descripción**: Listar productos.

**Query Params**:
| Param | Type | Default | Descripción |
|-------|------|---------|-------------|
| page | number | 1 | Página |
| limit | number | 25 | Items por página |
| category | UUID | - | Filtrar por categoría |
| search | string | - | Buscar por nombre |
| minPrice | number | - | Precio mínimo |
| maxPrice | number | - | Precio máximo |
| inStock | boolean | - | Solo productos con stock |

**Response (200 OK)**:
```json
{
  "data": [
    {
      "id": "660e8400-e29b-41d4-a716-446655440001",
      "name": "Camisa azul manga larga",
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

**Descripción**: Crear nuevo producto.

**Request Body**:
```json
{
  "name": "Pantalón negro slim fit",
  "description": "Pantalón de mezclilla, talla 32",
  "price": 49.99,
  "stock": 75,
  "categoryId": "770e8400-e29b-41d4-a716-446655440002",
  "minStock": 10,
  "imageUrl": "https://cdn.ejemplo.com/products/661e8400.jpg"
}
```

**Response (201 Created)**:
```json
{
  "id": "661e8400-e29b-41d4-a716-446655440001",
  "name": "Pantalón negro slim fit",
  "description": "Pantalón de mezclilla, talla 32",
  "price": 49.99,
  "stock": 75,
  "categoryId": "770e8400-e29b-41d4-a716-446655440002",
  "isActive": true,
  "createdAt": "2026-05-29T15:00:00Z"
}
```

---

### POST /api/products/bulk

**Descripción**: Carga masiva de productos.

**Content-Type**: `multipart/form-data`

**Request**:
| Field | Type | Required | Descripción |
|-------|------|---------|-------------|
| file | File | Yes | Excel o CSV con productos |
| validateOnly | boolean | No | Solo validar sin guardar |

**Response (200 OK)**:
```json
{
  "success": 95,
  "errors": [
    {
      "row": 5,
      "message": "Invalid price format",
      "data": { "name": "Producto X", "price": "abc" }
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

## Órdenes

### GET /api/orders

**Descripción**: Listar órdenes del usuario actual.

**Query Params**:
| Param | Type | Default | Descripción |
|-------|------|---------|-------------|
| status | string | - | Filtrar por estado |
| from | date | - | Fecha inicio |
| to | date | - | Fecha fin |

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

**Descripción**: Crear nueva orden.

**Request Body**:
```json
{
  "items": [
    { "productId": "660e8400-e29b-41d4-a716-446655440001", "quantity": 2 },
    { "productId": "661e8400-e29b-41d4-a716-446655440002", "quantity": 1 }
  ],
  "shippingAddress": {
    "street": "Av. Principal 123",
    "city": "Buenos Aires",
    "state": "CABA",
    "postalCode": "C1001",
    "country": "AR"
  },
  "notes": "Dejar en portería"
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

**Descripción**: Actualizar estado de orden (admin only).

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

## Códigos de Error Globales

| Code | Significado | Cuándo ocurre |
|------|-------------|---------------|
| 400 | Bad Request | Validación de datos fallida |
| 401 | Unauthorized | Token faltante o inválido |
| 403 | Forbidden | Sin permisos para este recurso |
| 404 | Not Found | Recurso no existe |
| 409 | Conflict | Recurso duplicado (ej: email ya registrado) |
| 422 | Unprocessable Entity | Datos válidos pero no procesables |
| 429 | Too Many Requests | Rate limit excedido |
| 500 | Internal Server Error | Error inesperado del servidor |

---

## Cómo Usar Estos Ejemplos

1. **Copiar** el endpoint que se parezca a tu API
2. **Adaptar** paths, nombres de recursos y campos
3. **Mantener** consistencia en formato de request/response
4. **Usar** los códigos de error globales para errores estándar

Para modelos de datos, ver `modelos.md`.
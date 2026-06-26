# API Documentation

## Autenticación

### POST /api/auth/login

**Descripción**: Autenticar usuario con credenciales.

**Request Body**:
```json
{
  "email": "string (email)",
  "password": "string (min 8 chars)"
}
```

**Response (200 OK)**:
```json
{
  "accessToken": "string (JWT)",
  "refreshToken": "string (httpOnly cookie)",
  "user": {
    "id": "string",
    "email": "string",
    "role": "admin | user | etc.",
    "idEmpresa": "number"
  }
}
```

**Error Responses**:
| Code | Body | Description |
|------|------|-------------|
| 400 | `{ error: "Invalid email format" }` | Email inválido |
| 401 | `{ error: "Invalid credentials" }` | Credenciales incorrectas |
| 403 | `{ error: "Account disabled" }` | Cuenta desactivada |

---

### POST /api/auth/refresh

**Descripción**: Obtener nuevo access token usando refresh token.

**Request**: Cookies (refresh token en httpOnly cookie)

**Response (200 OK)**:
```json
{
  "accessToken": "string (JWT)"
}
```

**Error Responses**:
| Code | Body | Description |
|------|------|-------------|
| 401 | `{ error: "Invalid refresh token" }` | Token inválido o expirado |

---

### GET /api/auth/me

**Descripción**: Obtener información del usuario actual.

**Headers**: `Authorization: Bearer <accessToken>`

**Response (200 OK)**:
```json
{
  "id": "string",
  "email": "string",
  "role": "string",
  "idEmpresa": "number",
  "permissions": ["string"]
}
```

---

## Usuarios

### GET /api/users

**Descripción**: Listar usuarios de la empresa.

**Headers**: `Authorization: Bearer <accessToken>`

**Query Params**:
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| page | number | 1 | Página (paginación) |
| limit | number | 25 | Items por página |
| search | string | - | Búsqueda por nombre/email |

**Response (200 OK)**:
```json
{
  "data": [
    {
      "id": "string",
      "email": "string",
      "role": "string",
      "createdAt": "ISO8601"
    }
  ],
  "meta": {
    "total": 100,
    "page": 1,
    "limit": 25,
    "totalPages": 4
  }
}
```

---

### POST /api/users

**Descripción**: Crear nuevo usuario.

**Request Body**:
```json
{
  "email": "string (email)",
  "password": "string (min 8 chars)",
  "role": "string",
  "idEmpresa": "number"
}
```

**Response (201 Created)**:
```json
{
  "id": "string",
  "email": "string",
  "role": "string",
  "createdAt": "ISO8601"
}
```

---

## Productos

### GET /api/products

**Descripción**: Listar productos.

**Query Params**:
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| page | number | 1 | Página |
| limit | number | 25 | Items por página |
| category | string | - | Filtrar por categoría |
| search | string | - | Búsqueda por nombre |

**Response**: Similar a `/api/users`

---

### POST /api/products

**Descripción**: Crear nuevo producto.

**Request Body**:
```json
{
  "name": "string",
  "description": "string",
  "price": "number",
  "stock": "number",
  "categoryId": "string",
  "imageUrl": "string (optional)"
}
```

---

### POST /api/products/bulk-upload

**Descripción**: Carga masiva de productos via Excel/CSV.

**Content-Type**: `multipart/form-data`

**Request Body**:
| Field | Type | Description |
|-------|------|-------------|
| file | File | Archivo Excel/CSV |
| validateOnly | boolean | Si true, solo valida sin guardar |

**Response (200 OK)**:
```json
{
  "success": 95,
  "errors": [
    {
      "row": 5,
      "message": "Invalid price format",
      "data": { ... }
    }
  ]
}
```

---

## Error Codes Globales

| Code | Meaning | When |
|------|---------|------|
| 400 | Bad Request | Validación fallida |
| 401 | Unauthorized | Token faltante o inválido |
| 403 | Forbidden | Sin permisos |
| 404 | Not Found | Recurso no existe |
| 409 | Conflict | Recurso duplicado |
| 500 | Internal Server Error | Error del servidor |

---

## Authentication Flow

```
1. Client → POST /api/auth/login → Server
2. Server → Set-Cookie (refreshToken) + accessToken → Client
3. Client → Store accessToken in memory → Client
4. Client → API requests with Authorization header → Server
5. Server → 401 if token expired → Client
6. Client → POST /api/auth/refresh (with cookie) → Server
7. Server → New accessToken → Client
8. Client → Retry original request → Server
```

---

**Last Updated**: YYYY-MM-DD  
**Maintained By**: @backend-lead

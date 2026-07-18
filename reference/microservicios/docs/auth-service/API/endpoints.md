# auth-service API Endpoints

## POST /api/auth/login

**Description**: Authenticate user.

**Request**:
```json
{ "email": "user@example.com", "password": "secret123" }
```

**Response 200**:
```json
{ "accessToken": "<JWT>", "user": { "id": "...", "email": "...", "role": "customer" } }
```
Refresh token set in httpOnly cookie `refreshToken`.

| Code | Body error                       | When              |
|------|----------------------------------|-------------------|
| 400  | `{ "error": "VALIDATION_ERROR" }` | Bad email format  |
| 401  | `{ "error": "INVALID_CREDENTIALS" }` | Wrong creds       |
| 429  | `{ "error": "RATE_LIMITED" }`    | Too many attempts |

---

## POST /api/auth/refresh

**Request**: cookie `refreshToken`

**Response 200**:
```json
{ "accessToken": "<new JWT>" }
```
Rotates the refresh token; detects reuse (revokes family).

---

## GET /api/auth/verify

**Headers**: `Authorization: Bearer <JWT>`

**Response 200**:
```json
{ "valid": true, "user": { "id": "...", "email": "...", "role": "customer", "idEmpresa": 1 } }
```
**Response 401**:
```json
{ "valid": false, "error": { "code": "UNAUTHORIZED", "message": "..." } }
```

---

## GET /api/auth/me

**Headers**: `Authorization: Bearer <JWT>`

**Response 200**:
```json
{ "id": "...", "email": "...", "role": "customer", "idEmpresa": 1, "permissions": ["orders:create"] }
```

---

**Last Updated**: 2026-07-18
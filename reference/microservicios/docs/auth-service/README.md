# auth-service

## Overview

Auth service handles user authentication, JWT issuance, and refresh-token rotation for DeliveryPlatform. Stateless verification endpoint consumed by every other service.

---

## Responsibilities

- [ ] Authenticate users with email/password
- [ ] Issue short-lived access tokens (JWT, 15min)
- [ ] Rotate refresh tokens (httpOnly cookie) with reuse detection
- [ ] Expose `/api/auth/verify` for internal callers

---

## Tech Stack

| Layer      | Technology  |
|------------|-------------|
| Language   | Node.js 20  |
| Framework  | Express 4   |
| Database   | PostgreSQL 15 (auth_db — isolated) |
| Testing    | Vitest      |

---

## API Endpoints

**Full**: `API/endpoints.md`

| Method | Endpoint             | Description       | Auth |
|--------|----------------------|-------------------|------|
| POST   | /api/auth/login      | User login        | ❌   |
| POST   | /api/auth/refresh    | Refresh access    | ❌ (cookie) |
| GET    | /api/auth/verify     | Internal verify   | ✅   |
| GET    | /api/auth/me         | Current user      | ✅   |

---

## DB Schema

**Full**: `DB/schema.md`

| Table        | Description                | ~Rows |
|--------------|----------------------------|-------|
| users        | Customer/admin accounts    | 1K+   |
| refresh_tokens | Hashed refresh tokens    | 1K+   |

---

## Module Dependencies

| Depends On | Service | Contract              | Purpose            |
|------------|---------|-----------------------|--------------------|
| —          | —       | —                     | No deps (leaf)     |

Downstream consumers: `orders-service`, `web-frontend`. See `docs/SHARED/contratos.md`.

---

## Local Dev

```bash
npm install
npm run dev          # http://localhost:3001
npm test
```

### Env
```
DATABASE_URL=postgresql://user:pass@localhost:5432/auth_db
JWT_SECRET=...
PORT=3001
```

### Docker
```bash
docker-compose up auth-service
```

---

## Deployment

| Env      | URL                              | Branch  |
|----------|----------------------------------|---------|
| Dev      | localhost:3001                    | any     |
| Staging  | https://auth-staging.delv.app     | develop |
| Prod     | https://auth.delv.app             | main    |

---

## Owner

| Role           | Person     |
|----------------|------------|
| Primary Owner  | @auth-lead |
| Reviewers      | @tech-lead |

---

**Last Updated**: 2026-07-18
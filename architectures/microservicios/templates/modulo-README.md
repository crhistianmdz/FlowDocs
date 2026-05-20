# <SERVICE_NAME> Service

## Overview

[Brief description of what this service does in 1-2 sentences.]

**Example:**
> Auth service handles user authentication, authorization, and JWT token management for the entire system.

---

## Responsibilities

- [ ] Responsibility 1 (ej: Authenticate users with email/password)
- [ ] Responsibility 2 (ej: Generate and validate JWT tokens)
- [ ] Responsibility 3 (ej: Manage user roles and permissions)
- [ ] Responsibility 4 (ej: Refresh token rotation)

---

## Tech Stack

| Layer | Technology | Version |
|-------|------------|---------|
| **Language** | Node.js / Go / Python | X.X |
| **Framework** | Express / Gin / FastAPI | X.X |
| **Database** | PostgreSQL / MySQL / MongoDB | X.X |
| **Testing** | vitest / go test / pytest | X.X |

---

## API Endpoints

**Full documentation**: `API/endpoints.md`

### Quick Reference

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | /api/auth/login | User login | ❌ |
| POST | /api/auth/refresh | Refresh token | ❌ (uses cookie) |
| GET | /api/auth/me | Get current user | ✅ |
| GET | /api/auth/users | List users | ✅ (admin only) |

---

## Database Schema

**Full documentation**: `DB/schema.md`

### Tables

| Table | Description | Row Count (approx) |
|-------|-------------|-------------------|
| users | User accounts | 1,000+ |
| roles | Role definitions | 5 |
| user_roles | User-role mappings | 1,000+ |

---

## Dependencies on Other Modules

| Depends On | Service | Contract | Purpose |
|------------|---------|----------|---------|
| — | — | — | [This service has no dependencies] |

**Or if it has dependencies:**

| Depends On | Service | Contract | Purpose |
|------------|---------|----------|---------|
| orders-service | orders | `POST /api/orders/validate` | Validate order before creating |
| inventory-service | inventory | `GET /api/inventory/stock` | Check stock availability |

**See**: `docs/SHARED/contratos.md` for full contract details.

---

## Local Development

### Prerequisites
- [ ] Node.js / Go / Python installed
- [ ] Database running (PostgreSQL on port 5432)
- [ ] Environment variables configured

### Run Locally

```bash
# Install dependencies
npm install / go mod download / pip install -r requirements.txt

# Run development server
npm run dev / go run main.go / python main.py

# Run tests
npm test / go test ./... / pytest
```

### Environment Variables

```bash
# .env file
DATABASE_URL=postgresql://user:pass@localhost:5432/auth_db
JWT_SECRET=your-secret-key
PORT=3001
NODE_ENV=development
```

**See**: `.env.example` for full list.

### Docker

```bash
# Run with docker
docker-compose up <service-name>

# Build and run
docker build -t <service-name> .
docker run -p 3001:3001 <service-name>
```

---

## Deployment

**See**: `docs/SHARED/deployments.md` for deployment guide.

### Environments

| Environment | URL | Branch | Auto-deploy |
|-------------|-----|--------|-------------|
| Development | localhost:3001 | any | ❌ |
| Staging | https://auth-staging.example.com | develop | ✅ |
| Production | https://auth.example.com | main | ✅ |

---

## Testing

### Test Coverage

| Type | Coverage | Command |
|------|----------|---------|
| Unit | >80% | `npm test -- --coverage` |
| Integration | >70% | `npm run test:integration` |
| E2E | Critical paths | `npm run test:e2e` |

### Run Tests

```bash
# All tests
npm test

# Unit tests only
npm run test:unit

# Integration tests only
npm run test:integration

# Watch mode
npm run test:watch
```

---

## Owner & Team

| Role | Person | Contact |
|------|--------|---------|
| **Primary Owner** | @person-name | Slack: @person |
| **Secondary** | @person-name | Slack: @person |
| **Reviewers** | @person-A, @person-B | — |

**PR Rule**: Primary owner must review all PRs for this service.

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | YYYY-MM-DD | Initial release |
| 1.1.0 | YYYY-MM-DD | Added refresh token rotation |

---

**Last Updated**: YYYY-MM-DD  
**Maintained By**: @primary-owner

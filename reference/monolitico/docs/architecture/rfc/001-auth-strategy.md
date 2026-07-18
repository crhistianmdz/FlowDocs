# RFC-001: Auth strategy — JWT vs server-side sessions

- **Status**: In Review
- **Author(s)**: @backend-lead
- **Date**: 2026-01-20
- **Project**: TaskManager

---

## 1. Summary

Decide the authentication mechanism for TaskManager: stateless JWT (access + refresh) vs server-side sessions stored in Redis.

---

## 2. Context

- App is a single deployable monolith serving API + SPA.
- Needs horizontal scalability behind a load balancer from day one (multi-tenant SaaS).
- Team has no prior Redis operations experience.
- Need to support "remember me" for 30 days.

Alternatives considered:
1. **JWT (access+refresh)**: stateless access tokens; refresh tokens in DB for rotation.
2. **Server sessions in Redis**: session id in httpOnly cookie; server keeps state.
3. **Hybrid**: JWT access + Redis-tracked refresh. (Excluded for complexity.)

---

## 3. Technical Decision (proposed)

### 3.1 Chosen Technology
| Item       | Selection                              | Justification                          |
|------------|-----------------------------------------|----------------------------------------|
| Access token | JWT, 15min, in-memory on client       | Stateless; cheap verification         |
| Refresh token | JWT, 30d, httpOnly cookie + DB rotation | Revocable; supports reuse detection |
| Hashing    | bcrypt (cost 12)                       | Industry standard                      |

---

## 4. Infrastructure

### 4.1 Containers
| Service   | Image        | Port | Description    |
|-----------|--------------|------|----------------|
| API       | node:20-alpine | 3001 | Express API    |
| Frontend  | vite preview | 4200 | SPA            |
| Database  | postgres:15  | 5432 | PostgreSQL     |

### 4.2 Environments
| Environment | URL                          |
|-------------|------------------------------|
| Development | localhost                    |
| Staging     | https://staging.taskmgr.app |
| Production  | https://app.taskmgr.app      |

---

## 5. Security Considerations
- Access tokens NEVER in localStorage (XSS risk).
- Refresh tokens: `httpOnly`, `Secure`, `SameSite=Strict`.
- Refresh rotation: every refresh issues a new token, invalidates the previous; DB tracks `family_id` to detect reuse → revoke family on reuse.
- Rate-limit `/auth/login` (5 attempts / 15min / IP).

---

## 6. Risks
| Risk                              | Impact   | Mitigation                          |
|------------------------------------|----------|-------------------------------------|
| Stolen refresh token               | High     | Rotation + reuse detection          |
| User logged out on token rotation race | Medium | Grace window of 30s                 |

---

## 7. Approval Status

| Role      | Person        | Status   | Date       |
|-----------|---------------|----------|------------|
| Tech Lead | @tech-lead    | Pending  | 2026-01-20 |

---

> Once approved → create `ADR-002` from this RFC.

## 8. Change History
| Date       | Change          | Author        |
|------------|-----------------|---------------|
| 2026-01-20 | Initial version | @backend-lead |
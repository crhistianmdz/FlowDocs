# Agent Context — TaskManager (Monolith)

## Project

- **Name**: TaskManager
- **Type**: Monolith (Backend + Frontend in one repo)
- **Created**: 2026-01-10
- **Owner**: @backend-lead

## Stack

| Layer       | Technology          | Version  |
|-------------|---------------------|----------|
| Runtime     | Node.js             | 20.x LTS |
| Backend     | Express             | 4.x      |
| Database    | PostgreSQL          | 15       |
| ORM         | Prisma              | 5.x      |
| Frontend    | React (CSR)         | 18.x     |
| Bundler     | Vite                | 5.x      |
| Testing     | Vitest + RTL        | 1.x      |
| Auth        | JWT (access+refresh) | —       |

## Module Structure

```
src/
├── components/   # Shared React components
├── services/     # Backend services (auth, tasks, users)
└── hooks/        # Shared React hooks
```

## Key Decisions (ADRs)

| ID     | Title                        | Status   |
|--------|------------------------------|----------|
| ADR-001 | Use PostgreSQL as primary DB | Accepted |
| ADR-002 | JWT with refresh-token rotation | Accepted |
| ADR-003 | Adopt Prisma as ORM          | In Review |

## Sources of Truth

- **PRD**: `docs/PRD.md`
- **Decisions**: `docs/architecture/adr/INDEX.md`
- **Proposals**: `docs/architecture/rfc/`
- **API**: `docs/api/endpoints.md`
- **DB**: `docs/database/schema.md`
- **Tasks**: `docs/tasks/`

## Conventions

- Commit style: Conventional Commits (`feat:`, `fix:`, `docs:`)
- All API responses use `{ data, meta }` envelope for collections
- Multi-tenant: every table includes `company_id`
- No `any` in TypeScript — strict mode

---

**Last Updated**: 2026-07-18
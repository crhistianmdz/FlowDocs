# ADR-001: Use PostgreSQL as primary database

- **Date**: 2026-01-15
- **Related RFC**: (none — straightforward decision)
- **Status**: Accepted

---

## Context

TaskManager needs a relational store with strong consistency for boards/cards/assignments, JSON columns for flexible card metadata, and good Node.js driver support. We compared PostgreSQL, MySQL, and MongoDB.

- MongoDB was rejected because card moves require transactional integrity across `cards` and `audit_log`.
- MySQL lacks native `JSONB` indexing suitable for flexible card fields.

---

## Decision

Use **PostgreSQL 15** as the primary datastore. JSON columns for flexible card metadata. UUID primary keys via `gen_random_uuid()`.

---

## Consequences

- **Positive**: ACID guarantees for card moves; rich indexing on JSON; mature ecosystem (Prisma, pgvector extensions possible later).
- **Negative**: Operational burden of running a Postgres cluster (backups, failover) — team must learn replication.
- **Neutral**: All teams standardized on SQL (no NoSQL branch).
- **Accepted technical debt**: Single instance for MVP; architecturally sharding of `company_id` left for Phase 4.
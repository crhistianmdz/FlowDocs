# ADR-002: JWT access + refresh-token rotation

- **Date**: 2026-02-02
- **Related RFC**: `docs/architecture/rfc/001-auth-strategy.md`
- **Status**: Accepted

---

## Context

TaskManager needs authentication for a multi-tenant SPA with horizontal scale behind a load balancer. RFC-001 evaluated JWT vs server sessions vs hybrid. The team has no Redis experience and stateless verification simplifies scaling.

---

## Decision

Adopt **JWT** with two tokens:
- **Access token**: 15min, verified statelessly, held in memory on the client.
- **Refresh token**: 30 days, httpOnly+Secure+SameSite=Strict cookie, stored hashed in DB, rotated on every refresh. Reuse detection by `family_id` revokes the whole family on anomaly.

---

## Consequences

- **Positive**: Stateless API verification; horizontal scale without session store; built-in session revocation.
- **Negative**: Refresh-token theft window exists; reuse detection adds DB write per refresh.
- **Neutral**: Frontend must implement silent-refresh on 401.
- **Accepted technical debt**: Single JWT signing key until Phase 4 (key rotation pending).
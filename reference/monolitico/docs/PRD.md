# PRD — TaskManager

## 1. System Overview

- **Project**: TaskManager
- **Target Platform**: Web (cross-browser), mobile- responsive
- **Review Date**: July 2026
- **Description**: Internal task management tool for small-to-mid teams. Boards, cards, assignments, due dates, and role-based access. Single deployable monolith serving both API and React SPA.

---

## 2. Specific Functional Requirements

### Main Use Cases
1. **Login / Auth**: Users authenticate with email+password; admins manage users.
2. **Boards**: Create boards, columns, and cards. Drag-and-drop reordering.
3. **Assignments**: Assign cards to users; receive notifications.
4. **Reporting**: View team workload and overdue cards.

### Exemplary User Flow
1. User opens app → redirected to `/login`.
2. Enters credentials → receives JWT (access + refresh cookie).
3. Lands on dashboard → sees assigned boards.
4. Opens a board → drags card across columns → state persists.
5. Receives in-app notification when assigned a new card.

---

## 3. Testing and Validation

### Required Test Types
1. **Unit Tests**: services, Utils, Zod schemas (Vitest, >80% coverage).
2. **Integration Tests**: API endpoints + DB (Supertest + Testcontainers).
3. **Performance Tests**: p95 < 300ms for board listing; 100 concurrent users.
4. **Recovery Tests**: DB rollback on failed transaction; refresh-token reuse detection.

### Tools and Metrics
- Coverage threshold: 80% (CI gate).
- Lighthouse score: >90 on key pages.

---

## 4. Edge Cases and Fault Tolerance
1. **Concurrent card moves**: optimistic UI + server reconciliation via `updated_at`.
2. **Expired refresh token**: silent re-login; preserve draft card content in `localStorage`.
3. **Network drop**: retry queue with exponential backoff.

---

## 5. Roadmap

### Project Phases
1. **MVP**: Auth + Boards + Cards (Q1 2026).
2. **Phase 2**: Notifications + reporting (Q2 2026).
3. **Phase 3**: Integrations (Slack, calendar) (Q3 2026).

---

## 6. Non-Functional Requirements
- **Scalability**: up to 500 users per company.
- **Usability**: first-meaningful-paint < 1.5s on 4G.
- **Performance**: API p95 < 300ms.
- **Security**: bcrypt password hashing; JWT short-lived; rate-limit `/auth/*`.

---

## 9. Dependencies and Technical Risks
1. **Prisma**: leaks connections under high concurrency — mitigated by connection pooling.
2. **React DnD**: bundle size overhead — code-split.

---

## Success Indicators
- DAU/MAU > 40% within 3 months.
- Onboarding completion > 70%.
- NPS > 30.

---

**Last Updated**: 2026-07-18
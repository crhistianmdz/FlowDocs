# PRD — TaskBoard SaaS

## 1. System Overview

- **Project**: TaskBoard SaaS
- **Architecture**: Monorepo (web + mobile + api + shared)
- **Description**: Cross-platform kanban for distributed teams. Web app, mobile app, and an API that both consume — plus shared UI utils and types.

---

## 2. Functional Requirements

### Main Use Cases
1. **Login** (web + mobile + api): shared auth flow, each package implements its slice.
2. **Boards & Cards**: full CRUD; offline-first on mobile.
3. **Real-time updates**: WebSocket from api to web, push on mobile.

### Exemplary User Flow
1. Mobile user logs in (mobile HU-001) → api verifies (api HU-001) → JWT issued.
2. Opens board → api serves WS subscription → cards stream.

---

## 3. Roadmap
- MVP: web + api login + boards.
- Phase 2: mobile parity.
- Phase 3: shared UI library extraction.

---

## 4. Monorepo Strategy
| Concern      | Where                          |
|--------------|--------------------------------|
| Product docs | `docs/PRD.md` (root)           |
| Architecture | root RFC/ADR (cross-cutting)   |
| Feature docs | `packages/<pkg>/docs/tasks/`   |
| Code sharing | `packages/shared/*` via `workspace:*` |

---

**Last Updated**: 2026-07-18
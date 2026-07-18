# Agent Context — TaskBoard (Monorepo)

## Project

- **Name**: TaskBoard SaaS
- **Type**: Monorepo (npm workspaces)
- **Created**: 2026-03-15
- **Owner**: @platform-lead

## Stack

| Layer   | Tech |
|---------|------|
| Monorepo tool | npm workspaces |
| Frontend (web) | React + Vite |
| Mobile | React Native (Expo) |
| API | Node.js + Fastify |
| Shared | TypeScript types, UI components, utils |
| Testing | Vitest + RTL + Maestro (mobile) |

## Packages

| Package  | Type     | Path                       | Owner       |
|----------|----------|----------------------------|-------------|
| web      | App      | `packages/web/`            | @web-lead    |
| mobile   | App      | `packages/mobile/`         | @mobile-lead|
| api      | Service  | `packages/api/`            | @api-lead    |
| shared/ui    | Lib | `packages/shared/ui/`    | @design-lead |
| shared/utils | Lib | `packages/shared/utils/`| @platform-lead|
| shared/types | Lib | `packages/shared/types/`| @platform-lead|

## Sources of Truth

- **PRD**: `docs/PRD.md`
- **Per-package tasks**: `packages/<pkg>/docs/tasks/`
- **Shared RFC/ADR**: `docs/` (cross-cutting)
- **SDD artifacts**: `openspec/changes/`

## Conventions

- Cross-package features get an HU **per package** (e.g., `HU-001-login` exists in `web` AND `api`).
- Shared packages version-pinned to `workspace:*`.
- Each package can deploy independently.

---

**Last Updated**: 2026-07-18
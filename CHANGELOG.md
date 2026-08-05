# Changelog

Documentation of changes and decisions adopted in the framework.

---

## 2026-08-05 — Specialist Architecture

### New Feature: Multi-Specialist Architecture

FlowDoc now uses an **orchestrator + specialists** architecture for documentation generation.

**Components**:

| Component | Purpose |
|-----------|---------|
| `flowdoc-assist` | Orchestrator — coordinates specialists |
| `flowdoc-discover` | Deep codebase investigation |
| `flowdoc-prd` | PRD document creation/updates |
| `flowdoc-rfc` | RFC creation/updates/closure |
| `flowdoc-adr` | ADR creation/updates/deprecation |
| `flowdoc-api` | API documentation from code |
| `flowdoc-db` | Database schema documentation |
| `flowdoc-hu` | User stories + post-dev updates |
| `flowdoc-review` | Documentation validation |

**Key Changes**:
- `flowdoc-assist` v3: now an orchestrator (was monolithic)
- New session register at `docs/.flowdoc/sessions/` (git-ignored)
- Skills registered in `.atl/skill-registry.md`

### New ADRs

| ADR | Title |
|-----|-------|
| ADR-013 | Specialist Orchestrator Architecture |
| ADR-014 | Session Register Location and Format |
| ADR-015 | Specialist Communication Protocol |
| ADR-016 | Parallel Execution Rules for Specialists |

### New RFC

| RFC | Title |
|-----|-------|
| RFC-005 | Specialist Architecture |

### New Templates

| Template | Purpose |
|----------|---------|
| `PRD_template_meta.md` | For documentation frameworks (not product projects) |

### Updated Documentation

- `AGENTS.md` — Skills table updated with all 9 specialists
- `docs/flowDocs/AGENT_MANUAL.md` — Specialist architecture documented
- `es/AGENTS.md` — Skills table (Spanish)
- `es/docs/flowDocs/AGENT_MANUAL.es.md` — Specialist architecture (Spanish)

### See Also

- [RFC-005](docs/architecture/rfc/005-specialist-architecture.md) — Full architecture spec
- [ADR-013](docs/architecture/adr/013-specialist-orchestrator-architecture.md) — Orchestrator ADR

---

## 2026-06-24 — Version 2.0: Documentation Only

### Breaking Change: Workflow Removed

FlowDocs is now **documentation-only**. The delivery workflow (15-day cycle, feature flags, SDD commands) has been removed.

**Why**: After evaluation, the team decided that documentation is the strength. The workflow added complexity without proportional value for most use cases.

### What Changed

| Component | Status | Now at |
|-----------|--------|--------|
| 15-day work cycle | **Deprecated** | `docs/deprecated/workflow/` |
| Feature flags | **Deprecated** | `docs/deprecated/workflow/` |
| SDD commands | **Removed** | N/A |
| walkthrough-hu-login.md | **Deprecated** | `docs/deprecated/workflow/` |
| architecture-diagram.md | **Deprecated** | `docs/deprecated/workflow/` |
| ADR-003 (ciclo-15-dias) | **Deprecated** | `docs/deprecated/architecture/` |
| ADR-004 (feature-flags) | **Deprecated** | `docs/deprecated/architecture/` |
| RFC-002 (ciclo-15-dias) | **Deprecated** | `docs/deprecated/architecture/` |
| RFC-003 (feature-flags) | **Deprecated** | `docs/deprecated/architecture/` |

### What Remains

| Component | Purpose |
|-----------|---------|
| ADR system | Recording technical decisions |
| RFC system | Discussing proposals |
| Templates | Starting points for docs |
| API contracts | Service documentation |
| DB schema | Database documentation |
| AI agent compatibility | Any agent can read `docs/` |

### Updated Files

| File | Change |
|------|--------|
| `AGENTS.md` | Removed SDD workflow, focused on documentation |
| `README.md` | Updated to reflect documentation-only |
| `docs/PRD.md` | Completely rewritten |
| `docs/FAQ.md` | Removed workflow references |
| `docs/anti-patrones.md` | Removed process anti-patterns |
| `docs/adoption-guide.md` | Removed workflow levels |
| `docs/troubleshooting.md` | Removed workflow issues |
| `docs/legacy-migration.md` | Removed workflow references |
| `ONBOARDING.md` | Simplified for documentation |
| `QUICKSTART.md` | Simplified for documentation |

### See Also

- [docs/deprecated/README.md](docs/deprecated/README.md) — What's in the deprecated folder
- [docs/PRD.md](docs/PRD.md) — New product requirements

---

## 2026-06-03 — SDD Sub-agent Context Pattern

### New ADRs

| ADR | Title |
|-----|-------|
| ADR-009 | SDD Sub-agent Context Pattern |

---

## 2026-05-29 — Framework Name: FlowDoc

### Naming Decision

The framework is called **FlowDoc**.

| Project | Purpose |
|---------|---------|
| **FlowDoc** | Documentation framework that flows with the work |
| **FlowForge** | Tool that minimizes SDD overhead |

See [ADR-008](docs/architecture/adr/008-nombre-flowdoc.md).

---

## Previous Versions

See [docs/deprecated/](docs/deprecated/) for workflow documentation from v1.0.

# Changelog

Documentation of changes and decisions adopted in the framework.

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

# Architecture Decisions Index

> **Auto-maintained**: When creating a new ADR, add it to this index.
>
> **ID format**: `NNN-name.md` (e.g., `001-my-decision.md`) — numbers are never reused.
> **Statuses**: `Draft` → `In Review` → `Accepted` (or `Deprecated` / `Superseded by ADR-NNN`).
> **Why gaps in numbering?** Deprecated ADRs keep their number for historical reference. A gap signals "something was here but it's no longer active."

## All ADRs

| ID | Title | Status | Date |
|----|-------|--------|------|
| ADR-001 | Persistencia Engram for SDD Artifacts | Accepted | 2026-05-29 |
| ADR-002 | docs/ as Source of Truth | Accepted | 2026-05-29 |
| ADR-003 | Ciclo de Trabajo de 15 Días | Deprecated | 2026-05-29 |
| ADR-004 | Feature Flags Obligatorios | Deprecated | 2026-05-29 |
| ADR-005 | Organización de HUs por rangos de 100 | Accepted | 2026-05-29 |
| ADR-006 | Cuatro Arquitecturas Soportadas | Accepted | 2026-05-29 |
| ADR-007 | Estructura de Templates (docs/templates/ como source of truth) | Accepted | 2026-05-29 |
| ADR-008 | Nombre del Framework: FlowDoc | Accepted | 2026-05-29 |
| ADR-009 | SDD Sub-agent Context Pattern | Deprecated | 2026-05-29 |
| ADR-011 | Self-Contained Skill Templates and ADR Index | Accepted | 2026-07-18 |
| ADR-012 | Visual Reference Structures for Architecture Patterns | Accepted | 2026-07-18 |

## By Status

### Accepted
- [ADR-001 — Persistencia Engram](./001-persistencia-engram.md)
- [ADR-002 — docs/ como Source of Truth](./002-docs-source-of-truth.md)
- [ADR-005 — Organización de HUs](./005-organizacion-hu.md)
- [ADR-006 — Cuatro Arquitecturas](./006-cuatro-arquitecturas.md)
- [ADR-007 — Estructura de Templates](./007-estructura-templates.md)
- [ADR-008 — Nombre FlowDoc](./008-nombre-flowdoc.md)
- [ADR-011 — Self-Contained Skill Templates and ADR Index](./011-self-contained-skill-and-index.md)
- [ADR-012 — Visual Reference Structures for Architecture Patterns](./012-visual-reference-structures.md)

### Deprecated
<!-- Deprecated ADRs keep their number for historical reference. Do NOT reuse numbers. -->
- ADR-003 — Ciclo de Trabajo de 15 Días → `../deprecated/architecture/003-ciclo-15-dias.md`
- ADR-004 — Feature Flags Obligatorios → `../deprecated/architecture/004-feature-flags.md`
- ADR-009 — SDD Sub-agent Context Pattern → `../deprecated/architecture/009-sdd-subagent-context-pattern.md`

### In Review
<!-- Add ADRs currently under review here -->

### Draft
<!-- Add ADRs in draft state here -->

---

## Status Definitions

| Status | Meaning |
|--------|---------|
| Draft | Being written, not yet circulated |
| In Review | Under discussion (usually paired with an RFC) |
| Accepted | Decision made and in effect |
| Deprecated | No longer in effect (kept for history) |
| Superseded | Replaced by a later ADR (link it) |
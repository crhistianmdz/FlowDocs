# Deprecated — FlowDocs Workflow Components

**Date**: 2026-06-24
**Reason**: FlowDocs v2.0 focuses purely on documentation structure, not delivery workflow.

---

## What's here

This folder contains the **delivery workflow** components that were removed in v2.0. They are kept for historical reference in git.

### Workflow (docs/deprecated/workflow/)

| File | Description |
|------|-------------|
| `flowdoc-ciclo.md` | 15-day work cycle (Planning → Execution → Integration → Retrospective) |
| `walkthrough-hu-login.md` | Complete example of a HU through the full SDD cycle |
| `architecture-diagram.md` | Mermaid diagrams of the work cycle and SDD flow |

### Architecture Decisions (docs/deprecated/architecture/)

| File | Description |
|------|-------------|
| `003-ciclo-15-dias.md` | ADR: 15-Day Work Cycle |
| `004-feature-flags.md` | ADR: Mandatory Feature Flags |
| `002-ciclo-15-dias.md` | RFC: 15-Day Work Cycle discussion |
| `003-feature-flags.md` | RFC: Feature Flags discussion |

---

## Why these are deprecated

FlowDocs v2.0 is now **documentation-only**. The team decided:

1. **Documentation is the strength**: The ADR/RFC/template system is what makes FlowDocs valuable
2. **Workflow adds complexity**: The 15-day cycle, feature flags, and delivery ceremonies were overhead for most use cases
3. **AI agents benefit more from pure docs**: Any AI tool can read `docs/` without needing to understand sprint planning

---

## If you need the workflow

These components are fully functional and were working well for teams that needed:
- Sprint-like structure
- Feature flags for parallel development
- Integration/verification phases

Copy them back into your project if your team needs this level of coordination.

---

## See also

- [FlowDocs README](../README.md) — Current framework (documentation-only)
- [docs/PRD.md](../PRD.md) — Product Requirements (rewritten)
- [docs/adoption-guide.md](../adoption-guide.md) — Adoption levels (simplified)

# Architecture Decision Records

**Permanent record of technical decisions.**

---

## ADR Index

| # | Title | Status | EN | ES |
|---|-------|--------|----|----|
| 001 | Persistencia Engram | Accepted | ✅ | ✅ |
| 002 | docs/ como Source of Truth | Accepted | ✅ | ✅ |
| 003 | Ciclo de Trabajo de 15 Días | **Deprecated** | ⚠️ `../deprecated/architecture/003-ciclo-15-dias.md` | ✅ |
| 004 | Feature Flags Obligatorios | **Deprecated** | ⚠️ `../deprecated/architecture/004-feature-flags.md` | ✅ |
| 005 | Organización de HUs | Accepted | ✅ | ✅ |
| 006 | Cuatro Arquitecturas | Accepted | ✅ | ✅ |
| 007 | Estructura de Templates | Accepted | ✅ | ✅ |
| 008 | Nombre FlowDoc | Accepted | ✅ | ✅ |
| 009 | SDD Sub-agent Context Pattern | **Deprecated** | ⚠️ `../deprecated/architecture/009-sdd-subagent-context-pattern.md` | ⚠️ `../../deprecated/architecture/009-sdd-subagent-context-pattern.md` |

---

## Why gaps in numbering?

Numbers are **never reused**. When an ADR is deprecated, it stays at its number for historical reference. The gap signals "something was here but it's no longer active."

## Status Definitions

| Status | Meaning |
|--------|---------|
| **Accepted** | Active decision, currently in use |
| **Deprecated** | Superseded by FlowDocs v2.0 (documentation-only) or a later decision |

---

## Creating an ADR

1. Copy `../templates/architecture/ADR_template.md`
2. Use the next available number
3. Status starts as `Draft` → `In Review` → `Accepted`

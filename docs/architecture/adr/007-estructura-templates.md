# ADR-007: docs/templates/ as Source of Truth

**Date**: 2026-05-29  
**Related RFC**: None (framework organization decision)  
**Status**: Accepted

---

## Context

The framework has templates in multiple locations:
- `/templates/` — generic templates
- `/reference/monolitico/templates/` — specific examples
- `/reference/microservicios/templates/` — specific examples

This dispersion causes confusion about which one to use and what is the source of truth. New developers don't know if they should copy from `/templates/` or from `reference/*/templates/`.

AI agents need to know the canonical location to propose correct changes.

---

## Decision

**`docs/templates/` is the source of truth** for all framework templates.

```
docs/templates/           ← Source of truth (copy from here)
├── user-stories/         ← User story templates
├── bug-fixes/            ← Bug fix templates
├── refactors/            ← Refactor templates
├── architecture/         ← RFC and ADR templates
├── database/             ← Schema templates
├── api/                  ← Endpoint and model templates
└── PRD/                  ← PRD templates

reference/*/          ← Reference examples (do not modify)
├── monolitico/
├── microservicios/
├── monorepo/
└── serverless/
```

### Fundamental Rule

**Always copy from `docs/templates/`**. `reference/*/` are reference examples, not templates to copy directly.

---

## Structure of `docs/templates/`

| Folder | Content |
|--------|---------|
| `user-stories/` | `template-user-story.md`, `template-user-story-detailed.md` |
| `bug-fixes/` | `template-bug-fix.md`, `template-bug-fix-detailed.md` |
| `refactors/` | `template-refactor.md` |
| `architecture/` | `RFC_template.md`, `ADR_template.md` |
| `database/` | `schema.md` (generic example) |
| `api/` | `endpoints.md`, `modelos.md` (generic examples) |
| `PRD/` | `PRD.md` (main template) |

---

## `reference/` as Reference

Each architecture folder includes:

```
reference/monolitico/
├── estructura.md              ← Structure guide
├── templates/                 ← EXAMPLE COPIES (not templates)
│   ├── HU-TEMPLATE.md
│   ├── API-endpoints.md
│   └── DB-schema.md
└── scripts/
    └── init-monolith.sh

reference/microservicios/
├── estructura.md
├── templates/
│   ├── modulo-README.md
│   ├── contratos.md
│   └── HU-TEMPLATE.md
└── scripts/
    └── init-microservices.sh
```

**Important**: Files in `reference/*/templates/` are **example copies**, not copied directly to new projects. They are used as reference for what is expected in each architecture type.

---

## Why Not Unify Everything in `templates/`

1. **`docs/` is the source of truth** according to ADR-002 (docs/ as source of truth)
2. **`reference/` as examples** allows visualizing how the complete structure looks in each case
3. **Scalability**: adding a new architecture doesn't require changing the template structure
4. **Consistency**: developers always go to `docs/templates/` without confusion

---

## Consequences

### ✅ Positive

- Single location for templates (no ambiguity)
- `reference/` stays clean as reference
- Agents and developers know where to go
- Structure consistent with docs/ as source of truth decision (ADR-002)

### ❌ Negative

- There are two sets of similar files (docs/templates/ vs reference/*/templates/)
- Requires keeping both structures synchronized at the beginning

### 🔄 Neutral

- `reference/` is not deleted, remains as reference documentation
- In the future, root `templates/` could be deprecated and only `docs/templates/` used

---

## Migration Path

1. **Short term**: Create `docs/templates/` with the correct structure
2. **Medium term**: Initialization scripts copy from `docs/templates/`, not from `reference/*/`
3. **Long term**: Root `templates/` becomes deprecated, `docs/templates/` is the only place

---

## Related Documents

| Document | Location |
|----------|----------|
| docs/ as source of truth | ADR-002 |
| Templates guide | `docs/templates/TEMPLATE_GUIDE.md` |
| Initialization | `scripts/init-*.sh` (to be updated) |

---

## Implementation Checklist

- [ ] `docs/templates/` created with subfolders
- [ ] Templates moved/copied to `docs/templates/`
- [ ] `TEMPLATE_GUIDE.md` updated with new structure
- [ ] Initialization scripts updated (copy from docs/templates/)
- [ ] `reference/*/templates/` marked as "reference examples" in their READMEs
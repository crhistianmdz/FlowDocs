# Templates Guide — When and Which to Use

> This guide explains what templates exist, why there are two versions of some, and when to use each one.

> **ℹ️ Note**: These templates are documentation — for the actual implementation used by the `flowdoc-assist` skill, see `skills/flowdoc-assist/templates/`. The skill ships a self-contained copy of the templates it relies on so it can operate independently of this folder.

---

> **⚠️ Note**: English templates are now the primary version.
> Spanish templates are available at `es/docs/templates/`.

---

## Overview of Templates

```
docs/templates/               ← Source of truth (copy from here)
├── TEMPLATE_GUIDE.md         ← This guide
├── user-stories/
│   ├── template-user-story.md       ← User Story (simple)
│   └── template-user-story-detailed.md   ← User Story (SDD-Ready) ⭐
├── bug-fixes/
│   ├── template-bug-fix.md          ← Bug Fix (simple)
│   └── template-bug-fix-detailed.md      ← Bug Fix (SDD-Ready) ⭐
├── refactors/
│   └── template-refactor.md         ← Refactor
├── architecture/
│   ├── RFC_template.md              ← Request for Comments
│   └── ADR_template.md              ← Architecture Decision Record
├── database/
│   └── schema.md                    ← Generic Database Schema
├── api/
│   ├── endpoints.md                 ← API Endpoints example
│   └── modelos.md                   ← Models/DTOs example
└── PRD/
    ├── PRD.md                       ← Product Requirements Document
    └── PRD_template.md              ← PRD Template with ML/AI sections

reference/*/               ← Reference examples (do not modify)
├── monolitico/
├── microservicios/
├── monorepo/
└── serverless/
```

### Reference Folders — Visual Structures for Each Architecture Pattern

The `reference/<pattern>/` folders show **complete visual structures** for each of the four supported architectures. Each one contains a representative full project layout — with the expected `docs/` tree, an example `src/` layout, example scripts, configuration, an `estructura.md` describing the layout, and an `.agent-context.md` for AI agents.

Their purpose is to make the folder organization **concrete and visible at a glance**, so you can compare patterns without reconstructing them from prose. They are **read-only examples**, not templates to copy into a project — `docs/templates/` remains the source of truth for human-authored templates.

> See [ADR-012 — Visual Reference Structures for Architecture Patterns](../architecture/adr/012-visual-reference-structures.md) for the decision rationale.

---

## Why Two Versions (simple vs SDD-Ready)?

### The Difference

| Feature | Simple | SDD-Ready |
|---------|--------|-----------|
| Basic User Story | ✅ | ✅ |
| Acceptance criteria | ✅ | ✅ |
| Given/When/Then scenarios | ❌ | ✅ |
| Test references (🧪 Ref) | ❌ | ✅ |
| Feature Flag integration | ❌ | ✅ |
| Contract Layer (owner, deadline) | ❌ | ✅ |
| Documented technical debt | ❌ | ✅ |

### The "Why"

**Simple**: For teams just starting with SDD or for small tasks where the full ceremony would be overhead.

**SDD-Ready**: For real features where you need complete traceability between what is specified and the tests that verify it.

---

## When to Use Each Template

### User Stories

| Case | Template | Example |
|------|----------|---------|
| Very small task, 1-2h | Simple | Fix typo, change copy |
| Normal feature, 1-3 days | SDD-Ready | Login, CRUD, search |
| Complex feature, 3+ days | SDD-Ready + split | Payment module |

**Recommendation**: If unsure, use **SDD-Ready**. The extra overhead is worth it.

---

### Bug Fixes

| Case | Template | Why |
|------|----------|-----|
| Obvious bug, trivial fix | Simple | Just verify nothing breaks |
| Bug with unclear root cause | SDD-Ready | You need to understand the full scenario |
| Bug that requires a test | SDD-Ready | 🧪 Ref helps track which test verifies the fix |

**Recommendation**: Most bugs should use **SDD-Ready** because you need to ensure they don't recur.

---

### Refactors

| Case | Template |
|------|----------|
| Small refactor, same behavior | `template-refactor.md` |
| Large refactor with API changes | SDD-Ready + ADR if there is an architecture decision |

---

### PRD

| Template | When to use |
|----------|-------------|
| `PRD.md` | New project, living product document |
| `PRD_template.md` | Detailed template with ML/AI sections (use if applicable) |

---

### RFC vs ADR

| Template | Status | Use |
|----------|--------|-----|
| `RFC_template.md` | Under Discussion | When you are evaluating a technical decision |
| `ADR_template.md` | Approved | When the decision is already made and is permanent |

**Flow**: RFC (discussion) → ADR (recorded decision)

---

## Quick Decision Guide

```
Need to document a technical decision?
├── Already decided?
│   ├── YES → Create ADR (docs/templates/architecture/ADR_template.md)
│   └── NO → Create RFC (docs/templates/architecture/RFC_template.md)
│
Need a new feature?
├── Very small (< 2h)?
│   └── USE: docs/templates/user-stories/template-user-story.md
└── Normal or large?
    └── USE: docs/templates/user-stories/template-user-story-detailed.md ⭐
    └── If large → split into smaller HUs
    └── If requires technical decision → RFC first
│
Found a bug?
├── Is the fix obvious and trivial?
│   └── USE: docs/templates/bug-fixes/template-bug-fix.md
└── Need to verify it doesn't recur?
    └── USE: docs/templates/bug-fixes/template-bug-fix-detailed.md
    └── Is there an architecture decision involved?
        └── ADR after the fix
│
Going to refactor?
└── USE: docs/templates/refactors/template-refactor.md
    └── If changes API or architecture → also create ADR
│
Documenting product?
└── USE: docs/templates/PRD/PRD.md (new project)
    └── If ML/AI project → docs/templates/PRD/PRD_template.md
```

---

## Tips

1. **Don't use templates out of inertia**: If the task is trivial, use the simple template. If it's important, use SDD-Ready.

2. **Split large HUs**: If a HU has more than 5 Given/When/Then scenarios, it probably should be split.

3. **🧪 Refs matter**: Each scenario needs a test that verifies it. If there is no test, the scenario is not complete.

4. **ADRs are not deleted**: When a decision changes, create a new ADR and mark the old one as `DEPRECATED`. Don't delete it.

---

## Resources

- SDD-Ready Template: `docs/templates/user-stories/template-user-story-detailed.md`
- SDD-Ready Template: `docs/templates/bug-fixes/template-bug-fix-detailed.md`
- Refactor Template: `docs/templates/refactors/template-refactor.md`
- RFC Template: `docs/templates/architecture/RFC_template.md`
- ADR Template: `docs/templates/architecture/ADR_template.md`
- PRD Template: `docs/templates/PRD/PRD.md`
- SDD Cycle: `docs/deprecated/workflow/flowdoc-ciclo.md` (deprecated)
- Troubleshooting guide: `docs/troubleshooting.md`
- Template structure decision: `docs/architecture/adr/007-estructura-templates.md`

---

## HU Organization in the Filesystem

As a project grows, accumulating many HUs in a single folder can affect filesystem performance and make it difficult to find specific files.

### Rule: Ranges of 100

```
docs/tasks/
├── HU-001-HU-099/           ← Phase 1
│   ├── HU-001-first-feature.md
│   └── ...
├── HU-100-HU-199/           ← Phase 2 (create when HU-099 exists)
│   └── ...
├── HU-200-HU-299/           ← Phase 3 (create when HU-199 exists)
│   └── ...
```

### When to Apply

| Number of HUs | Strategy |
|---------------|----------|
| < 50 | Flat folder (no need to split) |
| 50-99 | Consider creating next folder |
| ≥ 100 | Mandatory — split by range |

### How to Create the Next Folder

1. When the last HU of the range exists (e.g: HU-099), create the next range folder
2. Don't create empty folders ahead of time
3. Move the corresponding HU to the range

```bash
# When HU-099 is complete
mkdir -p docs/tasks/HU-100-HU-199

# Move the first HU of the new range
mv docs/tasks/HU-100-login.md docs/tasks/HU-100-HU-199/
```

### In Commits

The full HU path changes when including the folder:

```
docs/tasks/HU-001-HU-099/HU-042-login.md
```

```bash
# Commit message stays the same
git add docs/tasks/HU-001-HU-099/HU-042-login.md
git commit -m "feat: HU-042 - add login page"
```

### Scripts

Scripts like `hu-to-issues.sh` automatically detect the folder based on the HU number.

See ADR-005 for more details on the decision.
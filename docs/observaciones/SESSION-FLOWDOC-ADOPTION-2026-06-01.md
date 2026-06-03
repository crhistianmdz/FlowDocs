# Session Notes — FlowDoc Adoption (2026-06-01)

> Summary of observations and decisions from the FlowDoc adoption session for engram-dotnet.

---

## What We Did

### FlowDoc Scenario A Adoption

Adopted FlowDoc in engram-dotnet using **Scenario A: Legacy Project WITH Existing SDD**.

**Steps completed:**

| Step | Status |
|------|--------|
| 1. Inventory | ✅ Analyzed existing structure (docs/, sdd/, openspec/) |
| 2. Create FlowDoc structure | ✅ `docs/architecture/`, `docs/tasks/HU-001-HU-099/`, `docs/templates/` |
| 3. Migrate ADRs/RFCs | ✅ Moved to `docs/architecture/adr/` and `docs/architecture/rfc/` |
| 4. Map sdd/ changes to HUs | ✅ 6 HUs created in `docs/tasks/HU-001-HU-099/` |
| 5. Deprecate sdd/ and openspec/ | ✅ Both marked as deprecated with README.md + migration mapping |
| 6. Create AGENTS.md | ✅ Adapted to engram-dotnet project |
| 7. Validate structure | ✅ All checks passed |

**Migration mapping (sdd/ → docs/tasks/HU-001-HU-099/):**

| Old sdd/ Change | New HU |
|----------------|--------|
| backend-config-switch | HU-001 |
| obsidian-export | HU-002 |
| postgres-backend | HU-003 |
| promotion-level2 | HU-004 |
| traceability | HU-005 |
| ttl-configurable | HU-006 |

---

## Key Decisions

### 1. Keep sdd/ as Deprecated, Not Deleted

**Decision:** Leave `sdd/` and `openspec/` in place (not deleted), marked as deprecated with migration documentation.

**Rationale:**
- Preserves git history
- Maintains traceability for historical decisions
- Documents what was migrated and where

### 2. OpenCode @ Syntax — Clarification

**Finding:** The `@` prefix in file paths within markdown files does NOT auto-load content into agent context.

**What it actually does:** `@` is a fuzzy search shortcut in OpenCode's UI for finding files quickly, not a content loader.

**Implication:** Agents need explicit instruction to read files. The `@` syntax is for navigation, not context injection.

> **ADR-009**: This finding directly motivated [ADR-009: SDD Sub-agent Context Pattern](../architecture/adr/009-sdd-subagent-context-pattern.md), which provides a structured solution for context injection without relying on the `@` syntax.

### 3. AGENTS.md Updates

Added two important rules:

```markdown
**This agent DOES:**
- **After completing SDD Archive or any SDD phase**: Document findings, decisions, and changes in `docs/` following the appropriate convention
- **Any documentation requested by the user**: Save it to `docs/` even if outside SDD flow — for team handoff, cross-session continuity, or other developers
```

**Why:**
- SDD phases generate decisions and findings that shouldn't be lost after archiving
- Team members or future sessions need to understand why things were done
- User requests outside SDD flow still need to be documented for continuity

### 4. Documentation Conventions Section

Created a dedicated "Documentation Conventions" section in AGENTS.md:

```markdown
## Documentation Conventions

All documentation lives in `docs/` (source of truth). Use the appropriate location and template:

| Type | Location | Template |
|------|----------|----------|
| Feature/Bug | `docs/tasks/HU-001-HU-099/` | `templates/user-stories/` or `templates/bug-fixes/` |
| Architectural Decision | `docs/architecture/adr/` | `ADR_template.md` |
| Proposal (under discussion) | `docs/architecture/rfc/` | `RFC_template.md` |
| Product Requirements | `docs/architecture/rfc/` | `PRD.md` |

### When to Document (regardless of SDD flow)

- **After SDD Archive**: Decisions, findings, and changes
- **User requests**: Any documentation the user asks for — even outside SDD
- **Team handoff**: Information needed by other developers or sessions
- **Cross-session continuity**: Context that should survive session ends

### Documentation Location

[structure tree]
```

**Why:**
- Without explicit location guidance, documentation gets scattered (we saw this with docs/, sdd/, openspec/)
- Templates ensure consistency across documentation
- "When to Document" rule ensures documentation even outside formal SDD
- Different document types need different locations and templates for discoverability

---

## Lessons Learned

1. **Dual documentation systems are problematic.** engram-dotnet had docs/, sdd/, and openspec/ — all partially used. FlowDoc unifies into docs/.

2. **SDD incomplete adoption is common.** Several sdd/ changes had proposals but no specs or tasks. HU migration captures the intent but implementation is incomplete.

3. **AGENTS.md is context, not code.** Reading AGENTS.md gives agents path references, not content auto-load. Must explicitly read files for actual content.

4. **Documentation should survive sessions.** The rule "save user-requested docs to docs/" ensures continuity across team members and sessions.

---

## Project Structure (Final)

```
docs/
├── architecture/
│   ├── adr/
│   │   ├── ADR-001-no-orm.md
│   │   └── README.md
│   └── rfc/
│       ├── RFC-001-postgresql-backend.md
│       ├── RFC-002-multi-user-isolation.md
│       ├── RFC-003-offline-first-sync-architecture.md
│       ├── RFC-004-ambiguous-project-recovery.md
│       ├── RFC-005-prompt-auto-capture.md
│       ├── PRD-001-postgresql-backend.md
│       └── README.md
├── tasks/
│   └── HU-001-HU-099/
│       ├── HU-001-backend-config-switch.md
│       ├── HU-002-obsidian-export.md
│       ├── HU-003-postgres-backend.md
│       ├── HU-004-promotion-level2.md
│       ├── HU-005-traceability.md
│       └── HU-006-ttl-configurable.md
├── templates/            ← (empty, use flowdoc-migration.sh to populate)
├── flowdoc-ciclo.md
├── adoption-guide.md
└── *.md                  ← existing docs

sdd/                     ← ⚠️ DEPRECATED (with README.md)
openspec/                 ← ⚠️ DEPRECATED (with README.md)
AGENTS.md                ← updated with FlowDoc rules
```

---

## Next Steps (For Human)

1. Review the migration (git status)
2. Commit with: `feat: adopt FlowDoc framework`
3. Consider populating `docs/templates/` with actual template files
4. Follow up on HUs that have proposals but no specs/tasks (HU-001 specifically)

---

**Last updated**: 2026-06-01
**Session context**: FlowDoc adoption, Scenario A, engram-dotnet
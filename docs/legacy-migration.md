# Migration Guide: Existing Project to FlowDocs

> How to adopt FlowDocs documentation structure in an existing project without rewriting everything.

---

## When to Migrate

| Signal | Description |
|-------|-------------|
| Project > 6 months | Documentation outdated or missing |
| Team members work differently | No shared conventions |
| Onboarding takes > 1 week | Newcomers can't find anything |
| Knowledge lost when someone leaves | Decisions not documented |

If your project has 2+ of these signals, it's time to add FlowDocs structure.

---

## Core Principle

**Don't rewrite everything.** Add structure incrementally:

1. Create `docs/` folder with templates
2. Document decisions as they're made (not retroactively)
3. New code follows the structure
4. Legacy code is documented when touched

---

## Phase 1: Base Structure (Day 1)

### 1.1 Create `docs/` folder

```bash
cd your-project
mkdir -p docs/architecture/rfc
mkdir -p docs/architecture/adr
mkdir -p docs/api
mkdir -p docs/database
mkdir -p docs/templates
```

### 1.2 Copy templates

```bash
# Copy from FlowDocs templates
cp -r /path/to/flowdocs/docs/templates/* docs/templates/
```

### 1.3 Create `docs/PRD.md`

Document what the project is:
```markdown
# PRD: Project Name

**Version**: 1.0
**Last updated**: YYYY-MM-DD

## 1. Summary
[What this project does]

## 2. Tech Stack
[Technologies used]

## 3. Team
[Team size, time zones]
```

### 1.4 Create `AGENTS.md` at root

The `AGENTS.md` file helps AI agents understand the project. Create it at the project root.

See the `AGENTS.md` in FlowDocs repository as reference.

---

## Phase 2: Document Existing Decisions (Week 1)

### 2.1 Create legacy state ADR

Create `docs/architecture/adr/000-legacy-state.md`:

```markdown
# ADR-000: Legacy State

**Date**: YYYY-MM-DD

## Context

Existing project with [X] months/years of development.
Stack: [current technologies]
Team: [size, time zones]

## Known Technical Decisions

[What you know about past decisions, even if not documented]

## Technical Debt

| # | Area | Impact | Proposal |
|---|------|--------|----------|
| 1 | [Area] | High/Medium/Low | [Solution] |

## What Exists (inventory)

- **Frontend**: [stack]
- **Backend**: [stack]
- **Database**: [engine]
- **External APIs**: [list]
```

### 2.2 Don't try to document everything

**Rule**: Document what you know, not what you guess. Future decisions get ADRs.

---

## Phase 3: New Code Follows Structure (Ongoing)

### For every new feature or change

| If change touches... | Update... |
|---------------------|-----------|
| API endpoint | `docs/api/endpoints.md` |
| Database schema | `docs/database/schema.md` |
| Technical decision | Create ADR in `docs/architecture/adr/` |
| Module structure | `docs/architecture/` (RFC if discussion needed) |

**Rule**: Update docs in the SAME PR that changes code.

---

## Phase 4: Complete Structure (Month 2-3)

After applying the structure for a while, you'll have:

```
your-project/
├── docs/
│   ├── PRD.md                    ← Project overview
│   ├── FAQ.md                    ← Common questions
│   ├── tech-debt.md              ← Debt registry
│   ├── architecture/
│   │   ├── adr/
│   │   │   ├── 000-legacy-state.md
│   │   │   └── 001-*.md          ← New decisions
│   │   └── rfc/
│   │       └── 001-*.md          ← Proposals in discussion
│   ├── api/
│   │   ├── endpoints.md          ← API contracts
│   │   └── modelos.md            ← DTOs
│   └── database/
│       └── schema.md             ← DB schema
├── templates/                    ← Copied from FlowDocs
├── AGENTS.md                     ← AI agent entry point
└── src/                          ← Your code
```

---

## Common Errors

| Error | Why | Solution |
|-------|-----|----------|
| Trying to document EVERYTHING before starting | Paralysis | Only document what you know now |
| No `AGENTS.md` | Agent doesn't know context | Create it Day 1 |
| Not updating docs with code | Docs get stale | Same PR = same docs update |
| Legacy decisions with no ADR | Knowledge lost | Create ADR for important decisions when you learn them |

---

## Migration Checklist

- [ ] `docs/` created with subfolders
- [ ] Templates copied to `docs/templates/`
- [ ] `docs/PRD.md` created
- [ ] `AGENTS.md` created at root
- [ ] `ADR-000-legacy-state.md` documenting known state
- [ ] New code follows doc structure
- [ ] Docs updated in same PR as code

---

## Resources

- Templates: `docs/templates/`
- ADR examples: `docs/architecture/adr/`
- RFC examples: `docs/architecture/rfc/`
- Adoption guide: `docs/adoption-guide.md`

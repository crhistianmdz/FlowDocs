# Migration Guide: Legacy Project to SDD

> How to adapt an existing project to the SDD workflow without rewriting everything at once.

---

## When to Migrate

| Signal | Description |
|-------|-------------|
| Project > 6 months | Documentation outdated or missing |
| Team > 3 people | Each works differently |
| Onboarding > 1 week | Newcomers don't know where anything is |
| Frequent changes | New code but no strategy |

If your project has 2+ of these signals, it's time to migrate.

---

## Core Principle

**You don't rewrite everything at once.** SDD works incrementally:

1. First: docs structure + AGENTS.md
2. Then: each new feature or refactor follows SDD
3. Legacy code is documented when touched

---

## Phase 1: Base Structure (Day 1)

### 1.1 Create `docs/` folder

```bash
cd your-project
mkdir -p docs/architecture/rfc
mkdir -p docs/architecture/adr
mkdir -p docs/api
mkdir -p docs/database
mkdir -p docs/tasks
```

### 1.2 Copy templates

```bash
# If using this framework as base
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/*/*.md your-project/docs/templates/

# Or copy individually the ones you need
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/user-stories/template-user-story-sdd.md your-project/docs/tasks/TEMPLATE.md
```

### 1.3 Create `AGENTS.md` at root

See `AGENTS.md-example.md` in this repo as a reference.

The goal is that any agent (OpenCode, Antigravity, other) can read this file and understand:
- Project tech stack
- Folder structure
- Team conventions
- How to work with SDD

### 1.4 Document current state

Create `docs/architecture/adr/000-legacy-state.md` with:

```markdown
# ADR-000: Legacy State

**Date**: YYYY-MM-DD

## Context

Existing project with X years/months of development.
Stack: [current technologies]
Team: [size, time zones]

## Previously Taken Decisions

| Decision | RFC/ADR | Status |
|----------|---------|--------|
| [Decision 1] | N/A | Legacy (no document) |

## Known Technical Debt

| # | Area | Impact | Proposal |
|---|------|---------|-----------|
| 1 | [Area] | [High/Medium/Low] | [Solution] |

## What Exists (inventory)

- **Frontend**: [what exists, what stack]
- **Backend**: [what exists, what stack]
- **DB**: [what exists, what engine]
- **External APIs**: [which ones]
```

---

## Phase 2: First HU from Legacy (Day 2-3)

### 2.1 Choose something that will be touched

**Rule**: Don't document code that won't be touched. Only create HUs for:

1. New features
2. Planned refactors
3. Bugs that will be fixed
4. Technical debt that will be paid

### 2.2 Create first HU

Copy template and document what exists:

```bash
cp docs/tasks/TEMPLATE.md docs/tasks/HU-001-name.md
```

Fill with:
- User story of the change
- Given/When/Then scenarios
- Affected API endpoints (if any)
- DB changes (if any)
- Dependencies with legacy code

### 2.3 First SDD cycle

```bash
/sdd-new HU-001-name --from-docs
```

The agent will propose, spec, design, tasks based on:
- What you wrote in the HU
- The context of `AGENTS.md`
- Existing code (if the agent can read it)

---

## Phase 3: Gradual Integration (Sprint 1 onwards)

### 15-day adapted cycle

| Day | Action |
|-----|--------|
| 1-2 | Planning: choose HUs from legacy backlog |
| 3-11 | Execution: SDD for each HU |
| 12-14 | Integration: verify everything works together |
| 15 | Retro: what we learned, update docs |

### Legacy Rule

**For each HU you touch, update docs:**

| If HU touches... | Update... |
|-----------------|---------------|
| New API endpoint | `docs/api/endpoints.md` |
| New DB schema | `docs/database/schema.md` |
| Technical decision | Create ADR in `docs/architecture/adr/` |
| New module/feature | `docs/tasks/HU-XXX.md` |

**Legacy code is documented ONLY when touched.**

---

## Phase 4: Complete Structure (Month 2-3)

After 2-3 cycles, you will have:

```
your-project/
├── docs/
│   ├── PRD.md                    ← Created in phase 1
│   ├── architecture/
│   │   ├── rfc/                  ← New team RFCs
│   │   └── adr/
│   │       ├── 000-legacy-state.md  ← Initial state
│   │       └── 001-*.md          ← New decisions
│   ├── api/
│   │   └── endpoints.md         ← Documented endpoints
│   ├── database/
│   │   └── schema.md            ← Documented schema
│   └── tasks/
│       └── HU-*.md             ← Completed HUs
├── AGENTS.md                     ← Entry point for agents
└── src/                          ← Your legacy code
```

---

## Common Errors

| Error | Why | Solution |
|-------|---------|----------|
| Trying to document EVERYTHING before working | Paralysis | Only document what is touched |
| Not creating AGENTS.md | Agent doesn't know context | Create it Day 1 |
| Skipping RFC for legacy decisions | Decisions lost | Create retroactive ADR with what is known |
| HU too large | Legacy is huge | Split into small parts |
| Not updating docs in the PR | Docs outdated | Rule: same PR, same docs update |

---

## Migration Checklist

- [ ] `docs/` created with subfolders
- [ ] `AGENTS.md` created at root
- [ ] `ADR-000-legacy-state.md` documenting what exists
- [ ] First HU created for something that will be touched
- [ ] `/sdd-init` run in the project
- [ ] First HU passed through full SDD
- [ ] Documentation updated in the same PR

---

## Resources

- HU Template: `templates/template-user-story-sdd.md`
- ADR Template: `templates/ADR_template.md`
- RFC Template: `templates/RFC_template.md`
- AGENTS.md Example: `AGENTS.md-example.md`
- Workflow cycle: `docs/flowdoc-ciclo.md`
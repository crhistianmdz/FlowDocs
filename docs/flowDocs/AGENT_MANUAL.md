# Agent Manual — FlowDocs

> When in doubt about documentation, start here.

---

## Golden Rule

**Don't know what to do? → Ask the developer. No guesses. No assumptions.**

---

## Architecture Overview

FlowDoc uses a **specialist architecture** where an orchestrator coordinates specialized skills:

```
flowdoc-assist (ORCHESTRATOR)
├── flowdoc-discover   (investigation)
├── flowdoc-prd       (PRD documents)
├── flowdoc-rfc       (RFC documents)
├── flowdoc-adr       (ADR documents)
├── flowdoc-api       (API documentation)
├── flowdoc-db        (DB schema documentation)
├── flowdoc-hu        (User stories + post-dev)
└── flowdoc-review    (validation)
```

**Orchestrator** (`flowdoc-assist`): Coordinates specialists, maintains session register in `docs/.flowdoc/sessions/`

**Specialists**: Each handles one document type. Can be invoked directly or through the orchestrator.

---

## Decision Tree

```
Need to document something?
│
├── Use flowdoc-assist orchestrator
│   └── "adopt flowdocs" or "help me document"
│
├── Specific document needed?
│   ├── PRD → flowdoc-prd
│   ├── RFC → flowdoc-rfc
│   ├── ADR → flowdoc-adr
│   ├── API docs → flowdoc-api
│   ├── DB schema → flowdoc-db
│   └── User story/HU → flowdoc-hu
│
├── Validate existing docs?
│   └── flowdoc-review
│
└── Don't know what you need?
    └── flowdoc-discover (investigates project, recommends specialists)
```

---

## Quick Reference

| Situation | Action | Specialist |
|-----------|--------|------------|
| Start documentation from scratch | Run `flowdoc-assist` | orchestrator |
| Investigate existing project | `flowdoc-discover` | discover |
| Product requirements | Create/update PRD | `flowdoc-prd` |
| Technical proposal (under discussion) | Create RFC | `flowdoc-rfc` |
| Technical decision (approved) | Create ADR | `flowdoc-adr` |
| API endpoints | Document from code | `flowdoc-api` |
| Database schema | Document from code | `flowdoc-db` |
| User story / feature | Create/update HU | `flowdoc-hu` |
| HU completed, document what was done | Post-dev update | `flowdoc-hu` |
| Validate all documentation | Run validation | `flowdoc-review` |

---

## Specialist Invocation

### Via Orchestrator (recommended)
```
User: "adopt flowdocs"
     → flowdoc-assist orchestrates everything
     → Specialists run in sequence
     → flowdoc-review validates
```

### Direct Specialist
```
User: "create an ADR for auth"
     → flowdoc-adr invoked directly
     → Can invoke flowdoc-discover if needed
```

### Specialist + Review
```
User: "create ADR + review"
     → flowdoc-adr invoked
     → flowdoc-review validates
```

---

## Document States

### ADR / RFC
```
Draft → In Review → Accepted
                      ↓
                 Deprecated (if replaced)
```

### Rules
- **ADR in Draft > 1 month**: Ask dev — decision is stuck
- **RFC in Review > 2 weeks**: Ask dev — no consensus
- **Don't know the state**: Ask dev

---

## Session Register

Each session generates a register at `docs/.flowdoc/sessions/`:

```
docs/.flowdoc/sessions/
├── 2026-08-05_1430_register.json
└── ...
```

This directory is **git-ignored**. It tracks:
- Specialists invoked
- Documents created/updated
- Issues found
- Pending updates

---

## Naming Conventions

```
NNN-descriptive-name.md
```

| Type | Example |
|------|---------|
| ADR | `001-auth-jwt.md` |
| RFC | `001-auth-jwt-proposal.md` |
| HU | `HU-001-login.md` |

- NNN = sequential number (check latest in folder)
- Name = kebab-case, descriptive
- No spaces, no accents

---

## Minimum Required Format

### ADR
```markdown
# ADR-NNN: Title

- **Date**: YYYY-MM-DD
- **Status**: Accepted | Deprecated
- **Context**: Why this decision was made
- **Decision**: What was decided
- **Consequences**: Pros and cons
```

### RFC
```markdown
# RFC-NNN: Title

- **Author**: Your name
- **Status**: Draft | In Review
- **Problem**: What problem this solves
- **Proposed Solution**: Your proposal
- **Open Questions**: What still needs definition
```

---

## Don't Do This

- ❌ Modify `docs/` without dev approval
- ❌ Create ADR without prior RFC (unless dev asks)
- ❌ Delete existing documentation
- ❌ Update deprecated ADR (create new one instead)
- ❌ Invent conventions that don't exist
- ❌ API specialist touches PRD (reports to orchestrator instead)

---

## When Updating Documentation

**Rule**: Docs are updated in the SAME PR that changes the code.

```
If you change code → Update docs in that same PR
```

No separate PR for docs.

---

## Pre-Commit Checklist

- [ ] Used the correct specialist?
- [ ] Document follows template format?
- [ ] Session register updated?
- [ ] flowdoc-review run?
- [ ] Anything to ask the dev?

---

## When Everything Fails

1. Read `docs/anti-patrones.md` — might be described there
2. Read `docs/troubleshooting.md` — common problems and solutions
3. **Ask the developer** — don't guess

---

## Skills Reference

| Skill | Purpose | Invokes |
|-------|---------|---------|
| `flowdoc-assist` | Orchestrator | All specialists |
| `flowdoc-discover` | Investigation | — |
| `flowdoc-prd` | PRD documents | discover |
| `flowdoc-rfc` | RFC documents | discover |
| `flowdoc-adr` | ADR documents | discover |
| `flowdoc-api` | API docs | discover |
| `flowdoc-db` | DB schema | discover |
| `flowdoc-hu` | User stories | adr (if new decision) |
| `flowdoc-review` | Validation | — |

---

## See Also

- `docs/architecture/rfc/005-specialist-architecture.md` — Full specialist architecture
- `docs/architecture/adr/013-specialist-orchestrator-architecture.md` — Orchestrator ADR
- `docs/architecture/adr/014-session-register-location.md` — Register ADR
- `docs/anti-patrones.md` — Signs something is wrong
- `docs/troubleshooting.md` — Problems and solutions
- `docs/templates/` — Templates for each document type

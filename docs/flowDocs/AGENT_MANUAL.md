# Agent Manual — FlowDocs

> When in doubt about documentation, start here.

---

## Golden Rule

**Don't know what to do? → Ask the developer. No guesses. No assumptions.**

---

## Decision Tree

```
Need to document something?
├── TECHNICAL DECISION → Already discussed?
│   ├── YES → Create ADR in `docs/architecture/adr/`
│   └── NO → Create RFC in `docs/architecture/rfc/`
│
├── REQUIREMENT → Create/update in `docs/PRD.md`
│
├── API CONTRACT → Update `docs/api/endpoints.md`
│
├── DB SCHEMA → Update `docs/database/schema.md`
│
├── DON'T KNOW the type → ASK the developer
│
└── Found OUTDATED docs?
    ├── YES → Update in the SAME PR as the code change
    └── NO → Continue with your task
```

---

## Quick Reference

| Situation | Action | Location |
|-----------|--------|----------|
| Pending technical decision | Create RFC | `docs/architecture/rfc/NNN-name.md` |
| Approved technical decision | Create ADR | `docs/architecture/adr/NNN-name.md` |
| Decision exists and changes | Update existing ADR | Same file |
| Decision is obsolete | Change status to `Deprecated` | Same ADR |
| New requirement | Update PRD | `docs/PRD.md` |
| API change | Update endpoints | `docs/api/endpoints.md` |
| DB change | Update schema | `docs/database/schema.md` |
| None of the above | **Ask** | — |

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

## Naming Conventions

```
NNN-descriptive-name.md
```

| Type | Example |
|------|---------|
| ADR | `001-auth-jwt.md` |
| RFC | `001-auth-jwt-proposal.md` |

- NNN = sequential number (check latest in folder)
- Name = kebab-case, descriptive
- No spaces, no accents

---

## Minimum Required Format

### ADR
```markdown
# ADR-NNN: Title

- **Date**: YYYY-MM-DD
- **Status**: Draft | In Review | Accepted | Deprecated
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

---

## When Updating Documentation

**Rule**: Docs are updated in the SAME PR that changes the code.

```
If you change code → Update docs in that same PR
```

No separate PR for docs.

---

## Pre-Commit Checklist

- [ ] Created or updated the correct document?
- [ ] ADR/RFC has the right status?
- [ ] Name follows NNN-name.md convention?
- [ ] Anything to ask the dev?

---

## When Everything Fails

1. Read `docs/anti-patrones.md` — might be described there
2. Read `docs/troubleshooting.md` — common problems and solutions
3. **Ask the developer** — don't guess

---

## See Also

- `docs/anti-patrones.md` — Signs something is wrong
- `docs/troubleshooting.md` — Problems and solutions
- `docs/templates/` — Templates for each document type

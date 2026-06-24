# Quick Start Guide

**Set up FlowDocs documentation in your project in 5 minutes.**

---

## Step 1: Copy Structure

```bash
# Copy to your project
cp -r /path/to/flowdocs/docs/ /your/project/
```

---

## Step 2: Create PRD

Edit `docs/PRD.md`:

```markdown
# PRD: Your Project Name

**Version**: 1.0
**Last updated**: YYYY-MM-DD

## 1. Summary
[What this project does]

## 2. Tech Stack
[Technologies used]

## 3. Team
[Team size, time zones]
```

---

## Step 3: Document Your First Decision

Create your first ADR in `docs/architecture/adr/001-initial-state.md`:

```markdown
# ADR-001: Initial Project State

**Date**: YYYY-MM-DD
**Status**: Accepted

## Context

[What exists at project start]

## Decision

[Initial technical choices]

## Consequences

### Positive
- [Benefit 1]

### Negative
- [Tradeoff 1]
```

---

## Step 4: Set Up Templates

Copy templates you need from `docs/templates/`:

| Template | Use for |
|----------|---------|
| `architecture/ADR_template.md` | Recording decisions |
| `architecture/RFC_template.md` | Proposing discussions |
| `user-stories/template-user-story.md` | New features |
| `bug-fixes/template-bug-fix.md` | Bug fixes |

---

## Step 5: Create AGENTS.md

Create `AGENTS.md` at your project root:

```markdown
# AGENTS.md

**Project**: Your Project
**Stack**: [technologies]

## Structure

- `docs/` — All documentation
- `docs/architecture/adr/` — Architecture decisions
- `docs/api/` — API contracts

## Conventions

[Team conventions]

## Resources

- PRD: docs/PRD.md
- Templates: docs/templates/
```

---

## What's Next?

| Goal | Action |
|------|--------|
| Record a decision | Create ADR in `docs/architecture/adr/` |
| Propose something | Create RFC in `docs/architecture/rfc/` |
| Document API | Update `docs/api/endpoints.md` |
| Document DB | Update `docs/database/schema.md` |

---

## Golden Rules

1. **If there's no ADR, the decision doesn't exist**
2. **Update docs in the same PR as code**
3. **Copy from `docs/templates/` for consistency**

---

## Common Issues

| Issue | Solution |
|-------|----------|
| Don't know which template | See `docs/templates/TEMPLATE_GUIDE.md` |
| ADR is obsolete | Mark with status "Deprecated" + link replacement |
| Docs outdated | Update in the same PR that changes code |

---

## Resources

| Resource | Link |
|---------|------|
| Documentation Guide | `docs/README.md` |
| PRD | `docs/PRD.md` |
| Templates | `docs/templates/` |
| FAQ | `docs/FAQ.md` |
| Adoption Guide | `docs/adoption-guide.md` |

---

**Questions?** See `docs/FAQ.md` or open an issue.

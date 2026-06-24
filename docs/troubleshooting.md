# Troubleshooting — Common Issues and Solutions

> Common issues when using FlowDocs.

---

## Documentation

### I don't know which template to use

| Situation | Template |
|-----------|---------|
| New feature | `templates/user-stories/template-user-story.md` |
| Bug fix | `templates/bug-fixes/template-bug-fix.md` |
| Refactor (no behavior change) | `templates/refactors/template-refactor.md` |
| New technical decision (discussion) | `templates/architecture/RFC_template.md` |
| Approved technical decision | `templates/architecture/ADR_template.md` |
| Product requirements | `templates/PRD/PRD_template.md` |
| API contract | `templates/api/endpoints.md` |
| Database schema | `templates/database/schema.md` |

---

### ADR is obsolete but I don't know how to mark it

```markdown
# ADR-NNN: Title of the decision

- **Date**: YYYY-MM-DD
- **Status**: Deprecated
- **Replaced by**: ADR-MMM - New title
```

The ADR remains as historical record. It is not deleted.

---

### Documentation is outdated

**Rule**: Docs are updated in the SAME PR that changes the code.

**Solution**:
1. If you find outdated docs, create an issue with label `docs-stale`
2. Fix them in the same PR that changes the related code

---

### ADR has no status

All ADRs must have a status:
- **Draft**: Work in progress
- **In Review**: Under discussion
- **Accepted**: Approved and active
- **Deprecated**: Superseded by another ADR

ADRs older than 1 month without Accepted status need attention.

---

## Git

### Conflicts in `docs/` when pulling

**Cause**: Two people edited the same documentation.

**Solution**:
```bash
# Option 1: Talk to the other dev BEFORE editing shared docs

# Option 2: Resolve conflicts manually
git pull origin main
# Edit the conflicting files
git add .
git commit -m "chore: resolve conflicts in docs"

# Option 3: Pull with rebase (if your changes come first)
git pull --rebase origin main
```

---

### Someone merged without review

**Rule**: No self-merge. Always another member reviews and approves.

If it happened:
1. Document as a minor incident
2. Establish a rule: minimum 1 approval before merge
3. Tech Lead enforces the rule

---

## AI Agents

### Agent doesn't know project context

**Solution**: Create `AGENTS.md` at the project root.

The agent reads `AGENTS.md` to understand:
- Project stack
- Folder structure
- Team conventions

See `AGENTS.md` in this repository as reference.

---

### Agent generates code instead of using existing docs

**Rule**: Tell the agent to read from `docs/` before working.

Example prompt:
```
Read docs/PRD.md and docs/architecture/adr/ first.
Then implement based on the documentation.
```

---

## Quick Reference

| Problem | Reference |
|---------|-----------|
| How to structure docs | `docs/PRD.md` → Section 7 |
| How to write ADR | `templates/architecture/ADR_template.md` |
| How to write RFC | `templates/architecture/RFC_template.md` |
| Legacy migration | `docs/legacy-migration.md` |
| AI agent config | `AGENTS.md` |

---

## Problem not listed?

Open an issue in the repository or ask on Discord.

---

## See Also

- [FAQ.md](FAQ.md) — Frequently asked questions
- [anti-patrones.md](anti-patrones.md) — Documentation anti-patterns
- [adoption-guide.md](adoption-guide.md) — How to adopt FlowDocs

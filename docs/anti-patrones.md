# Anti-Patterns — Signs the Documentation Isn't Working

> Signs that something is wrong with how your documentation is maintained.
> These are documentation problems, not process problems.

---

## Why anti-patterns?

Good documentation is alive. These are symptoms that indicate your documentation is rotting or your decision process is broken.

---

## Documentation Anti-Patterns

### docs/ becomes a cemetery

**Sign**: Files in `docs/` that haven't been updated in months and no longer reflect reality.

**What to check**:
- `docs/templates/api/endpoints.md` — does it reflect current endpoints?
- `docs/templates/database/schema.md` — does it reflect current schema?
- `docs/architecture/adr/` — are there ADRs in "Draft" older than 1 month?

**What to do**:
- **Rule**: "docs are updated in the same PR as the code"
- Add `docs-stale` label when you detect outdated content
- Create an issue to fix it

---

### ADRs without status

**Sign**: ADRs that have been in "Draft" or "In Review" for more than 1 month.

**What to check**:
```bash
grep -r "Estado.*Borrador\|Estado.*En Revisión\|Status.*Draft\|Status.*In Review" docs/architecture/adr/
```

**What to do**:
- Force decision: either approve or discard
- If decision was made, update status to "Accepted"
- If no decision, close the RFC without creating an ADR
- **Rule**: If there's no ADR, the decision doesn't exist

---

### Stale RFCs

**Sign**: RFCs in "In Review" for more than 2 weeks without decision.

**What to check**:
```bash
grep -r "Estado.*En Revisión\|Status.*In Review" docs/architecture/rfc/
```

**What to do**:
- Ask on Discord: "Do we have a decision yet?"
- If no consensus in 48h: schedule a sync meeting to decide
- After 2 weeks with no decision: close the RFC without ADR

---

### Decisions without ADR

**Sign**: "I think we agreed on that" but there's no ADR.

**What to do**:
- **Rule**: If there's no ADR, the decision doesn't exist
- Create a retroactive ADR if the decision was already made
- For new decisions, create an RFC first

**Why it matters**: Without ADR, future developers don't know why something was done. They might undo a decision they don't understand.

---

### API contract drift

**Sign**: `docs/templates/api/endpoints.md` doesn't match the actual API.

**What to check**:
```bash
# Compare docs with actual routes
# This depends on your stack - add your own check
```

**What to do**:
- API docs must be updated in the same PR that changes endpoints
- If you find drift, create an issue to fix it
- Don't let API docs get stale — they break integrations

---

### DB schema drift

**Sign**: `docs/templates/database/schema.md` doesn't match the actual database.

**What to do**:
- Schema docs updated in the same PR that changes the DB
- If you find drift, create an issue to fix it

---

## Documentation Anti-Patterns Checklist

Use this to evaluate your documentation health:

- [ ] `docs/` files are updated when code changes
- [ ] ADRs don't stay in "Draft" for more than 1 month
- [ ] RFCs reach a decision within 2 weeks or get closed
- [ ] Every significant decision has an ADR
- [ ] API docs match the actual endpoints
- [ ] DB schema docs match the actual database
- [ ] New developers can find what they need in `docs/`

---

## Summary

| Anti-Pattern | Sign | Urgency |
|-------------|-------|---------|
| docs as cemetery | Files not updated in months | High |
| ADRs without status | >1 month in draft | High |
| Stale RFCs | >2 weeks in review | Medium |
| Decisions without ADR | "I think we agreed" | High |
| API drift | Docs don't match code | High |
| DB drift | Docs don't match schema | High |

---

## See Also

- [adoption-guide.md](adoption-guide.md) — How to adopt the framework
- [troubleshooting.md](troubleshooting.md) — Common technical errors
- [FAQ.md](FAQ.md) — Frequently asked questions
- [deprecated/workflow/](deprecated/workflow/) — Old workflow documentation

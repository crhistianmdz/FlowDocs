# Anti-Patterns — Signs the Framework Isn't Working

> This document lists signs that something isn't working in how you're using the framework.
> They are not mandatory errors, but if you see these signs, something needs attention.

---

## Why anti-patterns?

The framework works when used well. These are the symptoms of misuse.

The goal isn't to punish but to **identify early** so you can correct.

---

## Documentation Anti-Patterns

### docs/ becomes a cemetery

**Sign**: Files in `docs/` that haven't been updated in months.

**What to check**:
- `docs/api/endpoints.md` - does it reflect current endpoints?
- `docs/database/schema.md` - does it reflect the current schema?
- `docs/architecture/adr/` - are there ADRs in "Draft" older than 1 month?

**What to do**:
- Rule: "docs are updated in the same PR as the code"
- Add `docs-stale` label when you detect outdated content
- Prioritize in the next planning

---

### HUs without owner

**Sign**: There are HUs in `docs/tasks/` without an `**Owner**:` field or with an owner that doesn't exist.

**What to check**:
```bash
grep -r "Owner" docs/tasks/HU-*.md | grep -v "@"
```

**What to do**:
- Assign an owner to each HU during planning
- If the owner is no longer on the team, reassign

---

### ADRs without status

**Sign**: ADRs that have been in "Draft" or "In Review" for more than 1 month.

**What to check**:
```bash
grep -r "Estado.*Borrador\|Estado.*En Revisión" docs/architecture/adr/
```

**What to do**:
- Force decision: either approve or discard
- If the decision was already made, update the status
- If it wasn't made, close the RFC without creating an ADR

---

### Stale RFCs

**Sign**: RFCs in "In Review" for more than 1 cycle (15 days).

**What to check**:
```bash
grep -r "Estado.*En Revisión" docs/architecture/rfc/
```

**What to do**:
- Ask on Discord: "Do we already have a decision?"
- If there's no consensus, schedule a synchronous meeting
- If no response in 48h, force decision

---

## Process Anti-Patterns

### Planning takes more than 2 hours

**Sign**: Day 1 planning extends to 4+ hours.

**What to do**:
- Prepare agenda BEFORE planning
- Have each developer come with their HUs already written
- Limit to 2 hours max, discuss remaining topics later

**Why it happens**:
- No prior preparation
- The team doesn't know what it wants
- Things outside the planning scope are discussed

---

### Daily is a status meeting

**Sign**: 30-minute meetings every day to "update."

**What to do**:
- Replace with 5-min async update on Discord
- Meeting only if there's a blocker that needs discussion

**Why it happens**:
- No trust in written communication
- The team isn't used to async

---

### Meetings without agenda

**Sign**: "We meet in plenary" without a prior document.

**What to do**:
- Every meeting needs an agenda published BEFORE
- No agenda, no meeting
- Results are documented post-meeting

---

## SDD Anti-Patterns

### Giant HUs

**Sign**: A HU with more than 5 Given/When/Then scenarios.

**What to check**:
```bash
grep -c "GIVEN" docs/tasks/HU-*.md
```

**What to do**:
- Split the HU into 2 or more HUs
- Rule: if you need to scroll to see all scenarios, it's probably too big

---

### Stale HUs

**Sign**: HUs in "📋 Backlog" for more than 2 cycles.

**What to do**:
- Re-evaluate priority in the next planning
- If it's not important, close it with a note
- If it's important but blocked, resolve the blocker

---

### Feature flags accumulating

**Sign**: More than 3 active feature flags from previous cycles.

**What to check**:
```bash
grep -r "Feature Flag" docs/tasks/HU-*.md
```

**What to do**:
- Add to `docs/tech-debt.md`
- In the next cycle, remove obsolete flags
- Rule: a flag cannot be active for more than 2 cycles

---

### Self-merge

**Sign**: The same developer who opened the PR merged it.

**What to do**:
- Immediately: establish "another must approve" rule
- Tech Lead reviews that there are no self-merges
- If it happened, document as a minor incident

**Why it happens**:
- Rush
- "It's a minor fix"
- Lack of habit

---

## Team Anti-Patterns

### Slow onboarding

**Sign**: New member can't work productively after 4 days.

**What to check**:
- Is `ONBOARDING.md` up to date?
- Is there access to all systems?
- Does the newcomer know where the documentation is?

**What to do**:
- Review and update `ONBOARDING.md`
- Assign a buddy/mentor to the newcomer
- Day-by-day checklist

---

### Decisions without ADR

**Sign**: "I think we agreed on that" but there's no ADR.

**What to do**:
- Rule: **if there's no ADR, the decision doesn't exist**
- Create retroactive ADR if the decision was already made
- For new decisions, create an RFC first

---

### Ignored technical debt

**Sign**: `docs/tech-debt.md` exists but nobody looks at it.

**What to do**:
- Review tech-debt in every planning
- Assign time to pay debt (rule: 20% of sprint)
- If it's not paid, at least document why

---

## Team Health Checklist

Use this to evaluate how the framework is working:

- [ ] Docs are updated when code changes
- [ ] Each HU has an assigned owner
- [ ] ADRs have status (don't stay in "Draft")
- [ ] Planning lasts less than 2 hours
- [ ] Dailies are async, not meetings
- [ ] HUs have fewer than 5 scenarios
- [ ] No stale HUs for more than 2 cycles
- [ ] Feature flags are removed post-release
- [ ] Nobody does self-merge
- [ ] Newcomer can work in 4 days

---

## Summary

| Anti-Pattern | Sign | Urgency |
|-------------|-------|----------|
| docs as cemetery | Files not updated in months | High |
| HUs without owner | Owner field empty | Medium |
| ADRs without status | >1 month in draft | High |
| Stale RFCs | >1 cycle in review | Medium |
| Long planning | >2 hours | Medium |
| Daily as meeting | 30 min daily | Low |
| Meetings without agenda | No prior document | Medium |
| Giant HUs | >5 scenarios | High |
| Stale HUs | >2 cycles in backlog | Medium |
| Flags accumulating | >3 old flags | High |
| Self-merge | Owner merges their PR | Critical |
| Slow onboarding | >4 days to productive | Medium |
| Decisions without ADR | "I think we agreed" | High |
| Ignored debt | tech-debt.md unread | Low |

---

## See also

- [adoption-guide.md](adoption-guide.md) - How to adopt the framework
- [troubleshooting.md](troubleshooting.md) - Common technical errors
- [Ciclo de Trabajo](./flowdoc-ciclo.md) - Work cycle
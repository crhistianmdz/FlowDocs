# ADR-003: 15-Day Work Cycle

**Date**: 2026-05-29  
**Related RFC**: [RFC-002: 15-Day Work Cycle](./rfc/002-ciclo-15-dias.md)  
**Status**: Accepted

---

## Context

Teams across different time zones need structure to coordinate without constant meetings. 1-2 week sprints are too short for meaningful results, and 1-month milestones are too long without feedback. We needed a cycle that balances structure with flexibility for async work.

---

## Decision

We adopt **15 business day** cycles with 4 clearly defined phases:

```
Days 1-2:   Planning & Contract
Days 3-11:  Execution (async, with weekly sync on day 7)
Days 12-14: Integration & Verify
Day 15:     Retrospective
```

Each cycle includes:
- Feature flags for safe parallel work
- Daily 5-min async updates
- Definition of Done agreed upon in Planning
- Release checklist before production

---

## Consequences

### ✅ Positive

- Clear structure without being rigid (15 days vs exactly 2 weeks)
- Feedback in 2 weeks (vs 4 weeks of monthly milestones)
- Weekly sync prevents prolonged blockers
- Feature flags enable continuous deployment without breaking others' work

### ❌ Negative

- 2h Planning may feel long for small teams
- Coordination overhead (~15% of time in cycles)
- Retrospective requires discipline to not become a complaint session

### 🔄 Neutral

- Synchronous teams may feel the cycle is unnecessarily long
- Async teams value it as a lifeline

---

## Related Decisions

| Decision | Location |
|----------|----------|
| docs/ as source of truth | ADR-002 |
| Mandatory feature flags | ADR-004 |
| Documentation in ONBOARDING | ONBOARDING.md |
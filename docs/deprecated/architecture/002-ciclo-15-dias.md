# RFC-002: 15-Day Work Cycle

- **Status**: Approved
- **Author(s)**: @Crhistian
- **Date**: 2026-05-29
- **Project**: Distributed Teams Workflow Framework

---

## 1. Summary

Establish **15 business day** work cycles that include Planning (days 1-2), Execution (days 3-11), Integration (days 12-14), and Retrospective (day 15). The goal is to provide enough structure for distributed teams without being as rigid as traditional 2-week sprints.

---

## 2. Context

- **Technical problem**: Teams in different time zones need structure to coordinate without constant meetings. 1-2 week sprints are too short for meaningful results, and 1-month milestones are too long without feedback.
- **Why this needs to be decided now**: The framework will be used by teams in different countries. Without a defined cycle, each team improvises.
- **Alternatives considered**:
  1. **1-week sprints**: Too short, little time for significant features, too much planning overhead
  2. **2-week sprints (traditional)**: Works well for synchronous teams, less effective for async
  3. **1-month milestones**: Too slow feedback, difficult to course-correct
  4. **15 business days (chosen)**: Equivalent to 3 calendar weeks, balance between structure and flexibility

---

## 3. Technical Decision

### 3.1 Cycle Structure

```
Days 1-2:   Planning & Contract
            - Feature list collaboration
            - Task contract (owner, deadline, dependencies)
            - Agreed Definition of Done
            - Feature flags defined

Days 3-11:  Execution
            - Daily async updates (5 min)
            - Weekly sync (day 7, 30 min)
            - If you're blocked, NOTIFY IMMEDIATELY

Days 12-14: Integration & Verify
            - Complete integration review
            - Joint testing
            - Verify against specs
            - Release candidate to staging

Day 15:     Retrospective
            - What worked well?
            - What didn't work?
            - What did we learn?
```

### 3.2 Daily Async Updates

Format in Discord (or team's async tool):

```
Feature X: [in progress/blocked/completed]
Blocked: [yes/no] - If yes, by whom and why
Tests: [written / pending]
```

**Rule**: If you're blocked for more than 24h and didn't notify, it's a problem. If you notified and it wasn't resolved, it's a coordination problem, not yours.

### 3.3 Weekly Sync (Day 7)

30 min session (maximum):
1. What was completed? (5 min)
2. What is blocked? (10 min — resolve right there)
3. What to adjust? (10 min)
4. Next step (5 min)

**If it doesn't need real-time interaction, it's not a meeting** — it's an async message or an issue.

---

## 4. Feature Flags Considerations

Every new feature is developed behind a flag:

```
HU-001          → flag: HU-001 (default: false)
HU-003-v2       → flag: HU-003-v2 (for gradual migrations)
HU-005-exp      → flag: HU-005-exp (for A/B testing)
```

**Flag rules**:
- Flag is defined in Planning along with the HU
- Code merges to `dev` with flag in `false` — doesn't break anything
- Flag is activated in staging for integration review
- Flag is activated in production after validated release
- Previous cycle flags are REMOVED — don't accumulate flag debt

**Benefit**: Allows continuous merge to `dev` without fear of breaking others' features.

---

## 5. Meeting Cadence

| Type | Frequency | Duration | Who |
|------|-----------|----------|-----|
| **Planning** | Cycle start (Day 1) | 2h | Whole team |
| **Weekly Sync** | Day 7 | 30 min | Whole team |
| **Integration Review** | Day 12 | 1h | Whole team |
| **Retrospective** | Day 15 | 1h | Whole team |
| **Technical decision** | Only if no async consensus | Max 2h | Involved + moderator |
| **1:1 / Onboarding** | As needed | Variable | Owner + new member |

**Timezone rotation**: If the team is in more than 2 time zones, rotate meeting times to avoid always disadvantaging the same group.

---

## 6. Costs and Resources

- **Planning time**: ~2h per cycle (per person)
- **Retrospective time**: ~1h per cycle
- **Async updates**: ~5 min per day
- **Weekly sync**: ~30 min per cycle

**Total overhead per cycle**: ~4-5 hours of coordination (~15% of time in 15-day cycles)

---

## 7. Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Team skips planning | High | No planning = no clear direction. Tech Lead insists |
| Weekly sync runs over | Medium | Moderator with timer, clear agenda |
| Feature flags accumulate debt | Medium | Rule: flags are removed in the following cycle |
| Retrospective becomes criticism | Low | Focus on process, not people |

---

## 8. Approval Status

| Role | Person | Status | Date |
|------|--------|--------|------|
| Tech Lead | @Crhistian | Approved | 2026-05-29 |

---

## 9. Change History

| Date | Change | Author |
|------|--------|--------|
| 2026-05-29 | Initial version | @Crhistian |

---

## 10. Related Documents

- **RFC-001**: docs/ documentation structure
- **RFC-003**: Mandatory Feature Flags
- **ONBOARDING.md**: Checklist for new members
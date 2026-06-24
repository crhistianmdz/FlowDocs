# ADR-004: Mandatory Feature Flags

**Date**: 2026-05-29  
**Related RFC**: [RFC-003: Mandatory Feature Flags](./rfc/003-feature-flags.md)  
**Status**: Accepted

---

## Context

In distributed teams working in parallel, a developer can merge code that breaks another team's functionality. Without an isolation mechanism, parallel work is risky and requires long branches that cause integration hell. We needed to allow multiple people to work simultaneously on `dev` without stepping on each other.

---

## Decision

Every new feature (non-hotfix) is developed behind a feature flag:

**Naming**: `{HU-ID}[-optional-subfeature]`
- `HU-001` — flag for the complete feature
- `HU-003-v2` — version 2 of the feature (gradual migration)
- `HU-005-exp` — experimental (A/B testing)

**Flag Lifecycle**:
1. Development: flag in `false` → code exists but is not active
2. Staging (days 12-14): flag in `true` → integration review
3. Production: flag in `true` post-release validated
4. Post-release: **REMOVE** — max 2 cycles (30 days) per flag

---

## Consequences

### ✅ Positive

- Safe parallel work on `dev` without blockers
- Instant rollback without deploy (disable flag = instant)
- Continuous integration review, not at end of cycle
- Staging usable entire cycle, not only last 3 days

### ❌ Negative

- Dual code (if/else) while flag exists
- Technical debt if flags accumulate without removal
- Initial configuration overhead per feature (~15 min)

### 🔄 Neutral

- Requires discipline to remove flags post-release
- Small teams may see overhead; large teams value it

---

## Related Decisions

| Decision | Location |
|----------|-----------|
| 15-day cycle | ADR-003 |
| docs/ as source of truth | ADR-002 |
| Release checklist | docs/flowdoc-ciclo.md Section 1.6 |
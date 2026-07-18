# Template: ADR (Architecture Decision Record)

> Copy this template when an RFC is **approved** or an important technical decision is made.
> The ADR records the decision permanently. Unlike RFC, it is not a proposal — it is an immutable record.
> Standard Michael Nygard format: Context → Decision → Consequences.

---

# ADR-[Sequential Number]: [Decision Title]

- **Date**: [YYYY-MM-DD]
- **Related RFC**: [Link to RFC if exists]
- **Status**: [Accepted | Deprecated | Superseded by ADR-NNN]

---

## Context

[What problem motivated this decision? What alternatives existed?
Max 3-5 lines. Enough for someone reading this in 6 months to understand why.]

---

## Decision

[What was decided? Why this option and not another?
Max 3-5 lines. Don't repeat the context.]

---

## Consequences

[What impact does this decision have?
- Positive: [what improves]
- Negative: [what is lost or complicated]
- Neutral: [what changes without being better or worse]
- Accepted technical debt: [if applicable]]

---

<!--
## ADR Index

> **Maintenance note**: Add a row to this table every time a new ADR is created.
> Keep entries ordered by ADR number. Update "Status" if an ADR is deprecated or superseded.
> This index belongs in the `docs/architecture/adr/` directory (e.g. as `INDEX.md` or at the top of the folder's README), NOT inside each individual ADR file.

| ID | Title | Status | Date |
|----|-------|--------|------|
| ADR-001 | [Title] | Accepted | YYYY-MM-DD |
| ADR-002 | [Title] | Accepted | YYYY-MM-DD |

-->

---

> **Reminder**: After creating this ADR, add it to [`docs/architecture/adr/INDEX.md`](../../docs/architecture/adr/INDEX.md).
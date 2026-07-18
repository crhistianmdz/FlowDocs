# ADR-011: Self-Contained Skill Templates and ADR Index

- **Date**: 2026-07-18
- **Related RFC**: None
- **Status**: Accepted

---

## Context

The `flowdoc-assist` skill was being distributed as a single `SKILL.md` file, but it depended on templates that only lived in `docs/templates/` — which is documentation intended for humans.

If someone copied the skill to use in another project, they had to separately locate and copy the templates from `docs/templates/`, because the skill folder was not self-contained. This friction made the skill hard to reuse and created an implicit coupling between the skill and the project's documentation tree.

Additionally, the `docs/architecture/adr/` directory had no central entry point. A reader landing in the folder had no quick way to see all decisions, their statuses, or find a specific ADR without listing files manually.

---

## Decision

### 1. Skill templates live in TWO places with different purposes

Templates are now duplicated intentionally, serving distinct audiences:

| Location | Audience | Purpose |
|----------|----------|---------|
| `docs/templates/` | Humans reading docs | Documentation source of truth |
| `skills/flowdoc-assist/templates/` | The skill at runtime | Implementation copies the skill uses |

These are **NOT** accidental duplicates — they serve different audiences. `docs/templates/` is the canonical reference a human consults; `skills/flowdoc-assist/templates/` is the bundle the skill needs to function when copied to another project.

### 2. Created `docs/architecture/adr/INDEX.md` as the entry point for all ADRs

- Provides a **table view** (`All ADRs`) and a **by-status view** (`Accepted` / `Deprecated` / `In Review` / `Draft`).
- **Deprecated ADRs keep their numbers** — numbers are never reused. A gap in numbering signals "something was here but it's no longer active," preserving historical reference.
- **Every new ADR must be added to the index** — both the `All ADRs` table and the corresponding `By Status` section.

---

## Consequences

### ✅ Positive

- The `flowdoc-assist` skill is now **self-contained**: copy the `skills/flowdoc-assist/` folder and you have everything needed to run it. No external template dependencies.
- `INDEX.md` provides a quick overview of all architectural decisions in one place, with status-based navigation.
- New readers can orient themselves in the project's decision history without scanning filenames.

### ❌ Negative

- When updating a template, it must be updated in **BOTH** locations: `docs/templates/` (for humans) and `skills/flowdoc-assist/templates/` (for the skill implementation). Forgetting one creates drift between the canonical reference and what the skill actually uses.
- Two template sources can confuse contributors who don't understand they are intentionally split by audience.

### 🔄 Neutral

- The `docs/templates/` location remains the canonical reference for human-authored documentation, consistent with ADR-002 (`docs/` as source of truth) and ADR-007 (templates structure).

### Accepted technical debt

- Template synchronization between the two locations is currently manual. No automated check enforces parity yet; rely on the `flowdoc-audit` skill to detect drift if extended.

---

## Related Documents

| Document | Location |
|----------|----------|
| docs/ as source of truth | ADR-002 |
| Templates structure (docs/templates/) | ADR-007 |
| ADR Index | `docs/architecture/adr/INDEX.md` |
| flowdoc-assist skill | `skills/flowdoc-assist/SKILL.md` |
| Skill implementation templates | `skills/flowdoc-assist/templates/` |

---

> **Reminder**: After creating this ADR, add it to [`docs/architecture/adr/INDEX.md`](./INDEX.md).
# Architecture Decision Records

A conceptual guide to ADRs in FlowDocs. For the list of all decisions, see [INDEX.md](./INDEX.md).

---

## What is an ADR?

An **ADR** (Architecture Decision Record) is a permanent, one-page document that captures a single technical decision: what was decided, why, and what consequences it brings. Think of it as the **minutes of a decision** — not a spec, not a tutorial, not a discussion thread.

An ADR is immutable once `Accepted`. It records a moment in time. If the decision changes later, you don't edit the ADR — you write a new one that **supersedes** it, and mark the old one as `Deprecated`.

---

## Why we use ADRs

Decisions disappear. Six months from now, nobody will remember *why* you chose Engram over a database, or *why* docs live in `docs/`. Without a record, the team re-litigates the same questions over and over — or worse, reverses a decision without knowing the original reasoning.

ADRs solve three problems:

- **Amnesia** — the "why" is written down, not in someone's head.
- **Onboarding** — new members read the index and understand the project's history in 10 minutes.
- **Accountability** — decisions are traceable to a context and a date, not anonymous.

---

## The ADR lifecycle

```
Draft  →  In Review  →  Accepted  →  Deprecated / Superseded
```

| Status | Meaning |
|--------|---------|
| **Draft** | Being written. Not yet official. |
| **In Review** | Shared with the team for feedback. Open to changes. |
| **Accepted** | Active decision. The project follows this. Immutable from here. |
| **Deprecated** | No longer active. Kept for history. Usually superseded by a newer ADR. |
| **Superseded** | Replaced by a specific later ADR (linked in the body). |

An `Accepted` ADR is **never edited**. If reality changes, write a new ADR and point the old one to it. The gap in numbering is intentional — it signals "something was here, but it's no longer active."

---

## When to create an ADR

**After** a decision is made — never before.

- ✅ You had a discussion, reached a conclusion, and now want to record it → **create an ADR**.
- ❌ You're still exploring options and want feedback → write an **RFC**, not an ADR.
- ❌ You're documenting how something works (not a *decision*) → write a doc, not an ADR.

If you need discussion first, start with an [RFC](../rfc/) in `docs/architecture/rfc/`. When the discussion converges into a decision, close the RFC and open the ADR. The RFC is ephemeral (max 2 weeks); the ADR is permanent.

An ADR that records a decision that hasn't been made yet is just a proposal pretending to be a record — and it will mislead anyone who reads it later.

---

## How to write a good ADR

A good ADR is **short**. One page, readable in two minutes. The hard part isn't writing it — it's knowing what to leave out.

### Do
- **Focus on context and consequences.** The decision itself is usually obvious; the *why* and the *what-it-costs* are what people need.
- **Name alternatives.** "We considered X and Y, chose Z because…" is worth its weight in gold.
- **Be specific about tradeoffs.** "Simpler" is useless. "Simpler, but means we can't query history" is an ADR.
- **Use the template.** Start from [`docs/templates/architecture/ADR_template.md`](../../templates/architecture/ADR_template.md).

### Don't
- Don't write a tutorial. The reader knows the project.
- Don't justify the decision to a courtroom — explain it to a teammate who joins in six months.
- Don't edit an `Accepted` ADR. Open a new one that supersedes it.

---

## The Golden Rule

> **If there's no ADR, the decision doesn't exist.**

A decision made in a Slack thread, a meeting, or a hallway conversation — and not recorded in an ADR — **is not a decision**. It's a vibe. The next person (or the next you) is free to ignore it.

The ADR is the only place a decision is real.

---

## Where things live

| File | Role |
|------|------|
| [INDEX.md](./INDEX.md) | The live index. Table of all ADRs with status. **This is where you look up decisions.** |
| `NNN-descriptive-name.md` | A single ADR. The detailed record of one decision. |
| [`ADR_template.md`](../../templates/architecture/ADR_template.md) | The starting point for writing a new ADR. |
| [`../rfc/`](../rfc/) | Proposals under discussion, before they become ADRs. |

This `README.md` is the **conceptual guide**: it explains what ADRs are and how to use them. [INDEX.md](./INDEX.md) is the **catalog**: it lists every ADR and its current status. They complement each other — read this once to understand the practice, then bookmark INDEX to consult decisions.
# FAQ — Frequently Asked Questions

> The most common questions when adopting this framework.

---

## Getting Started

### Where do I start?

**Create a HU at `docs/tasks/HU-001-your-feature.md`.** That's it. You don't need anything else to get started.

### Can I adopt it without using the full SDD cycle?

Yes. You can have valuable documentation without following the SDD cycle. The minimum viable is: one documented HU that a human or agent can read.

### How long does it take to document a HU?

| Level | Time |
|-------|------|
| Simple HU (no SDD) | 10-15 min |
| SDD-Ready HU (with Given/When/Then) | 30-45 min |
| Complete HU with spec + design | 1-2 hours |

It doesn't have to be perfect. A basic HU already has value.

---

## Tools and Agents

### Do I need OpenCode or Antigravity?

No. Any AI agent that can read markdown files works with this framework:
- OpenCode + SDD
- Antigravity + SDD
- ClaudeCode + SDD
- Any other agent

The SDD workflow is tool-independent. `docs/` is the source of truth.

### What minimum knowledge do I need?

At minimum:
- Know what an AI agent is
- Understand that the agent reads files and can write files
- Know the basic cycle: Proposal → Spec → Design → Tasks → Apply → Verify

You don't need to be an expert in prompting or SDD to get started.

### Can I use this with GitHub Copilot?

GitHub Copilot is not an autonomous agent (it can't read and write files by itself). But you can use it while writing code following your HU specs.

---

## The 15-Day Cycle

### Are the 15 days mandatory?

No. The 15-day cycle is a **reference**, not an obligation. You can adapt it:
- Weekly (5 days)
- Bi-weekly (10 days)
- Monthly (20 days)
- Whatever works for your team

The important thing is to have a rhythm of planning, work, and review.

### What if my team is 2 people?

You can use the framework at Level 2 (basic SDD) or Level 3 (adapted cycle without all ceremonies). You don't need the full 15 days.

### What if we're in different time zones?

The 15-day cycle was designed for that:
- 5 min async updates
- 30 min weekly sync
- Documentation instead of meetings

If your team is spread across time zones, prioritize written communication.

### Where does the 15-day cycle come from?

The framework is based on **adapted Scrum** for distributed teams and async work:

| Scrum Concept | How We Use It |
|---------------|---------------|
| Sprint | 15-day working cycle |
| Daily standup | 5 min async update |
| Sprint planning | Days 1-2 |
| Integration review | Days 12-14 |
| Retrospective | Day 15 |

If your team uses Kanban or another methodology, adapt the concepts. The important thing isn't the name but having a **work rhythm**: planning → execution → review.

---

## Projects

### Does it work for existing (legacy) projects?

Yes. See [legacy-migration.md](legacy-migration.md) for a step-by-step guide.

The rule is: **don't rewrite everything, only document what you touch.**

### What if my project is not exactly monolithic or microservices?

The framework is adaptable. You can use a hybrid structure:
- Monolithic with clear modules
- Monorepo with separate packages
- Mix of monolithic and serverless

See [ADR-006: Four Architectures](architecture/adr/006-cuatro-arquitecturas.md) for more details.

### Can I use this for a personal project?

Yes, and it's ideal for that. Start at Level 1 (documentation only) and level up when you need it.

---

## Templates

### Which template do I use?

| Situation | Template |
|-----------|----------|
| Small feature (< 2h) | Simple (`template-user-story.md`) |
| Normal feature | SDD-Ready (`template-user-story-sdd.md`) |
| Bug fix | SDD-Ready (`template-bug-fix-sdd.md`) |
| Refactor | `template-refactor.md` |
| New technical decision | RFC first, then ADR |
| Already-made decision | ADR directly |

If you're not sure, use SDD-Ready. The extra overhead is worth it.

### Why are there "simple" and "SDD-Ready" templates?

**Simple**: For trivial tasks or when you're learning.
**SDD-Ready**: For real features where you need complete traceability.

Don't use SDD-Ready out of inertia. If the task is trivial, use the simple template.

---

## Team

### How do I convince my team?

**Don't impose, inspire.** Start by yourself documenting your HUs. When your team sees that:
- The documentation has value
- Decisions are clear
- Onboarding new members is easier

...they'll want to adopt more. Show value before asking for change.

### What if someone doesn't want to change how they work?

Respect their pace. Everyone adopts at their own speed. As long as you maintain the documentation, the rest of the team can observe and adopt when ready.

### Can I be a team of 1?

Yes. The framework works for 1 person. In fact, starting alone is the most common approach.

---

## Metrics and Measurement

### How do I know if the framework is working?

At Level 4 you can measure:
- Average HU time (goal: predictable)
- % of HUs completed vs planned
- Accumulated technical debt

At lower levels, the metric is simpler: "Is the documentation saving me time?"

### Are there defined KPIs?

There are no mandatory KPIs. The framework is adaptive. Measure what makes sense for your team.

---

## Resources

| Resource | What it is |
|----------|------------|
| [adoption-guide.md](adoption-guide.md) | Level-by-level adoption guide |
| [TEMPLATE_GUIDE.md](templates/TEMPLATE_GUIDE.md) | When to use each template |
| [legacy-migration.md](legacy-migration.md) | How to adapt an existing project |
| [troubleshooting.md](troubleshooting.md) | Common errors |
| [Workflow cycle](../flowdoc-ciclo.md) | Complete workflow cycle |

---

## Tool Integration

### How do I integrate with GitHub Projects, Jira, Linear, etc.?

**It's not the framework's responsibility.** Integration with your project management tool is your decision, your team's, or your company's.

The framework provides you with:
- `docs/` with all documentation
- `openspec/` with SDD artifacts
- Scripts in `scripts/` to create issues from HUs

How you link that to GitHub Projects, Jira, Linear, Trello, or any other tool is:
- **Individual**: Whatever you prefer
- **Team**: What the team agrees on
- **Company**: What the company decides

The framework is agnostic. It doesn't tell you how to manage your projects.

---

## HUs that FAIL

### What happens if a HU can't be completed?

A HU is not a hard contract. It's a living document. It can be closed without completing.

| Scenario | What to do |
|----------|------------|
| **Underestimated, too big** | Split into 2-3 smaller HUs |
| **Blocks that don't get resolved** | Archive with note: "blocked by X" |
| **Scope changed, no longer makes sense** | Archive with note: "scope changed, obsolete" |
| **Owner left** | Reassign or archive |
| **Feature doesn't work** | Create Bug Fix HU to resolve |

### How do I archive an incomplete HU?

```markdown
# HU-042: User login

**Status**: ❌ Archived

**Reason**: Scope changed. Social login is now priority.

**See**: [HU-043](HU-043-social-login.md)
```

The important thing: **don't leave zombie HUs** in the backlog without a defined status.

---

## Your question not answered?

Open an issue in the repo or ask on Discord. This FAQ is updated with the most frequently asked questions.

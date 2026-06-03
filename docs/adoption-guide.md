# Adoption Guide — How to Adopt the Framework Based on Your Context

> You don't have to adopt everything at once. Choose the level that best fits your situation and grow from there.

---

## Adoption Levels

```
┌─────────────────────────────────────────────────────────────┐
│  Level 4: Full Team                                          │
│  15-day Cycle + Metrics + Complete Process                   │
├─────────────────────────────────────────────────────────────┤
│  Level 3: Coordinated Team                                   │
│  Adapted Cycle + Planning + Integration                      │
├─────────────────────────────────────────────────────────────┤
│  Level 2: Basic SDD                                          │
│  Proposal → Spec → Design → Tasks → Apply → Verify           │
├─────────────────────────────────────────────────────────────┤
│  Level 1: Documentation Only                                 │
│  UHs in docs/tasks/, no SDD ceremony                         │
└─────────────────────────────────────────────────────────────┘
```

---

## Level 1: Documentation Only ✅

**Ideal for**: Single-person teams, small projects, starting to document without overhead.

### What to do

1. Create `docs/tasks/HU-001-your-feature.md`
2. Use template from `docs/templates/user-stories/template-user-story.md`
3. Document: what it does, acceptance criteria

### The HU is the starting point

**No HU = No development.** The HU tells you what to build. Start there.

### Value obtained

- The feature is documented
- Any agent can read it later
- No process to follow, just files

### When to move to Level 2

When you feel you need more structure to track what still needs to be done.

---

## Level 2: Basic SDD ✅

**Ideal for**: 1-2 people who want structure without a team cycle.

### What to add

1. Follow the complete SDD cycle:
   ```
   Proposal → Spec → Design → Tasks → Apply → Verify → Archive
   ```

2. Use SDD-Ready templates:
   - `docs/templates/user-stories/template-user-story-sdd.md`
   - `docs/templates/bug-fixes/template-bug-fix-sdd.md`

3. Save artifacts in `openspec/` or Engram
4. (Optional) Configure `.context/flowDocs.config.json` for SDD sub-agent context (see [ADR-009](architecture/adr/009-sdd-subagent-context-pattern.md))

### Value obtained

- Every decision is documented
- Given/When/Then scenarios serve as verifiable specifications
- 🧪 Refs let you track which tests exist

### When to move to Level 3

When you need to coordinate with others or have blockers between features.

---

## Level 3: Adapted Cycle ✅

**Ideal for**: 2-5 person teams that want synchronization without excessive meetings.

### What to add

1. **Adapted Planning** (not mandatory 15 days)
   - Can be weekly, biweekly, monthly
   - The important thing is to have a review moment

2. **Clear Contract**
   - Owner of each UH
   - Explicit dependencies
   - Agreed Definition of Done

3. **Feature flags**
   - For parallel work without blockers

### Value obtained

- The team knows who does what
- Dependencies are made explicit
- Parallel work is safe with flags

### When to move to Level 4

When you want to measure if the process is working.

---

## Level 4: Full Team ✅

**Ideal for**: 4+ people teams in different time zones.

### What to add

1. **15-day Cycle** (or adapted to your context)
   - Planning (days 1-2)
   - Execution (days 3-11)
   - Integration (days 12-14)
   - Retrospective (day 15)

2. **Metrics**
   - Average UH time
   - % of UHs completed vs planned
   - Accumulated technical debt

3. **Complete process**
   - RFC for technical decisions
   - ADR as a permanent record
   - Onboarding for new members

### Value obtained

- Complete visibility of work
- Decisions documented for future reference
- Fast onboarding of new members

---

## How Do I Know if the Framework is Working?

The framework works when:

| Indicator | What to look for |
|-----------|------------------|
| **Accessible documentation** | When someone has a question, do they go to `docs/` and find an answer? |
| **No zombie UHs** | Do all UHs have a clear state (active, done, archived)? |
| **Updated specs** | When something changes, is the docs updated? |
| **Faster onboarding** | Can a new member start contributing without asking you everything? |
| **Less "what is this feature about?"** | Are decisions and context documented? |

### Indicators by Level

| Level | It's working when... |
|-------|---------------------|
| **L1** | The UHs you create have useful information for yourself tomorrow |
| **L2** | The SDD cycle helps you think before coding |
| **L3** | The team knows who does what without needing to ask |
| **L4** | Metrics show predictability in the work |

### Don't worry about

- Advanced DORA metrics
- Specific test coverage
- 100% cycle compliance
- All files being perfect

**The only thing that matters**: Is it saving you time or not?

---

## FAQ: Frequently Asked Questions

### Can I skip levels?

Yes. If you already have experience with SDD, you can start at Level 2 or 3. The idea is not to repeat unnecessary ceremony.

### What if my team doesn't want to change how they work?

Start by yourself (Level 1). When they see value in the documentation, they will want to adopt more. Don't impose, inspire.

### Can I mix levels?

Yes. For example:
- Main project at Level 3
- A new module at Level 1
- A refactor at Level 2

### How long does Level 1 take?

10-15 minutes per UH. No more.

### How much time does Level 3 save over having no process?

According to teams using it:
- Less time in coordination (status meetings)
- Fewer bugs due to lack of specs
- Onboarding of new members in days, not weeks

---

## Getting Started

1. **Today**: Create `docs/tasks/HU-001-your-next-feature.md`
2. **This week**: Try the SDD cycle on one UH
3. **This month**: Evaluate if you need more structure

The goal is for documentation to be useful, not perfect. Iterate based on your context.

---

## See also

- [ADR-002: docs/ as source of truth](architecture/adr/002-docs-source-of-truth.md)
- [ADR-007: docs/templates/ as source of truth](architecture/adr/007-estructura-templates.md)
- [TEMPLATE_GUIDE.md](templates/TEMPLATE_GUIDE.md)

# Adoption Guide — How to Adopt FlowDocs

> You don't have to adopt everything at once. Choose the level that fits your context.

---

## Adoption Levels

```
┌─────────────────────────────────────────────────────────────┐
│  Level 3: Complete Documentation                             │
│  RFC system + Templates + Decision tracking                 │
├─────────────────────────────────────────────────────────────┤
│  Level 2: Decisions                                         │
│  ADRs for all technical decisions                          │
├─────────────────────────────────────────────────────────────┤
│  Level 1: Structure                                         │
│  docs/ folder with templates                               │
└─────────────────────────────────────────────────────────────┘
```

---

## Level 1: Structure

**Ideal for**: Single person, small projects, starting to document.

### What to do

1. Create `docs/` folder
2. Copy templates from `docs/templates/`
3. Start with `docs/PRD.md` (what is this project)

### What you get

- A clear place for documentation
- Any agent can read `docs/` and understand context
- No process overhead, just files

### When to move to Level 2

When you make a technical decision that others need to know about.

---

## Level 2: Decisions

**Ideal for**: Teams that make technical decisions.

### What to add

1. **ADRs** for every significant decision
2. Use `docs/templates/architecture/ADR_template.md`

### What you get

- Past decisions are recorded
- New team members understand why things are done this way
- "If there's no ADR, the decision doesn't exist"

### When to move to Level 3

When you need a formal process for discussing proposals before deciding.

---

## Level 3: Complete Documentation

**Ideal for**: Teams that need to discuss technical proposals.

### What to add

1. **RFC system** for proposals under discussion
2. Use `docs/templates/architecture/RFC_template.md`
3. Define max time for RFCs (2 weeks recommended)

### What you get

- Formal space to discuss proposals
- Team input before committing to a decision
- Clear path: RFC → ADR (when decided) or RFC → Closed (if no consensus)

---

## How Do I Know if FlowDocs is Working?

| Indicator | What to look for |
|-----------|------------------|
| **Accessible docs** | When someone asks "how does X work?" → answer is in `docs/` |
| **Decisions recorded** | No more "I think we agreed on that" |
| **Faster onboarding** | New member can find context without asking everything |
| **Less rework** | Decisions are documented, not forgotten |

### The only metric that matters

**Is it saving you time or not?**

If you spend more time maintaining docs than you save using them, simplify.

---

## FAQ: Frequently Asked Questions

### Can I skip levels?

Yes. If you already know what ADRs are, start at Level 2. No need to repeat ceremony.

### What if my team doesn't want to change?

Start by yourself (Level 1). When they see value, they'll adopt naturally. Don't impose, inspire.

### How long does Level 1 take?

10-15 minutes to create `docs/PRD.md`. No more.

### Can I mix levels?

Yes. Different parts of the project can be at different levels. Document what matters most first.

---

## Getting Started Today

1. **Now**: Create `docs/` folder with `docs/PRD.md`
2. **This week**: Create first ADR for a recent decision
3. **This month**: Evaluate if you need RFC system

The goal is useful documentation, not perfect documentation.

---

## See Also

- [PRD.md](PRD.md) — Product Requirements
- [FAQ.md](FAQ.md) — Frequently asked questions
- [anti-patrones.md](anti-patrones.md) — Documentation anti-patterns
- [templates/TEMPLATE_GUIDE.md](templates/TEMPLATE_GUIDE.md) — Template usage guide

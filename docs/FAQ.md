# FAQ — Frequently Asked Questions

> Common questions about FlowDocs. For workflow-related questions, see [deprecated/workflow/](./deprecated/workflow/).

---

## Getting Started

### Where do I start?

Create `docs/` folder and copy templates from `docs/templates/`. That's it.

### What minimum do I need?

Minimum: `docs/PRD.md` (what is this project) + `docs/architecture/adr/` (decisions made).

### How long does it take to document?

| Document | Time |
|----------|------|
| ADR (simple decision) | 15-30 min |
| RFC (proposal) | 30-60 min |
| API contract | 20-40 min |
| DB schema | 30-60 min |

It doesn't have to be perfect. A basic ADR already has value.

---

## Document Types

### What's the difference between RFC and ADR?

| | RFC | ADR |
|--|-----|-----|
| **When** | Before deciding | After deciding |
| **Purpose** | Get team input | Record the decision |
| **Lifetime** | Until decision (max 2 weeks) | Permanent |
| **Status** | "In Discussion" | "Accepted" or "Deprecated" |

**Rule**: If there's no ADR, the decision doesn't exist.

### Do I need RFCs?

RFCs are optional. For small teams or obvious decisions, go straight to ADR.

Use RFCs when:
- The decision affects multiple people
- There's legitimate disagreement
- You need buy-in before committing

### What goes in API docs?

| Document | What it contains |
|----------|------------------|
| `endpoints.md` | All endpoints with method, path, description |
| `modelos.md` | Request/response DTOs with field types |

---

## Templates

### Where are templates?

Templates live in `docs/templates/`. This is the **only** source of truth.

### Which template for each case?

| Situation | Template |
|-----------|---------|
| Technical decision (done) | `ADR_template.md` |
| Technical proposal | `RFC_template.md` |
| User story / feature | `user-stories/template-user-story.md` |
| Bug fix | `bug-fixes/template-bug-fix.md` |
| Database changes | `database/schema.md` |
| API changes | `api/endpoints.md`, `api/modelos.md` |
| Product requirements | `PRD/PRD_template.md` |

### Can I customize templates?

Yes. Templates are starting points. Adjust format to your needs, but keep the core sections (Context, Decision, Consequences for ADRs).

---

## AI Agents

### Do I need a specific AI tool?

No. Any agent that reads markdown works with FlowDocs:
- OpenCode
- Antigravity
- ClaudeCode
- GitHub Copilot (read-only)
- Cursor
- Any future agent

### How do agents use FlowDocs?

1. Agent reads `docs/PRD.md` → understands the project
2. Agent reads `docs/architecture/adr/` → understands past decisions
3. Agent reads `docs/api/` → knows how to integrate
4. Agent reads `docs/database/` → knows the data model

### Can agents modify documentation?

Agents can **propose** changes. Humans **approve** changes.

Set this rule in your `AGENTS.md`:
```
Agents DO NOT modify docs/ without human approval.
```

---

## Projects

### Does it work for existing projects?

Yes. See [legacy-migration.md](legacy-migration.md).

**Rule**: Don't rewrite everything. Document what you touch.

### What if my project is hybrid?

FlowDocs adapts. See [ADR-006: Four Architectures](architecture/adr/006-cuatro-arquitecturas.md).

### Can I use it for personal projects?

Yes. Start at Level 1 (just `docs/` structure) and grow as needed.

---

## Adoption

### How do I convince my team?

**Don't impose, inspire.** Document your decisions. When the team sees:
- Decisions are clear and recorded
- Onboarding is faster
- Less "why was this done this way?"

...they'll adopt naturally.

### Can I adopt incrementally?

Yes. See [adoption-guide.md](adoption-guide.md) for levels.

---

## Troubleshooting

### My docs are outdated. What do I do?

1. Mark with `docs-stale` label (if using issues)
2. Update in the same PR that changes the related code
3. Review periodically

**Rule**: Docs updated in the same PR as code.

### ADRs are in "Draft" forever. Help.

Force a decision:
- Ask on Discord: "Do we have consensus?"
- If no response in 48h: either approve or close
- Closed RFCs don't become ADRs

### API docs don't match code.

Contract drift. Fix it by:
1. Updating the API docs in the same PR as code changes
2. If you find drift, create an issue to fix it

---

## Your question not answered?

Open an issue in the repository or ask on Discord.

---

## See Also

- [PRD.md](./PRD.md) — Product Requirements
- [adoption-guide.md](./adoption-guide.md) — Adoption levels
- [anti-patrones.md](./anti-patrones.md) — Documentation anti-patterns
- [troubleshooting.md](./troubleshooting.md) — Common issues
- [deprecated/workflow/](./deprecated/workflow/) — Old workflow documentation

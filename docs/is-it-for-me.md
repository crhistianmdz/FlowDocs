# Is FlowDoc for me?

## TL;DR (60 seconds)

| ✅ Yes, FlowDoc fits if... | ❌ No, look elsewhere if... |
|---------------------------|----------------------------|
| Your team is 2-6 people (sweet spot, works for larger), distributed across timezones, and written docs are your primary handoff | You're 1 person or a co-located pair — keep it simple, talk is faster |
| You want AI agents (OpenCode, Antigravity, ClaudeCode) to read and write your specs | You need a WYSIWYG editor or real-time collaborative editing |
| You already use Git as your source of truth and want docs that live in the same repo as code | Your team won't use Git for documentation — no Git, no FlowDoc |
| | You only need a shared wiki — Notion or Outline fits better |

**FlowDoc is a documentation framework for teams that already use Git and want docs that evolve with code — for humans and AI agents alike, not a wiki replacement.**

## Who uses FlowDoc?

**The distributed team (2-6 people)**

They work across 2-3 timezones. A meeting is a calendar puzzle when half the team starts their day as the other half ends it. Specs and decision records become the handoff — written once, read by everyone. FlowDoc keeps docs where the code is.

**The AI-augmented team**

They're 2-6 people using OpenCode, Antigravity, or ClaudeCode daily. Their agents need structured markdown to read context and write specs — the same PRD the PM writes becomes the agent's implementation brief. FlowDoc's templates and conventions are built for this human-AI interface.

**The OSS maintainer**

PRs land at 3am from contributors in 4 timezones. Decisions made in Discord last week are already forgotten. ADRs in `docs/architecture/adr/` make every decision visible, searchable, and dated. Async contributors self-serve context without pinging maintainers.

**The team mixing devs, PMs, and designers**

Not everyone writes code, but everyone reads and contributes to specs. Markdown is the common language — no Jira training, no Notion permissions. The PM writes the PRD. The designer references it. The dev implements from it. AI agents read it for context. Same file, four audiences.

## When to use FlowDoc

**Distributed across timezones**: your team spans UTC-3, UTC+1, and UTC+8. Real-time sync is impractical. Specs, ADRs, and task breakdowns are how work transfers between timezones. FlowDoc puts them in the repo, next to the code.

**Specs drift from code**: your PRDs live in Notion, your code in GitHub, and two sprints later they diverge. FlowDoc keeps both in the repo — a PR changes code AND its spec together. No sync, no drift.

**Async-first culture**: your team writes before scheduling a meeting. Decisions live in ADRs, not in someone's memory of a call. The 15-day cycle gives rhythm without daily standups.

**Already use Git as source of truth**: you want docs that branch, merge, and review like code. FlowDoc is markdown files in your repo — no new tool, no new workflow.

**Adopting AI agents**: you want agents that read your specs and write code against them. Structured markdown with Given/When/Then and ADRs gives agents clear context.

**Growing team, growing docs debt**: you're 2 people today, 6-8 in 6 months. Wiki pages stale, READMEs scattered. Onboarding takes weeks because knowledge lives in heads. FlowDoc's conventions scale before docs become a liability.

**Heavy process is slowing you down**: SAFe or Scrum-of-scrums felt like overhead. FlowDoc's 15-day cycle fits in markdown files.

## When NOT to use FlowDoc

**You're 1 person or a co-located pair**: for truly tiny, co-located teams, direct conversation beats docs. FlowDoc's sweet spot starts at 2. Below that, a shared Notion page or a well-maintained README is enough.

**You only need a wiki**: you want drag-and-drop, rich text, and real-time editing. Notion, Outline, or Confluence fits better. FlowDoc is markdown-only by design.

**Git isn't your source of truth**: your team treats docs as secondary artifacts. FlowDoc assumes docs-in-repo as the authoritative record. If Google Drive works for you, FlowDoc won't add value.

**You want zero process overhead**: even L1 requires creating a user story file per feature. If "write a markdown file" feels like bureaucracy, FlowDoc isn't for you. Structure is overhead by definition.

**Your team hates markdown**: FlowDoc is markdown-only — no WYSIWYG editor, no rich text toolbar, no real-time cursors. If writing markdown is a daily frustration, this framework will make it worse.

**You need real-time collaborative editing**: Notion and Google Docs let multiple people edit simultaneously. FlowDoc is Git-based — changes go through branches, commits, and PRs.

**Your org mandates a specific platform**: if Confluence, SharePoint, or Google Docs is required for compliance, FlowDoc can supplement but can't replace it. Don't fight your org's requirements.

**You have 30+ people**: FlowDoc is designed for small teams (2-6 is the sweet spot). It scales with care, but if you need enterprise cross-team coordination, FlowDoc may need supplementation.

## The 4 adoption levels

FlowDoc adapts to your team — you don't adapt to FlowDoc. Pick a level and grow from there.

| Level | Time to adopt | What's included | Problem it solves |
|-------|--------------|-----------------|-------------------|
| 🟢 **L1: Documentation Only** | 15 minutes | PRD in `docs/PRD.md`, RFCs in `docs/architecture/rfc/`, ADRs in `docs/architecture/adr/`, HUs in `docs/tasks/`. Source of truth for anyone — human or AI agent — who reads the repo. No SDD cycle, no ceremony. | "I need docs that live next to my code — PRD, RFCs, decisions, and user stories — readable by anyone." |
| 🟡 **L2: Basic SDD** | 1-2 days | Full SDD cycle (proposal → spec → design → tasks → apply → verify). Individual workflow. Your specs are agent-parsable: Given/When/Then, ADRs, task checklists. | "I want structured thinking before I code, not just a TODO list." |
| 🟠 **L3: AI-Context Team** | 1-2 weeks | AI agents (OpenCode, Antigravity, ClaudeCode) read the PRD, RFCs, ADRs, and HUs to understand project context, history, and current state. Planning cycle, explicit dependencies, team conventions. This is where FlowDoc's agent-friendliness pays off — your docs are now infrastructure. | "My agents need structured context to work. My team needs coordination without 3 standups a day." |
| 🔴 **L4: Full Team** | 2-4 weeks | 15-day cycle, metrics, RFCs, ADRs, onboarding, issue automation. Agents contribute to architecture decisions and maintain institutional memory. | "We need predictability, institutional memory, and a process that scales with our team." |

**You don't have to start at L1.** Teams already doing SDD can start at L2 or L3. Solo devs can stay at L1 forever. A 2-person team can reach L4 in days, not months — the overhead is habit changes, not organizational buy-in. See [adoption-guide.md](adoption-guide.md) for the full guide per level.

## Comparison with alternatives

### FlowDoc vs Notion/Confluence vs README-only

| What you get | FlowDoc | Notion/Confluence | README-only |
|-------------|---------|-------------------|-------------|
| Git-based (PRs, history, blame) | ✅ | ❌ | ✅ |
| AI agents read directly from Git | ✅ (markdown in repo) | ❌ (API-dependent) | ⚠️ (unstructured) |
| PRDs, RFCs, ADRs, HUs readable by agents | ✅ (markdown in repo, all four artifacts) | ❌ (API-dependent, unstructured) | ⚠️ (PRD at best) |
| Vendor lock-in | ❌ (markdown files) | ✅ (proprietary) | ❌ |
| Free forever | ✅ | ❌ (free tiers limited) | ✅ |
| Async-first (docs as handoff) | ✅ | ⚠️ (real-time bias) | ❌ |
| Decision records (ADRs) | ✅ | ⚠️ (manual) | ❌ |
| Captures proposals and reasoning (RFCs) | ✅ (structured in `docs/architecture/rfc/`) | ⚠️ (ad-hoc pages) | ❌ |
| Templates for specs and tasks | ✅ | ❌ | ❌ |
| WYSIWYG editor | ❌ (markdown only) | ✅ | ❌ |
| Real-time collaboration | ❌ (Git-based, PRs) | ✅ | ❌ |
| Built-in search | ❌ (use grep or GitHub) | ✅ | ❌ |

**Honest take**: Notion has a better editor and real-time collaboration. If markdown or Git-based workflow is a dealbreaker, FlowDoc won't work — and that's fine. But if you already live in Git and want async docs that AI agents can read and write, FlowDoc's tradeoffs are worth it. README-only breaks down when you have multiple features in flight and no decision history.

### FlowDoc vs SAFe-style methodologies

SAFe defines roles, ceremonies, and artifacts at enterprise scale. FlowDoc defines where docs live and how they evolve. They solve different problems.

If your org mandates SAFe: FlowDoc complements it. Store PI objectives, feature docs, and backlogs in `docs/`. The SDD cycle maps to SAFe's inspect-and-adapt loop. ADRs replace hallway decisions with dated, searchable records.

Choosing between them is comparing apples to oranges — organizational structure vs documentation hygiene. Use both, neither, or one without the other.

## FAQ

### Q: Do I need to use GitHub?

No. FlowDoc works with any Git host — GitLab, Bitbucket, Gitea, or self-hosted. GitHub is used in examples because it's the most common. The only requirement: docs in a Git repo.

### Q: How long does it take to adopt?

L1 takes 15 minutes — create one user story file. L2 takes a day or two to run your first SDD cycle. L3 and L4 take weeks because they involve team coordination and habit changes. See [the adoption levels](#the-4-adoption-levels).

### Q: Is FlowDoc free?

Yes. FlowDoc is markdown templates and conventions — no paid product, no license, no subscription. FlowForge (the companion tool) may have paid tiers later, but the framework itself is free forever.

### Q: Our team is only 2 people. Should we use this?

Yes — 2-6 people is FlowDoc's sweet spot. L1 or L2 works perfectly: structured docs that survive when someone leaves, and your PRD becomes readable context for AI agents. L3 and L4 add coordination a pair might not need. See [the adoption levels](#the-4-adoption-levels).

### Q: Can I migrate from Notion?

Yes, but it's manual. Export pages to markdown, reorganize into FlowDoc's structure, and commit. The value comes from docs and code in the same repo under version control — not the migration itself.

### Q: Which AI tools work with FlowDoc?

Any AI agent that reads markdown: OpenCode, Antigravity, ClaudeCode, Cursor, GitHub Copilot. FlowDoc's structured format — Given/When/Then, ADR templates, task checklists — gives agents predictable context to parse and act on. See [Tool Compatibility](../README.md#-tool-compatibility).

### Q: What if my team hates writing docs?

FlowDoc won't fix a culture that resists documentation. Start with L1 — 15 minutes per feature, no ceremony. If that still feels like overhead, FlowDoc isn't right for your team. And that's a valid conclusion.

### Q: Why is FlowDoc good for AI agents?

AI agents read markdown — they don't navigate rich-text wikis. FlowDoc puts your PRD, RFCs, ADRs, and HUs in a predictable Git repo structure with consistent formatting. Even at L1, all four artifacts are agent-readable context — agents understand not just WHAT was decided but WHY (RFCs capture the reasoning ADRs reference). At L3, agents contribute to specs and designs — the same files humans read become the shared language between humans and AI. See [Tool Compatibility](../README.md#-tool-compatibility).

### Q: What's the difference between RFCs and ADRs?

RFCs are proposals under discussion — they capture alternatives and the reasoning process. ADRs are immutable records of decisions made. FlowDoc supports both: RFCs for "why we considered X" and ADRs for "we chose Y because Z." Together they give agents and new teammates the full picture, not just the outcome.

### Q: Does this replace Jira or Linear?

No. FlowDoc handles documentation structure — specs, designs, decisions. Jira and Linear handle task tracking. They complement each other: write specs in `docs/`, track progress in your issue tracker. The `hu-to-issues` script bridges both.

## Next steps

- **Start now**: [QUICKSTART.md](../QUICKSTART.md) — create your first user story in 5 minutes
- **Go deeper**: [adoption-guide.md](adoption-guide.md) — full guide to each adoption level
- **Join the team**: [ONBOARDING.md](../ONBOARDING.md) — checklist for new team members

---

**Last updated**: 2026-06-05

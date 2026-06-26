# FlowDoc

**Documentation framework for software projects — Tool-agnostic, AI-ready**

*Documentation that flows with the work.*

---

## Start Here

**New to FlowDocs?** Here's how to get started:

1. **Starting from scratch** → Copy `docs/` to your project and edit `docs/PRD.md`
2. **Existing project** → Read `docs/legacy-migration.md` for migration steps
3. **Understanding the framework** → Read `docs/adoption-guide.md`

> Any AI agent that reads `docs/` can work with your project without additional configuration.

---

## What is FlowDoc?

FlowDoc is a **documentation framework**. Not a workflow, not a process — just documentation structure that any team or AI agent can read and use.

### What it solves

- No clear place for technical decisions
- Knowledge loss when team members leave
- Slow onboarding
- Documentation scattered across multiple tools
- AI agents can't find context

### How it works

Everything lives in `docs/`:

```
docs/
├── PRD.md                      # What this project is
├── architecture/
│   ├── adr/                   # Decisions (permanent)
│   └── rfc/                   # Proposals (discussion)
├── api/                        # API contracts
├── database/                   # DB schema
└── templates/                  # Starting points
```

---

## Quick Start

### 1. Copy structure

```bash
# Copy to your project
cp -r docs/ /your/project/
```

### 2. Create PRD

Edit `docs/PRD.md` with your project info.

### 3. Start documenting

- Made a decision? → Create ADR in `docs/architecture/adr/`
- Proposing something? → Create RFC in `docs/architecture/rfc/`
- Changing API? → Update `docs/api/endpoints.md`

---

## Core Concepts

### ADR — Architecture Decision Record

A **permanent record** of a technical decision.

```
docs/architecture/adr/001-persistencia-engram.md
```

**Rule**: If there's no ADR, the decision doesn't exist.

### RFC — Request for Comments

A **proposal under discussion** before a decision.

**Lifetime**: Max 2 weeks, then either creates ADR or closes.

### Templates

Copy from `docs/templates/` — this is the only source of truth.

---

## AI Agent Integration

FlowDocs is designed so any AI agent can understand your project:

| Tool | Works because |
|------|---------------|
| OpenCode | Reads `AGENTS.md` → points to `docs/` |
| Antigravity | Reads `AGENTS.md` → points to `docs/` |
| ClaudeCode | Reads `docs/` directly |
| GitHub Copilot | Indexes `docs/` automatically |
| Cursor | Indexes `docs/` automatically |

**The agent reads `docs/` and understands the project without asking humans.**

---

## Golden Rules

| Rule | Why |
|------|-----|
| If there's no ADR, the decision doesn't exist | Prevents "I think we agreed on that" |
| Docs updated in the same PR as code | Prevents documentation rot |
| Copy from `docs/templates/` | Ensures consistency |

---

## Documentation

| Guide | Purpose |
|------|---------|
| [docs/PRD.md](docs/PRD.md) | Product Requirements |
| [docs/FAQ.md](docs/FAQ.md) | Frequently asked |
| [docs/adoption-guide.md](docs/adoption-guide.md) | How to adopt |
| [docs/legacy-migration.md](docs/legacy-migration.md) | Migrating existing projects |
| [docs/anti-patrones.md](docs/anti-patrones.md) | Anti-patterns |
| [docs/troubleshooting.md](docs/troubleshooting.md) | Common issues |

---

## Tool Compatibility

The framework is **tool-independent**:

| Tool | Compatible? |
|------|-------------|
| OpenCode | ✅ |
| Antigravity | ✅ |
| ClaudeCode | ✅ |
| Any agent that reads markdown | ✅ |

---

## What FlowDoc is NOT

FlowDoc is **documentation only**. It does NOT include:
- Delivery workflow (sprints, planning, retrospectives)
- Feature flags
- Branching strategy
- CI/CD pipelines
- Communication tools

These were removed in v2.0 to focus on what matters: **documentation structure**.

---

## Version

**Version 2.0** — 2026-06-24

Changelog:
- Removed delivery workflow
- Focused on documentation only
- AI agent compatibility maintained

---

**Last updated**: 2026-06-24

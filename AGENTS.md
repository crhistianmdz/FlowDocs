# AGENTS.md — FlowDoc

**Framework**: FlowDoc — Documentation that flows with the work
**Purpose**: Documentation structure for software projects
**Stack**: Documentation only, no code

---

## Overview

FlowDoc is a **documentation framework**. Not a workflow, not a process — just documentation structure that any team or AI agent can read and use.

### What this file is for

This file (`AGENTS.md`) is the **entry point** for AI agents. When an agent joins the project, it reads this file first to understand:
1. What the project is
2. Where documentation lives
3. How to find context

---

## Project Structure

```
README.md                     <- Framework guide (start here)
docs/                          <- DOCUMENTATION (source of truth)
│   ├── PRD.md                <- Product Requirements
│   ├── FAQ.md                <- Frequently asked
│   ├── anti-patrones.md      <- Documentation anti-patterns
│   ├── troubleshooting.md     <- Common issues
│   ├── legacy-migration.md    <- Migrating existing projects
│   │
│   ├── architecture/
│   │   ├── adr/              <- Architecture Decision Records (permanent)
│   │   │   └── *.md
│   │   │
│   │   └── rfc/              <- Requests for Comments (in discussion)
│   │       └── *.md
│   │
│   ├── api/                  <- API Contracts
│   │   ├── endpoints.md
│   │   └── modelos.md
│   │
│   ├── database/             <- DB Schema
│   │   └── schema.md
│   │
│   └── templates/            <- Templates (source of truth)
│       ├── architecture/
│       │   ├── ADR_template.md
│       │   └── RFC_template.md
│       └── ...
│
├── scripts/                  <- Automation scripts
└── AGENTS.md                <- This file
```

---

## Key Concepts

### ADR — Architecture Decision Record

A **permanent record** of a technical decision.

- Location: `docs/architecture/adr/`
- Entry point: Start at `docs/architecture/adr/INDEX.md` to find all decisions
- Format: `NNN-descriptive-name.md`
- Status: Draft → In Review → Accepted (or Deprecated)

**Golden Rule**: If there's no ADR, the decision doesn't exist.

### RFC — Request for Comments

A **proposal under discussion** before a decision is made.

- Location: `docs/architecture/rfc/`
- Format: `NNN-descriptive-name.md`
- Lifetime: Max 2 weeks, then either creates ADR or closes

### Templates

All templates live in `docs/templates/`. This is the **only source of truth** for templates intended for humans.

> The `flowdoc-assist` skill keeps its own implementation copies at `skills/flowdoc-assist/templates/` for use during guided adoption. `docs/templates/` remains the canonical reference for human-authored documentation.

| Template | Use |
|----------|-----|
| `ADR_template.md` | Recording a decision |
| `RFC_template.md` | Proposing a discussion |
| `API/` | Endpoint contracts |
| `Database/` | Schema documentation |

---

## Sources of Truth

| Document | Location | Purpose |
|----------|----------|---------|
| **PRD** | `docs/PRD.md` | What this project is |
| **Decisions** | `docs/architecture/adr/INDEX.md` | Technical decisions (index of all ADRs) |
| **Proposals** | `docs/architecture/rfc/` | Under discussion |
| **API** | `docs/api/` | Service contracts |
| **Database** | `docs/database/` | Schema |
| **Templates** | `docs/templates/` | Starting points |

---

## AI Agent Rules

**This agent can:**
- Read `docs/` to understand the project
- Propose changes to documentation
- Create ADRs for decisions made
- Create RFCs for proposals under discussion

**This agent does NOT:**
- Modify `docs/` without human approval
- Make commits — that's the human's job
- Modify this `AGENTS.md` without approval

### Documentation Quick Reference

**Don't know what to do with documentation?** → See [docs/flowDocs/AGENT_MANUAL.md](docs/flowDocs/AGENT_MANUAL.md)

**Rule**: When in doubt → Ask the developer. No guesses.

---

**Want to set up documentation with guided assistance?** → Use the `flowdoc-assist` skill.

The skill guides you through FlowDoc adoption with dialogue:
1. Discover — understand your project
2. Propose — present an adoption plan (L1-L5)
3. Execute — generate structure and content with explanations
4. Validate — run audit and fix issues

Unlike the script (`init-flowdoc.sh`), this skill teaches FlowDoc concepts while generating docs.

**Location**: `skills/flowdoc-assist/SKILL.md`

Trigger: "adopt flowdocs", "setup documentation", "implementar flowdocs", "adopcion de flowdocs"

---

## How to Work with Documentation

### Finding Context

1. Read `docs/PRD.md` → understand the project
2. Read `docs/architecture/adr/INDEX.md` → understand decisions
3. Read `docs/api/` → understand contracts
4. Read `docs/database/` → understand schema

### Making a Decision

1. Create RFC in `docs/architecture/rfc/` (if discussion needed)
2. Discuss with team
3. When decided, create ADR in `docs/architecture/adr/`
4. Close the RFC

### Updating Documentation

**Rule**: Update docs in the same PR that changes code.

If you change an API endpoint → update `docs/templates/api/endpoints.md` in the same PR.

---

## Supported AI Tools

FlowDocs works with any AI tool that reads markdown:

| Tool | Works because |
|------|---------------|
| OpenCode | Reads `AGENTS.md` → points to `docs/` |
| Antigravity | Reads `AGENTS.md` → points to `docs/` |
| ClaudeCode | Can read `docs/` directly |
| GitHub Copilot | Indexes `docs/` |
| Cursor | Indexes `docs/` |

---

## Common Errors

| Error | Solution |
|-------|----------|
| Agent doesn't know project context | Create `AGENTS.md` at project root |
| Decisions lost | Create ADR — rule: no ADR = no decision |
| Docs outdated | Update in same PR as code |
| API contracts drift | Must update `docs/api/` with code changes |

---

## Skills

| Skill | Purpose | Location |
|-------|---------|----------|
| `flowdoc-assist` | Orchestrator — coordinates specialists | `skills/flowdoc-assist/SKILL.md` |
| `flowdoc-discover` | Deep codebase investigation | `skills/flowdoc-discover/SKILL.md` |
| `flowdoc-prd` | Creates/updates PRD | `skills/flowdoc-prd/SKILL.md` |
| `flowdoc-rfc` | Creates/updates/closes RFCs | `skills/flowdoc-rfc/SKILL.md` |
| `flowdoc-adr` | Creates/updates/deprecates ADRs | `skills/flowdoc-adr/SKILL.md` |
| `flowdoc-api` | Documents API endpoints | `skills/flowdoc-api/SKILL.md` |
| `flowdoc-db` | Documents DB schema | `skills/flowdoc-db/SKILL.md` |
| `flowdoc-hu` | User stories + post-dev docs | `skills/flowdoc-hu/SKILL.md` |
| `flowdoc-review` | Validates documentation | `skills/flowdoc-review/SKILL.md` |

---

## Resources

| Resource | Link |
|---------|------|
| FlowDocs Repository | (this repo) |
| Documentation Guide | `README.md` |
| PRD | `docs/PRD.md` |
| Templates | `docs/templates/` |
| Adoption Guide | `docs/adoption-guide.md` |
| FAQ | `docs/FAQ.md` |

---

**Last updated**: 2026-08-05

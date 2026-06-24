# PRD: FlowDoc — Documentation Framework

**Version**: 2.0
**Last updated**: 2026-06-24
**Owner**: @author

---

## 1. Product Summary

**FlowDoc** is a **documentation framework** for software projects. Not a workflow, not a process — pure documentation structure that any team (or AI agent) can read and understand.

### What it solves

- No clear place for technical decisions
- Knowledge loss when team members leave
- Slow onboarding (where do I find how this works?)
- Documentation scattered across Drive, Notion, Slack, READMEs
- AI agents can't find context to work effectively

### Solution

A single `docs/` folder where everything lives: decisions, contracts, schemas, templates.

---

## 2. Target Users

| User | Need |
|------|------|
| **Developers** | Know where to find and how to document decisions |
| **Tech Leads** | Maintain a living record of technical direction |
| **Newcomers** | Onboard in days, not weeks |
| **AI Agents** | Read `docs/` and understand the project without asking humans |

---

## 3. Scope

### ✅ In Scope

- `docs/` structure: ADR, RFC, API contracts, DB schema, templates
- ADR system: How to record technical decisions permanently
- RFC system: How to discuss proposals before deciding
- Template library: Copy-paste templates for every document type
- AI agent compatibility: Any agent can read and use `docs/`
- Migration guides: How to adopt FlowDocs in existing projects

### ❌ Out of Scope

- Delivery workflow (sprints, planning, retrospectives)
- Feature flags
- Branching strategy
- CI/CD pipelines
- Test runners
- Communication tools (Discord, Slack, etc.)
- Code-specific tooling

---

## 4. Core Concepts

### ADR — Architecture Decision Record

**What**: A permanent record of a technical decision.

**When**: After a decision is made. Not before.

**Rule**: If there's no ADR, the decision doesn't exist.

```
docs/architecture/adr/
├── 001-persistencia-engram.md
├── 002-docs-source-of-truth.md
└── ...
```

### RFC — Request for Comments

**What**: A proposal under discussion.

**When**: Before making a decision. To get team input.

**Rule**: RFCs that don't reach consensus after 2 weeks are closed without creating an ADR.

```
docs/architecture/rfc/
├── 001-estructura-docs.md
└── ...
```

### API Contracts

**What**: How services communicate.

**When**: Any time there's an API, define contracts first.

```
docs/api/
├── endpoints.md
└── modelos.md
```

### DB Schema

**What**: Database structure documentation.

**When**: Any time the database changes.

```
docs/database/
└── schema.md
```

### Templates

**What**: Copy-paste starting points for every document type.

**Location**: `docs/templates/`

**Rule**: Always copy from `docs/templates/`, never from `architectures/*/templates/`.

---

## 5. Document Types

| Type | Folder | Purpose | Lifetime |
|------|--------|---------|----------|
| **PRD** | `docs/PRD.md` | Product requirements | Project life |
| **RFC** | `docs/architecture/rfc/` | Proposals in discussion | Until decision |
| **ADR** | `docs/architecture/adr/` | Approved decisions | Permanent |
| **API** | `docs/api/` | Service contracts | Until changed |
| **DB** | `docs/database/` | Schema documentation | Until changed |
| **Templates** | `docs/templates/` | Starting points | Reusable |

---

## 6. AI Agent Integration

FlowDocs is designed so any AI agent can understand a project by reading `docs/`.

### How it works

1. Agent reads `docs/PRD.md` → understands the project
2. Agent reads relevant ADRs → understands past decisions
3. Agent reads API contracts → knows how to integrate
4. Agent reads DB schema → knows the data model

### Supported tools

| Tool | Works because |
|------|---------------|
| OpenCode | Reads `AGENTS.md` which points to `docs/` |
| Antigravity | Reads `AGENTS.md` which points to `docs/` |
| ClaudeCode | Can read `docs/` directly |
| Copilot | Indexes `docs/` automatically |
| Cursor | Indexes `docs/` automatically |
| Any agent that reads Markdown | Works by default |

---

## 7. Project Structure

```
docs/
├── README.md                    # This file
├── PRD.md                       # Product Requirements
├── FAQ.md                       # Frequently asked
├── troubleshooting.md           # Common issues
├── anti-patrones.md             # Documentation anti-patterns
├── tech-debt.md                 # Technical debt registry
├── adoption-guide.md            # How to adopt FlowDocs
├── legacy-migration.md          # Migrating existing projects
│
├── architecture/
│   ├── adr/                     # Architecture Decision Records (permanent)
│   │   ├── 001-persistencia-engram.md
│   │   ├── 002-docs-source-of-truth.md
│   │   └── ...
│   │
│   └── rfc/                     # Requests for Comments (in discussion)
│       └── ...
│
├── api/                         # API Contracts
│   ├── endpoints.md
│   └── modelos.md
│
├── database/                     # Database Schema
│   └── schema.md
│
└── templates/                    # Templates (source of truth)
    ├── ADR_template.md
    ├── RFC_template.md
    ├── PRD_template.md
    └── ...
```

---

## 8. How Decisions Flow

```
Problem arises
     ↓
Create RFC in docs/architecture/rfc/
     ↓
Discuss (async on Discord, comments on RFC)
     ↓
     ├── Consensus reached → Create ADR in docs/architecture/adr/
     └── No consensus in 2 weeks → Close RFC without ADR
```

### ADR Format

Every ADR has:
- **Context**: What was the problem?
- **Decision**: What was decided?
- **Consequences**: What changed (positive, negative, neutral)?

---

## 9. Documentation Rules

### Golden Rules

| Rule | Why |
|------|-----|
| **If there's no ADR, the decision doesn't exist** | Prevents "I think we agreed on that" |
| **Docs updated in the same PR as code** | Prevents documentation rot |
| **ADR status must be current** | Draft ADRs older than 1 month are a smell |
| **Copy from `docs/templates/`** | Ensures consistency |

### Anti-Patterns

| Sign | What it means |
|------|---------------|
| Files in `docs/` not updated in months | Docs are a cemetery |
| ADRs in "Draft" for >1 month | Decision paralysis |
| "I think we agreed" without ADR | The decision doesn't exist |
| API docs don't match code | Contract drift |

---

## 10. Adoption Levels

FlowDocs adapts to your context:

| Level | What you get | Ideal for |
|-------|-------------|-----------|
| **L1: Structure** | `docs/` folder with templates | Single dev, small projects |
| **L2: Decisions** | Add ADR system | Teams that make technical decisions |
| **L3: Complete** | Add RFC system + full templates | Projects needing discussion process |

You don't need to adopt everything at once. Start with L1, grow when needed.

---

## 11. Resources

| Resource | Link |
|---------|------|
| FlowDocs Repository | (this repo) |
| ADR Template | `docs/templates/architecture/ADR_template.md` |
| RFC Template | `docs/templates/architecture/RFC_template.md` |
| Adoption Guide | `docs/adoption-guide.md` |
| FAQ | `docs/FAQ.md` |

---

## 12. Changelog

| Version | Date | Change |
|---------|------|--------|
| 2.0 | 2026-06-24 | Removed delivery workflow, focused on documentation only |
| 1.0 | 2026-05-29 | Initial version with 15-day cycle |

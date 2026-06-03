# FlowDoc

**Documentation framework for distributed teams — Tool-agnostic, async-first, gradual adoption**

*Part of the FlowForge ecosystem: FlowForge minimizes SDD overhead, FlowDoc is the documentation that flows.*

---

## 📁 Framework Structure

```
newPropuestaFrameworkTrabajo/
├── README.md                    ← This file
├── CHANGELOG.md                 ← Change log
├── AGENTS.md                    ← AI agent context
├── ONBOARDING.md                ← New member checklist
├── QUICKSTART.md                ← Quick start guide
├── .context/                    ← SDD sub-agent context config (ADR-009)
├── docs/flowdoc-ciclo.md        ← 15-day work cycle
├── docs/                        ← Source of truth (see below)
└── scripts/                     ← Automation
    ├── hu-to-issues.sh          ← Linux/macOS
    ├── hu-to-issues.ps1         ← Windows PowerShell
    └── hu-to-issues.bat         ← Windows double-click
```

## 📂 Docs Structure

```
docs/                                ← Source of truth
├── PRD.md                          ← Product requirements
├── CHANGELOG.md                    ← Framework change log
├── legacy-migration.md             ← Guide for legacy projects
├── troubleshooting.md             ← Common errors and solutions
├── tech-debt.md                    ← Technical debt registry
├── api/
│   ├── endpoints.md                ← API contracts
│   └── modelos.md                  ← DTOs and models
├── architecture/
│   ├── rfc/                        ← Request for Comments
│   │   ├── 001-estructura-docs.md
│   │   ├── 002-ciclo-15-dias.md
│   │   └── 003-feature-flags.md
│   └── adr/                        ← Architecture Decision Records
│       ├── 001-persistencia-engram.md
│       ├── 002-docs-source-of-truth.md
│       ├── 003-ciclo-15-dias.md
│       ├── 004-feature-flags.md
│       ├── 005-organizacion-hu.md
│       ├── 006-cuatro-arquitecturas.md
│       ├── 007-estructura-templates.md
│       ├── 008-nombre-flowdoc.md
│       └── 009-sdd-subagent-context-pattern.md
├── database/
│   └── schema.md                   ← Database schema
├── tasks/                          ← User stories
│   └── HU-001-HU-099/              ← Folder by range (see ADR-005)
│       ├── HU-001-onboarding-docs.md
│       └── HU-002-validacion-hus.md
└── templates/                      ← Templates (source of truth)
    ├── TEMPLATE_GUIDE.md           ← Usage guide
    ├── user-stories/
    ├── bug-fixes/
    ├── refactors/
    ├── architecture/
    ├── database/
    ├── api/
    └── PRD/
```

### Where Each Document Goes

| Document | Location | Description |
|---------|-----------|-------------|
| **PRD** | `docs/PRD.md` | Project requirements |
| **RFC** | `docs/architecture/rfc/` | Technical proposals (before decision) |
| **ADR** | `docs/architecture/adr/` | Recorded decisions (after approval) |
| **HU** | `docs/tasks/` | User stories to implement |
| **API Docs** | `docs/api/` | Endpoints, models, contracts |
| **DB Schema** | `docs/database/` | Database schema |

---

## 🚀 Quick Start

### 1. New Project

```bash
# Copy structure to your project
cp -r ~/Documentos/newPropuestaFrameworkTrabajo/* /your/project/
```

### 2. Initialize

```bash
# OpenCode
/init
/sdd-init

# Configure GitHub Project Board
```

### 3. Work Flow

| Phase | Days | Action |
|-------|------|--------|
| Planning | 1-2 | Create HUs in docs/tasks/ |
| Script | - | Run hu-to-issues to create GitHub Issues |
| Execution | 3-11 | Work on issues |
| Integration | 12-14 | Integration review |
| Retrospective | 15 | Document lessons |

---

## 📋 Templates

Templates are in **`docs/templates/`** (source of truth). See `docs/templates/TEMPLATE_GUIDE.md` for usage guide.

| Template | Location | Use |
|----------|-----------|-----|
| User Story Simple | `docs/templates/user-stories/` | Small features (< 2h) |
| User Story SDD-Ready | `docs/templates/user-stories/` | Normal features, with Given/When/Then |
| Bug Fix Simple | `docs/templates/bug-fixes/` | Trivial bugs |
| Bug Fix SDD-Ready | `docs/templates/bug-fixes/` | Bugs with verification test |
| Refactor | `docs/templates/refactors/` | Refactors without behavior change |
| RFC | `docs/templates/architecture/` | Technical proposals in discussion |
| ADR | `docs/templates/architecture/` | Approved technical decisions |
| PRD | `docs/templates/PRD/` | Product requirements document |

---

## 🔧 Scripts

### Linux/macOS
```bash
./scripts/hu-to-issues.sh
```

### Windows (double-click)
```
./scripts/hu-to-issues.bat
```

---

## 📖 Documentation

- **docs/adoption-guide.md** → Gradual adoption guide in levels
- **docs/FAQ.md** → Frequently asked questions
- **docs/troubleshooting.md** → Common errors and solutions
- **docs/anti-patrones.md** → Signs that the framework is not working
- **docs/walkthrough-hu-login.md** → Complete HU example through SDD cycle
- **docs/architecture-diagram.md** → Architecture diagrams (Mermaid)
- **docs/flowdoc-ciclo.md** → Adaptable work cycle
- **AGENTS.md** → AI agent context

---

## 🔄 Tool Compatibility

The framework is **tool-independent**:

| Tool | Compatible? |
|------|-------------|
| OpenCode + SDD | ✅ |
| Antigravity + SDD | ✅ |
| ClaudeCode + SDD | ✅ |
| Any agent that reads docs/ | ✅ |

---

## ⚠️ Golden Rules

| Rule | Description |
|------|-------------|
| Docs in repo | Everything in docs/ and openspec/ |
| One HU = one change | One feature = one change |
| Branch naming | `feature-{user}-{HU}` from `dev` |
| No self-merge | Always another peer reviews and merges |
| Frequent commits | No more than 1 day without committing |
| Async-first | Written communication before meetings. If no ADR, the decision doesn't exist |
| Clear owner | Each HU has a responsible person |

---

## 📚 Resources

- [SDD Spec](https://github.com/Gentleman-Programming/gentle-ai)
- [OpenCode Docs](https://opencode.ai/docs/es)
- [Google Antigravity](https://antigravity.google/)
- [ClaudeCode Docs](https://docs.claude.ai)
- [Engram (persistent memory)](https://github.com/antigravity-dev/engram)

---

## 🏗️ Supported Architectures

| Architecture | When to Use | Location |
|--------------|-------------|-----------|
| **Monolithic** | Frontend-only, single backend, < 5 people | `architectures/monolitico/` |
| **Microservices** | Multiple independent services, teams per module | `architectures/microservicios/` |
| **Monorepo** | Multiple packages/apps in one repo | `architectures/monorepo/` |
| **Serverless** | Cloud functions, variable traffic | `architectures/serverless/` |

---

## 🌐 Language

This is the **English version**. For Spanish, see [`es/`](es/) folder.

---

**Version**: 1.1
**Last updated**: 2026-05-29
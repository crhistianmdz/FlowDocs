# AGENTS.md — FlowDoc

**Framework**: FlowDoc — Documentation that flows with the work
**Ecosystem**: FlowForge (tool) + FlowDoc (framework)
**Stack**: Documentation (no code), SDD workflow, Engram/openspec for artifacts

---

## Stack and Technologies

### Main Framework
- **Name**: FlowDoc
- **Methodology**: SDD (Spec-Driven Development)
- **Artifact Store**: Engram (default), openspec (for teams)
- **Format**: Markdown Documentation
- **Architecture**: Adaptable (monolithic, microservices, monorepo, serverless, or hybrid)

### AI Tool Compatibility

The SDD workflow is **tool-independent**. Any agent that can read and write markdown files works:

| Tool | Compatibility | Notes |
|------|---------------|-------|
| OpenCode | ✅ | Native SDD commands |
| Antigravity | ✅ | Native SDD commands |
| ClaudeCode | ✅ | Compatible with docs/ |
| Other agents | ✅ | Read `docs/` as source of truth |

**What matters**: `docs/` is the source of truth. The agent you use is secondary.

### Team Tools
- **Version control**: Git + GitHub
- **Communication**: Discord (async-first)
- **Issues**: GitHub Issues

---

## Project Structure

```
newPropuestaFrameworkTrabajo/
├── docs/                          <- DOCUMENTATION (source of truth)
│   ├── PRD.md                     <- Product Requirements
│   ├── architecture/
│   │   ├── rfc/                   <- Request for Comments (discussion)
│   │   └── adr/                   <- Architecture Decision Records (immutable)
│   ├── api/
│   │   ├── endpoints.md           <- API Contracts
│   │   └── modelos.md            <- DTOs
│   ├── database/
│   │   └── schema.md             <- DB Schema
│   └── tasks/
│       └── HU-*.md               <- User Stories
├── templates/                     <- DEPRECATED, use docs/templates/
├── architectures/                 <- Guides by architecture type
│   ├── monolitico/
│   ├── microservicios/
│   ├── monorepo/
│   └── serverless/
├── scripts/                       <- Automations
│   ├── hu-to-issues.sh
│   └── hu-to-issues.ps1
├── docs/flowdoc-ciclo.md         <- Workflow cycle
├── ONBOARDING.md                  <- Checklist for new members
├── QUICKSTART.md                  <- Quick guide
├── adoption-guide.md              <- Adoption guide by levels
├── FAQ.md                        <- Frequently asked questions
└── README.md                      <- This file
```

---

## Sources of Truth

### Core Documentation
- **PRD**: `docs/PRD.md`
- **Architecture decisions**: `docs/architecture/adr/`
- **RFC (discussion)**: `docs/architecture/rfc/`
- **User stories**: `docs/tasks/`
- **API contracts**: `docs/api/`

### Conventions
- **Workflow cycle**: `docs/flowdoc-ciclo.md`
- **Team unification**: [RFC-004 (deprecated)](docs/architecture/rfc/004-propuesta-unificada-equipo-deprecada.md) — See AGENTS.md for the current version
- **Onboarding**: `ONBOARDING.md`

---

## Framework Conventions

### File Conventions

| Type | Format | Location |
|------|--------|----------|
| RFC | `NNN-descriptive-name.md` | `docs/architecture/rfc/` |
| ADR | `NNN-descriptive-name.md` | `docs/architecture/adr/` |
| HU | `HU-NNN-name.md` | `docs/tasks/` |
| Template | varies by type | `docs/templates/` |

### Commit Conventions (Conventional Commits)

```
feat: add reservation system with date picker
fix: resolve login timeout on mobile
refactor: extract payment logic to domain
docs: update API endpoint documentation
chore: update dependencies
```

### Branch Naming

```
feature/add-reservation-system
fix/login-timeout
refactor/order-service
docs/api-endpoints
hotfix/critical-security-patch
```

---

## SDD Workflow

### Commands

| Command | What it does |
|---------|--------------|
| `/sdd-init` | Initialize SDD project, detect stack |
| `/sdd-new <name>` | Create new change (explore + propose) |
| `/sdd-new <name> --from-docs` | Create from pre-written HU in `docs/tasks/` |
| `/sdd-continue <name>` | Continue to next phase |
| `/sdd-apply <name>` | Implement tasks |
| `/sdd-verify <name>` | Validate against specs |
| `/sdd-archive <name>` | Archive completed change |

### SDD Cycle

```
proposal → spec → design → tasks → apply → verify → archive
    ↑           ↑        ↑       ↑        ↑        ↑
 explore    (optional depending on change complexity)
```

### Artifact Store Modes

| Mode | Use | Shareable |
|------|-----|-----------|
| `engram` | Individual work | ❌ |
| `openspec` | Teams, git-tracked | ✅ |
| `hybrid` | Individual + recovery | ✅ |

---

## Agent Rules

**This agent does NOT:**
- Make commits — that's the human's job
- Modify `AGENTS.md` without human approval
- Modify `docs/` or `openspec/` without human approval
- Merge to `main` or `staging`

**This agent DOES:**
- Generate code in feature branches
- Propose changes, but always with human review
- Read from `docs/` to understand context

---

## Testing in This Project

This is a **documentation** project. There are no automated tests for the framework itself.

For projects that USE the framework:
- Tests according to the chosen stack (vitest, jest, xUnit, etc.)
- Minimum coverage: >80%
- Each code task includes its associated test

---

## Common Errors

| Error | Solution |
|-------|----------|
| SDD doesn't read HUs | Use `--from-docs` in the command |
| Engram doesn't save context | Run `/sdd-init` at the start of each session |
| Conflicts in docs/ | Communicate changes before editing |
| HU too large | Split into 1-3 day HUs |

More solutions in: `docs/troubleshooting.md`

---

## Resources

| Resource | Link |
|---------|------|
| SDD Spec | https://github.com/Gentleman-Programming/gentle-ai |
| OpenCode Docs | https://opencode.ai/docs/es |
| Google Antigravity | https://antigravity.google/ |
| ClaudeCode Docs | https://docs.claude.ai |
| Engram (persistent memory) | https://github.com/antigravity-dev/engram |

---

## Support Guides

| Guide | Purpose |
|------|---------|
| `docs/adoption-guide.md` | How to adopt the framework in levels |
| `docs/FAQ.md` | Frequently asked questions |
| `docs/troubleshooting.md` | Common errors and solutions |
| `docs/legacy-migration.md` | Adapt existing project to SDD |

---

**Last updated**: 2026-05-29
**Maintained by**: @author

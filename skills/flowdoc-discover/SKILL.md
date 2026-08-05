---
name: flowdoc-discover
description: >
  Investigates a codebase to understand stack, architecture, decisions, and existing documentation.
  Used by flowdoc-assist orchestrator to gather context before invoking specialists.
  Can also be invoked directly by users who want deep project analysis.
  Trigger: "discover", "investigate", "analyze project", "qué tecnologías usa este proyecto"
license: Apache-2.0
metadata:
  author: FlowDoc
  version: "1.0"
---

## When to Use

Use this skill when you need to understand a project deeply before creating documentation:

- **Orchestrator invoke**: Before launching specialists, the orchestrator calls this to gather base context
- **Direct user invoke**: User wants to know what stack, architecture, and decisions exist in their project
- **Specialist invoke**: Another specialist needs deeper investigation than the orchestrator provided

**This skill does NOT create documentation.** It only investigates and reports findings.

---

## What This Skill Returns

```
contextGathered:
├── projectPath
├── language (user's language detected)
├── architecture (monolith | microservices | monorepo | serverless)
├── stack (list of technologies found)
├── decisionsFound (technical decisions inferred from code)
├── existingDocs (what FlowDoc structure exists, if any)
└── recommendations (what specialists should be invoked)
```

---

## Investigation Protocol

### Step 1: Detect Language Preference

Detect the user's language from their input:

- **Spanish** → respond in Spanish
- **English** → respond in English
- Default to English if unclear

### Step 2: Passive Analysis (READ FIRST)

Before asking anything, read the existing project to gather evidence:

| Read | To find |
|------|---------|
| `AGENTS.md` | Does FlowDoc already exist? |
| `README.md` | What is this project about? |
| `docs/` | Any existing documentation structure |
| `package.json`, `requirements.txt`, `*.csproj`, `go.mod`, `Cargo.toml` | Language, package manager |
| `docker-compose.yml`, `docker-compose.yaml` | Database and services |
| `auth/*.ts`, `middleware/*.ts`, `*/auth*` | Auth approach |
| `routes/*.ts`, `controllers/*.ts`, `api/*.py` | API style |
| `prisma/schema.prisma`, `models/*.py`, `schema.prisma` | ORM choice |
| `store/*.ts`, `context/*.tsx`, `redux/*` | State management |
| `scripts/` | Existing automation |
| `.git/` | Is it a git repo? |

### Step 3: Detect Architecture Type

Based on evidence found:

| Evidence found | Architecture |
|----------------|--------------|
| Single docker-compose service, no workspaces | Monolithic |
| Multiple services in docker-compose | Microservices |
| `packages/` + workspaces in root | Monorepo |
| `functions/` or `serverless.yml` | Serverless |
| `turbo.json` / `nx.json` / `lerna.json` | Monorepo |

If evidence is unclear, ask the user.

### Step 4: Infer Technical Decisions

From code evidence, infer what technical decisions were made:

| Evidence | Decision likely |
|----------|----------------|
| `docker-compose.yml` with PostgreSQL/MySQL/MongoDB | Database choice |
| JWT middleware, `auth/*.ts` | Auth approach |
| REST routes, GraphQL resolvers | API style |
| Prisma/TypeORM/Sequelize | ORM |
| Redux/Zustand/Jotai | State management |
| Express/FastAPI/NestJS | Framework |

### Step 5: Check Existing FlowDoc Structure

If `docs/` exists:

| Path | What it means |
|------|---------------|
| `docs/PRD.md` | PRD exists |
| `docs/architecture/adr/` | ADR system in use |
| `docs/architecture/rfc/` | RFC system in use |
| `docs/api/` | API documentation exists |
| `docs/database/` | DB schema documented |
| `docs/templates/` | Templates exist |

### Step 6: Return Investigation Report

```
## Discovery Complete

### Project: {project name}
### Path: {absolute path}
### Architecture: {monolith | microservices | monorepo | serverless}

### Stack Detected
| Category | Technology | Evidence |
|----------|------------|----------|
| Language | {lang} | {file found} |
| Framework | {framework} | {file found} |
| Database | {db} | {file found} |
| ORM | {orm} | {file found} |
| Auth | {auth} | {file found} |
| API Style | {rest/graphql} | {file found} |
| State | {state} | {file found} |

### Technical Decisions Found
| Decision | Evidence | Confidence |
|----------|----------|------------|
| {decision} | {file/code} | High/Medium/Low |

### Existing FlowDoc Structure
- FlowDoc adopted: Yes/No
- PRD: Exists / Missing
- ADRs: {N} found
- RFCs: {N} found
- API docs: Exists / Missing
- DB docs: Exists / Missing

### Recommendations
Based on findings, invoke these specialists:
1. flowdoc-prd — PRD missing
2. flowdoc-adr — {N} decisions found
3. flowdoc-api — REST API detected
4. ...

### Context for Specialists
{concise context summary that orchestrator passes to specialists}
```

---

## Usage Examples

### As Orchestrator (automatic)
```
User: "adopt flowdocs"
     → flowdoc-assist invokes flowdoc-discover
     → Receives contextGathered
     → Decides which specialists to invoke
```

### Direct Invocation
```
User: "descubreme este proyecto"
     → flowdoc-discover runs full investigation
     → Returns detailed report
```

### Specialist Invocation (deeper investigation)
```
flowdoc-adr specialist needs to verify database decision
     → Invokes flowdoc-discover for deeper analysis
     → Gets enhanced context
     → Continues with ADR creation
```

---

## Output Format Options

The skill can return in two modes:

### Full Report (default)
Verbose output with all findings, used by orchestrator to decide which specialists to invoke.

### Concise Context
Stripped-down context for passing to specialists:
```
stack: [Node.js, Express, PostgreSQL, Prisma]
decisionsFound: [PostgreSQL, JWT auth, REST API]
existingDocs: [PRD exists, 3 ADRs, API docs missing]
recommendations: [flowdoc-prd, flowdoc-api, flowdoc-adr]
```

---

## Rules

- **READ FIRST** — always do passive analysis before asking questions
- **Evidence-based** — only report what you found, never assume
- **No documentation creation** — this skill investigates only
- **Concurrency-safe** — can be invoked by multiple agents without conflicts
- **Stateless** — doesn't persist anything, returns results to caller

---

## See Also

- [RFC-005 — Specialist Architecture](../../docs/architecture/rfc/005-specialist-architecture.md)
- [flowdoc-assist](./flowdoc-assist/SKILL.md) — the orchestrator

# ADR-006: Four Supported Architectures

**Date**: 2026-05-29  
**Related RFC**: None (framework design decision)  
**Status**: Accepted

---

## Context

The work framework is designed to adapt to different types of projects and teams. There is no single structure that works for all cases. A frontend-only project has different needs than a microservices system with multiple teams.

Teams adopting the framework need:
- Clear structure that matches their software architecture
- Documents that reflect their reality (endpoints, schemas, contracts)
- Ability to scale the structure if the project grows

---

## Decision

The framework supports **four predefined architectures**, each with its own `docs/` structure, templates, and initialization scripts.

### The 4 Architectures

| Architecture | When to use | docs/ structure |
|--------------|-------------|------------------|
| **Monolithic** | Frontend-only, single backend, < 5 people | Flat `docs/` |
| **Microservices** | Multiple services, teams per module, separate DBs | `docs/SHARED/` + `docs/<module>/` |
| **Monorepo** | Multiple packages/apps in one repo | Packages in `packages/` |
| **Serverless** | Cloud functions, variable traffic | `functions/` + `infrastructure/` |

### Hybrid Architecture (Adaptable)

**You are not limited to choosing a single architecture.** Your real project is probably a mix:

| Example | Description |
|---------|-------------|
| **Monolithic with modules** | One codebase but with clear modules that could be separated |
| **Monorepo + Microservices** | Some modules are separate services |
| **Monolithic + Serverless** | Main monolithic API + lambda functions for specific tasks |
| **Monolithic backend + Separate frontend** | Single REST API + multiple frontends |

**Rule**: Use the structure that best matches your real project. If hybrid, document why in your `docs/architecture/`.

For teams starting new: choose the structure closest to your reality and adapt as needed.

---

## Selection Criteria

### Monolithic ✅ Ideal for:

| Criteria | Threshold |
|----------|-----------|
| Team size | 1-10 people |
| Complexity | Single codebase |
| Database | One shared DB |
| Deployment | Single deploy |
| Changes | Most cross the entire system |

**Examples**: SPA web app, simple REST API, CLI tool

---

### Microservices ✅ Ideal for:

| Criteria | Threshold |
|----------|-----------|
| Team size | 5+ people |
| Complexity | Multiple independent services |
| Database | One per service (or shared with boundaries) |
| Deployment | Independent deploy per service |
| Changes | Changes are per module, not per system |

**Examples**: E-commerce (auth, inventory, orders, payments as separate services)

---

### Monorepo ✅ Ideal for:

| Criteria | Threshold |
|----------|-----------|
| Team size | 3+ people |
| Stack | Multiple packages (web + mobile + shared) |
| Database | Shared or per package |
| Deployment | Multiple apps from one repo |
| Sharing | Shared code between packages |

**Examples**: React Native app + web app + shared utilities

---

### Serverless ✅ Ideal for:

| Criteria | Threshold |
|----------|-----------|
| Workload type | Event-driven functions |
| Traffic | Variable or unpredictable |
| Scaling | Automatic |
| Budget | Pay-per-use preferred |

**Examples**: Lambda/Cloud Function-based APIs, webhooks, event processors

---

## Folder Structure by Architecture

### Monolithic

```
<project>/
├── docs/
│   ├── PRD.md
│   ├── architecture/adr/
│   ├── api/endpoints.md
│   ├── database/schema.md
│   └── tasks/HU-*.md
├── .agent/context.md
└── src/
```

### Microservices

```
<project>/
├── docs/
│   ├── SHARED/                 ← Global contracts, shared RFCs
│   │   ├── PRD.md
│   │   ├── contracts.md
│   │   └── architecture/
│   ├── auth-service/           ← Each service self-contained
│   │   ├── API/
│   │   ├── DB/
│   │   └── tasks/
│   ├── inventory-service/
│   └── orders-service/
├── .agent/context.md
└── src/
    ├── auth-service/
    ├── inventory-service/
    └── orders-service/
```

### Monorepo

```
<project>/
├── packages/
│   ├── shared/                 ← Shared packages
│   ├── web-app/                ← Web application
│   └── mobile-app/             ← Mobile application
├── docs/
│   ├── PRD.md
│   ├── architecture/
│   ├── api/
│   └── tasks/
├── .agent/context.md
└── package.json (root workspace)
```

### Serverless

```
<project>/
├── functions/                  ← Serverless functions
│   ├── auth/
│   ├── users/
│   └── orders/
├── infrastructure/             ← IaC (Terraform, CDK, etc.)
│   └── terraform/
├── shared/                      ← Shared code between functions
├── docs/
│   ├── PRD.md
│   ├── architecture/
│   ├── api/
│   └── tasks/
└── serverless.yml
```

---

## Transition Rules

| Transition | Possible | How |
|------------|---------|-----|
| Monolithic → Microservices | ✅ Yes | When there are separate teams per module |
| Monolithic → Monorepo | ✅ Yes | When multiple apps are added |
| Microservices → Monorepo | ❌ No | Different structures |
| Any → Serverless | ⚠️ Partial | Requires re-architecture |

**Note**: Growing from monolithic to microservices is a big decision. Document with ADR if it occurs.

---

## Consequences

### ✅ Positive

- Framework adaptable to any project type
- Team chooses structure that matches their reality
- Each architecture's templates include relevant examples
- Initialization scripts automate setup

### ❌ Negative

- More documentation to maintain (4 architectures vs 1)
- New team might be confused when choosing architecture
- Some template sections repeat between architectures

### 🔄 Neutral

- Architecture choice is at the start, but can be adapted later
- SDD workflow is identical regardless of architecture

---

## Related Documents

| Document | Location |
|----------|---------|
| Monolithic Guide | `reference/monolitico/estructura.md` |
| Microservices Guide | `reference/microservicios/estructura.md` |
| Monorepo Guide | `reference/monorepo/estructura.md` |
| Serverless Guide | `reference/serverless/estructura.md` |
| Monolithic Init | `reference/monolitico/scripts/init-monolith.sh` |
| Microservices Init | `reference/microservicios/scripts/init-microservices.sh` |
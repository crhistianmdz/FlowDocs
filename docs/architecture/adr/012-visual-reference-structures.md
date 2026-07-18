# ADR-012: Visual Reference Structures for Architecture Patterns

- **Date**: 2026-07-18
- **Related RFC**: None
- **Status**: Accepted

---

## Context

FlowDocs supports four architecture patterns (monolítico, microservicios, monorepo, serverless), each with its own conventions for how the `docs/` tree is organized. Until now, those conventions were described in prose — text explaining how folders should be laid out — but a reader had to mentally reconstruct the structure from the description.

This created friction:

- A reader could not, at a glance, **see** the expected folder layout for an architecture.
- When onboarding a new project, adopters had to guess what concrete files should live where.
- Comparing patterns required reading multiple prose descriptions side by side.

The need: a way for someone to **look** at an architecture pattern and immediately understand the folder organization without parsing prose.

---

## Decision

### Introduce `reference/` folders with complete visual structures for each architecture

FlowDocs now ships a `reference/` folder at the project root, containing one subfolder per architecture pattern:

```
reference/
├── monolitico/
├── microservicios/
├── monorepo/
└── serverless/
```

Each `reference/<pattern>/` folder contains **complete folder structures with realistic example files for docs, src, scripts, and configuration** — not diagrams or prose descriptions, but actual files showing a representative project that follows FlowDocs conventions for that architecture.

What each reference folder contains, qualitatively:

- A representative `docs/` tree (PRD, ADRs, RFCs, per-service or per-package documentation, user stories, API/database docs, etc. — whatever applies to the pattern).
- An example `src/` layout that fits the pattern (a single app for monolítico; per-service folders for microservicios; packages for monorepo; functions for serverless).
- Example scripts and configuration files appropriate to the pattern.
- An `estructura.md` describing the structure, and an `.agent-context.md` so AI agents can orient themselves.

The intent is to show the **shape** of the project — what folders exist, what kinds of files live in them, and how FlowDocs docs map onto each architecture — rather than to serve as a copy-paste scaffold. Adopters use the references to compare patterns visually and then apply the relevant conventions to their own project.

### Reference folders are example artifacts, not templates

References are **not** copied into a project during adoption — `docs/templates/` remains the source of truth for human-authored templates. References are read-only examples whose only job is to make the folder layout concrete and visible.

---

## Consequences

### ✅ Positive

- Readers can now **see** folder organization for each architecture at a glance, without reconstructing it from prose.
- Comparing the four patterns is visual and fast — open two `estructura.md` files side by side.
- New adopters have a concrete mental model of what their project should look like before generating any files.
- AI agents landing in a reference folder can read the `.agent-context.md` and immediately understand the expected layout for that pattern.

### ❌ Negative

- Reference folders must be maintained alongside the framework — if FlowDocs conventions evolve, the example files risk drifting from the canonical templates.
- Four reference folders add to the repo's surface area; contributors must understand they are examples, not templates to copy.
- Example file names are illustrative — adopters who copy them literally will end up with generic names (e.g., `HU-001-login.md`) that don't reflect their project.

### 🔄 Neutral

- `docs/templates/` keeps its role as the source of truth for templates; references inherit those conventions but do not define new ones.
- Naming is in Spanish (`monolitico`, `microservicios`, `monorepo`, `serverless`), consistent with ADR-006 naming.

### Accepted technical debt

- No automated check yet enforces that the example files in `reference/` stay consistent with `docs/templates/`. Drift is possible and is left to manual review or a future extension of the `flowdoc-audit` skill.

---

## Related Documents

| Document | Location |
|----------|----------|
| Cuatro Arquitecturas Soportadas | ADR-006 |
| Templates structure (docs/templates/) | ADR-007 |
| docs/ as source of truth | ADR-002 |
| Reference folders | `reference/{monolitico,microservicios,monorepo,serverless}/` |
| Templates Guide (mentions references) | `docs/templates/TEMPLATE_GUIDE.md` |

---

> **Reminder**: After creating this ADR, add it to [`docs/architecture/adr/INDEX.md`](./INDEX.md).
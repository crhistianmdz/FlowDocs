# ADR-013: Specialist Orchestrator Architecture

- **Date**: 2026-08-05
- **Related RFC**: [RFC-005](./005-specialist-architecture.md)
- **Status**: Accepted

---

## Context

FlowDoc needed a way to handle documentation generation that was modular, testable, and allowed both full orchestration and direct specialist invocation. The monolithic `flowdoc-assist` skill had limitations in testing, parallelization, and user flexibility.

---

## Decision

Split `flowdoc-assist` into an **orchestrator** that coordinates **specialized skills**, each expert in their document domain.

```
flowdoc-assist (ORCHESTRATOR)
├── flowdoc-discover   (deep investigation)
├── flowdoc-prd       (PRD)
├── flowdoc-rfc       (RFC)
├── flowdoc-adr       (ADR)
├── flowdoc-api       (API)
├── flowdoc-db        (DB)
├── flowdoc-hu        (HU + post-dev)
└── flowdoc-review    (validation)
```

Each specialist is **self-contained and independently invokable**. The orchestrator maintains dialogue, detects project needs, and coordinates execution.

---

## Consequences

- **Positive**: Specialists testable independently; users can invoke one directly; parallel execution possible for ADR
- **Negative**: More files to maintain; orchestration complexity
- **Neutral**: Same end result, different path

---

## See Also

- [RFC-005 — Specialist Architecture](../rfc/005-specialist-architecture.md)
- ADR-011: Self-Contained Skill Templates

# ADR-015: Specialist Communication Protocol

- **Date**: 2026-08-05
- **Related RFC**: [RFC-005](./005-specialist-architecture.md)
- **Status**: Accepted

---

## Context

Specialists need to coordinate without creating tight coupling. A specialist may detect that another document needs updating (e.g., API change affects PRD), but should not modify documents outside its scope.

---

## Decision

Three communication rules:

1. **Orchestrator → Specialist**: Passes base context (paths, existing docs, template references) via prompt
2. **Specialist → Orchestrator**: Writes results to `docs/`, updates register, reports pending cross-document updates
3. **Specialist ↔ Specialist**: **No direct communication**. If a specialist needs investigation, it invokes `flowdoc-discover`. If it detects impact on another document, it reports to the orchestrator

Special case: **API specialist NEVER touches PRD**. If API changes affect PRD, the API specialist reports to orchestrator, which routes to `flowdoc-prd`.

---

## Consequences

- **Positive**: Clear ownership; no accidental document conflicts; easy to trace update lineage
- **Negative**: Extra hop for cross-document updates (specialist → orchestrator → other specialist)
- **Neutral**: Follows single responsibility principle

---

## See Also

- [RFC-005 — Communication Protocol](../rfc/005-specialist-architecture.md#6-communication-protocol)

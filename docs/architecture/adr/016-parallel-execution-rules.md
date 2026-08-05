# ADR-016: Parallel Execution Rules for Specialists

- **Date**: 2026-08-05
- **Related RFC**: [RFC-005](./005-specialist-architecture.md)
- **Status**: Accepted

---

## Context

Some specialists could theoretically run in parallel to save time, but running all in parallel risks document conflicts and inconsistent state. Rules are needed to define when parallelism is safe.

---

## Decision

**Sequential by default**. All specialists run one after another.

**Parallel allowed only for ADR specialist** when:
1. All technical decisions are already identified by PRD/RFC
2. ADRs don't depend on each other
3. Orchestrator performed a checkpoint before launching parallel tasks

The orchestrator acts as coordinator and is responsible for detecting when parallel execution is safe.

---

## Consequences

- **Positive**: No document conflicts; predictable execution order; easy to debug
- **Negative**: Slower than potential parallel execution
- **Neutral**: Parallelism reserved for proven-safe cases (multiple independent ADRs)

---

## See Also

- [RFC-005 — Parallel Execution Rules](../rfc/005-specialist-architecture.md#7-parallel-execution-rules)

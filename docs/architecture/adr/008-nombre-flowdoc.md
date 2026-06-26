# ADR-008: Framework Name: FlowDoc

**Date**: 2026-05-29
**Related RFC**: None (naming decision)
**Status**: Accepted

---

## Context

The framework needs an official name to identify it. Until now, it was referred to as "Distributed Teams SDD Framework" or simply "the framework".

During the documentation session, two names emerged for complementary projects:
- **FlowForge**: Tool to minimize SDD overhead and optimize time/resources
- **FlowDoc**: Documentation that flows with the work

These two names form a coherent ecosystem.

---

## Decision

**The framework is called `FlowDoc`**.

```
FlowForge ──→ Minimizes SDD overhead (tool)
FlowDoc ────→ Documentation that flows (framework)
```

### Why FlowDoc

| Criteria | Evaluation |
|----------|------------|
| **Descriptive** | "Doc" = documentation, "Flow" = that flows with the work |
| **Memorable** | Short, easy to pronounce, unique |
| **Ecosystem** | Complements FlowForge |
| **Agnostic** | Doesn't say "SDD" in the name (the framework is more than SDD) |
| **Async-first** | "Flow" suggests frictionless rhythm |

### Why NOT Other Names

| Name | Reason for discard |
|------|-------------------|
| `SDD Framework` | Too technical, excludes newcomers |
| `SpecOps` | Sounds like military operations, not friendly |
| `Async-First Framework` | Accurate but too long |
| `SDD Async Framework` | Mix of terms |

---

## Relationship with FlowForge

```
FlowForge + FlowDoc = Complete Ecosystem

FlowForge:
- Minimizes SDD overhead
- Automations
- Time/resource optimization

FlowDoc:
- First-class documentation
- SDD workflow
- Gradual adoption
- Tool-agnostic
```

**FlowForge uses FlowDoc as its documentation layer.** FlowForge generates/updates documentation according to the FlowDoc workflow.

---

## Consequences

### ✅ Positive

- Memorable and descriptive name
- Clear ecosystem with FlowForge
- Doesn't exclude by being too technical
- Easy to search on the internet ("FlowDoc framework")

### ❌ Negative

- "Flow" is a common term in tech (Flow, Vue Flow, etc.)
- Possible name collision with other tools

### 🔄 Neutral

- The name doesn't change functionality
- `docs/` files remain the source of truth
- Repository may be renamed to `flowdoc` in the future

---

## Name Change in Documentation

The repository is called `newPropuestaFrameworkTrabajo` but the framework is **FlowDoc**.

| Document | Required update |
|----------|-----------------|
| `README.md` | Title changes to "FlowDoc" |
| `docs/CHANGELOG.md` | Version note with new name |
| `AGENTS.md` | Reference to FlowDoc name |

---

## Implementation Checklist

- [x] ADR-008 created with the decision
- [ ] `README.md` updated with "FlowDoc" title
- [ ] `docs/CHANGELOG.md` recorded
- [ ] `AGENTS.md` updated
- [ ] Repository rename to `flowdoc` (optional, future decision)

---

## Related Documents

| Document | Location |
|----------|----------|
| Unified team proposal | [RFC-004 (deprecated)](../rfc/004-propuesta-unificada-equipo-deprecada.md) | History — see AGENTS.md |
| Adoption guide | `docs/adoption-guide.md` |
| FAQ | `docs/FAQ.md` |
| ADR-009 | SDD Sub-agent Context Pattern | Uses the FlowDoc naming convention established here |
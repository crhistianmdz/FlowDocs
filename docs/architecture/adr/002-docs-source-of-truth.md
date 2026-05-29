# ADR-002: docs/ as Source of Truth

**Date**: 2026-05-29  
**Related RFC**: [RFC-001: Documentation Structure](./rfc/001-estructura-docs.md)  
**Status**: Accepted

---

## Context

In distributed teams, documentation is often scattered across Drive, Notion, Slack, READMEs in different folders. This causes: inability to find past decisions, decisions made without record, and slow onboarding. We needed a single, consistent location for all project documentation.

---

## Decision

We establish `docs/` as the single location for documentation, with the following structure:

```
docs/
├── PRD.md                       ← Product Requirements
├── architecture/
│   ├── rfc/                     ← Proposals under discussion
│   └── adr/                     ← Approved decisions (immutable)
├── api/                         ← API Contracts
├── database/                    ← DB Schema
└── tasks/                       ← User Stories
```

Each document type has a clear purpose and a defined moment to be created. The fundamental rule is: **"If there is no ADR, the decision does not exist."**

---

## Consequences

### ✅ Positive

- Single place to search for documentation
- Technical decisions always have tracking
- Faster onboarding (everything is in docs/)
- Git-tracked with change history

### ❌ Negative

- Overhead per technical decision (30 min extra for RFC + ADR)
- Requires team discipline to keep docs updated
- Initial resistance may occur ("too much paperwork")

### 🔄 Neutral

- Documents "become obsolete" if not maintained — requires process
- Small teams may feel overhead — can be adapted

---

## Related Decisions

| Decision | Location |
|----------|----------|
| Artifact persistence | ADR-001 |
| Work cycle | ADR-003 |
| Feature flags | ADR-004 |
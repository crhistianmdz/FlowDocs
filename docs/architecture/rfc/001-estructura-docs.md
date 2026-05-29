# RFC-001: Documentation Structure — docs/ as Source of Truth

- **Status**: Approved
- **Author(s)**: @Crhistian
- **Date**: 2026-05-29
- **Project**: Distributed Teams Workflow Framework

---

## 1. Summary

Establish `docs/` as the single place where project documentation lives, with specialized subfolders (PRD, RFC, ADR, HU, API, DB). The goal is that any AI agent or human can find the information they need without searching in multiple places.

---

## 2. Context

- **Technical problem**: In distributed teams, documentation is often scattered: in Drive, Notion, Slack, READMEs in different folders, etc. This causes:
  - Inability to find past decisions
  - Decisions made without record ("why was it done this way?" → "I don't know")
  - Slow onboarding for new members
- **Why this needs to be decided now**: The framework aims to be adopted by teams using OpenCode and Antigravity. Without a clear structure, each team documents differently.
- **Alternatives considered**:
  1. **Notion/Confluence as central**: Requires licenses, not git-tracked, agents don't read it well
  2. **Only READMEs in code**: Becomes long and difficult to navigate
  3. **Shared Google Drive**: No version control, hard to track

---

## 3. Technical Decision

### 3.1 Chosen Structure

```
docs/
├── PRD.md                       ← Product Requirements (what the team builds)
├── architecture/
│   ├── rfc/                     ← Request for Comments (open discussion)
│   │   └── NNN-name.md
│   └── adr/                     ← Architecture Decision Records (final decision)
│       └── NNN-name.md
├── api/
│   ├── endpoints.md             ← API contracts
│   └── modelos.md               ← DTOs and data types
├── database/
│   └── schema.md                ← Database schema
└── tasks/
    └── HU-*.md                  ← User stories
```

### 3.2 Each Document's Responsibility

| Document | Purpose | When to create | Immutable |
|----------|---------|----------------|------------|
| **PRD** | What is being built and why | Project start | No (evolution) |
| **RFC** | Technical proposal under discussion | Before major decisions | Becomes ADR or discarded |
| **ADR** | Accepted technical decision | After RFC approved | Yes (marked obsolete if changed) |
| **HU** | Feature to implement | Each cycle planning | No (updated with changes) |
| **API docs** | Endpoint and model contracts | With each API change | No |

### 3.3 Fundamental Rule

**"If there is no ADR, the decision doesn't exist."**

Any significant technical decision must go through the cycle: Discussion (RFC) → Approval (ADR). Informal decisions in chat are not considered documented decisions.

---

## 4. Infrastructure

Not applicable (documentation, not code).

---

## 5. Security Considerations

- **Git-tracked**: All documentation is in the Git repo, with change history
- **Code review**: Changes in `docs/` go through PR, same as code
- **Branch protection**: `main` protected to prevent overwriting without review

---

## 6. Costs and Resources

- **Initial setup time**: ~1 hour (create folders and templates)
- **Maintenance time**: ~15 min per PR that includes updated docs
- **Overhead per decision**: ~30 min to write RFC + ADR

---

## 7. Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Outdated documentation | Medium | Rule: docs are updated in the same PR as the code |
| Team doesn't follow structure | Medium | Onboarding includes training, DoD includes docs check |
| Duplicate ADRs | Low | ADR has sequential number, review before creating new |

---

## 8. Approval Status

| Role | Person | Status | Date |
|------|--------|--------|------|
| Tech Lead | @Crhistian | Approved | 2026-05-29 |

---

## 9. Change History

| Date | Change | Author |
|------|--------|--------|
| 2026-05-29 | Initial version | @Crhistian |

---

## 10. Related Documents

- **ADR-001**: Persistence with Engram for SDD Artifacts
- **RFC-002**: 15-day work cycle
- **RFC-003**: Mandatory Feature Flags
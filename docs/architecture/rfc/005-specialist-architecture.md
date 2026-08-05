# RFC 005: FlowDoc Specialist Architecture

- **Status**: Draft
- **Author**: Kaito
- **Date**: 2026-08-05

---

## 1. Summary

Proposal to split `flowdoc-assist` into an orchestrator that coordinates specialized skills, each expert in their document domain. The orchestrator maintains dialogue, detects what the project needs, and delegates to the appropriate specialist.

## 2. Context

The current `flowdoc-assist` skill is monolithic — it handles discovery, proposal, execution, and validation in one skill. While functional, this creates problems:

- Hard to test individual phases independently
- No parallel execution possible
- User cannot invoke a single specialist directly
- Difficult to maintain and extend

The goal is to decompose into specialized, composable skills that can work together under an orchestrator or independently.

## 3. Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  flowdoc-assist (ORCHESTRATOR)                              │
│  - Maintains dialogue with user                             │
│  - Detects project needs                                    │
│  - Decides which specialists to invoke                       │
│  - Coordinates sequential and parallel execution            │
│  - Does checkpoint before parallel launches                  │
│  - Maintains session register in docs/.flowdoc/sessions/    │
│  - Can work standalone or with specialists                  │
└─────────────────────────────────────────────────────────────┘
          │
          ├──► flowdoc-discover   (deep investigation)
          ├──► flowdoc-prd       (PRD: creates and updates)
          ├──► flowdoc-rfc       (RFC: creates, updates, closes)
          ├──► flowdoc-adr       (ADR: creates, updates, deprecates)
          ├──► flowdoc-api       (API: documents only)
          ├──► flowdoc-db        (DB: documents schema only)
          ├──► flowdoc-hu        (HU + post-dev documentation)
          └──► flowdoc-review    (validation after specialists)
```

## 4. Specialist Responsibilities

| Specialist | Creates | Updates | Deletes | Scope |
|-----------|---------|---------|---------|-------|
| `flowdoc-prd` | ✅ | ✅ | ❌ | Both initial and existing |
| `flowdoc-rfc` | ✅ | ✅ | Closes | Both initial and existing |
| `flowdoc-adr` | ✅ | ✅ | Deprecates | Both initial and existing |
| `flowdoc-api` | ✅ | ✅ | ❌ | Documents from code only |
| `flowdoc-db` | ✅ | ✅ | ❌ | Documents from code only |
| `flowdoc-hu` | ✅ | ✅ | ❌ | Based on HU + changes made |
| `flowdoc-review` | ❌ | Suggests fixes | ❌ | Validates format and templates |

## 5. Session Register

Each session generates a register file:

```
docs/.flowdoc/sessions/
├── 2026-08-05_1430_register.json
├── 2026-08-05_1600_register.json
└── ...
```

**Location**: `docs/.flowdoc/` (must be in `.gitignore`)

**Register schema**:
```json
{
  "session": {
    "id": "2026-08-05_1430",
    "startedAt": "2026-08-05T14:30:00Z",
    "endedAt": "2026-08-05T15:45:00Z",
    "duration": "1h 15m",
    "trigger": "adopt-flowdocs | HU-001 | flowdoc-adr | manual"
  },
  "context": {
    "projectPath": "/path/to/project",
    "language": "es | en",
    "architecture": "monolith | microservices | monorepo | serverless",
    "scope": "adoption | new-hu | update-hu | maintenance"
  },
  "invokedSpecialists": [
    {
      "name": "flowdoc-discover",
      "status": "completed | failed | skipped",
      "contextGathered": {
        "stack": ["Node.js", "PostgreSQL"],
        "decisionsFound": ["auth", "database"],
        "existingDocs": ["docs/PRD.md"]
      },
      "duration": "2m"
    }
  ],
  "documents": {
    "created": [
      {
        "path": "docs/PRD.md",
        "specialist": "flowdoc-prd",
        "template": "docs/templates/PRD/PRD_template.md"
      }
    ],
    "updated": [
      {
        "path": "docs/tasks/HU-001-login.md",
        "specialist": "flowdoc-hu",
        "previousCommit": "abc123",
        "template": "docs/templates/user-stories/template-user-story.md",
        "scope": "after-dev",
        "reference": "docs/tasks/HU-001-login.md (original)"
      }
    ],
    "closed": [
      {
        "path": "docs/architecture/rfc/001-auth-strategy.md",
        "specialist": "flowdoc-rfc",
        "action": "accepted | rejected | obsolete",
        "resultingAdr": "docs/architecture/adr/003-auth-jwt.md"
      }
    ]
  },
  "pendingUpdates": [
    {
      "from": "flowdoc-api",
      "reason": "API change affects PRD section 3.2",
      "requiresUpdate": ["docs/PRD.md"],
      "status": "pending | resolved | dropped"
    }
  ],
  "issues": [
    {
      "type": "format | template | ortography | context | consistency",
      "specialist": "flowdoc-review",
      "document": "docs/PRD.md",
      "description": "Missing constraints section",
      "severity": "error | warning",
      "status": "open | fixed | ignored"
    }
  ],
  "adrImpactAnalysis": [
    {
      "hu": "docs/tasks/HU-001-login.md",
      "decisionsTaken": ["JWT auth", "refresh token rotation"],
      "adrsAffected": ["docs/architecture/adr/003-auth-jwt.md"],
      "newAdrRequired": true,
      "newAdrPath": "docs/architecture/adr/005-refresh-token-rotation.md"
    }
  ],
  "summary": {
    "specialistsRun": 4,
    "documentsCreated": 3,
    "documentsUpdated": 2,
    "documentsClosed": 1,
    "issuesFound": 1,
    "issuesFixed": 1,
    "parallelExecution": false
  }
}
```

## 6. Communication Protocol

### 6.1 Orchestrator → Specialist
- **Base context**: paths to search, what exists, template references
- **Prompt**: Minimum context needed to start
- **Register entry**: What documentation should be updated after

### 6.2 Specialist → Orchestrator
- **Result**: Document created/updated in `docs/`
- **Register update**: Notifies which docs were updated
- **Pending updates**: If detects another document needs change, reports to orchestrator

### 6.3 Specialist → Specialist
- **NO direct communication**
- **If needed**: invoke `flowdoc-discover` for investigation
- **If impact detected**: report to orchestrator

## 7. Parallel Execution Rules

### Sequential (default)
All specialists run sequentially to avoid conflicts.

### Parallel allowed
Only ADR specialist can parallelize when:
- All technical decisions are already identified by PRD/RFC
- ADRs don't depend on each other
- Orchestrator did checkpoint before launching

### Conflict resolution
- Orchestrator maintains register of which doc updated what
- If ADR contradicts RFC → checkpoint + manual review
- API specialist NEVER touches PRD

## 8. Invocation Modes

### Mode A: Full orchestration
```
User: "adopt flowdocs"
     → flowdoc-assist orchestrates all specialists
     → flowdoc-review validates
     → Register updated
```

### Mode B: Direct specialist
```
User: "creame un ADR para auth"
     → flowdoc-adr invoked directly
     → Can invoke flowdoc-discover if needed
     → Reports to orchestrator (if session exists)
```

### Mode C: Specialist + review
```
User: "creame un ADR para auth + review"
     → flowdoc-adr invoked
     → flowdoc-review validates
```

## 9. HU Documentation Lifecycle

```
┌──────────────────────────────────────────────────────────────┐
│  HU Original                                                 │
│  (e.g: HU-001-login.md)                                    │
└──────────────────────────────────────────────────────────────┘
          │
          ▼
┌──────────────────────────────────────────────────────────────┐
│  flowdoc-hu (pre-development)                               │
│  - Generates/updates documentation based on HU               │
│  - PRD, RFC, ADR created as needed                          │
└──────────────────────────────────────────────────────────────┘
          │
          ▼
┌──────────────────────────────────────────────────────────────┐
│  Development                                                 │
└──────────────────────────────────────────────────────────────┘
          │
          ▼
┌──────────────────────────────────────────────────────────────┐
│  flowdoc-hu (post-development)                              │
│  - Updates docs based on what was done                      │
│  - References original HU as source                          │
│  - If new technical decisions → ADR specialist               │
└──────────────────────────────────────────────────────────────┘
          │
          ▼
┌──────────────────────────────────────────────────────────────┐
│  flowdoc-review                                             │
│  - Validates all generated documents                        │
│  - Format, templates, ortography, context                    │
└──────────────────────────────────────────────────────────────┘
```

## 10. Review Validation Checklist

`flowdoc-review` validates:

- [ ] Format matches template from `docs/templates/`
- [ ] Required sections present
- [ ] Spelling and grammar
- [ ] Context understandable (agent can continue without more input)
- [ ] Cross-references valid
- [ ] Status valid (Draft/In Review/Accepted/Deprecated)
- [ ] Naming correct (NNN-name.md)
- [ ] ADR Index updated (if new ADR created)

## 11. Template References

Templates live in `docs/templates/` (source of truth). Specialists reference, don't duplicate:

| Document | Template |
|-----------|----------|
| PRD | `docs/templates/PRD/PRD_template.md` |
| RFC | `docs/templates/architecture/RFC_template.md` |
| ADR | `docs/templates/architecture/ADR_template.md` |
| HU | `docs/templates/user-stories/template-user-story.md` |
| API | `docs/templates/api/endpoints.md` |
| DB | `docs/templates/database/schema.md` |

## 12. Discovery Dependency

```
┌─────────────────────────────────────────────────────────────┐
│  Specialist needs more context                              │
│                                                             │
│  Can investigate alone?                                      │
│  ├── NO → Invokes flowdoc-discover                          │
│  └── YES → Continues with orchestrator base context         │
└─────────────────────────────────────────────────────────────┘
```

## 13. Design Principles

1. **Tool-agnostic**: FlowDoc is independent of any AI stack (SDD, engram, etc.)
2. **Persistence optional**: Documents live in `docs/`, register lives in `docs/.flowdoc/`
3. **Specialist independence**: Each skill is self-contained and invokeable directly
4. **No direct specialist communication**: All coordination through orchestrator
5. **Sequential by default**: Parallelism only when safe (ADR specialist case)
6. **Register for audit**: Every session documented, survives tool restarts

## 14. Open Questions

| # | Question | Decision |
|---|----------|----------|
| 1 | Rollback mechanism | Use `git` to see previous state |
| 2 | Register retention policy | Keep all (low volume) |
| 3 | Specialist can be invoked without orchestrator | Yes, with reduced context |

---

## 15. Approval Status

| Role | Person | Status | Date |
|------|--------|--------|------|
| Author | Kaito | Draft | 2026-08-05 |
| Decision | - | Pending | - |

---

## 16. Change History

| Date | Change | Author |
|------|--------|--------|
| 2026-08-05 | Initial version | Kaito |

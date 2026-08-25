---
name: flowdoc-review
description: >
  Validates FlowDoc documentation after specialists run. Checks format, template compliance,
  ortography, context understandability, cross-references, status, naming, and ADR index.
  Reports issues but does NOT modify documents. Invoked by flowdoc-assist orchestrator
  automatically after all specialists, or directly by the user.
  Trigger: "review docs", "validate docs", "revisar documentacion", "validar flowdoc",
  "audit flowdoc", "verificar documentos"
license: Apache-2.0
metadata:
  author: FlowDoc
  version: "1.0"
---

## When to Use

Use this skill when you need to validate FlowDoc documentation quality:

- **Orchestrator invoke (automatic)**: After all specialists have run, `flowdoc-assist` invokes this skill to validate generated/updated documents before reporting back to the user
- **Direct user invoke**: User wants to audit existing FlowDoc quality without going through full orchestration
- **Specialist + review mode**: User explicitly requests validation after a single specialist (e.g., "creame un ADR + review")

**This skill does NOT modify documents.** It only validates and reports issues. Fixes are the responsibility of the relevant specialist or the human.

---

## What This Skill Returns

```
validationResult:
├── documentsValidated (list of paths checked)
├── issues (list of issues found, each with severity and status)
├── summary
│   ├── totalDocuments
│   ├── totalIssues
│   ├── errors
│   └── warnings
└── sessionRegisterUpdated: true | false
```

---

## Template References

Templates live in `docs/templates/` (source of truth). This skill reads them to validate against — it never duplicates template content.

| Document | Template |
|----------|----------|
| PRD | `docs/templates/PRD/PRD_template.md` |
| RFC | `docs/templates/architecture/RFC_template.md` |
| ADR | `docs/templates/architecture/ADR_template.md` |
| HU | `docs/templates/user-stories/template-user-story.md` |
| API | `docs/templates/api/endpoints.md` |
| DB | `docs/templates/database/schema.md` |

If a template is missing, report it as an issue (type: `template`, severity: `error`) — do NOT fall back to hardcoded content.

---

## Validation Protocol

### Step 1: Load Documents to Validate

Receive the list of documents to validate from the orchestrator. This list comes from the session register's `documents` section (created, updated, and closed entries).

```
documentsToValidate:
├── created: [list of paths from register.documents.created]
├── updated: [list of paths from register.documents.updated]
└── closed: [list of paths from register.documents.closed]
```

If invoked directly by the user (no orchestrator session), ask which documents to validate or scan `docs/` for all FlowDoc documents.

**If no session register exists**: enumerate documents by scanning `docs/` directly. Report that validation ran without a session register (no `issues` section will be persisted).

### Step 2: Read Corresponding Template for Each Document

For each document to validate:

1. Detect document type (PRD, RFC, ADR, HU, API, DB) from its path
2. Read the corresponding template from `docs/templates/`
3. Extract the list of required sections from the template
4. Keep both the document and template in context for comparison

| Path pattern | Document type | Template |
|--------------|---------------|----------|
| `docs/PRD.md` | PRD | `docs/templates/PRD/PRD_template.md` |
| `docs/architecture/rfc/NNN-*.md` | RFC | `docs/templates/architecture/RFC_template.md` |
| `docs/architecture/adr/NNN-*.md` | ADR | `docs/templates/architecture/ADR_template.md` |
| `docs/tasks/HU-*.md` | HU | `docs/templates/user-stories/template-user-story.md` |
| `docs/api/endpoints.md` | API | `docs/templates/api/endpoints.md` |
| `docs/database/schema.md` | DB | `docs/templates/database/schema.md` |

**If the template does not exist**: report an issue `{type: "template", severity: "error", description: "Template missing: {templatePath}"}` and skip template-based checks for that document. Continue with the other checks.

### Step 3: Validate Against Checklist

For each document, run all applicable checks. Each check produces zero or more issues.

#### 3.1 Format matches template

- [ ] Section headings match the template's structure
- [ ] Required sections are present (see 3.2)
- [ ] No extraneous sections that don't belong to the document type
- [ ] Markdown is valid (headings, lists, tables, code fences balanced)

**Issue type**: `format`

#### 3.2 Required sections present

- [ ] Every section marked as required in the template exists in the document
- [ ] Required sections are not empty (placeholder text like "TODO" or "Pendiente" counts as missing content)

**Issue type**: `template`

#### 3.3 Spelling and grammar

- [ ] No obvious spelling errors in the document's language
- [ ] Grammar is coherent enough to convey meaning
- [ ] Terminology is consistent within the document (e.g., don't mix "auth" and "authentication" if the template uses one)

**Issue type**: `ortography`

**Note**: This is a best-effort semantic check, not a full spell-check pass. Flag obvious errors only — this is not a linter.

#### 3.4 Context understandable

- [ ] An AI agent reading this document could continue the work WITHOUT asking the human for more context
- [ ] Acronyms and project-specific terms are either defined or referenced where they first appear
- [ ] Decisions explain WHY, not just WHAT (critical for ADRs: the `Context` and `Decision` sections must contain reasoning, not just the outcome)
- [ ] No section leaves the reader guessing what was decided

**Issue type**: `context`

**This is the most important check.** A document that is well-formatted but lacks reasoning is useless to future developers and agents. Flag aggressively.

#### 3.5 Cross-references valid

- [ ] All internal links point to files that exist
- [ ] All relative paths in references resolve correctly from the document's location
- [ ] ADR-to-RFC and RFC-to-ADR references are bidirectional (if an ADR superseded an RFC, the RFC should reference the resulting ADR)
- [ ] No dangling references to documents that were never created

**Issue type**: `consistency`

#### 3.6 Status valid

Applies to ADRs and RFCs. Valid status values:

| Document | Valid statuses |
|----------|----------------|
| ADR | Draft, In Review, Accepted, Deprecated |
| RFC | Draft, In Review, Accepted, Rejected, Obsolete |

- [ ] Status field is present
- [ ] Status value is one of the allowed values
- [ ] Status is consistent with the document's lifecycle (e.g., an RFC with a resulting ADR should NOT still be `Draft`)

**Issue type**: `consistency`

#### 3.7 Naming correct

- [ ] ADRs and RFCs follow `NNN-descriptive-name.md` (three-digit zero-padded number, hyphenated name)
- [ ] Numbering has no gaps (e.g., if `001` and `003` exist, `002` must exist or be documented as deprecated/removed)
- [ ] HU files follow `HU-NNN-name.md`
- [ ] Filenames are lowercase, hyphenated, no spaces

**Issue type**: `format`

#### 3.8 ADR Index updated

Only applies when a new ADR was created in this session.

- [ ] `docs/architecture/adr/INDEX.md` exists
- [ ] The new ADR is listed in the index
- [ ] The index entry matches the ADR's title, status, and date
- [ ] If `INDEX.md` does not exist, report an issue `{type: "consistency", severity: "error", description: "ADR Index missing (docs/architecture/adr/INDEX.md required when ADRs exist)"}`

**Issue type**: `consistency`

### Step 4: Report Issues

After validating all documents, compile the issues list. DO NOT fix anything — just report.

```
## Validation Report

### Documents Validated
- docs/PRD.md
- docs/architecture/adr/003-auth-jwt.md
- docs/api/endpoints.md

### Issues Found

#### docs/architecture/adr/003-auth-jwt.md
| # | Type | Severity | Description |
|---|------|----------|-------------|
| 1 | template | error | Missing required section: "Consequences" |
| 2 | context | warning | Decision section states JWT but does not explain why over sessions |
| 3 | consistency | error | ADR Index (INDEX.md) does not list ADR-003 |

#### docs/api/endpoints.md
| # | Type | Severity | Description |
|---|------|----------|-------------|
| 4 | ortography | warning | "endpint" typo in section 2 |

### Summary
- Documents validated: 3
- Total issues: 4
- Errors: 2
- Warnings: 2
```

Each issue follows the register schema:

```json
{
  "type": "format | template | ortography | context | consistency",
  "specialist": "flowdoc-review",
  "document": "docs/architecture/adr/003-auth-jwt.md",
  "description": "Missing required section: Consequences",
  "severity": "error | warning",
  "status": "open"
}
```

**Severity guide**:

| Severity | When to use |
|----------|-------------|
| `error` | Document is unusable or contradicts FlowDoc rules (missing required section, invalid status, broken cross-reference, ADR not indexed) |
| `warning` | Document is usable but suboptimal (typo, thin context, naming style inconsistency) |

### Step 5: Update Issues in Session Register

Append the issues found to the session register's `issues` array.

**Register location**: `docs/.flowdoc/sessions/{timestamp}_register.json`

Where `{timestamp}` matches the current session's register file (identifiable by the `session.id` passed by the orchestrator, or by the most recent register file if invoked standalone).

```json
{
  "issues": [
    {
      "type": "template",
      "specialist": "flowdoc-review",
      "document": "docs/architecture/adr/003-auth-jwt.md",
      "description": "Missing required section: Consequences",
      "severity": "error",
      "status": "open"
    }
  ]
}
```

**Rules for register update**:

- Set `status: "open"` for all new issues (the orchestrator or specialist that fixes them will flip it to `fixed` or `ignored`)
- If a session register does not exist, create it with a minimal schema containing only the `session`, `issues`, and `summary` sections
- If the register already has issues from a previous review pass, append rather than overwrite
- Update the `summary.issuesFound` count to reflect the new total

**If `docs/.flowdoc/` does not exist**: create it (it MUST be in `.gitignore`). Add a note to the report that the register directory was created.

### Step 6: Report Results to Orchestrator

Return the validation result to the orchestrator (`flowdoc-assist`). The orchestrator decides the next action:

```
validationResult:
  status: completed | partial | failed
  documentsValidated: [list]
  issues:
    - {type, document, description, severity, status}
  summary:
    totalDocuments: N
    totalIssues: N
    errors: N
    warnings: N
  sessionRegisterUpdated: true | false
  recommendedAction: "fix-and-revalidate | accept-and-continue | escalate"
```

`recommendedAction` guide:

| Condition | Action |
|-----------|--------|
| Any `error` severity issue | `fix-and-revalidate` — the orchestrator should re-invoke the relevant specialist |
| Only `warning` issues | `accept-and-continue` — present warnings to user, let them decide |
| Validation could not complete (template missing, register unreadable) | `escalate` — surface to user |

---

## Rules

- **VALIDATES, does NOT modify** — this skill reports issues only. Fixing is the specialist's or human's job.
- **No fix suggestions in documents** — suggestions go in the issue `description`, never as edits to the document
- **Report against templates** — templates in `docs/templates/` are the source of truth. Never use hardcoded templates.
- **Severity discipline** — `error` is for things that break usability or FlowDoc rules. `warning` is for suboptimal quality. Don't inflate severity.
- **Stateless on documents** — this skill does not modify any document under `docs/`. The ONLY file it writes to is the session register.
- **Concurrency-safe** — can be invoked while other specialists are still running if the orchestrator chooses, but recommended after all specialists complete
- **No direct specialist communication** — if a deeper investigation is needed (e.g., to verify a cross-reference target), invoke `flowdoc-discover`. Never contact specialists directly.
- **Language follows the user** — reports are written in the language the orchestrator passed as context (or the user's language if direct invocation)

---

## Usage Examples

### As Orchestrator (automatic, after all specialists)
```
flowdoc-assist completes PRD + ADR + API specialists
     → invokes flowdoc-review with register session.id
     → flowdoc-review validates all created/updated documents
     → appends issues to register
     → returns recommendedAction to orchestrator
```

### Direct user invocation
```
User: "revisá la documentación"
     → flowdoc-review scans docs/ for FlowDoc documents
     → validates each against its template
     → reports issues (and creates/updates register if possible)
```

### Specialist + review mode
```
User: "creame un ADR para auth + review"
     → flowdoc-adr creates the ADR
     → flowdoc-review validates that single ADR
     → reports issues back
```

---

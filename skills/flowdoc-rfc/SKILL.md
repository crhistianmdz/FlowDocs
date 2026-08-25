---
name: flowdoc-rfc
description: >
  Creates, updates, and closes RFC (Request for Comments) documents in docs/architecture/rfc/.
  Handles both initial and existing RFCs. Can invoke flowdoc-discover for deeper investigation
  when orchestrator context is insufficient. Writes results to docs/ and reports back to the
  flowdoc-assist orchestrator (or returns results directly when invoked standalone).
  Trigger: "create rfc", "creame un rfc", "update rfc", "close rfc", "cerrar rfc",
  "propuesta tecnica", "request for comments"
license: Apache-2.0
metadata:
  author: FlowDoc
  version: "1.0"
---

## When to Use

Use this skill when a developer or orchestrator needs to:

- **Create a new RFC** for a technical decision under discussion (not yet finalized)
- **Update an existing RFC** with new context, alternatives, or feedback
- **Close an RFC** that was accepted (→ create ADR), rejected, or obsoleted
- **Convert a discussion into a structured proposal** before a decision is made

**This skill is NOT for:**
- Recording finalized decisions → use `flowdoc-adr` (RFC → ADR when approved)
- Investigating the codebase from scratch → use `flowdoc-discover`
- Documenting product requirements → use `flowdoc-prd`
- API or DB documentation → use `flowdoc-api` / `flowdoc-db`

---

## RFC Lifecycle

```
┌──────────────────────────────────────────────────────────┐
│  DRAFT                                                   │
│  Initial proposal. Author is still shaping the idea.     │
│  Not ready for team review.                              │
└──────────────────────────────────────────────────────────┘
              │
              ▼
┌──────────────────────────────────────────────────────────┐
│  IN REVIEW                                               │
│  Open for team feedback. Lifetime: max 2 weeks.          │
│  After 2 weeks → must resolve (accept / reject / extend) │
└──────────────────────────────────────────────────────────┘
              │
       ┌──────┴──────┬──────────┐
       ▼             ▼          ▼
┌────────────┐ ┌──────────┐ ┌────────────┐
│  ACCEPTED  │ │ REJECTED  │ │  OBSOLETE  │
│  → Create  │ │ → Close   │ │ → Close    │
│    ADR     │ │  (history)│ │  (history) │
└────────────┘ └──────────┘ └────────────┘
```

**Status options** (written in the RFC frontmatter `Status` field):

| Status | Meaning | Next action |
|--------|---------|-------------|
| Draft | Author is still shaping the proposal | Continue editing |
| In Review | Open for team feedback | Collect comments, decide within 2 weeks |
| Accepted | Decision made → RFC succeeded | Create ADR via `flowdoc-adr` |
| Obsolete | Superseded or no longer relevant | Close RFC, mark as history |

> The RFC `Status` field uses: `Draft | In Review | Accepted | Obsolete`.
> The Approval Status table (section 8) uses per-role: `Approved | Rejected | Pending | Reviewed`.

---

## What This Skill Returns

```
rfcResult:
├── action: created | updated | closed
├── path: docs/architecture/rfc/NNN-name.md
├── status: Draft | In Review | Accepted | Obsolete
├── resultingAdr (if closed as Accepted): docs/architecture/adr/NNN-name.md
├── pendingUpdates (other docs that may be affected)
└── needsReview: bool (suggests flowdoc-review)
```

---

## Protocol

### Step 1: Load Context from Orchestrator

The orchestrator (`flowdoc-assist`) provides base context. This skill does NOT search for it.

| Receive from orchestrator | Used for |
|---------------------------|---------|
| `projectPath` | Where to write the RFC |
| `language` | Respond in user's language (es/en) |
| `architecture` | Shape infrastructure section |
| `stack` | Pre-fill Technical Decision table |
| `decisionsFound` | Identify what the RFC is about |
| `existingDocs` | Check for conflicting RFCs/ADRs |
| `template` reference | `docs/templates/architecture/RFC_template.md` |

**If invoked directly (no orchestrator):**
- Detect language from the user's input
- Read `AGENTS.md` and `docs/` for existing FlowDoc structure
- Use minimal context and ask the user directly

### Step 2: Read Existing RFCs (if updating or closing)

Before creating a new RFC, check what already exists:

| Read | To find |
|------|---------|
| `docs/architecture/rfc/INDEX.md` (if exists) | The full list of RFCs |
| `docs/architecture/rfc/*.md` | Existing RFCs that may conflict or overlap |
| `docs/architecture/adr/INDEX.md` | Decisions already recorded as ADRs (an RFC for a decided topic is redundant) |

**If updating:** read the target RFC fully and preserve its existing content/history.

**If closing:** read the target RFC to determine if it was Accepted (→ trigger ADR), Rejected, or Obsolete.

### Step 3: Gather Info (Code + flowdoc-discover if needed)

Use orchestrator-provided context first. If insufficient:

```
┌─────────────────────────────────────────────────────────┐
│  Can I fill all RFC sections with current context?      │
│  ├── YES → Continue to Step 4                           │
│  └── NO  → Invoke flowdoc-discover for deeper analysis   │
└─────────────────────────────────────────────────────────┘
```

**When to invoke `flowdoc-discover`:**
- Infrastructure section needs real container/port info from `docker-compose.yml`
- Security section needs evidence of secrets/auth approach
- Technical Decision table needs stack confirmation from code
- Existing ADRs may conflict and need verification

**When NOT to invoke:**
- Orchestrator already provided stack and decisions
- User is drafting a forward-looking proposal (no existing code yet)
- The RFC is for a new project without a codebase

### Step 4: Create / Update / Close RFC

Follow the structure from `docs/templates/architecture/RFC_template.md` **exactly**. Do NOT invent new sections.

#### RFC File Naming

```
docs/architecture/rfc/NNN-descriptive-name.md
```

- `NNN`: zero-padded sequential number (find highest existing, +1)
- `descriptive-name`: kebab-case, reflects the technical decision

#### RFC Sections (from template)

| # | Section | Required | Purpose |
|---|---------|----------|---------|
| 1 | Summary | ✅ | Brief description of the technical decision and why it is needed |
| 2 | Context | ✅ | Problem, why decide now, alternatives considered |
| 3 | Technical Decision | ✅ | Table: Item \| Selection \| Justification |
| 4 | Infrastructure | ○ (if applicable) | Containers, Docker files, environments |
| 5 | Security Considerations | ○ (if applicable) | Sensitive env vars, ports, secrets management |
| 6 | Costs and Resources | ○ (if applicable) | Hardware, monthly cost, licenses |
| 7 | Risks | ✅ | Table: Risk \| Impact \| Mitigation |
| 8 | Approval Status | ✅ | Table: Role \| Person \| Status \| Date |
| 9 | Change History | ✅ | Table: Date \| Change \| Author |

Legend: ✅ = always required · ○ = required if the decision involves that domain (omit if N/A)

#### 4a. Create New RFC

1. Determine next RFC number (scan existing files)
2. Fill template sections from gathered context:
   - **Summary** → 1-3 sentences, what + why
   - **Context** → the problem, why now, alternatives (from user or discovery)
   - **Technical Decision** → table from orchestrator-provided stack + decisions
   - **Infrastructure** → from `docker-compose.yml`, Dockerfiles, env config (if applicable)
   - **Security** → ports, secrets, auth approach (if applicable)
   - **Costs and Resources** → from user or discovery (if applicable)
   - **Risks** → always include; Low/Medium/High impact + mitigation
   - **Approval Status** → set to `Draft` with author
   - **Change History** → "Initial version" entry
3. Set `Status: Draft` in frontmatter
4. Write to `docs/architecture/rfc/NNN-descriptive-name.md`
5. Ask user: "Is this ready for team review, or still a draft?"

#### 4b. Update Existing RFC

1. Read the target RFC fully
2. Apply changes preserving existing content (don't rewrite history)
3. **Add a new Change History row** — never overwrite existing rows
4. Update `Status` only if the user explicitly requests (Draft → In Review typically)
5. If new alternatives emerged → add to Context section
6. If decision evolved → update Technical Decision table
7. Write back to the same path

#### 4c. Close RFC

Closing is a status transition, not deletion. The RFC remains as history.

| Close reason | Action |
|--------------|--------|
| Accepted (decision made) | Set `Status: Accepted`. Report `resultingAdr` needed. Orchestrator invokes `flowdoc-adr`. |
| Rejected (decision not taken) | Set `Status: Obsolete`. Add Change History row explaining why. |
| Obsolete (superseded by another RFC/ADR) | Set `Status: Obsolete`. Reference the superseding document. |

**On Accepted close:**
- Do NOT create the ADR directly (that's `flowdoc-adr`'s job)
- Report to orchestrator: `resultingAdr: docs/architecture/adr/NNN-name.md` needed
- Include the RFC as the ADR's context reference

### Step 5: Report Results to Orchestrator

Return a structured result:

```
## RFC {action} ✓

**Path**: docs/architecture/rfc/NNN-name.md
**Status**: {Draft | In Review | Accepted | Obsolete}
**Action**: {created | updated | closed}

{If closed as Accepted:}
**Resulting ADR needed**: docs/architecture/adr/NNN-name.md
→ Orchestrator should invoke flowdoc-adr

{If pendingUpdates detected:}
**Pending updates**:
- {document} — {reason}

**Needs review**: {yes | no}
```

---

## Communication Protocol

### Orchestrator → This Skill
Receives: base context (paths, stack, decisions), template reference, register entry.

### This Skill → Orchestrator
Returns: RFC path, status, action taken, resulting ADR if closed-accepted, pending updates.

### This Skill → Other Specialists (§6.3)
- **NO direct communication** with other specialists
- If deeper investigation needed → invoke `flowdoc-discover` (the only allowed cross-specialist call)
- If impact on another document detected → report as `pendingUpdates` to orchestrator (do NOT modify other docs)

---

## Usage Examples

### Example A: Create new RFC (orchestrator invokes)

```
Orchestrator: "User wants to propose a caching strategy. Stack: Node.js + Express + PostgreSQL. 
               Create an RFC for the caching decision."

flowdoc-rfc:
  1. Loads context (stack, projectPath)
  2. Checks existing RFCs (no conflicts)
  3. Asks user: "Which caching options are you considering?" (Redis? Memcached? in-memory?)
  4. Fills template:
     - Summary: caching strategy for the Express API
     - Context: response times, DB load, alternatives (Redis, Memcached, node-cache)
     - Technical Decision table: Item=Cache | Selection=Redis | Justification=...
     - Infrastructure: Redis container port 6379
     - Risks: cache invalidation (Medium), extra infra cost (Low)
  5. Writes docs/architecture/rfc/006-caching-strategy.md with Status: Draft
  6. Reports back to orchestrator with path + needsReview: true
```

### Example B: Update existing RFC

```
User: "actualizá el RFC-001 con los resultados de la discusión de hoy"

flowdoc-rfc:
  1. Reads docs/architecture/rfc/001-name.md
  2. Preserves existing content
  3. Adds new context from discussion to Context section
  4. Updates Technical Decision table if new selections were made
  5. Adds Change History row: "2026-08-05 | Added team discussion outcomes | Kaito"
  6. Writes back to same path
  7. Reports: action=updated, status unchanged
```

### Example C: Close RFC as Accepted

```
User: "close RFC-001, the team approved it"

flowdoc-rfc:
  1. Reads docs/architecture/rfc/001-estructura-docs.md
  2. Sets Status: Accepted in frontmatter
  3. Updates Approval Status table (Tech Lead: Approved, date)
  4. Adds Change History row: "2026-08-05 | RFC Accepted | {author}"
  5. Does NOT create ADR (that's flowdoc-adr's job)
  6. Reports to orchestrator:
     - action: closed
     - resultingAdr: docs/architecture/adr/NNN-estructura-docs.md
     - "Orchestrator should invoke flowdoc-adr"
```

### Example D: Direct invocation (no orchestrator)

```
User: "creame un RFC para decidir entre REST y GraphQL"

flowdoc-rfc (standalone):
  1. Detects language: Spanish → responde en español
  2. Reads AGENTS.md, docs/ structure for context
  3. No orchestrator context → asks user directly for stack info
  4. If insufficient to fill Infrastructure → invokes flowdoc-discover
  5. Creates RFC with Status: Draft
  6. Returns result directly to user (no orchestrator to report to)
```

---

## Rules

- **Follow the template exactly** — `docs/templates/architecture/RFC_template.md` is the source of truth. Do NOT invent new sections.
- **No direct specialist communication** — all coordination flows through the orchestrator.
- **Invoke flowdoc-discover only when needed** — if orchestrator context is sufficient, don't add latency.
- **Never create the ADR** — on Accepted close, report `resultingAdr` and let the orchestrator invoke `flowdoc-adr`.
- **Preserve Change History** — never overwrite existing rows; always append.
- **Status transitions are deliberate** — only change `Status` when the user or orchestrator explicitly requests it.
- **RFC lifetime: max 2 weeks in review** — if an RFC has been "In Review" longer, surface this to the orchestrator.
- **Evidence-based** — fill Technical Decision and Infrastructure sections from code/config evidence, not assumptions.
- **No ADR redundancy** — before creating an RFC, check `docs/architecture/adr/` for an already-decided topic.
- **Respond in the user's language** — detected from input or provided by orchestrator.
- **Write only to `docs/architecture/rfc/`** — this skill never touches other docs; pending changes are reported, not applied.
- **Close ≠ delete** — closing sets a status; the RFC remains as historical record.


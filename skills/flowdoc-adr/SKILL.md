---
name: flowdoc-adr
description: >
  Creates, updates, and deprecates ADR (Architecture Decision Record) documents following the
  Michael Nygard format (Context -> Decision -> Consequences). Operates under the flowdoc-assist
  orchestrator or can be invoked directly. Can run in PARALLEL with other ADR specialists when
  decisions are independent. Invokes flowdoc-discover if deeper investigation is needed.
  Trigger: "creame un ADR", "create ADR", "document this decision", "deprecate ADR",
  "update ADR", "supersede ADR"
license: Apache-2.0
metadata:
  author: FlowDoc
  version: "1.1"
---

## When to Use

Use this skill when you need to record, update, or deprecate a technical decision as an ADR:

- **Orchestrator invoke**: flowdoc-assist delegates ADR creation after discovery/PRD phase
- **Direct user invoke**: "creame un ADR para auth", "document this decision as an ADR"
- **Specialist invoke**: flowdoc-hu or flowdoc-rfc needs to record a decision that was finalized

**This skill handles:**
- Creating new ADRs (from code evidence or user explanation)
- Updating existing ADRs (correcting context, adding missing info)
- Deprecating ADRs (marking as Deprecated or Superseded)
- Maintaining the ADR INDEX.md

**This skill does NOT:**
- Create RFCs (that's flowdoc-rfc)
- Document from code only (that's flowdoc-api / flowdoc-db)
- Validate other documents (that's flowdoc-review)

---

## ADR Format (Michael Nygard)

Every ADR follows the standard Michael Nygard structure — **Context -> Decision -> Consequences**.
The template lives at `docs/templates/architecture/ADR_template.md`. Reference it; do NOT duplicate.

```
# ADR-[NNN]: [Decision Title]

- Date: YYYY-MM-DD
- Related RFC: [link if exists]
- Related HU: [link to HU that originated this decision, e.g. HU-014]
- Status: Accepted | Deprecated | Superseded by ADR-NNN

## Context
[What problem? What alternatives existed? Max 3-5 lines.]

## Decision
[What was chosen and why. Max 3-5 lines. No repetition of context.]

## Consequences
- Positive: [what improves]
- Negative: [what is lost or complicated]
- Neutral: [what changes without being better or worse]
- Accepted technical debt: [if applicable]
```

> **Maintenance note**: Add a row to `docs/architecture/adr/INDEX.md` every time a new ADR
> is created. Keep entries ordered by ADR number. Update "Status" if an ADR is deprecated
> or superseded.

---

## ADR Status Options

| Status | Meaning | When to set |
|--------|---------|-------------|
| **Accepted** | Decision made and in effect | Default for newly created ADRs |
| **Deprecated** | No longer in effect (kept for history) | Decision was reversed or abandoned |
| **Superseded by ADR-NNN** | Replaced by a later ADR | A new ADR overrides this one |

> The lifecycle states `Draft` and `In Review` belong to RFCs, not ADRs.
> ADRs are permanent records created when the decision is finalized.

---

## Protocol (6 Steps)

### Step 1: Load Context from Orchestrator

Receive base context from flowdoc-assist (or direct user input):

```
contextFromOrchestrator:
├── projectPath        — where docs/ lives
├── language           — user's detected language (es | en)
├── stack             — technologies found by flowdoc-discover
├── existingAdrs      — list of ADR files already in docs/architecture/adr/
├── decisionsFound    — technical decisions identified during discovery
├── relatedRfc        — RFC that produced this decision (if any)
└── sessionRegister   — path to session register file (if orchestrator session)
```

If invoked directly without orchestrator:
- Detect language from user input (Spanish -> Spanish, English -> English)
- Read `AGENTS.md` to confirm FlowDoc is adopted
- Check `docs/architecture/adr/` for existing ADRs

### Step 2: Read Existing ADRs (if updating or deprecating)

Before writing anything, read the current state:

| Read | To find |
|------|---------|
| `docs/architecture/adr/INDEX.md` | All existing ADRs, their numbers and statuses |
| `docs/architecture/adr/NNN-*.md` | The specific ADR being updated or deprecated |
| `docs/architecture/rfc/` | Any RFC that relates to this decision |

**Determine the next ADR number:**
- Read INDEX.md
- Find the highest NNN used
- Next ADR = highest + 1
- NEVER reuse a deprecated/superseded number (gaps signal "something was here")

### Step 3: Gather Information

Gather the evidence needed to write a complete ADR:

```
Can I write the ADR with what I have?
├── YES (context from orchestrator + code evidence is enough)
│   └── Proceed to Step 4
└── NO (need deeper investigation about WHY the decision was made)
    └── Invoke flowdoc-discover for deeper analysis
        └── Receive enhanced context
        └── Proceed to Step 4
```

**Evidence sources:**

| Source | What it provides |
|--------|-----------------|
| Code files (`docker-compose.yml`, `auth/*`, `schemas/*`) | What was chosen (the fact) |
| Orchestrator context | What decisions were identified |
| flowdoc-discover | Deeper reasoning if "why" is unclear |
| User explanation | The human story behind the decision |
| Related RFC | The discussion that preceded the decision |

**Edge case — user doesn't remember the "why":**
```
No problem. I'll create the ADR with what I found in code.
You can fill in the 'why' later when you remember or ask a teammate.
The structure is there — you just need the story.
```

### Step 4: Create / Update / Deprecate the ADR

#### 4a: Create new ADR

1. Determine the ADR number (Step 2)
2. Determine filename: `NNN-descriptive-name.md` (kebab-case)
3. **Ask for related HU**: "Which HU originated this decision?" (e.g. "HU-014")
   - If orchestrator provided `baseContext.taskReference`, use that HU
   - If no HU applies, mark as "N/A" but still ask explicitly
4. Write the file at `docs/architecture/adr/NNN-descriptive-name.md`
5. Follow the ADR_template.md format exactly:

```
# ADR-{NNN}: {Title}

- Date: {YYYY-MM-DD}
- Related RFC: {link or "—"}
- Related HU: {link to HU that originated this decision, e.g. "HU-014" or "N/A"}
- Status: Accepted

## Context
{Problem + alternatives. Max 3-5 lines.}

## Decision
{What was chosen + why. Max 3-5 lines.}

## Consequences
- Positive: {...}
- Negative: {...}
- Neutral: {...}
- Accepted technical debt: {...}
```

5. Explain WHY while generating:
```
## Creating ADR-{NNN}: {Title}

Why this ADR: {reason}. This is a PERMANENT decision —
once made, it stays documented. Future developers will know WHY,
not just THAT you chose it.

Evidence found:
- {file}: {evidence}
```

#### 4b: Update existing ADR

1. Read current ADR content
2. Identify what to change (context addition, decision correction, consequences update)
3. Show the user the proposed change before applying
4. Apply changes preserving the original structure
5. Do NOT change the ADR number
6. Do NOT change the status unless explicitly deprecating/superseding

> Updating an ADR's CONTENT is different from changing its STATUS. Content updates
> clarify or add missing information. Status changes go through Step 4c.

#### 4c: Deprecate or supersede an ADR

**Deprecate** (decision reversed or abandoned):
1. Read the existing ADR
2. Change `Status: Accepted` -> `Status: Deprecated`
3. Keep all original content intact (it's a historical record)
4. Update INDEX.md status column

**Supersede** (replaced by a new ADR):
1. Create the new ADR (Step 4a) with the new decision
2. Read the old ADR
3. Change `Status: Accepted` -> `Status: Superseded by ADR-NNN` (point to the new one)
4. Add a reference at the top of the new ADR pointing back:
   ```
   > This ADR supersedes ADR-{old-NNN}.
   ```
5. Update INDEX.md status for both ADRs

### Step 5: Update ADR INDEX.md

After creating a new ADR, update `docs/architecture/adr/INDEX.md`:

1. **All ADRs table** — add a new row:
   ```
   | ADR-{NNN} | {Title} | Accepted | {YYYY-MM-DD} |
   ```

2. **By Status section** — add to "Accepted":
   ```
   - [ADR-{NNN} — {Title}](./{NNN}-descriptive-name.md)
   ```

3. If deprecating/superseding:
   - Move the row from "Accepted" to "Deprecated"
   - Update the status column in the "All ADRs" table
   - For superseded: add the superseding reference

**Rules:**
- Keep entries ordered by ADR number
- NEVER reuse numbers from deprecated ADRs
- Gaps in numbering are intentional and preserved

### Step 6: Report Results to Orchestrator

Return a structured result to flowdoc-assist (or the user if direct invocation):

```
## ADR Specialist Complete

### Actions taken:
- Created: docs/architecture/adr/{NNN}-{name}.md
- Updated: docs/architecture/adr/INDEX.md (+1 entry)
- Status: Accepted

### Decision recorded:
{Title} — {one-line summary}

### Context used:
- Evidence: {files analyzed}
- Related RFC: {link or "none"}
- flowdoc-discover invoked: {yes | no}

### Pending updates detected:
[If the ADR affects other documents, report here]
- {document} needs update: {reason}
[Or: No pending updates detected]

### Register update:
- Documents created: 1
- Documents updated: 1
- Specialist: flowdoc-adr
```

If direct invocation (no orchestrator): display the report to the user.

---

## Parallel Execution

**The ADR specialist is the ONLY specialist that can parallelize execution.**

This is allowed because technical decisions are independent — choosing PostgreSQL
does not depend on choosing JWT auth, so both ADRs can be written simultaneously.

### When parallel is allowed

All three conditions must be met:

1. **All technical decisions are already identified** by PRD or RFC phase
2. **ADRs don't depend on each other** — one doesn't supersede or modify another
3. **Orchestrator did a checkpoint** before launching parallel specialists

### How parallel execution works

```
                    Orchestrator checkpoint
                           │
            ┌──────────────┼──────────────┐
            ▼              ▼              ▼
      ADR-001         ADR-002         ADR-003
    (PostgreSQL)    (JWT Auth)      (REST API)
            │              │              │
            └──────────────┴──────────────┘
                           │
                    Orchestrator merges results
                    Updates INDEX.md once
                    Reports to session register
```

### Conflict resolution

| Situation | Resolution |
|-----------|-----------|
| Two parallel ADRs write to INDEX.md | Orchestrator merges — only one write per file |
| ADR contradicts an existing RFC | Checkpoint + manual review (do not auto-resolve) |
| ADR depends on another ADR's decision | Re-run sequentially, not parallel |

### When parallel is NOT allowed

- Decisions are interdependent (one choice affects another)
- Orchestrator hasn't done a checkpoint
- A specialist needs deeper investigation first (invoke flowdoc-discover, then reassess)

---

## Decision Gates

| Situación | Acción | Tipo |
|-----------|--------|------|
| ADR ya existe para misma decisión | Update o deprecated check | warning |
| `INDEX.md` no existe | Crearlo | info |
| ADR# ya usado | Buscar siguiente número libre | info |

---

## Output Contract

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `status` | `completed \| partial \| failed` | Estado de la ejecución |
| `documents.created` | `string[]` | Paths de ADRs creados |
| `documents.updated` | `string[]` | Paths de ADRs modificados |
| `decisionsRecorded` | `string[]` | Decisiones grabadas como ADRs |
| `document.relatedHu` | `string \| null` | HU que originó esta decisión (e.g. "HU-014") |
| `pendingUpdates` | `object[]` | Docs que necesitan atención de otro specialist |
| `registerUpdate` | `object` | Entrada para el session register |

| `status` values | Significado |
|-----------------|-------------|
| `completed` | ADR(s) creado(s) exitosamente, INDEX.md actualizado |
| `partial` | 部分 ADRs creados, requiere atención adicional |
| `failed` | No se pudo crear el ADR |

---

## Rules

- **No ADR = no decision** — undocumented decisions don't exist
- **Immutable records** — ADRs are permanent; you don't delete them, you deprecate/supersede
- **Reference the template** — use `docs/templates/architecture/ADR_template.md`, do NOT duplicate format logic
- **Evidence-based** — if no code evidence and no user explanation, use placeholders and mark them
- **NUMBER recycling is FORBIDDEN** — deprecated ADRs keep their number forever
- **ALWAYS update INDEX.md** — an ADR without an index entry is invisible
- **No direct specialist communication** — coordinate through the orchestrator; if you need investigation, invoke flowdoc-discover
- **Show WHY, not just WHAT** — the value of an ADR is the reasoning, not the conclusion
- **Match user language** — respond in Spanish or English based on user input
- **Status changes are explicit** — never silently change an ADR's status without user confirmation
- **Always link to originating HU** — every ADR must reference the HU that required this decision

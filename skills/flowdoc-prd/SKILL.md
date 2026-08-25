---
name: flowdoc-prd
description: >
  Creates and updates Product Requirements Documents (PRD) following the FlowDoc PRD template.
  Handles both initial creation and updates to existing PRDs.
  Can invoke flowdoc-discover for deeper project investigation when needed.
  Writes results to docs/PRD.md.
  Reports created/updated documents back to the orchestrator (flowdoc-assist).
  Trigger: "crear PRD", "actualizar PRD", "generate PRD", "update PRD", "product requirements"
license: Apache-2.0
metadata:
  author: FlowDoc
  version: "1.0"
---

## When to Use

Use this skill when a Product Requirements Document needs to be created or updated:

- **Orchestrator invoke** — flowdoc-assist delegates PRD creation/update after discovery
- **Direct user invoke** — user wants a PRD generated or refreshed without full orchestration
- **Specialist invoke** — another specialist detects outdated PRD and reports to orchestrator, which re-invokes this skill

**This skill creates and updates PRDs only.** It does not create RFCs, ADRs, API docs, or DB docs.

---

## Inputs

When invoked, this skill expects:

| Input | Source | Required | Description |
|-------|--------|----------|-------------|
| `projectPath` | Orchestrator / caller | Yes | Absolute path to the project root |
| `language` | Orchestrator / user input | No (defaults to English) | Language for the PRD content |
| `existingDocs` | Orchestrator / flowdoc-discover | No | What FlowDoc structure already exists |
| `templateReference` | Orchestrator / convention | No | Path to PRD template (defaults to `docs/templates/PRD/PRD_template.md`) |
| `contextSummary` | Orchestrator / flowdoc-discover | No | Stack, architecture, decisions found |
| `mode` | Orchestrator / user input | No | `create` or `update` (auto-detected if omitted) |

**If invoked directly by the user without orchestrator context**, the skill performs its own
minimal discovery (reads `README.md`, `AGENTS.md`, `package.json` or equivalent) before proceeding.

---

## PRD Template Sections

The PRD follows `docs/templates/PRD/PRD_template.md`. The sections, in order:

| # | Section | Required | Notes |
|---|---------|----------|-------|
| 1 | System Overview | Yes | Project, platform, review date, description |
| 2 | Specific Functional Requirements | Yes | Use cases + exemplary user flow |
| 3 | Testing and Validation | Yes | Test types, tools, metrics |
| 4 | Edge Cases and Fault Tolerance | Yes | Scenarios + recovery mechanisms |
| 5 | Model and Tool Details | No | AI/ML projects only — omit if N/A |
| 6 | Roadmap and Future Objectives | Yes | Project phases (MVP → future) |
| 7 | Non-Functional Requirements | Yes | Scalability, usability, performance, security |
| 8 | Quality Validation | No | AI/ML projects only — omit if N/A |
| 9 | Dependencies and Technical Risks | Yes | External dependencies + associated risks |
| 10 | Terms Glossary | Yes | Key terms and definitions |
| 11 | Success Indicators | Yes | Metrics and expected results |
| 12 | Competitive Analysis | Yes | Similar tools + differentiation |
| 13 | Cost Estimation | No | Hardware, dev time, testing costs |

> **Optional sections** (5, 8, 13) are included only when relevant to the project. If the project
> is not AI/ML, omit sections 5 and 8 entirely. Cost estimation is included only if the user
> requests it or it is meaningful for planning.

---

## Protocol

### Step 1: Load Context from Orchestrator

Accept the base context provided by the orchestrator:

- `projectPath` — where the project lives
- `existingDocs` — what documentation already exists (especially `docs/PRD.md`)
- `templateReference` — the PRD template path (fallback: `docs/templates/PRD/PRD_template.md`)
- `contextSummary` — stack, architecture, decisions found (from flowdoc-discover)

If context is insufficient to write a meaningful PRD, proceed to Step 3 to gather more info.

### Step 2: Read Existing PRD (if exists)

Check whether `docs/PRD.md` already exists at `projectPath`:

| Situation | Action |
|-----------|--------|
| `docs/PRD.md` exists and is non-empty | **Update mode** — read current content, identify gaps vs template, preserve existing valid content |
| `docs/PRD.md` exists but is empty/stub | **Create mode** — treat as new PRD |
| `docs/PRD.md` does not exist | **Create mode** — generate from template + gathered info |

**Update rules**:
- Preserve user-written content that is still valid
- Fill missing sections from the template
- Update outdated information (technology stacks, dates, roadmap) only if evidence supports the change
- Never delete content silently — flag changes in the report (Step 5)

### Step 3: Gather Information

With the context available, gather what is needed to fill all **required** PRD sections:

| Source | What to look for |
|--------|------------------|
| `README.md` | Project description, purpose, platform |
| `AGENTS.md` | Project overview, stack, structure |
| `package.json` / `go.mod` / `Cargo.toml` / `*.csproj` | Dependencies, platform |
| `docs/` existing structure | Architecture decisions, API contracts, DB schema |
| `docs/architecture/adr/` | Technical decisions to reference in Dependencies/Risks |
| `docs/api/` | Functional requirements context |
| Code structure | Use cases, user flows, edge cases |

**If the gathered context is insufficient** to fill required sections meaningfully:

1. Invoke `flowdoc-discover` for deeper investigation
2. Receive enhanced `contextSummary`
3. Continue with Step 4

> Only invoke flowdoc-discover when truly needed. If the orchestrator already passed a complete
> context summary from a prior discovery, skip to Step 4 directly.

### Step 4: Create or Update PRD

Write the PRD to `docs/PRD.md` following the template structure exactly:

1. **System Overview** — project name, target platform, review date (current month/year), concise description
2. **Specific Functional Requirements**
   - List main use cases based on what the system does
   - Describe an exemplary user flow step-by-step from a typical user perspective
3. **Testing and Validation**
   - Unit, integration, performance, recovery test types
   - Recommended tools and metrics (coverage targets, response times)
4. **Edge Cases and Fault Tolerance**
   - Scenarios to consider (failure modes, boundary conditions)
   - Recovery and persistence mechanisms
5. **Model and Tool Details** `[OPTIONAL]` — include only if AI/ML project
6. **Roadmap and Future Objectives** — MVP phase + future phases with objectives and timeline
7. **Non-Functional Requirements** — scalability, usability, performance, security
8. **Quality Validation** `[OPTIONAL]` — include only if AI/ML project
9. **Dependencies and Technical Risks** — external dependencies with associated risks
10. **Terms Glossary** — key terms used in the document with brief definitions
11. **Success Indicators** — key metrics and expected results
12. **Competitive Analysis** — similar tools and what differentiates this project
13. **Cost Estimation** `[OPTIONAL]` — include only if requested or planning-relevant

**Formatting rules**:
- Follow the template structure exactly — same headings, same order
- Keep the `---` separators between sections as in the template
- Mark optional sections clearly if included; omit entirely if not applicable
- Use the project's detected language for all content
- Replace `[placeholder]` text with real values based on gathered info — never leave placeholders

### Step 5: Report Results to Orchestrator

Return a structured report:

```
## PRD Specialist Report

### Mode: {create | update}
### Document: docs/PRD.md
### Template: docs/templates/PRD/PRD_template.md

### Sections Written
| # | Section | Status |
|---|---------|--------|
| 1 | System Overview | Written / Preserved / Updated |
| 2 | Specific Functional Requirements | Written / Preserved / Updated |
| ... | ... | ... |
| 5 | Model and Tool Details | Skipped (non-AI project) |
| ... | ... | ... |

### Changes Made (update mode only)
- Updated: System Overview review date → {new date}
- Updated: Stack list to reflect current dependencies
- Preserved: Functional requirements (still valid)
- Added: Terms Glossary was missing, now populated

### Pending Updates Detected
- {e.g., docs/api/endpoints.md references a feature not in PRD → requires PRD update}
- {e.g., New ADR created since last PRD update → Dependencies section may need update}
- (none if no pending updates)

### Recommendations
- {e.g., flowdoc-adr should be invoked — N decisions found without ADRs}
- {e.g., flowdoc-api should be invoked — API endpoints detected, no docs}
```

**Report rules**:
- Always report which sections were written vs preserved vs updated
- Flag any pending updates detected for other documents
- Recommend which other specialists should be invoked
- Include the document path so the orchestrator can update the session register

---

## Usage Examples

### As Orchestrator (automatic)
```
User: "adopt flowdocs"
     → flowdoc-assist invokes flowdoc-discover
     → flowdoc-discover returns contextGathered
     → flowdoc-assist invokes flowdoc-prd with context summary
     → flowdoc-prd creates docs/PRD.md
     → Returns report to orchestrator
     → Orchestrator updates session register
```

### Direct Invocation
```
User: "creame el PRD de este proyecto"
     → flowdoc-prd runs minimal discovery
     → Creates docs/PRD.md from template + gathered info
     → Returns report to user
```

### Update Existing PRD
```
User: "actualizame el PRD"
     → flowdoc-prd reads existing docs/PRD.md
     → Identifies gaps vs template
     → Updates outdated sections, preserves valid content
     → Returns report of changes made
```

### With Discovery (insufficient context)
```
Orchestrator context lacks stack info
     → flowdoc-prd invokes flowdoc-discover
     → Receives enhanced context
     → Continues with PRD creation/update
```

---

## Rules

- **Follow the template** — sections, order, and separators must match `PRD_template.md`
- **Evidence over guessing** — base content on real project evidence, never fabricate requirements
- **No placeholders in output** — replace every `[placeholder]` with real values; if truly unknown, omit
- **Preserve user content** — in update mode, never silently delete valid existing content
- **Optional sections are optional** — omit sections 5, 8, 13 when not applicable; do not leave empty
- **Report everything** — the orchestrator needs the full report to update the session register
- **No cross-specialist work** — this skill writes only `docs/PRD.md`, never ADRs/RFCs/API/DB docs
- **Pending updates are reported, not executed** — if another doc needs change, report it
- **Language-aware** — match the user's or orchestrator's detected language for all content
- **No direct specialist-to-specialist communication** — report to orchestrator, let it coordinate


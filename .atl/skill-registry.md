# Skill Registry

**Delegator use only.** Any agent that launches sub-agents reads this registry to resolve compact rules, then injects them directly into sub-agent prompts. Sub-agents do NOT read this registry or individual SKILL.md files.

See `_shared/skill-resolver.md` for the full resolution protocol.

## User Skills

| Trigger | Skill | Path |
|---------|-------|------|
| adopt flowdocs, iniciar flowdocs, setup documentation, implementar flowdocs, adopcion de flowdocs, help me document this project, creame un ADR, creame un RFC, documentá esta API, revisá la documentación | flowdoc-assist | skills/flowdoc-assist/SKILL.md |
| discover, investigate, analyze project, qué tecnologías usa este proyecto | flowdoc-discover | skills/flowdoc-discover/SKILL.md |
| crear PRD, actualizar PRD, generate PRD, update PRD, product requirements | flowdoc-prd | skills/flowdoc-prd/SKILL.md |
| create rfc, creame un rfc, update rfc, close rfc, cerrar rfc, propuesta tecnica, request for comments | flowdoc-rfc | skills/flowdoc-rfc/SKILL.md |
| creame un ADR, create ADR, document this decision, deprecate ADR, update ADR, supersede ADR | flowdoc-adr | skills/flowdoc-adr/SKILL.md |
| document api, documentar api, documentar endpoints, scan api routes, update api docs | flowdoc-api | skills/flowdoc-api/SKILL.md |
| document database, documentar base de datos, schema docs, db schema, documentar schema | flowdoc-db | skills/flowdoc-db/SKILL.md |
| create hu, user story, update hu, post-dev hu, documentar hu, historia de usuario | flowdoc-hu | skills/flowdoc-hu/SKILL.md |
| review docs, validate docs, revisar documentacion, validar flowdoc, audit flowdoc, verificar documentos | flowdoc-review | skills/flowdoc-review/SKILL.md |

## Compact Rules

Pre-digested rules per skill. Delegators copy matching blocks into sub-agent prompts as `## Project Standards (auto-resolved)`.

### flowdoc-assist
- Orchestrator only — never writes documentation directly, always delegates to specialists
- Detect user intent first — full adoption (Mode A), direct specialist (Mode B), or specialist+review (Mode C)
- Always invoke flowdoc-discover before proposing specialists in full adoption mode
- No parallel execution without explicit checkpoint — only ADRs can run parallel and only when independent
- Maintain session register at docs/.flowdoc/sessions/{timestamp}_register.json
- Report pending updates from specialists to user for approval before invoking affected specialists
- Language-aware — respond in user's language (Spanish voseo or English)
- Never modify AGENTS.md without explicit user approval

### flowdoc-discover
- READ FIRST — do passive analysis before asking questions
- Evidence-based only — report what you found, never assume
- Never creates documentation — investigates and returns context only
- Stateless — returns results to caller, does not persist
- Concurrency-safe — can be invoked by multiple agents
- Scans: AGENTS.md, README.md, docs/, package.json, docker-compose.yml, auth/*, routes/*, prisma/*, store/*, scripts/

### flowdoc-prd
- Follow template exactly — sections, order, separators must match PRD_template.md
- Evidence over guessing — base content on real project evidence
- No placeholders in output — replace all [placeholder] with real values or omit
- Preserve user content — never silently delete valid existing content in update mode
- Optional sections are optional — omit sections 5, 8, 13 when not applicable
- Report everything — orchestrator needs full report for session register
- Write only to docs/PRD.md — never touch ADRs/RFCs/API/DB docs
- Language-aware — match user's or orchestrator's detected language

### flowdoc-rfc
- Follow template exactly — RFC_template.md is source of truth
- No direct specialist communication — all coordination through orchestrator
- Never create ADR on Accepted close — report resultingAdr and let orchestrator invoke flowdoc-adr
- Preserve Change History — never overwrite, always append
- Max 2 weeks in review — surface stale RFCs to orchestrator
- Evidence-based — fill Technical Decision and Infrastructure from code/config
- Write only to docs/architecture/rfc/ — never touch other docs
- Close ≠ delete — closing sets status, RFC remains as historical record

### flowdoc-adr
- No ADR = no decision — undocumented decisions don't exist
- Immutable records — never delete, deprecate or supersede instead
- Reference template — use ADR_template.md, do not duplicate format
- NUMBER recycling forbidden — deprecated ADRs keep their number forever
- ALWAYS update INDEX.md — ADR without index entry is invisible
- No direct specialist communication — invoke flowdoc-discover if needed
- Show WHY not just WHAT — reasoning is the value
- Immutable records — ADRs are permanent; deprecate/supersede, never delete
- Status changes are explicit — never silently change status without confirmation

### flowdoc-api
- DOCUMENT ONLY — record what code does, never suggest how APIs should be
- NEVER touch PRD — report pendingUpdates to orchestrator only
- Template first — always follow endpoints.md template format
- Normalize path params — :id and {id} both become {id} in documentation
- Realistic examples — UUIDs for IDs, ISO timestamps for dates
- Preserve existing docs — never silently delete documented endpoints
- Write to docs/api/endpoints.md — never touch other files

### flowdoc-db
- Document only from code — never invent tables, columns, or relationships
- NO design opinions — this is a reporter, not an advisor
- Descriptions from evidence only — use column name or schema comment, otherwise "—"
- Type canonicalization allowed — mapping ORM types to SQL types is NOT a design opinion
- Never modify schema files — only reads code, only writes to docs/database/schema.md
- If uncertain, ask — report as issue rather than guess silently
- Handle language directly — write section headers in user's language

### flowdoc-hu
- Stay in lane — write HU documents only, never ADRs/PRDs/RFCs
- One file only — modify only the HU at huPath, never touch other docs
- Template is source of truth — use template-user-story.md structure
- Pre-dev writes needs, post-dev writes reality
- Never investigate alone — request flowdoc-discover through orchestrator
- No direct specialist communication — all through orchestrator
- Language matches user — write HU body in user's language
- Never delete quietly — moved/dropped tasks go to Notes with reason
- Original HU is source — post-dev updates reference original as baseline

### flowdoc-review
- Validates only — does NOT modify documents
- Report against templates — docs/templates/ is source of truth
- Severity discipline — error is for unusable/broken, warning is for suboptimal
- Stateless on documents — only writes to session register, never to docs/
- No direct specialist communication — invoke flowdoc-discover if needed
- Language follows user — reports in orchestrator's or user's language

## Project Conventions

| File | Path | Notes |
|------|------|-------|
| AGENTS.md | AGENTS.md | FlowDoc framework entry point for AI agents |
| README.md | README.md | Framework guide |
| docs/templates | docs/templates/ | Canonical templates for all document types |

Read the convention files listed above for project-specific patterns and rules. All referenced paths have been extracted — no need to read index files to discover more.

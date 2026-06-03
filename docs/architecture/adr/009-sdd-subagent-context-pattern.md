# ADR-009: SDD Sub-agent Context Pattern

**Date**: 2026-06-03
**Author**: @author
**Related RFC**: None (initial decision)
**Status**: Accepted

---

## Context

Sub-agents launched via the SDD flow (`sdd-explore`, `sdd-propose`, `sdd-spec`, `sdd-design`, `sdd-tasks`, `sdd-apply`, `sdd-verify`, `sdd-archive`) start with **no context** about the project they are working on. They don't know the stack, the conventions, the active change, or the prior decisions.

The `@` syntax in file paths does **not** auto-load content into agent context — it is a navigation mechanism, not a context injection mechanism. This was empirically discovered in session `SESSION-FLOWDOC-ADOPTION-2026-06-01`.

Without context, sub-agents produce **generic** specs that don't match the project's conventions, naming, structure, or prior decisions. The orchestrator ends up rewriting the artifacts, defeating the purpose of delegation.

We need a pattern that:

1. **Gives context** to sub-agents in a structured, predictable way
2. Is **portable** beyond any specific tool (OpenCode, ClaudeCode, Antigravity, etc.)
3. **Optimizes token usage** (sub-agents are paid per-token)
4. Allows **knowledge propagation** between related HUs (decisions made in HU-A inform HU-B)

### Alternatives Considered

| Alternative | Description | Verdict |
|-------------|-------------|---------|
| **AGENTS.md only** | Put all context in `AGENTS.md` and let sub-agents read it | Rejected — too large, not phase-specific, static, bloats every agent context |
| **Inline in prompts** | Pass everything inline in the sub-agent prompt each time | Rejected — high token cost on every call, no persistence, no reusability |
| **Dynamic generated context** | Generate a per-change `sdd-context.md` file at `/sdd-new` | **Selected** — balances size, freshness, portability, and reusability |
| **Tool-specific config** | Use the tool's native context mechanism (e.g., OpenCode agents config) | Rejected — not portable across tools, locks the framework to one ecosystem |

---

## Decision

The selected pattern: **SDD Sub-agent Context Pattern**

### 1. File Generation

- Generated **once** at `/sdd-new` (when a new change / HU starts)
- File lives at: `openspec/changes/{change-name}/sdd-context.md`
- **Hard constraint**: 20-50 lines maximum
- Generated from **3 sources**:
  1. **AGENTS.md** (selective extraction of sections: Stack, Key Paths, Conventions)
  2. **Active Change state** (orchestrator-provided: name, phase, completed artifacts)
  3. **Engram pointers** (top 3-5 relevant topic keys via `mem_search`)
- **No** skill-registry dependency (must work without OpenCode infrastructure)
- **No** repo scan (AGENTS.md already declares core paths)
- Estimated generation cost: ~1200 tokens; typical cycle cost: ~4-5K tokens

### 2. File Structure

```markdown
# SDD Context — {change-name}

## Project Snapshot
[Extracted from AGENTS.md — name, type, stack, languages]

## Key Paths
[Extracted from AGENTS.md — paths to docs/, architecture/, tasks/, etc. with source note]

## Conventions
[Extracted from AGENTS.md — bilingual, conventional commits, etc.]

## Active Change
- Name: {change-name}
- Phase: {current_phase}
- Artifacts: [list of Engram topic keys for completed phases]
- Last updated: {ISO 8601 timestamp}

## Engram Pointers
[Top 3-5 topic keys from mem_search, formatted as references]

## Update Permissions
[Which agents can update — sdd-explore, sdd-design, sdd-apply — hardcoded in orchestrator logic]

## Discovery Schema
[Format for discoveries returned by authorized agents]
<!-- Format: ### [timestamp] [agent] [category] -->
<!-- Content goes here -->
```

### 3. How Sub-agents Receive Context

- **Option C**: Full content + path injected into sub-agent's prompt by the orchestrator
- Sub-agent does **not** write directly to the file
- Sub-agent returns discoveries in response via a structured block:

```markdown
=== DISCOVERIES ===
### Discovery 1
- timestamp: <ISO 8601>
- agent: <sdd-explore|sdd-design|sdd-apply>
- category: <adr-applicable|convention|pattern|workaround|reference>
- summary: <max 200 chars>
- details_ref: <inline|engram:topic_key>
- details: <optional short text>
=== END DISCOVERIES ===
```

- **Format**: Markdown (consistent with the framework; YAML/JSON rejected for being less human-friendly)
- **Error handling**: If the discovery block is malformed, the orchestrator logs a warning and continues (log+continue, never block)

### 4. Orchestrator Persistence Logic

- Orchestrator parses the `DISCOVERIES` block from the sub-agent response
- For each discovery, applies the **45-line switch rule**:
  - If adding inline fits within the 20-50 line cap → add to `sdd-context.md`
  - If it exceeds the cap → save to Engram as a topic key, add a pointer to `sdd-context.md`
- Orchestrator decides location (inline vs Engram) — **not** the sub-agent

### 5. R2: Knowledge Propagation Between HUs

When a new HU references an archived HU (via `Related HU: HU-XXX` in the HU file), the orchestrator:

1. Looks up the archived `sdd-context.md` of the referenced HU
2. Inherits relevant discoveries into the new HU's `sdd-context.md`
3. Sub-agents of the new HU inherit knowledge **without rediscovering** it

This creates **knowledge propagation between related HUs** — the "jewel" of the pattern.

### 6. Lifecycle: Archive vs Delete

- **Option B (conserve with change)**: File persists with the change in `openspec/changes/{change-name}/`
- Archived file can be looked up if a new HU references the archived one
- **No time limit** — at the team's discretion
- **Git commit** of archived file — at the team's discretion
- **Engram upload** of archived context — **only** if the project uses Engram as artifact store (opt-in per-project)

### 7. Configuration System (`.context/`)

Two-level configuration file system for user preferences:

**Files**:
- `.context/flowDocs.config.json` (project-level, committed to git)
- `.context/flowDocs.config.local.json` (dev-level, gitignored manually)

**Precedence**: Local (dev) wins over project-level.

**Config structure** (JSON, strict):

```json
{
  "version": "1.0",
  "last_updated": "2026-06-03T14:30:00Z",
  "dismissed": {
    "section_key": {
      "scope": "project|session",
      "dismissed_at": "2026-06-03T14:30:00Z",
      "reason": "user_choice"
    }
  },
  "preferences": {
    "engram_upload_on_archive": true,
    "archive_time_limit_days": null,
    "commit_archived_to_git": false
  },
  "force_show": {
    "section_key": true
  }
}
```

- **No automatic `.gitignore` template** — documented in the implementation guide, reminded in install check, offered in install script
- The `.gitignore` entry to add manually: `.context/*.local.json`

### 8. Failure Handling

- All suggestions are **opt-in, never blocking** (only a file write failure is a hard fail)
- **Graceful degradation**: missing sections are omitted with a warning logged
- For missing sources:
  - **AGENTS.md not found** → fail hard with instruction to create it
  - **Engram unavailable** → omit the Engram Pointers section, log a warning
  - **Engram empty (no relevant results)** → omit the section silently (not an error)
- Suggestions are dismissed per-session by default, opt-in per-project
- `force_show` field in config overrides project-level dismissals for an individual dev

---

## Consequences

### ✅ Positive

- Sub-agents have consistent, curated context without improvising
- Token cost is controlled (20-50 line file, generated once per change)
- Knowledge discovered during one HU propagates to related HUs (R2)
- Portable across tools (OpenCode, ClaudeCode, Antigravity, etc.) — no tool-specific config
- Two-level config respects both project and individual dev preferences
- Suggestions never block user flow — everything is opt-in

### ❌ Negative

- Additional file to maintain in the orchestrator implementation
- Discovery schema requires sub-agents to format output correctly (some training needed)
- Config files add slight complexity (`.context/` directory)
- R2 knowledge propagation requires the orchestrator to track HU relationships

### 🔄 Neutral

- 20-50 line constraint requires discipline — if context grows, it must be pruned
- Config is JSON (not markdown) — different from rest of framework, but appropriate for machine consumption

---

## Configuration

### `.context/flowDocs.config.json`

This file (and its `.local` counterpart) controls suggestion dismissal and user preferences.

**Creation**: Orchestrator creates it **lazily** — only when the user dismisses a suggestion or sets a preference.

**Scopes**:
- `session`: In-memory only, lost when session ends
- `project`: Persisted in `.context/flowDocs.config.json`, committed to git
- `local`: Persisted in `.context/flowDocs.config.local.json`, gitignored manually

**Precedence**: `local` > `project` > `defaults`

**`force_show`**: A dev can override a project-level dismissal by setting `force_show.section_key = true` in their local config.

---

## Related Decisions

| ADR | Title | Relationship |
|-----|-------|--------------|
| ADR-001 | Persistencia Engram | Defines the artifact store (Engram / openspec / hybrid) that `sdd-context.md` extends |
| ADR-008 | Nombre FlowDoc | Establishes the FlowDoc naming that `sdd-context.md` uses |

---

## Related Documents

- `docs/observaciones/SESSION-FLOWDOC-ADOPTION-2026-06-01.md` — Empirical justification (the `@` syntax finding)
- `.atl/skill-registry.md` — SDD skills that use this context pattern
- `architectures/monolitico/.agent-context.md` — Informal description of the orchestrator / sub-agent pattern
- `architectures/microservicios/.agent-context.md` — Same for the microservices architecture

---

## Implementation Checklist

- [ ] Orchestrator generates `sdd-context.md` at `/sdd-new`
- [ ] Orchestrator injects content + path into sub-agent prompts
- [ ] Orchestrator parses the `DISCOVERIES` block from sub-agent responses
- [ ] Orchestrator implements the 45-line switch rule
- [ ] Orchestrator looks up archived `sdd-context.md` when HU references an archived HU
- [ ] Orchestrator creates `.context/flowDocs.config.json` lazily on first dismissal
- [ ] Orchestrator reads both project and local config; local wins
- [ ] Orchestrator offers dismissal options: `session` / `project` / `continue without`
- [ ] Documentation updated (this ADR, `AGENTS.md`, `skill-registry.md`, etc.)
- [ ] Install script updated to offer adding `.context/*.local.json` to `.gitignore`

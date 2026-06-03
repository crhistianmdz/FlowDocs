# ADR-001: Persistence with Engram for SDD Artifacts

**Date**: 2026-05-29  
**Author**: @Crhistian  
**Related RFC**: None (initial decision)  
**Status**: Accepted

---

## Context

The SDD framework requires storing artifacts from each phase (proposal, spec, design, tasks, verify, archive). We need a persistent location where:

1. Artifacts survive between sessions
2. Agents can read context from previous projects
3. It's accessible regardless of the tool (OpenCode or Antigravity)
4. State is not lost during context compactions

We evaluated three options:

| Option | Advantages | Disadvantages |
|--------|------------|---------------|
| **engram** | Cross-session persistence, semantic search, upserts | Local only, not shareable with team |
| **openspec** | Git-tracked files, shareable, complete audit trail | No semantic search, verbose |
| **hybrid** | Best of both worlds | More complex to configure |

---

## Decision

**We use Engram as the default artifact store.**

For teams that need to share artifacts (git-based workflow), use `openspec` or `hybrid`.

**Rationale**:
- The primary use case is **individual work** with SDD
- Engram's semantic search allows recovering context from previous cycles
- Upserts allow updating decisions without duplication
- Cross-session persistence is critical to avoid losing work during compactions

---

## Consequences

### ✅ Positive

- Artifacts persist between sessions automatically
- Semantic search to find past decisions
- Upserts avoid observation duplication
- No additional configuration required (OpenCode has Engram built-in)

### ❌ Negative

- **Not shareable**: other team members can't see Engram artifacts
- **Local**: each dev has their own Engram database
- **Iteration overwrites**: re-running a phase overwrites the previous one (only the last one survives)

### 🔄 Neutral

- For small teams (1-3 people) this is ideal
- For large teams, the limitation is real → use `hybrid` or `openspec`

---

## Configuration

### Engram mode (default)

```yaml
# Engram mode - local only
artifact_store: engram
```

### Openspec mode (teams)

```yaml
# Openspec mode - git-tracked, shareable
artifact_store: openspec
```

### Hybrid mode (best of both worlds)

```yaml
# Hybrid mode - files + engram recovery
artifact_store: hybrid
```

---

## How to Migrate Between Modes

### From engram to openspec

1. Export artifacts from Engram to files
2. Create `openspec/changes/{change-name}/` structure
3. Commit to git
4. Change `artifact_store: openspec`

### From openspec to engram

1. Import artifacts from files to Engram (future: migration script)
2. Change `artifact_store: engram`
3. Original artifacts remain available in Engram

---

## Related Decisions

| Decision | Location |
|----------|----------|
| SDD artifact structure | `openspec/changes/{change-name}/` |
| Topic keys for Engram | `sdd/{change-name}/{phase}` |
| Artifact store mode | `openspec/config.yaml` or equivalent |
| ADR-009 | SDD Sub-agent Context Pattern | Extends the artifact store model with per-change context files for sub-agents |

---

## Notes

- Engram works in both OpenCode and Antigravity (configurable)
- For complete audit trail, use `openspec` mode
- Engram is the **persistence**; the SDD **workflow** is identical across all modes
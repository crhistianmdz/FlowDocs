# FlowDoc Audit Skill

## Trigger

When user says any of:
- "audit flowdocs"
- "check docs integrity"
- "verificar estructura de docs"
- "doc integrity check"
- "auditar documentación"

## Purpose

Runs 5 documentation integrity checks against a FlowDoc project.
All checks are **dynamic** — no hardcoded file lists.
The agent derives expectations from the project structure itself.

---

## Prerequisites

1. Read `AGENTS.md` at project root — extract expected directory structure
2. Read `docs/flowDocs/AGENT_MANUAL.md` or `docs/README.md` — understand conventions
3. Check if `deprecated/README.md` exists — understand what to exclude

---

## The 5 Checks

### Check 1: Structural Completeness

**What**: Verify all directories and core files from AGENTS.md exist.

**How**:
1. Parse the "Project Structure" section in `AGENTS.md`
2. For each directory: use `glob` to verify it exists
3. For each core file (AGENTS.md, README.md, etc.): verify existence

**Report**: List any missing directories or files.

---

### Check 2: Orphaned Files

**What**: Find `.md` files in `docs/` that aren't referenced anywhere.

**How**:
1. `glob docs/**/*.md` → get all markdown files
2. `grep` for `[text](path)` patterns across all `.md` files
3. Any file that appears in no link target is potentially orphaned
4. Exclude:
   - `docs/templates/` — templates are not necessarily referenced
   - `docs/deprecated/` — known deprecated content
   - `docs/tasks/` — work in progress

**Report**: List orphaned files with suggestion (delete? reference? move to deprecated?).

---

### Check 3: Broken Internal Links

**What**: Find markdown links that point to non-existent files.

**How**:
1. `grep` for pattern `[text](relative-path)` across all `.md` files
2. Skip:
   - External URLs (http://, https://, mailto:)
   - Anchor-only links (#section)
   - Links starting with `/` (absolute paths)
3. For each internal link:
   - Resolve relative path from source file's directory
   - Check if target exists with `glob` or `read`
4. Report source file → broken target path

**Report**: List broken links with source file and broken path.

---

### Check 4: Naming Conventions

**What**: Verify file naming follows FlowDoc conventions.

**How**:
1. **ADRs**: `glob docs/architecture/adr/*.md`
   - Expected pattern: `NNN-kebab-case.md` (e.g., `001-auth-jwt.md`)
   - Status field must be: Draft | In Review | Accepted | Deprecated
2. **RFCs**: `glob docs/architecture/rfc/*.md`
   - Expected pattern: `NNN-kebab-case.md`
   - Status field must be: Draft | In Review | Accepted
3. **Templates**: verify `template-` prefix or `_template` suffix
4. **Root files**: AGENTS.md, README.md (case-sensitive exact match)

**Report**: List files with naming violations and what they should be named.

---

### Check 5: Bilingual Parity (if applicable)

**What**: If project has `es/` mirror, verify both sides exist.

**How**:
1. Check if `es/` directory exists
2. If yes:
   - `glob docs/**/*.md` → EN files
   - `glob es/docs/**/*.md` → ES files
   - Compare: each EN file should have ES counterpart
   - Exclude `deprecated/` from both sides
3. If no `es/` directory: **skip this check entirely**

**Report**: List files missing translation in either direction.

---

## Output Format

Present results as:

```
## FlowDoc Audit Results

### Check 1: Structural Completeness
✅ PASS — All expected directories and files found
   (or)
❌ FAIL — 3 issues found:
   - docs/architecture/adr/ — MISSING
   - docs/templates/ADR_template.md — MISSING

### Check 2: Orphaned Files
✅ PASS — No orphaned files detected
   (or)
❌ FAIL — 2 orphaned files:
   - docs/old-notes.md (suggestion: move to docs/deprecated/ or delete)

... (continue for all 5 checks)

---

## Summary

| Check | Status |
|-------|--------|
| Structural Completeness | ✅ PASS |
| Orphaned Files | ❌ FAIL |
| Broken Internal Links | ✅ PASS |
| Naming Conventions | ✅ PASS |
| Bilingual Parity | ⏭️ SKIPPED (no es/ mirror) |

**Result**: 3/5 passed, 1 failed, 1 skipped
```

---

## What NOT to Do

- ❌ **Don't hardcode file lists** — derive from `AGENTS.md` dynamically
- ❌ **Don't skip directories based on assumptions** — read `deprecated/README.md` to understand exclusions
- ❌ **Don't fail on stylistic issues** — only structural/integrity problems matter
- ❌ **Don't report EN/ES parity as FAIL if there's no `es/` mirror** — skip it

---

## Examples

### Triggering the skill

User: "Run a quick audit on the docs"

Agent should:
1. Recognize the trigger
2. Execute all 5 checks in order
3. Present results in the standard format above
4. For failures, provide specific files/paths and suggestions

### When something is broken

User: "I think there might be broken links in the docs"

Agent should:
1. Run Check 3 (Broken Internal Links) specifically
2. Report any broken links found
3. Suggest fixes if obvious (e.g., file was moved)

---

## See Also

- `docs/flowDocs/AGENT_MANUAL.md` — Agent quick reference
- `docs/anti-patrones.md` — Documentation anti-patterns
- `docs/troubleshooting.md` — Common problems and solutions

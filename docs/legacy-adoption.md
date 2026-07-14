# Legacy Adoption Guide

> How to adopt FlowDocs in existing projects with code.

---

## When to Use This

Use `--legacy` when:
- You have an existing project with code
- You want to document it with FlowDocs
- The codebase has no formal documentation yet

```
init-flowdoc.sh --legacy
```

---

## What It Does

1. **Explores** your codebase (entry points, APIs, DB, existing docs)
2. **Creates** `docs/flowDocs/` with:
   - `flowdoc-migration-progress.md` — tracks what's done
   - `flowdoc-migration-prompt.md` — prompt for AI agent
   - `migrations/` folder with 4 HU templates
3. **Generates** `docs/PRD.md` from exploration data

---

## Quick Start

### 1. Run the script

```bash
# Basic (with exploration)
bash scripts/init-flowdoc.sh --legacy

# Skip exploration (faster)
bash scripts/init-flowdoc.sh --legacy --no-explore

# Preview what would be created
bash scripts/init-flowdoc.sh --legacy --dry-run
```

### 2. Read the prompt

```bash
cat docs/flowDocs/flowdoc-migration-prompt.md
```

### 3. Pass to an AI agent

Give the agent the prompt content and let it generate the documentation.

### 4. Review the results

The agent creates:
- `migrations/HU-001-prd.md` — Project overview
- `migrations/HU-002-rfc-legacy.md` — Technical decisions found
- `migrations/HU-003-apis.md` — API endpoints
- `migrations/HU-004-db-schema.md` — Database schema

**Important**: Review the DB schema carefully. The agent infers from code — verify against the actual database.

### 5. Track progress

The `flowdoc-migration-progress.md` tracks what's done:

```markdown
| HU | Area | Status |
|----|------|--------|
| HU-001 | PRD | ✅ Done |
| HU-002 | RFC Legacy | 🟡 In Progress |
| HU-003 | APIs | 🔲 Pending |
| HU-004 | DB Schema | 🔲 Pending |
```

---

## Generated Structure

```
docs/
└── flowDocs/
    ├── flowdoc-migration-progress.md  ← Track progress
    ├── flowdoc-migration-prompt.md    ← Agent prompt
    └── migrations/
        ├── HU-001-prd.md
        ├── HU-002-rfc-legacy.md
        ├── HU-003-apis.md
        └── HU-004-db-schema.md
```

---

## Flags

| Flag | Purpose |
|------|---------|
| `--legacy` | Enable legacy adoption mode |
| `--no-explore` | Skip codebase exploration |
| `--overwrite` | Overwrite existing PRD |
| `--dry-run` | Preview without creating files |

---

## For Large Projects

If the project is large, work in sessions:

1. Run `--legacy` once to generate the structure
2. Have the agent complete one HU at a time
3. Update `flowdoc-migration-progress.md` after each session
4. When all HUs are done, move them to the appropriate `docs/` locations

---

## Example Session

```bash
# 1. Generate structure
bash scripts/init-flowdoc.sh --legacy

# 2. Agent fills HUs
# (Give the agent docs/flowDocs/flowdoc-migration-prompt.md)

# 3. Review each HU
# Especially validate: HU-004-db-schema.md

# 4. Move HUs to final location
mv docs/flowDocs/migrations/* docs/tasks/

# 5. Commit
git add .
git commit -m "docs: complete FlowDoc adoption"
```

---

## See Also

- [Adoption Guide](adoption-guide.md) — How to adopt FlowDocs
- [init-flowdoc.sh --help](scripts/init-flowdoc.sh) — Full script reference

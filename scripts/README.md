# Scripts

Operational tools for FlowDoc adoption and maintenance. These scripts are meant to be run by humans or AI agents working with the framework.

---

## Available Scripts

### `flowdoc-adoption-checklist.md`

Adoption guide for bringing FlowDoc into an existing project.

**What it does**: Step-by-step checklist covering three scenarios:
- **Scenario A**: Legacy project with existing SDD structure (ADRs, RFCs, HUs)
- **Scenario B**: Legacy project with code only, no formal documentation
- **Scenario C**: New project from scratch

**When to use it**: After running `flowdoc-migration.sh`, use this checklist to complete the adoption and validate the structure.

**Location**: `scripts/flowdoc-adoption-checklist.md`

---

## Skill Installation Scripts

These scripts install FlowDoc skills into OpenCode.

### Linux / macOS (Bash)

```bash
curl -fsSL https://raw.githubusercontent.com/crhistianmdz/FlowDocs/main/scripts/install-flowdoc-skills.sh | bash
```

Or download and run manually:

```bash
bash install-flowdoc-skills.sh [--dry-run] [--force] [--update] [--target /path]
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/crhistianmdz/FlowDocs/main/scripts/install-flowdoc-skills.ps1 | iex
```

Or download and run manually:

```powershell
powershell -ExecutionPolicy Bypass -File install-flowdoc-skills.ps1 [-DryRun] [-Force] [-Update] [-TargetDir "C:\path"]
```

#### Options

| Option | Description |
|--------|-------------|
| `--dry-run` / `-DryRun` | Show what would be done without executing |
| `--force` / `-Force` | Overwrite existing skills without asking |
| `--update` / `-Update` | Update already installed skills |
| `--target` / `-TargetDir` | Install to custom directory |
| `--verbose` / `-Verbose` | Show more detail |
| `--help` / `-Help` | Show help |

---

## Deprecated Tools

The `deprecated/` folder contains tools that are no longer maintained. They are kept for reference only.

### `bilingual-checklist.md`

Translation tracking checklist for the EN/ES bilingual effort.

**Status**: ✅ Complete (100% done)

This file served as the master checklist during the bilingual translation project. All phases are done — no further action needed. The file remains as historical record of the translation process.

**Location**: `scripts/deprecated/bilingual-checklist.md`

---

## Adding New Scripts

If you add a script to this directory:

1. Document what it does and when to use it in this README
2. Keep operational scripts (for humans/agents to run) here
3. Keep deprecated tools in `deprecated/` with a status note

---

**Last updated**: 2026-07-14

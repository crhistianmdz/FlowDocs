#!/bin/bash
# ============================================================================
# FlowDoc Migration Script v2
# Safe, idempotent adoption of the FlowDoc documentation framework.
#
# Usage:
#   bash flowdoc-migration.sh                  # default: --update mode
#   bash flowdoc-migration.sh --dry-run        # preview only
#   bash flowdoc-migration.sh --force          # backup + overwrite
#   bash flowdoc-migration.sh --update         # create missing only (default)
#   bash flowdoc-migration.sh --help           # show usage
#
# Requirements: Bash 4+, runs on macOS and Linux.
# ============================================================================

set -euo pipefail

# ------------------------------------------------------------------
# Global state
# ------------------------------------------------------------------
DRY_RUN=false
FORCE=false
UPDATE=false
STACK="generic"
CREATED_COUNT=0
SKIPPED_COUNT=0
ERROR_COUNT=0
BACKUP_DIR=""
AGENTS_MD_EXISTS=false
GITIGNORE_EXISTS=false

# ------------------------------------------------------------------
# Colors
# ------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ------------------------------------------------------------------
# Helper: create_file <path> <content>
# Idempotent file creation. Skips if file exists (unless --force).
# Creates parent directories via mkdir -p.
# Satisfies R1.4, R1.7.
# ------------------------------------------------------------------
create_file() {
  local path="$1"
  local content="$2"

  if [ -f "$path" ] && [ "$FORCE" != true ]; then
    echo -e "  ${YELLOW}⚠️  Skipped (exists):${NC} $path"
    ((SKIPPED_COUNT++)) || true
    return 0
  fi

  if [ "$DRY_RUN" = true ]; then
    echo -e "  ${CYAN}🔍 Would create:${NC} $path"
    ((CREATED_COUNT++)) || true
    return 0
  fi

  mkdir -p "$(dirname "$path")"
  printf '%s\n' "$content" > "$path"
  echo -e "  ${GREEN}✅ Created:${NC} $path"
  ((CREATED_COUNT++)) || true
}

# ==================================================================
# Phase 1: Flag parsing (T2)
# Satisfies R1.5, R1.6, R1.7
# ==================================================================
show_help() {
  cat << 'HELP_EOF'
FlowDoc Migration Script v2

Usage: bash flowdoc-migration.sh [FLAGS]

Flags:
  --help, -h      Show this help and exit
  --dry-run       Preview: show what would be created without writing files
  --force         Backup existing structure, then overwrite all files
  --update        Only create missing files (DEFAULT behavior)

Examples:
  bash flowdoc-migration.sh               # create missing files only
  bash flowdoc-migration.sh --dry-run     # preview what would be created
  bash flowdoc-migration.sh --force       # backup + full migration

The script creates the full FlowDoc documentation structure:
  - 14 directories (docs/, templates/, architecture/, tasks/, etc.)
  - 12 template files (user stories, bug fixes, refactors, RFC, ADR, etc.)
  - 11 base documentation files (guides, FAQ, anti-patterns, etc.)
  - 8 ADR placeholder stubs (001–008)
  - 4 RFC placeholder stubs (001–004)
  - 2 HU example files (001–002)
  - 4 root files (AGENTS.md, ONBOARDING.md, QUICKSTART.md, CHANGELOG.md)
  - Stack-aware .gitignore.flowdoc-suggestions
  - ES/ mirror of the full structure

HELP_EOF
}

parse_flags() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help|-h)
        show_help
        exit 0
        ;;
      --dry-run)
        DRY_RUN=true
        UPDATE=false
        shift
        ;;
      --force)
        FORCE=true
        UPDATE=false
        shift
        ;;
      --update)
        UPDATE=true
        FORCE=false
        shift
        ;;
      *)
        echo -e "${RED}❌ Unknown flag: $1${NC}"
        echo "Run with --help for usage information."
        exit 2
        ;;
    esac
  done
}

# ==================================================================
# Phase 1: Pre-checks (T3)
# Satisfies R1.1, R1.2, R1.13, R1.14
# ==================================================================

# Detect project root: we must be at the root of a project
is_project_root() {
  # Signs of being at or near a project root
  if [ -f "AGENTS.md" ] || [ -d ".git" ] || [ -d "src" ] || [ -d "docs" ] || \
     compgen -G "*.csproj" > /dev/null 2>&1 || \
     compgen -G "*.sln" > /dev/null 2>&1 || \
     [ -f "package.json" ] || \
     [ -f "go.mod" ] || \
     [ -f "requirements.txt" ] || \
     [ -f "pom.xml" ]; then
    return 0
  fi
  return 1
}

has_write_perms() {
  if [ ! -w "." ]; then
    echo -e "${RED}❌ No write permissions in current directory.${NC}"
    exit 1
  fi
}

guard_agents_md() {
  if [ -f "AGENTS.md" ]; then
    if [ "$UPDATE" = true ]; then
      # In update mode, AGENTS.md already exists from a previous FlowDoc run.
      # Skip it gracefully — never overwrite AGENTS.md (R1.1).
      echo -e "${YELLOW}⚠️  AGENTS.md already exists — skipping (update mode).${NC}"
      AGENTS_MD_EXISTS=true
      return 0
    fi
    # In default or force mode on a NEW project, AGENTS.md existing means
    # the user has a pre-existing agent configuration we MUST protect.
    echo -e "${RED}❌ AGENTS.md already exists.${NC}"
    echo "   This script will NOT overwrite your AGENTS.md — it protects your"
    echo "   existing project configuration."
    echo ""
    echo "   To adopt FlowDoc:"
    echo "   1. Rename or move your current AGENTS.md (e.g., AGENTS.md.backup)"
    echo "   2. Re-run this script"
    echo ""
    echo "   The created FlowDoc AGENTS.md will be placed at AGENTS.md."
    echo "   You can merge your custom rules afterward."
    exit 1
  fi
}

guard_gitignore() {
  if [ -f ".gitignore" ]; then
    echo -e "${YELLOW}⚠️  .gitignore already exists — will NOT overwrite.${NC}"
    echo "   Generating .gitignore.flowdoc-suggestions instead."
    echo "   Review and merge into your .gitignore manually."
    echo ""
    GITIGNORE_EXISTS=true
  else
    GITIGNORE_EXISTS=false
  fi
}

# ==================================================================
# Phase 1: Stack detection (T4)
# Satisfies R1.8
# ==================================================================
detect_stack() {
  if compgen -G "*.csproj" > /dev/null 2>&1 || compgen -G "*.sln" > /dev/null 2>&1; then
    STACK="dotnet"
  elif [ -f "package.json" ]; then
    STACK="node"
  elif [ -f "requirements.txt" ] || [ -f "setup.py" ] || [ -f "pyproject.toml" ]; then
    STACK="python"
  elif [ -f "pom.xml" ] || [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
    STACK="java"
  else
    STACK="generic"
  fi
  echo -e "🔍 Detected stack: ${BOLD}${STACK}${NC}"
}

# ==================================================================
# Phase 2: Backup (T14)
# Satisfies R1.3
# ==================================================================
create_backup() {
  if [ "$FORCE" != true ]; then
    return 0
  fi
  BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
  if [ "$DRY_RUN" = true ]; then
    echo -e "${CYAN}🔍 Would create backup:${NC} $BACKUP_DIR/"
    return 0
  fi
  mkdir -p "$BACKUP_DIR"

  # Backup existing FlowDoc structure if present
  for dir in docs scripts AGENTS.md ONBOARDING.md QUICKSTART.md CHANGELOG.md .gitignore; do
    if [ -e "$dir" ]; then
      cp -r "$dir" "$BACKUP_DIR/" 2>/dev/null || true
    fi
  done
  echo -e "${GREEN}✅ Backup created:${NC} $BACKUP_DIR/"
}

# ==================================================================
# Phase 2: Directory structure (T5)
# 14 directories
# ==================================================================
create_dirs() {
  echo ""
  echo -e "${BOLD}📁 Creating directory structure...${NC}"

  local dirs=(
    "docs/templates/user-stories"
    "docs/templates/bug-fixes"
    "docs/templates/refactors"
    "docs/templates/architecture"
    "docs/templates/database"
    "docs/templates/api"
    "docs/templates/PRD"
    "docs/architecture/adr"
    "docs/architecture/rfc"
    "docs/tasks/HU-001-HU-099"
    "docs/api"
    "docs/database"
    "docs/observaciones"
    "scripts"
  )

  for d in "${dirs[@]}"; do
    if [ "$DRY_RUN" = true ]; then
      if [ ! -d "$d" ]; then
        echo -e "  ${CYAN}🔍 Would create dir:${NC} $d/"
        ((CREATED_COUNT++)) || true
      else
        echo -e "  ${YELLOW}⚠️  Exists:${NC} $d/"
        ((SKIPPED_COUNT++)) || true
      fi
    else
      if [ -d "$d" ]; then
        echo -e "  ${YELLOW}⚠️  Exists:${NC} $d/"
        ((SKIPPED_COUNT++)) || true
      else
        mkdir -p "$d"
        echo -e "  ${GREEN}✅ Created:${NC} $d/"
        ((CREATED_COUNT++)) || true
      fi
    fi
  done
}

# ==================================================================
# Phase 2: Templates (T7)
# 12 template files
# ==================================================================
create_templates() {
  echo ""
  echo -e "${BOLD}📝 Creating template files...${NC}"

  # 1. User Story SDD-Ready
  create_file "docs/templates/user-stories/template-user-story-sdd.md" \
"# HU-XXX: [Feature Name]

**Status**: 🟡 In Progress
**Owner**: @username
**Created**: YYYY-MM-DD
**Priority**: Must | Should | Could | Wont

---

## 🎯 Intent

[Brief description of what this feature does and why it matters.]

---

## 📋 Scope

### In Scope
- [What this HU includes]

### Out of Scope
- [What this HU explicitly does NOT include]

---

## ✅ Requirements

### MUST (required)
- [Hard requirement]

### SHOULD (highly desirable)
- [Important but not critical]

### MAY (nice to have)
- [Enhancements if time permits]

---

## 🧪 Scenarios

### Happy Path

**GIVEN** [precondition]
**WHEN** [action]
**THEN** [expected result]

### Edge Cases

**GIVEN** [precondition]
**WHEN** [action]
**THEN** [expected result]

### Error Cases

**GIVEN** [precondition]
**WHEN** [action]
**THEN** [error handling]

---

## 🧪 Verification

🧪 Ref: [How to verify this HU works — test cases, manual steps]

---

## 📦 Affected Areas

- \`src/\`
- \`docs/api/\`

---

## ⚠️ Risks

| Risk | Mitigation |
|------|------------|
| [Risk] | [Mitigation] |

---

## 🔄 Rollback Plan

[How to revert if this fails]

---

## 🔗 Dependencies

- HU-XXX (must complete first)

---

## 📖 Notes

[Any additional context]"

  # 2. User Story Simple
  create_file "docs/templates/user-stories/template-user-story.md" \
"# HU-XXX: [Feature Name]

**Status**: 🟡 In Progress
**Owner**: @username
**Created**: YYYY-MM-DD

---

## Description

[What this feature does]

## Criteria

- [ ] [Acceptance criterion 1]
- [ ] [Acceptance criterion 2]

## Notes

[Any additional context]"

  # 3. Bug Fix SDD-Ready
  create_file "docs/templates/bug-fixes/template-bug-fix-sdd.md" \
"# BF-XXX: [Bug Title]

**Status**: 🟡 In Progress
**Owner**: @username
**Created**: YYYY-MM-DD
**Severity**: Critical | High | Medium | Low

---

## 🐛 Problem

[Description of the bug]

## 🔍 Root Cause

[What is causing the bug]

## 💡 Solution

[How to fix it]

## 🧪 Test Case

**GIVEN** [precondition]
**WHEN** [action]
**THEN** [expected behavior]

## 🔗 Related HU

[If any, link to the HU that introduced this bug]"

  # 4. Bug Fix Simple
  create_file "docs/templates/bug-fixes/template-bug-fix.md" \
"# BF-XXX: [Bug Title]

**Status**: 🟡 In Progress
**Owner**: @username
**Severity**: Critical | High | Medium | Low

---

## Problem

[Description of the bug]

## Steps to Reproduce

1. [Step 1]
2. [Step 2]
3. [Step 3]

## Expected Behavior

[What should happen]

## Actual Behavior

[What actually happens]"

  # 5. Refactor
  create_file "docs/templates/refactors/template-refactor.md" \
"# RF-XXX: [Refactor Name]

**Status**: 🟡 In Progress
**Owner**: @username
**Created**: YYYY-MM-DD

---

## 🎯 Intent

[Why this refactor is needed]

## 📋 Scope

### In Scope
- [What changes]

### Out of Scope
- [What does NOT change]

## ✅ Requirements

- [ ] No behavior change
- [ ] All existing tests pass
- [ ] Backward compatible

## 🧪 Verification

[How to verify the refactor did not break anything]"

  # 6. RFC Template
  create_file "docs/templates/architecture/RFC_template.md" \
"# RFC-XXX: [Title]

**Author**: @username
**Status**: Draft | Discussion | Accepted | Rejected
**Created**: YYYY-MM-DD

---

## Summary

[One paragraph: what is this RFC trying to solve]

## Motivation

[Why is this needed? What problem does it solve?]

## Proposed Solution

[Detailed description of the proposed solution]

## Alternatives Considered

| Alternative | Pros | Cons |
|-------------|------|------|
| [Alt 1] | [Pros] | [Cons] |

## Decision

[What is being decided]

## Timeline

- **Proposal**: YYYY-MM-DD
- **Discussion**: YYYY-MM-DD
- **Decision**: YYYY-MM-DD

## Checklist

- [ ] All stakeholders have reviewed
- [ ] Risks identified and mitigated
- [ ] Cost/benefit analysis complete"

  # 7. ADR Template
  create_file "docs/templates/architecture/ADR_template.md" \
"# ADR-XXX: [Title]

**Date**: YYYY-MM-DD
**RFC related**: RFC-XXX (if any)
**Status**: Proposed | Accepted | Deprecated

---

## Context

[What is the decision being made? What is the situation?]

## Decision

[What is being decided]

## Consequences

### ✅ Positive
- [Benefit 1]

### ❌ Negative
- [Drawback 1]

### 🔄 Neutral
- [Side effect]

## Migration

[If applicable, how to migrate from previous state]

## Related Documents

| Document | Location |
|----------|----------|
| [Doc] | [Location] |"

  # 8. Database Schema
  create_file "docs/templates/database/schema.md" \
"# Database Schema

> Document the database schema for this project.

## Conventions

- Table names: \`snake_case\`
- Column names: \`snake_case\`
- Primary keys: \`id\` (UUID or SERIAL)
- Timestamps: \`created_at\`, \`updated_at\`

---

## Tables

### Table: [name]

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PK | Primary key |
| created_at | TIMESTAMP | NOT NULL | Creation timestamp |
| updated_at | TIMESTAMP | NOT NULL | Last update timestamp |

### Relationships

- \`[table]\` has many \`[table]\` (1:N)
- \`[table]\` belongs to \`[table]\` (N:1)

---

## Indexes

- \`[table].[column]\` — for \`[purpose]\`

## Migrations

\`YYYY-MM-DD-initial-schema.sql\` — Initial schema"

  # 9. API Endpoints
  create_file "docs/templates/api/endpoints.md" \
"# API Endpoints

> Document API contracts here.

## Conventions

- Base URL: \`/api/v1\`
- Authentication: Bearer token
- Errors: Standard HTTP codes + \`{ error: string, code: string }\`

---

## Auth

### POST /api/v1/auth/login

**Request:**
\`\`\`json
{
  \"email\": \"string\",
  \"password\": \"string\"
}
\`\`\`

**Response (200):**
\`\`\`json
{
  \"token\": \"string\",
  \"user\": { \"id\": \"string\", \"email\": \"string\" }
}
\`\`\`

**Errors:**
- 401: Invalid credentials

---

## [Resource]

### GET /api/v1/[resource]

**Headers:**
- \`Authorization: Bearer {token}\`

**Response (200):**
\`\`\`json
{
  \"data\": [],
  \"pagination\": { \"page\": 1, \"limit\": 20, \"total\": 100 }
}
\`\`\`"

  # 10. PRD base
  create_file "docs/templates/PRD/PRD.md" \
"# Product Requirements Document (PRD)

**Project**: [Name]
**Owner**: @username
**Created**: YYYY-MM-DD
**Status**: Draft | In Review | Approved

---

## 🎯 Vision

[What is this project trying to achieve?]

## 👥 Users

| User | Needs | Pain Points |
|------|-------|-------------|
| [User 1] | [Needs] | [Pain points] |

## ✅ Requirements

### Must Have
- [Requirement]

### Should Have
- [Requirement]

### Nice to Have
- [Requirement]

## 🚫 Out of Scope

- [What is not included]

## 📊 Success Metrics

- [Metric 1]: [Target]
- [Metric 2]: [Target]

## 📝 Notes

[Any additional context]"

  # 11. PRD Template (extended)
  create_file "docs/templates/PRD/PRD_template.md" \
"# [Project Name] — Product Requirements Document

**Owner**: @username
**Version**: 1.0
**Last updated**: YYYY-MM-DD

---

## 1. Executive Summary

[One paragraph explaining the project]

## 2. Objectives

- [Primary objective]
- [Secondary objective]

## 3. Scope

### In Scope
- [What is included]

### Out of Scope
- [What is NOT included]

## 4. Users

| User | Description | Needs |
|------|-------------|-------|
| [User 1] | [Description] | [Needs] |

## 5. Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| RF-001 | [Requirement] | Must |

## 6. Non-Functional Requirements

| ID | Requirement | Criteria |
|----|-------------|----------|
| RNF-001 | [Requirement] | [Criteria] |

## 7. API Contracts

[Link to docs/api/endpoints.md]

## 8. Tech Stack

| Component | Technology |
|------------|------------|
| Frontend | [Tech] |
| Backend | [Tech] |
| Database | [Tech] |

## 9. Timeline

| Phase | Date | Deliverable |
|-------|------|-------------|
| [Phase] | [Date] | [Deliverable]"

  # 12. Template Guide
  create_file "docs/templates/TEMPLATE_GUIDE.md" \
"# Template Guide

> Quick reference for choosing the right template.

## User Stories

| Situation | Template |
|-----------|----------|
| Normal feature | \`user-stories/template-user-story-sdd.md\` |
| Small feature (< 2h) | \`user-stories/template-user-story.md\` |
| Refactor | \`refactors/template-refactor.md\` |

## Bug Fixes

| Situation | Template |
|-----------|----------|
| Bug with verification tests | \`bug-fixes/template-bug-fix-sdd.md\` |
| Trivial bug | \`bug-fixes/template-bug-fix.md\` |

## Architecture

| Situation | Template |
|-----------|----------|
| New decision (under discussion) | \`architecture/RFC_template.md\` |
| Decision already made | \`architecture/ADR_template.md\` |

## API & Database

| Document | Template |
|----------|----------|
| API Endpoints | \`api/endpoints.md\` |
| Database Schema | \`database/schema.md\` |

## Projects

| Document | Template |
|----------|----------|
| Product Requirements | \`PRD/PRD.md\` |

## How to Use

1. Copy template to \`docs/tasks/\` (for HUs) or relevant folder
2. Fill in the sections
3. Delete unused sections
4. Update status as work progresses

## Status Conventions

| Status | Meaning |
|--------|---------|
| 🟡 In Progress | Currently working on |
| 🟢 Done | Completed |
| 🔴 Blocked | Waiting on something |
| ⚫ Archived | Cancelled or superseded"
}

# ==================================================================
# Phase 2: Base documentation (T8 + T9)
# 11 base docs: supporting docs + architecture docs
# ==================================================================
create_base_docs() {
  echo ""
  echo -e "${BOLD}📚 Creating base documentation...${NC}"

  # 1. Workflow cycle
  create_file "docs/flowdoc-ciclo.md" \
"# FlowDoc Workflow Cycle

> The adapted 15-day workflow cycle for distributed teams.

---

## The Cycle

\`\`\`
Day 1-2   → Planning + HU creation
Day 3-7   → Development (SDD cycle per HU)
Day 8-11  → Integration testing + review
Day 12-14 → Stabilization + preparation
Day 15    → Retrospective + planning next cycle
\`\`\`

---

## SDD Cycle per HU

Each HU follows the SDD cycle independently:

\`Proposal → Spec → Design → Tasks → Apply → Verify → Archive\`

---

## Daily Async Updates

5-minute async updates on Discord:
- What I did yesterday
- What I am doing today
- Blockers (if any)

---

## Resources

- [Adoption Guide](adoption-guide.md)
- [FAQ](FAQ.md)
- [Anti-patterns](anti-patrones.md)"

  # 2. Adoption guide
  create_file "docs/adoption-guide.md" \
"# Adoption Guide — How to Adopt FlowDoc Based on Your Context

> You do not have to adopt everything at once. Choose the level that best fits your situation and grow from there.

---

## Adoption Levels

\`\`\`
┌─────────────────────────────────────────────────────────────┐
│  Level 4: Full Team                                          │
│  15-day cycle + Metrics + Complete process                   │
├─────────────────────────────────────────────────────────────┤
│  Level 3: Coordinated Team                                  │
│  Adapted cycle + Planning + Integration                     │
├─────────────────────────────────────────────────────────────┤
│  Level 2: Basic SDD                                         │
│  Proposal → Spec → Design → Tasks → Apply → Verify         │
├─────────────────────────────────────────────────────────────┤
│  Level 1: Documentation Only                                │
│  HUs in docs/tasks/, no SDD ceremony                        │
└─────────────────────────────────────────────────────────────┘
\`\`\`

---

## Level 1: Documentation Only ✅

**Ideal for**: Teams of 1 person, small projects.

1. Create \`docs/tasks/HU-001-your-feature.md\`
2. Use template from \`docs/templates/user-stories/\`
3. Document: what it does, acceptance criteria

## Level 2: Basic SDD ✅

**Ideal for**: 1-2 people who want structure.

Follow the full SDD cycle: Proposal → Spec → Design → Tasks → Apply → Verify → Archive

## Level 3: Adapted Cycle ✅

**Ideal for**: Teams of 2-5 people.

1. Adapted planning (not mandatory 15 days)
2. Clear owner on each HU
3. Feature flags for parallel work

## Level 4: Full Team ✅

**Ideal for**: Teams of 4+ people in different time zones.

15-day cycle + metrics + complete process.

---

## Getting Started

1. **Today**: Create \`docs/tasks/HU-001-your-next-feature.md\`
2. **This week**: Try the SDD cycle on one HU
3. **This month**: Evaluate if you need more structure

The goal is for documentation to be useful, not perfect."

  # 3. FAQ
  create_file "docs/FAQ.md" \
"# FAQ — Frequently Asked Questions

> The most common questions when adopting FlowDoc.

---

## Getting Started

### Where do I start?

**Create a HU at \`docs/tasks/HU-001-your-feature.md\`.**

### How long does it take to document a HU?

| Level | Time |
|-------|------|
| Simple HU | 10-15 min |
| SDD-Ready HU | 30-45 min |
| Full HU | 1-2 hours |

---

## The 15-Day Cycle

### Are the 15 days mandatory?

No. The 15-day cycle is a **reference**, not an obligation.

### Where does the cycle come from?

Based on **adapted Scrum** for distributed teams.

---

## Tool Integration

### How do I integrate with GitHub Projects, Jira, etc.?

**It is not the framework's responsibility.** Integrating with your project management tool is your team's decision.

---

## HUs That FAIL

### What if a HU cannot be completed?

A HU is not a hard contract. You can:
- **Split** into smaller HUs
- **Archive** with reason: \"blocked by X\", \"scope changed\"
- **Create Bug Fix** to resolve issues

The important thing: **do not leave zombie HUs**."

  # 4. Anti-patterns
  create_file "docs/anti-patrones.md" \
"# Anti-Patterns — Signs That FlowDoc Is Not Working

> If you see any of these signs, something needs adjusting.

---

## Documentation

### ❌ Outdated docs

**Sign**: Files in \`docs/\` do not reflect the reality of the code.

**Solution**: \"Docs in the PR\" rule — update documentation at the same time as code.

### ❌ Zombie HUs

**Sign**: HUs in \"in progress\" status for more than 2 cycles without progress.

**Solution**: Archive with documented reason.

### ❌ Obsolete ADRs

**Sign**: ADRs that contradict current decisions.

**Solution**: Mark as \`DEPRECATED\` and link to the new ADR that replaces it.

---

## Process

### ❌ Unnecessary meetings

**Sign**: Status meetings that could be an async message.

**Solution**: If it does not need real-time interaction, use Discord/Issue, not a meeting.

### ❌ In-person daily standups for async teams

**Sign**: Waiting for everyone to be online to do the daily.

**Solution**: 5-min async updates on Discord.

### ❌ 4+ hour planning sessions

**Sign**: Planning extends all day.

**Solution**: Max 4 hours. If it does not fit, the feature is too big.

---

## SDD

### ❌ Speccing for fun

**Sign**: All HUs have complete specs, but nobody reads them.

**Solution**: N1 just documentation. N2+ for real features.

### ❌ Design before understanding the problem

**Sign**: Starting with Design without going through Explore/Proposal.

**Solution**: SDD is Proposal → Spec → Design. Do not skip steps.

### ❌ Tasks without tests

**Sign**: Code tasks without their associated test task.

**Solution**: Each code task includes its test task alongside.

---

## Team

### ❌ Seeking perfection

**Sign**: Not doing anything because \"it is not ready\".

**Solution**: Iterate. Something imperfectly documented > nothing.

### ❌ Imposing the framework

**Sign**: Forcing the team to follow everything to the letter.

**Solution**: Inspire, do not impose. Show value first."

  # 5. Troubleshooting
  create_file "docs/troubleshooting.md" \
"# Troubleshooting — Common Errors and Solutions

---

## SDD Commands

### Error: \"Artifact not found\"

**Cause**: No artifact exists for that change.

**Solution**: First create the artifact with \`/sdd-new\` or verify the name is correct.

### Error: \"Permission denied\" on scripts

**Cause**: The script does not have execute permissions.

**Solution**: \`chmod +x scripts/*.sh\`

---

## Structure

### Error: \"docs/ does not exist\"

**Cause**: Structure was not initialized.

**Solution**: Run \`scripts/flowdoc-migration.sh\` to create the structure.

---

## HU Status

### HU has been in progress for 3+ cycles without completion

**Cause**: Underestimation or persistent blockers.

**Solution**:
- Split into smaller HUs
- Archive with documented reason
- Verify dependencies

---

## Resources

| Problem | Resource |
|---------|----------|
| Work cycle | \`docs/flowdoc-ciclo.md\` |
| Adoption | \`docs/adoption-guide.md\` |
| Templates | \`docs/templates/TEMPLATE_GUIDE.md\`"

  # 6. Legacy migration guide
  create_file "docs/legacy-migration.md" \
"# Legacy Migration — Adapting Existing Projects to FlowDoc

> Guide for projects with existing documentation that want to adopt FlowDoc.

---

## Before You Start

1. Identify what documentation already exists
2. Decide on adoption level (see [Adoption Guide](adoption-guide.md))
3. Run \`scripts/flowdoc-migration.sh\` to create the base structure

---

## Step 1: Map Existing Docs

| Current Location | FlowDoc Destination |
|------------------|---------------------|
| \`readme-docs/\` | \`docs/\` |
| \`specs/\` | \`docs/tasks/\` |
| \`decisions/\` | \`docs/architecture/adr/\` |

## Step 2: Convert to Templates

Use the closest FlowDoc template from \`docs/templates/\`.

## Step 3: Validate

Run \`scripts/flowdoc-audit.sh\` to check structure integrity.

---

## Common Scenarios

### We have GitHub Issues for tasks

Keep them — FlowDoc does not require replacing your issue tracker. HUs document the WHAT and WHY, issues track the HOW.

### We do not use SDD yet

Start at Level 1 (documentation only). Add SDD when you need more structure.

### We have architecture docs scattered across the repo

Consolidate into \`docs/architecture/\`:
- Decisions → \`adr/\`
- Proposals → \`rfc/\`
- Diagrams → \`docs/architecture-diagram.md\`"

  # 7. Architecture diagram
  create_file "docs/architecture-diagram.md" \
"# Architecture Diagram

> High-level architecture overview for this project.

---

## System Overview

\`\`\`
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Client     │ ──▶ │   API        │ ──▶ │   Database   │
└──────────────┘     └──────────────┘     └──────────────┘
\`\`\`

---

## Components

| Component | Technology | Responsibility |
|-----------|------------|----------------|
| Frontend | [Tech] | User interface |
| Backend | [Tech] | Business logic |
| Database | [Tech] | Data persistence |

---

## Data Flow

[Describe the main data flows in your system.]

---

## Deployment

[Describe the deployment architecture.]

---

## Related Documents

- [ADR: Four Architectures](architecture/adr/006-cuatro-arquitecturas.md)
- API Contracts: see \`templates/api/endpoints.md\`
- Database Schema: see \`templates/database/schema.md\`"

  # 8. Walkthrough HU login
  create_file "docs/walkthrough-hu-login.md" \
"# Walkthrough: HU Login — Complete SDD Cycle

> Step-by-step example of a full SDD cycle for a login feature.

---

## 1. Proposal

### Intent
Implement a login system so users can authenticate.

### Scope
- Login with email/password
- JWT token generation
- Session persistence

### Out of Scope
- Social login
- Password reset
- MFA

---

## 2. Spec

### Requirements

| ID | Requirement |
|----|-------------|
| R1 | User can log in with email and password |
| R2 | Invalid credentials return 401 |
| R3 | Token expires after 24 hours |

### Scenarios

**GIVEN** a registered user
**WHEN** they enter correct email and password
**THEN** they receive a valid JWT token

---

## 3. Design

### Architecture Decision

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Auth mechanism | JWT | Stateless, scalable |
| Token storage | HttpOnly cookie | XSS protection |

---

## 4. Tasks

- [ ] T1: Create \`POST /auth/login\` endpoint
- [ ] T2: Add JWT middleware
- [ ] T3: Write unit tests for login logic
- [ ] T4: Write integration tests for endpoint

---

## 5. Verification

- [ ] Login with valid credentials → 200 + token
- [ ] Login with invalid credentials → 401
- [ ] Token works for authenticated endpoints
- [ ] Token expires after 24 hours

---

## Key Takeaways

1. The SDD cycle brings clarity BEFORE writing code
2. Specs define WHAT, design defines HOW
3. Tasks are granular and testable
4. Verification proves it works"

  # 9. Technical debt tracker
  create_file "docs/tech-debt.md" \
"# Technical Debt

> Track and prioritize technical debt items.

---

## Active Debt

| ID | Description | Impact | Effort | Status |
|----|-------------|--------|--------|--------|
| TD-001 | [Item] | High/Medium/Low | S/M/L | 🟡 |

---

## Resolved Debt

| ID | Description | Resolution | Date |
|----|-------------|------------|------|
| - | - | - | - |

---

## Conventions

- **Impact**: High (blocks features), Medium (slows down), Low (cosmetic)
- **Effort**: S (< 1 day), M (1-3 days), L (> 3 days)
- **Status**: 🟡 Open, 🟢 In Progress, ✅ Resolved

---

## Review Cadence

Review tech debt during cycle planning (Day 1-2). Prioritize at least one item per cycle."

  # 10. PRD stub
  create_file "docs/PRD.md" \
"# Product Requirements Document

**Project**: [Name]
**Owner**: @username
**Created**: YYYY-MM-DD
**Status**: Draft

---

## 🎯 Vision

[What is this project trying to achieve?]

## 👥 Users

| User | Needs | Pain Points |
|------|-------|-------------|
| [User 1] | [Needs] | [Pain points] |

## ✅ Requirements

### Must Have
- [Requirement]

### Should Have
- [Requirement]

### Nice to Have
- [Requirement]

## 🚫 Out of Scope

- [What is not included]

## 📊 Success Metrics

- [Metric 1]: [Target]

## 📝 Notes

[Any additional context]"

  # 11. Is it for me?
  create_file "docs/is-it-for-me.md" \
"# Is FlowDoc for Me?

> A quick self-assessment to determine if FlowDoc fits your context.

---

## ✅ FlowDoc is for you if:

- You work on distributed or async teams
- You want documentation that stays in sync with code
- You prefer simple markdown over complex tools
- You want structure without bureaucracy
- You value async communication over meetings

---

## ❌ FlowDoc is probably NOT for you if:

- Your team is fully co-located and prefers real-time sync
- You already have a documented process that works well
- You need strict compliance (ISO, SOC2 — though FlowDoc can be adapted)
- Your project is < 1 week of work

---

## The Litmus Test

Try this for one week:

1. Create \`docs/tasks/HU-001.md\` for your next feature
2. Document what it does, criteria, scenarios
3. See if it helps clarity

If it helps → adopt more. If it does not → no harm done.

---

## Next Steps

- [Adoption Guide](adoption-guide.md) — choose your level
- [Quick Start](../QUICKSTART.md) — get started in 5 minutes
- [FAQ](FAQ.md) — common questions"
}

# ==================================================================
# Phase 2: ADR placeholders (T10)
# 8 ADR stubs 001–008
# ==================================================================
create_placeholder_adrs() {
  echo ""
  echo -e "${BOLD}📋 Creating ADR stubs...${NC}"

  create_file "docs/architecture/adr/001-persistencia-engram.md" \
"# ADR-001: Persistence with Engram

**Date**: YYYY-MM-DD
**Status**: Accepted

---

## Context

FlowDoc needed persistent memory across sessions. Options evaluated: file-based only, in-memory, Engram.

## Decision

Use Engram as the primary persistence backend for SDD artifacts.

## Consequences

### ✅ Positive
- Survives across sessions and compactions
- FTS5 full-text search
- Topic keys for evolving topics

### ❌ Negative
- Requires external Engram service
- Not shareable across teams (use openspec for teams)

### 🔄 Neutral
- Learning curve for Engram conventions"

  create_file "docs/architecture/adr/002-docs-source-of-truth.md" \
"# ADR-002: docs/ as Source of Truth

**Date**: YYYY-MM-DD
**Status**: Accepted

---

## Context

Multiple AI tools can interact with the project. We needed a single source of truth.

## Decision

\`docs/\` is the canonical source of truth. Templates moved from \`templates/\` to \`docs/templates/\`.

## Consequences

### ✅ Positive
- Single location for all documentation
- AI tools only need to read \`docs/\`
- Git-tracked, human-readable

### ❌ Negative
- \`docs/\` is deeper nested for templates

### 🔄 Neutral
- Requires migration from old \`templates/\` location"

  create_file "docs/architecture/adr/003-ciclo-15-dias.md" \
"# ADR-003: 15-Day Cycle

**Date**: YYYY-MM-DD
**Status**: Accepted

---

## Context

Distributed teams needed a predictable cadence. Options: standard Scrum sprints, Kanban, 15-day adapted cycle.

## Decision

Adopt a 15-day adapted cycle based on Scrum, not mandatory.

## Consequences

### ✅ Positive
- Predictable cadence for distributed teams
- Flexible — teams can adapt

### ❌ Negative
- Can feel like imposed process

### 🔄 Neutral
- Reference only — not enforced by tooling"

  create_file "docs/architecture/adr/004-feature-flags.md" \
"# ADR-004: Feature Flags for Parallel Work

**Date**: YYYY-MM-DD
**Status**: Accepted

---

## Context

Multiple team members working in parallel needed a way to isolate incomplete features.

## Decision

Use feature flags to decouple deployment from release.

## Consequences

### ✅ Positive
- Parallel work without merge conflicts
- Can deploy without releasing
- A/B testing capability

### ❌ Negative
- Additional complexity
- Flag cleanup required

### 🔄 Neutral
- Requires discipline to remove old flags"

  create_file "docs/architecture/adr/005-organizacion-hu.md" \
"# ADR-005: HU Organization

**Date**: YYYY-MM-DD
**Status**: Accepted

---

## Context

User stories (HUs) needed a consistent naming and organization scheme.

## Decision

HUs are grouped in ranges of 100 under \`docs/tasks/HU-001-HU-099/\`, named \`HU-NNN-name.md\`.

## Consequences

### ✅ Positive
- Consistent naming across the project
- Easy to find by range
- Clear ownership

### ❌ Negative
- Manual range management

### 🔄 Neutral
- Ranges are a convention, not enforced"

  create_file "docs/architecture/adr/006-cuatro-arquitecturas.md" \
"# ADR-006: Four Architecture Guides

**Date**: YYYY-MM-DD
**Status**: Accepted

---

## Context

FlowDoc needed architecture-specific guidance to help teams adopt the framework regardless of their stack architecture.

## Decision

Provide four architecture guides: monolithic, microservices, monorepo, and serverless.

## Consequences

### ✅ Positive
- Teams can adopt FlowDoc regardless of architecture
- Clear patterns per architecture type

### ❌ Negative
- Maintenance of four guides

### 🔄 Neutral
- Guides are reference, not enforcement"

  create_file "docs/architecture/adr/007-estructura-templates.md" \
"# ADR-007: Template Structure

**Date**: YYYY-MM-DD
**Status**: Accepted

---

## Context

Templates needed to be organized logically and accessible to both humans and AI agents.

## Decision

Templates live under \`docs/templates/\` organized by type: user-stories, bug-fixes, refactors, architecture, database, api, PRD.

## Consequences

### ✅ Positive
- Clear organization by artifact type
- Easy to find the right template
- AI agents can read from single location

### ❌ Negative
- Deep nesting for specific templates

### 🔄 Neutral
- Template guide helps navigation"

  create_file "docs/architecture/adr/008-nombre-flowdoc.md" \
"# ADR-008: FlowDoc Name

**Date**: YYYY-MM-DD
**Status**: Accepted

---

## Context

The framework needed a name. Options considered: SDD-Docs, DocFlow, FlowDoc.

## Decision

Name the framework FlowDoc — documentation that flows with the work.

## Consequences

### ✅ Positive
- Memorable and descriptive
- Suggests documentation that stays in sync

### ❌ Negative
- None

### 🔄 Neutral
- Ecosystem branding: FlowForge (tool) + FlowDoc (framework)"
}

# ==================================================================
# Phase 2: RFC placeholders (T11)
# 4 RFC stubs 001–004
# ==================================================================
create_placeholder_rfcs() {
  echo ""
  echo -e "${BOLD}📋 Creating RFC stubs...${NC}"

  create_file "docs/architecture/rfc/001-estructura-docs.md" \
"# RFC-001: Documentation Structure

**Author**: @username
**Status**: Accepted
**Created**: YYYY-MM-DD

---

## Summary

Proposal to organize all project documentation under \`docs/\` with a consistent structure.

## Motivation

Multiple locations for docs created confusion. Teams needed a single source of truth.

## Proposed Solution

Centralize all documentation under \`docs/\`:
- \`docs/templates/\` — reusable templates
- \`docs/architecture/\` — ADRs and RFCs
- \`docs/tasks/\` — user stories
- \`docs/api/\` — API contracts
- \`docs/database/\` — database schemas

## Decision

Accepted. This structure is now the FlowDoc standard."

  create_file "docs/architecture/rfc/002-ciclo-15-dias.md" \
"# RFC-002: 15-Day Work Cycle

**Author**: @username
**Status**: Accepted
**Created**: YYYY-MM-DD

---

## Summary

Proposal for a 15-day adapted development cycle for distributed teams.

## Motivation

Distributed teams needed predictability without rigid Scrum ceremonies.

## Proposed Solution

15-day cycle with async-first communication:
- Days 1-2: Planning
- Days 3-11: Development
- Days 12-14: Integration
- Day 15: Retrospective

## Decision

Accepted. The cycle is a reference, not mandatory."

  create_file "docs/architecture/rfc/003-feature-flags.md" \
"# RFC-003: Feature Flags

**Author**: @username
**Status**: Accepted
**Created**: YYYY-MM-DD

---

## Summary

Adopt feature flags to enable parallel development without merge conflicts.

## Motivation

Multiple team members working on the same codebase needed to isolate incomplete features.

## Proposed Solution

Use feature flags to decouple deployment from release. Flags are managed per environment.

## Decision

Accepted. Feature flags are recommended but not enforced by tooling."

  create_file "docs/architecture/rfc/004-propuesta-unificada-equipo-deprecada.md" \
"# RFC-004: Unified Team Proposal (DEPRECATED)

**Author**: @username
**Status**: Deprecated
**Created**: YYYY-MM-DD

---

## Summary

This RFC proposed a unified team workflow. It has been superseded by AGENTS.md and the SDD workflow.

## Deprecation Reason

The proposal was absorbed into AGENTS.md and the core workflow. Individual team conventions are now documented in AGENTS.md per project.

## Superseded By

- AGENTS.md — current team conventions
- \`docs/flowdoc-ciclo.md\` — work cycle
- SDD workflow — spec-driven development cycle"
}

# ==================================================================
# Phase 2: HU examples (T12)
# 2 HU examples in docs/tasks/HU-001-HU-099/
# ==================================================================
create_hu_examples() {
  echo ""
  echo -e "${BOLD}📋 Creating HU examples...${NC}"

  create_file "docs/tasks/HU-001-HU-099/HU-001-onboarding-docs.md" \
"# HU-001: Onboarding Documentation

**Status**: 🟢 Done
**Owner**: @team
**Created**: YYYY-MM-DD
**Priority**: Must

---

## 🎯 Intent

Create a comprehensive onboarding guide so new team members can be productive within their first week.

---

## 📋 Scope

### In Scope
- Day-by-day onboarding checklist
- Tool setup instructions
- Links to key documentation

### Out of Scope
- Deep architecture training (separate session)
- Pair programming schedule

---

## ✅ Requirements

### MUST
- Checklist covers first 5 days
- All links verified and working
- Access instructions for all tools

### SHOULD
- Videos for complex setup steps
- FAQ section

---

## 🧪 Scenarios

### Happy Path

**GIVEN** a new team member joining
**WHEN** they follow the onboarding checklist
**THEN** they have repo access, understand the workflow, and can pick up a small task within 5 days

---

## 📦 Affected Areas

- \`ONBOARDING.md\`
- \`docs/flowdoc-ciclo.md\`
- Repository access configuration

---

## 📖 Notes

This HU is an example. Use it as a reference for your own user stories."

  create_file "docs/tasks/HU-001-HU-099/HU-002-validacion-hus.md" \
"# HU-002: HU Validation Tool

**Status**: 🟡 In Progress
**Owner**: @username
**Created**: YYYY-MM-DD
**Priority**: Should

---

## 🎯 Intent

Create a validation script that checks user stories for completeness and consistency.

---

## 📋 Scope

### In Scope
- Check required sections (Intent, Scope, Requirements, Scenarios)
- Validate naming conventions (HU-NNN)
- Report missing fields

### Out of Scope
- Content quality analysis
- Automatic HU generation

---

## ✅ Requirements

### MUST
- Script accepts a file path as argument
- Reports missing sections
- Exit 0 on valid, exit 1 on issues

### SHOULD
- Batch mode for all HUs in a directory
- JSON output option

---

## 🧪 Scenarios

### Happy Path

**GIVEN** a well-formed HU file
**WHEN** validation runs
**THEN** reports \"✅ HU is valid\" and exits 0

### Missing Section

**GIVEN** an HU file without Scenarios section
**WHEN** validation runs
**THEN** reports \"❌ Missing: Scenarios\" and exits 1

---

## 📖 Notes

This HU is an example. Use it as a reference for your own user stories."
}

# ==================================================================
# Phase 2: Root files (T14)
# AGENTS.md, ONBOARDING.md, QUICKSTART.md, CHANGELOG.md
# ==================================================================
create_root_files() {
  echo ""
  echo -e "${BOLD}📄 Creating root files...${NC}"

  if [ "$AGENTS_MD_EXISTS" = true ]; then
    echo -e "  ${YELLOW}⚠️  Skipped (exists):${NC} AGENTS.md (protected)"
    ((SKIPPED_COUNT++)) || true
  else
    create_file "AGENTS.md" \
"# AGENTS.md — FlowDoc

**Framework**: FlowDoc — Documentation that flows with the work
**Ecosystem**: FlowForge (tool) + FlowDoc (framework)
**Stack**: [Your stack here]
**Artifact Store**: Engram (default) or openspec (for teams)

---

## Sources of Truth

- **PRD**: \`docs/PRD.md\`
- **Architecture decisions**: \`docs/architecture/adr/\`
- **RFC (discussion)**: \`docs/architecture/rfc/\`
- **User stories**: \`docs/tasks/\`
- **API contracts**: \`docs/api/\`

---

## Conventions

### Commit Conventions (Conventional Commits)

\`\`\`
feat: add reservation system with date picker
fix: resolve login timeout on mobile
refactor: extract payment logic to domain
docs: update API endpoint documentation
chore: update dependencies
\`\`\`

### Branch Naming

\`\`\`
feature/add-reservation-system
fix/login-timeout
refactor/order-service
docs/api-endpoints
hotfix/critical-security-patch
\`\`\`

---

## Agent Rules

**This agent does NOT:**
- Make commits — that is the human's job
- Modify \`AGENTS.md\` without human approval
- Modify \`docs/\` without human approval
- Merge to \`main\` or \`staging\`

**This agent DOES:**
- Generate code in feature branches
- Propose changes, but always with human review
- Read from \`docs/\` to understand context

---

## Framework Documentation

- [Work Cycle](docs/flowdoc-ciclo.md)
- [Adoption Guide](docs/adoption-guide.md)
- [FAQ](docs/FAQ.md)
- [Anti-patterns](docs/anti-patrones.md)
- [Troubleshooting](docs/troubleshooting.md)"

  create_file "ONBOARDING.md" \
"# Onboarding — New Team Member

> Checklist for new team members.

---

## Day 1: Context

- [ ] Read \`AGENTS.md\` — how the team works
- [ ] Read \`docs/flowdoc-ciclo.md\` — work cycle
- [ ] Read \`docs/adoption-guide.md\` — adoption levels
- [ ] Have access to repo and tools

## Day 2-3: First Steps

- [ ] Review active HUs in \`docs/tasks/\`
- [ ] Identify dependencies
- [ ] Local project setup

## Day 4-5: First Contribution

- [ ] Take a small HU
- [ ] Follow the SDD cycle
- [ ] Code + test + docs

## Resources

- [FAQ](docs/FAQ.md) — Frequently asked questions
- [Troubleshooting](docs/troubleshooting.md) — Common errors
- [Anti-patterns](docs/anti-patrones.md) — What to avoid"
  fi

  create_file "QUICKSTART.md" \
"# Quick Start Guide

**How to use this framework in 5 minutes**

---

## 1. Create your first HU

Create \`docs/tasks/HU-001-your-feature.md\`:

\`\`\`markdown
# HU-001: My Feature

**Status**: 🟡 In Progress

## Description
[What it does]

## Criteria
- [ ] It works
- [ ] It is tested
\`\`\`

## 2. Follow the SDD Cycle

\`Proposal → Spec → Design → Tasks → Apply → Verify → Archive\`

## 3. Use the tools

- \`scripts/flowdoc-migration.sh\` — initialize structure
- \`scripts/flowdoc-audit.sh\` — verify structure
- \`scripts/flowdoc-check.sh\` — quick smoke test

---

## Next Steps

- [Adoption Guide](docs/adoption-guide.md)
- [Work Cycle](docs/flowdoc-ciclo.md)
- [FAQ](docs/FAQ.md)"

  create_file "CHANGELOG.md" \
"# Changelog

Documentation of changes and decisions adopted in the project.

---

## YYYY-MM-DD — FlowDoc Structure Created

### Structure

- \`docs/\` with templates, architecture, tasks
- \`AGENTS.md\` adapted to the project
- Base documentation: adoption-guide, FAQ, troubleshooting, anti-patterns

### Next Steps

- Review \`AGENTS.md\` and customize for your project
- Fill in \`docs/PRD.md\` with your product requirements
- Start creating HUs in \`docs/tasks/\`"
}

# ==================================================================
# Phase 2: .gitignore suggestions (T6)
# Stack-aware .gitignore.flowdoc-suggestions
# Satisfies R1.8
# ==================================================================
create_gitignore_suggestions() {
  echo ""
  echo -e "${BOLD}📄 Generating .gitignore.flowdoc-suggestions...${NC}"

  local generic_rules="# FlowDoc .gitignore suggestions
# Merge these rules into your .gitignore as needed.
#
# Detected stack: ${STACK}

# Dependencies
node_modules/
vendor/

# Build outputs
dist/
build/
*.log

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/

# Environment
.env
.env.local

# Agents (FlowDoc internals)
.engram/
openspec/

# Legacy templates (use docs/templates instead)
/templates/"

  local dotnet_rules="${generic_rules}

# .NET
bin/
obj/
*.user
*.suo
*.csproj.user
packages/"

  local node_rules="${generic_rules}

# Node.js
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.next/
.cache/"

  local python_rules="${generic_rules}

# Python
__pycache__/
*.py[cod]
*.egg-info/
.venv/
venv/"

  local java_rules="${generic_rules}

# Java / JVM
target/
*.class
*.jar
*.war
.gradle/
.idea/
*.iml"

  local content
  case "$STACK" in
    dotnet) content="$dotnet_rules" ;;
    node)   content="$node_rules" ;;
    python) content="$python_rules" ;;
    java)   content="$java_rules" ;;
    *)      content="$generic_rules" ;;
  esac

  # Always create .gitignore.flowdoc-suggestions (never overwrite .gitignore)
  if [ "$DRY_RUN" = true ]; then
    echo -e "  ${CYAN}🔍 Would create:${NC} .gitignore.flowdoc-suggestions (${STACK})"
    ((CREATED_COUNT++)) || true
  else
    printf '%s\n' "$content" > ".gitignore.flowdoc-suggestions"
    echo -e "  ${GREEN}✅ Created:${NC} .gitignore.flowdoc-suggestions (${STACK})"
    ((CREATED_COUNT++)) || true
  fi

  # If .gitignore does NOT exist, create a generic one from the user instructions
  if [ "$GITIGNORE_EXISTS" = false ]; then
    create_file ".gitignore" \
"# Dependencies
node_modules/
vendor/

# Build outputs
dist/
build/
*.log

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/

# Environment
.env
.env.local

# Agents (FlowDoc internals)
.engram/
openspec/

# Legacy templates (use docs/templates instead)
/templates/"
  fi
}

# ==================================================================
# Phase 2: ES mirror (T13)
# Copies full EN structure to es/ with placeholder content
# Satisfies R1.10
# ==================================================================
create_es_mirror() {
  echo ""
  echo -e "${BOLD}🌐 Creating ES mirror structure...${NC}"

  if [ "$DRY_RUN" = true ]; then
    echo -e "  ${CYAN}🔍 Would create:${NC} es/ mirror of docs/ and scripts/"
    ((CREATED_COUNT++)) || true
    return 0
  fi

  # Create mirror directories
  mkdir -p "es/docs/templates/user-stories"
  mkdir -p "es/docs/templates/bug-fixes"
  mkdir -p "es/docs/templates/refactors"
  mkdir -p "es/docs/templates/architecture"
  mkdir -p "es/docs/templates/database"
  mkdir -p "es/docs/templates/api"
  mkdir -p "es/docs/templates/PRD"
  mkdir -p "es/docs/architecture/adr"
  mkdir -p "es/docs/architecture/rfc"
  mkdir -p "es/docs/tasks/HU-001-HU-099"
  mkdir -p "es/docs/api"
  mkdir -p "es/docs/database"
  mkdir -p "es/docs/observaciones"
  mkdir -p "es/scripts"

  # Copy all EN files to ES as structural placeholders
  # (same content as EN — translation is out of scope for this phase)
  if [ -d "docs" ]; then
    cp -r docs/* "es/docs/" 2>/dev/null || true
  fi
  if [ -d "scripts" ]; then
    cp -r scripts/* "es/scripts/" 2>/dev/null || true
  fi
  if [ -f "AGENTS.md" ]; then
    cp AGENTS.md "es/AGENTS.md" 2>/dev/null || true
  fi
  if [ -f "ONBOARDING.md" ]; then
    cp ONBOARDING.md "es/ONBOARDING.md" 2>/dev/null || true
  fi
  if [ -f "QUICKSTART.md" ]; then
    cp QUICKSTART.md "es/QUICKSTART.md" 2>/dev/null || true
  fi
  if [ -f "CHANGELOG.md" ]; then
    cp CHANGELOG.md "es/CHANGELOG.md" 2>/dev/null || true
  fi

  echo -e "  ${GREEN}✅ Created:${NC} es/ mirror (structural placeholders)"
  ((CREATED_COUNT++)) || true
}

# ==================================================================
# Phase 2: Print summary (T14)
# ==================================================================
print_summary() {
  echo ""
  echo -e "${GREEN}========================================${NC}"
  echo -e "${GREEN}✅ FlowDoc Migration Complete${NC}"
  echo -e "${GREEN}========================================${NC}"
  echo ""
  echo "  Files created: ${CREATED_COUNT}"
  echo "  Files skipped: ${SKIPPED_COUNT}"
  if [ -n "$BACKUP_DIR" ]; then
    echo "  Backup: ${BACKUP_DIR}/"
  fi
  echo "  Stack detected: ${STACK}"
  echo ""
  echo "Next steps:"
  echo "  1. Review AGENTS.md and customize for your project"
  echo "  2. Review .gitignore.flowdoc-suggestions and merge into your .gitignore"
  echo "  3. Run scripts/flowdoc-audit.sh to verify structure"
  echo "  4. Run scripts/flowdoc-check.sh for a quick smoke test"
  echo "  5. Start creating HUs in docs/tasks/"
  if [ "$DRY_RUN" = true ]; then
    echo ""
    echo -e "${CYAN}🔍 This was a dry run. No files were modified.${NC}"
    echo "   Run without --dry-run to create the structure."
  fi
  echo ""
}

# ==================================================================
# Main orchestration
# ==================================================================
main() {
  echo ""
  echo -e "${BOLD}🚀 FlowDoc Migration Script v2${NC}"
  echo -e "${BOLD}================================${NC}"
  echo ""

  # Phase 1: Parse flags
  parse_flags "$@"

  # Phase 1: Pre-checks (order matters — each builds on the previous)
  echo -e "${BOLD}🔍 Pre-checks...${NC}"
  if ! is_project_root; then
    echo -e "${RED}❌ Could not detect a project root.${NC}"
    echo "   Run this script from the root directory of your project."
    echo "   Look for: .git/, src/, docs/, package.json, *.csproj, etc."
    exit 2
  fi
  echo "  ✅ Project root detected"

  has_write_perms
  echo "  ✅ Write permissions OK"

  guard_agents_md
  echo "  ✅ AGENTS.md check passed"

  guard_gitignore

  # Phase 1: Stack detection
  detect_stack

  # Dry-run: show the plan and exit
  if [ "$DRY_RUN" = true ]; then
    echo ""
    echo -e "${CYAN}🔍 DRY RUN — showing what would be created:${NC}"
    echo ""
  fi

  # Phase 2: Backup (only when --force)
  create_backup

  # Phase 2: Structure creation
  create_dirs
  create_templates
  create_base_docs
  create_placeholder_adrs
  create_placeholder_rfcs
  create_hu_examples
  create_root_files
  create_gitignore_suggestions
  create_es_mirror

  # Print summary
  print_summary
}

# Entry point
main "$@"

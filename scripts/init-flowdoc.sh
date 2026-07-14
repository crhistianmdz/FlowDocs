#!/bin/bash
# ============================================================================
# FlowDoc Init Script v2.0
# Bootstrap a NEW project with FlowDoc v2.0 documentation structure.
#
# Usage:
#   bash init-flowdoc.sh                  # interactive setup (default)
#   bash init-flowdoc.sh --dry-run        # preview only, no files written
#   bash init-flowdoc.sh --force          # overwrite existing files
#   bash init-flowdoc.sh --update         # create missing files, skip existing
#   bash init-flowdoc.sh --help           # show usage
#
# Requirements: Bash 4+, runs on macOS and Linux.
#
# For EXISTING projects that already have docs, use:
#   bash scripts/flowdoc-migration.sh
# ============================================================================

set -euo pipefail

# ------------------------------------------------------------------
# Global state
# ------------------------------------------------------------------
DRY_RUN=false
FORCE=false
UPDATE=false
LEGACY=false
OVERWRITE=false
NO_EXPLORE=false
CHECK=false
STACK="generic"
PROJECT_NAME=""
CREATED_COUNT=0
SKIPPED_COUNT=0
# Phase 3: Exploration data globals (populated by explore_codebase)
EXPLORE_ENTRIES=""
EXPLORE_APIS=""
EXPLORE_DBS=""
EXPLORE_DOCS=""

# ------------------------------------------------------------------
# Required directories and files for --check mode
# ------------------------------------------------------------------
REQUIRED_DIRS=(
  "docs"
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
)

REQUIRED_FILES=(
  "AGENTS.md"
  "docs/flowDocs/AGENT_MANUAL.md"
  "docs/flowDocs/flowdoc-migration-prompt.md"
  "docs/templates/TEMPLATE_GUIDE.md"
  "docs/adoption-guide.md"
)

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
# Helper: create_file <path> <content> [force_override]
# Idempotent file creation. Skips if file exists (unless --force).
# Creates parent directories via mkdir -p.
# If force_override is "true", skip the exists check (used by --overwrite for PRD).
# ------------------------------------------------------------------
create_file() {
  local path="$1"
  local content="$2"
  local force_override="${3:-false}"

  if [ -f "$path" ] && [ "$FORCE" != true ] && [ "$force_override" != true ]; then
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
# Task 1.1: Flag parsing
# ==================================================================
show_help() {
  cat << 'HELP_EOF'
FlowDoc Init Script v2.0 — Bootstrap a new project with FlowDoc

Usage: bash init-flowdoc.sh [FLAGS]

Flags:
  --help, -h      Show this help and exit
  --dry-run       Preview: show what would be created without writing files
  --force         Overwrite existing files (safe: AGENTS.md is always protected)
  --update        Only create missing files, skip existing
  --legacy        Run in legacy adoption mode (for projects with existing code)
  --overwrite     Overwrite existing files (for PRD in legacy mode)
  --no-explore    Skip codebase exploration in legacy mode
  --check         Verify structure without migrating (smoke test)

Examples:
  bash scripts/init-flowdoc.sh               # interactive setup
  bash scripts/init-flowdoc.sh --dry-run     # preview what would be created
  bash scripts/init-flowdoc.sh --force       # overwrite + recreate
  bash scripts/init-flowdoc.sh --legacy      # adopt FlowDocs in existing project
  bash scripts/init-flowdoc.sh --legacy --no-explore  # skip codebase exploration
  bash scripts/init-flowdoc.sh --check        # verify structure (smoke test)

What this script creates:
  - docs/ directory structure (v2.0)
  - docs/PRD.md from 3 interactive questions
  - Stack detection: dotnet, node, python, java, or generic

For EXISTING projects with documentation already in place, use:
  bash scripts/init-flowdoc.sh --legacy

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
      --legacy)
        LEGACY=true
        shift
        ;;
      --overwrite)
        OVERWRITE=true
        shift
        ;;
      --no-explore)
        NO_EXPLORE=true
        shift
        ;;
      --check)
        CHECK=true
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
# Task 4.2: Auto-detect existing code hint
# Checks for common code indicators (config files, source dirs, source files).
# Returns 0 if code is found (so it can be used in conditionals).
# Only shown in normal mode (not --legacy) to guide users toward --legacy.
# ==================================================================
detect_existing_code() {
  # Project config files (same markers as detect_stack)
  [ -f "package.json" ] && return 0
  [ -f "pom.xml" ] && return 0
  [ -f "go.mod" ] && return 0
  [ -f "requirements.txt" ] && return 0
  [ -f "setup.py" ] && return 0
  [ -f "pyproject.toml" ] && return 0
  compgen -G "*.csproj" > /dev/null 2>&1 && return 0
  compgen -G "*.sln" > /dev/null 2>&1 && return 0
  # Source directories
  [ -d "src" ] && return 0
  # Source code files (check for actual source, not just config)
  local source_files
  source_files=$(find . -maxdepth 2 \( -name '*.ts' -o -name '*.js' -o -name '*.py' -o -name '*.go' -o -name '*.rs' -o -name '*.java' -o -name '*.cs' \) -type f 2>/dev/null | head -1)
  [ -n "$source_files" ] && return 0
  return 1
}

# ==================================================================
# Task 1.2: Stack detection
# Detects project stack from common config files.
# Falls back to "generic" if no known stack markers found.
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
# Task 1.3: Create docs/ v2.0 directory structure
# 12 directories total under docs/.
# Uses mkdir -p with dry-run support.
# ==================================================================
create_dirs() {
  echo ""
  echo -e "${BOLD}📁 Creating v2.0 directory structure...${NC}"

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
    "docs/api"
    "docs/database"
    "docs/tasks/HU-001-HU-099"
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
# Task 1.4: File protection
# AGENTS.md: never overwrite. If exists and not --update, exit with error.
# .gitignore: never overwrite. Create .gitignore.flowdoc-suggestions instead.
# ==================================================================
guard_agents_md() {
  if [ -f "AGENTS.md" ]; then
    if [ "$UPDATE" = true ]; then
      # In update mode, AGENTS.md already exists from a previous FlowDoc run.
      # Skip it gracefully — never overwrite AGENTS.md.
      echo -e "${YELLOW}⚠️  AGENTS.md already exists — skipping (update mode).${NC}"
      return 0
    fi
    # In default or force mode, AGENTS.md existing means the user has
    # a pre-existing agent configuration we MUST protect.
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
  fi
}

# ==================================================================
# Task 1.6: Interactive PRD creation
# Asks 3 questions via read -p, generates docs/PRD.md.
# Questions have defaults. Dry-run mode skips interaction.
# ==================================================================
create_prd() {
  echo ""
  echo -e "${BOLD}📋 Product Requirements Document...${NC}"

  # Dry-run: show intent but don't interact
  if [ "$DRY_RUN" = true ]; then
    echo -e "  ${CYAN}🔍 Would create:${NC} docs/PRD.md (interactive, 3 questions)"
    ((CREATED_COUNT++)) || true
    return 0
  fi

  # Check if PRD already exists before asking questions
  if [ -f "docs/PRD.md" ] && [ "$FORCE" != true ]; then
    echo -e "  ${YELLOW}⚠️  Skipped (exists):${NC} docs/PRD.md"
    ((SKIPPED_COUNT++)) || true
    return 0
  fi

  # Non-interactive fallback: create a stub PRD
  if [ ! -t 0 ]; then
    echo -e "  ${YELLOW}⚠️  Non-interactive mode — creating stub PRD.${NC}"
    echo "     Run interactively to answer the 3 setup questions."

    PROJECT_NAME="My Project"

    local today
    today=$(date +%Y-%m-%d)

    local stub_content="# My Project — Product Requirements Document

**Project:** My Project
**Owner:** @username
**Created:** ${today}
**Status:** Draft

---

## 🎯 Vision

[What is this project trying to achieve? What problem does it solve?]

## 👥 Users

| User | Needs | Pain Points |
|------|-------|-------------|
| [User 1] | [Needs] | [Pain points] |

## 🛠️ Tech Stack

- [Technology 1]
- [Technology 2]

## 👥 Team

- **Size & timezones**: [e.g., 3 people, GMT-3 and GMT+1]
- **Communication**: [e.g., Discord, Slack, Teams]

## ✅ Requirements

### Must Have
- [Requirement]

### Should Have
- [Requirement]

### Nice to Have
- [Requirement]

## 🚫 Out of Scope

- [What is NOT included in this phase]

## 📊 Success Metrics

- [Metric 1]: [Target]
- [Metric 2]: [Target]

## 📝 Notes

[Any additional context, risks, dependencies]"

    create_file "docs/PRD.md" "$stub_content"
    return 0
  fi

  # Interactive mode: ask 3 questions
  echo ""
  echo -e "${BOLD}Let's set up your PRD (press Enter to use defaults):${NC}"
  echo ""

  local tech_stack
  local team_info
  local today
  today=$(date +%Y-%m-%d)

  # Question 1: Project name → PRD title (also stored globally for AGENTS.md)
  read -r -p "  Project name [My Project]: " PROJECT_NAME
  PROJECT_NAME="${PROJECT_NAME:-My Project}"

  # Question 2: Tech stack → Tech Stack section
  read -r -p "  Tech stack, comma-separated [To be defined]: " tech_stack
  tech_stack="${tech_stack:-To be defined}"

  # Question 3: Team info → Team section
  read -r -p "  Team size and timezones [1 person, async]: " team_info
  team_info="${team_info:-1 person, async}"

  # Build tech stack items as a bullet list
  local tech_items=""
  IFS=',' read -ra techs <<< "$tech_stack"
  for tech in "${techs[@]}"; do
    # Trim whitespace
    tech=$(echo "$tech" | xargs)
    tech_items+="- ${tech}"$'\n'
  done

  # Build the PRD content
  local content="# ${PROJECT_NAME} — Product Requirements Document

**Project:** ${PROJECT_NAME}
**Owner:** @username
**Created:** ${today}
**Status:** Draft

---

## 🎯 Vision

[What is this project trying to achieve? What problem does it solve?]

## 👥 Users

| User | Needs | Pain Points |
|------|-------|-------------|
| [User 1] | [Needs] | [Pain points] |

## 🛠️ Tech Stack

${tech_items}
## 👥 Team

- **Size & timezones**: ${team_info}
- **Communication**: [e.g., Discord, Slack, Teams]

## ✅ Requirements

### Must Have
- [Requirement]

### Should Have
- [Requirement]

### Nice to Have
- [Requirement]

## 🚫 Out of Scope

- [What is NOT included in this phase]

## 📊 Success Metrics

- [Metric 1]: [Target]
- [Metric 2]: [Target]

## 📝 Notes

[Any additional context, risks, dependencies]"

  create_file "docs/PRD.md" "$content"
}

# ==================================================================
# Task 2.1: Stack-aware AGENTS.md generation
# Generates AGENTS.md content adapted to the detected stack.
# Uses PROJECT_NAME (from create_prd) and STACK (from detect_stack).
# ==================================================================
create_agents_md() {
  echo ""
  echo -e "${BOLD}📄 Generating AGENTS.md (${STACK} stack)...${NC}"

  local content
  local stack_label
  local stack_conventions=""

  # Stack-specific label and conventions
  case "$STACK" in
    dotnet)
      stack_label=".NET / C#"
      stack_conventions="### .NET Conventions

- Use \`dotnet format\` for consistent code style
- Follow Microsoft's C# coding conventions
- Solution structure: \`src/ProjectName/\` per project
- Test projects in \`tests/ProjectName.Tests/\`
"
      ;;
    node)
      stack_label="Node.js / TypeScript"
      stack_conventions="### Node.js Conventions

- Package manager: \`npm\` (or \`pnpm\`/\`yarn\` if configured)
- TypeScript strict mode recommended
- Use ES modules (\`\"type\": \"module\"\` in package.json)
- Source in \`src/\`, tests in \`tests/\` or colocated \`*.test.ts\`
"
      ;;
    python)
      stack_label="Python"
      stack_conventions="### Python Conventions

- Virtual environment: \`venv\` or \`poetry\`
- Package manager: \`pip\` (or \`poetry\`/\`uv\` if configured)
- Follow PEP 8 style guide
- Type hints recommended for all function signatures
- Tests with \`pytest\`, source in \`src/\` or project root
"
      ;;
    java)
      stack_label="Java"
      stack_conventions="### Java Conventions

- Build tool: Maven (\`pom.xml\`) or Gradle (\`build.gradle\`)
- Package structure: \`com.company.project\`
- Follow Google Java Style or Sun conventions
- Tests with JUnit 5, source in \`src/main/java/\`, tests in \`src/test/java/\`
"
      ;;
    *)
      stack_label="[your stack here]"
      ;;
  esac

  content="# AGENTS.md — ${PROJECT_NAME}

**Framework**: FlowDoc — Documentation that flows with the work
**Project**: ${PROJECT_NAME}
**Stack**: ${stack_label}

---

## Project Structure

\`\`\`
docs/                          <- DOCUMENTATION (source of truth)
├── PRD.md                     <- Product Requirements Document
├── architecture/
│   ├── adr/                   <- Architecture Decision Records (permanent)
│   └── rfc/                   <- Requests for Comments (in discussion)
├── api/                       <- API Contracts
├── database/                  <- DB Schema
├── templates/                 <- Templates for user stories, bugs, etc.
└── tasks/                     <- Active work items
\`\`\`

---

## Sources of Truth

| Document | Location | Purpose |
|----------|----------|---------|
| **PRD** | \`docs/PRD.md\` | What this project is |
| **Decisions** | \`docs/architecture/adr/\` | Technical decisions |
| **Proposals** | \`docs/architecture/rfc/\` | Under discussion |
| **API** | \`docs/api/\` | Service contracts |
| **Database** | \`docs/database/\` | Schema |

---

## Conventions

### Commit Conventions (Conventional Commits)

\`\`\`
feat: add user authentication with JWT
fix: resolve race condition in order processing
refactor: extract payment logic to domain service
docs: update API endpoint documentation
chore: update dependencies
\`\`\`

### Branch Naming

\`\`\`
feature/add-user-auth
fix/login-timeout
refactor/order-service
docs/api-endpoints
hotfix/critical-security-patch
\`\`\`

${stack_conventions}
---

## AI Agent Rules

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

## AI Agent Quick Reference

**Legacy project?** Start with [docs/flowDocs/flowdoc-migration-prompt.md](docs/flowDocs/flowdoc-migration-prompt.md) — it guides you through the migration process.

**Don't know what to do?** See [docs/flowDocs/AGENT_MANUAL.md](docs/flowDocs/AGENT_MANUAL.md)

**Rule**: When in doubt → Ask the developer. No guesses.

---

**Last updated**: $(date +%Y-%m-%d)"

  create_file "AGENTS.md" "$content"
}

# ==================================================================
# Task 2.3: Stack-aware .gitignore suggestions
# Creates .gitignore.flowdoc-suggestions with rules per stack.
# If .gitignore already exists, creates the suggestions file.
# If no .gitignore, also creates .gitignore.flowdoc-suggestions
# (user can rename it to .gitignore manually).
# ==================================================================
create_gitignore_suggestions() {
  echo ""
  echo -e "${BOLD}📄 Generating .gitignore.flowdoc-suggestions (${STACK} stack)...${NC}"

  local rules

  case "$STACK" in
    dotnet)
      rules="# .NET / C# — FlowDoc suggested ignores
# Rename this file to .gitignore or merge into your existing .gitignore

# Build outputs
bin/
obj/

# User-specific files
*.user
*.suo

# Visual Studio
.vs/

# Compiled output
*.dll
*.exe
*.pdb

# NuGet
*.nupkg
**/packages/*

# Test results
TestResults/
*.trx
"
      ;;
    node)
      rules="# Node.js / TypeScript — FlowDoc suggested ignores
# Rename this file to .gitignore or merge into your existing .gitignore

# Dependencies
node_modules/

# Build outputs
dist/
.next/
.nuxt/
.parcel-cache/

# TypeScript
*.tsbuildinfo

# Testing
coverage/

# Environment
.env
.env.local
.env.*.local

# Logs
*.log
npm-debug.log*
"
      ;;
    python)
      rules="# Python — FlowDoc suggested ignores
# Rename this file to .gitignore or merge into your existing .gitignore

# Byte-compiled / optimized
__pycache__/
*.py[cod]
*$py.class

# Virtual environments
venv/
.venv/
env/

# Distribution / packaging
*.egg-info/
dist/
build/

# Testing
.pytest_cache/
.mypy_cache/
.coverage
htmlcov/

# Environment
.env
.env.local

# IDE
.idea/
.vscode/
"
      ;;
    java)
      rules="# Java — FlowDoc suggested ignores
# Rename this file to .gitignore or merge into your existing .gitignore

# Build outputs
target/
*.class
*.jar
*.war

# Gradle
.gradle/
build/
!gradle/wrapper/gradle-wrapper.jar

# IDE
.idea/
*.iml
.project
.classpath
.settings/

# Logs
*.log
"
      ;;
    *)
      rules="# FlowDoc suggested ignores
# Rename this file to .gitignore or merge into your existing .gitignore

# OS files
.DS_Store
Thumbs.db

# Logs
*.log

# Environment
.env
.env.local

# IDE
.idea/
.vscode/
"
      ;;
  esac

  create_file ".gitignore.flowdoc-suggestions" "$rules"
}

# ==================================================================
# Task 3.1: Single-entry-point README.md
# Creates README.md with ONE prominent CTA: run init-flowdoc.sh.
# Includes expandable sections, golden rules, and reference links.
# ==================================================================
create_readme() {
  echo ""
  echo -e "${BOLD}📄 Generating README.md (single entry point)...${NC}"

  local content
  content=$(cat << 'READMEEOF'
# FlowDoc

**Documentation framework for software projects — Tool-agnostic, AI-ready**

*Documentation that flows with the work.*

---

## Get Started in 5 Minutes

```bash
bash scripts/init-flowdoc.sh
```

This single command bootstraps your project with FlowDoc v2.0 — docs structure, PRD, stack-aware AGENTS.md, and more.

---

<details>
<summary><b>Want to understand first?</b></summary>

- [Is FlowDoc for you?](docs/is-it-for-me.md) — Profiles, signals, comparisons
- [Adoption guide](docs/adoption-guide.md) — 3 levels, pick what fits
- [FAQ](docs/FAQ.md) — Common questions

</details>

<details>
<summary><b>Prefer manual setup?</b></summary>

Follow the [Quick Start guide](QUICKSTART.md) for step-by-step manual setup — equivalent to what the script generates automatically.

</details>

---

## What is FlowDoc?

FlowDoc is a **documentation framework** — just documentation structure that any team or AI agent can read and use.

With FlowDoc, every decision, API contract, and database schema lives in `docs/` — structured, searchable, and AI-readable.

---

## Architecture-Specific Guides

FlowDoc adapts to your project's architecture:

- [Monolith](reference/monolitico/) — Single app, simple structure
- [Microservices](reference/microservicios/) — Independent services
- [Monorepo](reference/monorepo/) — Multiple packages
- [Serverless](reference/serverless/) — Functions-first

---

## Golden Rules

| Rule | Why |
|------|-----|
| If there is no ADR, the decision does not exist | Prevents "I think we agreed on that" |
| Docs updated in the same PR as code | Prevents documentation rot |
| Copy from `docs/templates/` | Ensures consistency |

---

## AI Agent Integration

FlowDocs is designed so any AI agent can understand your project:

| Tool | How it works |
|------|-------------|
| OpenCode | Reads `AGENTS.md` → points to `docs/` |
| Antigravity | Reads `AGENTS.md` → points to `docs/` |
| ClaudeCode | Reads `docs/` directly |
| GitHub Copilot | Indexes `docs/` automatically |
| Cursor | Indexes `docs/` automatically |

---

**Version 2.0** — [Changelog](CHANGELOG.md)
READMEEOF
)

  create_file "README.md" "$content"
}

# ==================================================================
# Task 3.2: Unified 3-level adoption guide
# Creates docs/adoption-guide.md (EN) with 3 levels only.
# Copies same content to es/docs/adoption-guide.md (translated later).
# ==================================================================
create_adoption_guide() {
  echo ""
  echo -e "${BOLD}📄 Generating adoption-guide.md (3 levels, EN + ES)...${NC}"

  local content
  content=$(cat << 'ADOPTIONEOF'
# Adoption Guide — How to Adopt FlowDocs

> You don't have to adopt everything at once. Choose the level that fits your context.

---

## Adoption Levels

```
┌─────────────────────────────────────────────────────────────┐
│  Level 3: Complete Documentation                             │
│  RFC system + Templates + Decision tracking                 │
├─────────────────────────────────────────────────────────────┤
│  Level 2: Decisions                                         │
│  ADRs for all technical decisions                          │
├─────────────────────────────────────────────────────────────┤
│  Level 1: Structure                                         │
│  docs/ folder with templates                               │
└─────────────────────────────────────────────────────────────┘
```

---

## Level 1: Structure

**Ideal for**: Single person, small projects, starting to document.

### What to do

1. Create `docs/` folder
2. Copy templates from `docs/templates/`
3. Start with `docs/PRD.md` (what is this project)

### What you get

- A clear place for documentation
- Any agent can read `docs/` and understand context
- No process overhead, just files

### When to move to Level 2

When you make a technical decision that others need to know about.

---

## Level 2: Decisions

**Ideal for**: Teams that make technical decisions.

### What to add

1. **ADRs** for every significant decision
2. Use `docs/templates/architecture/ADR_template.md`

### What you get

- Past decisions are recorded
- New team members understand why things are done this way
- "If there's no ADR, the decision doesn't exist"

### When to move to Level 3

When you need a formal process for discussing proposals before deciding.

---

## Level 3: Complete Documentation

**Ideal for**: Teams that need to discuss technical proposals.

### What to add

1. **RFC system** for proposals under discussion
2. Use `docs/templates/architecture/RFC_template.md`
3. Define max time for RFCs (2 weeks recommended)

### What you get

- Formal space to discuss proposals
- Team input before committing to a decision
- Clear path: RFC → ADR (when decided) or RFC → Closed (if no consensus)

---

## How Do I Know if FlowDocs is Working?

| Indicator | What to look for |
|-----------|------------------|
| **Accessible docs** | When someone asks "how does X work?" → answer is in `docs/` |
| **Decisions recorded** | No more "I think we agreed on that" |
| **Faster onboarding** | New member can find context without asking everything |
| **Less rework** | Decisions are documented, not forgotten |

### The only metric that matters

**Is it saving you time or not?**

If you spend more time maintaining docs than you save using them, simplify.

---

## FAQ: Frequently Asked Questions

### Can I skip levels?

Yes. If you already know what ADRs are, start at Level 2. No need to repeat ceremony.

### What if my team doesn't want to change?

Start by yourself (Level 1). When they see value, they'll adopt naturally. Don't impose, inspire.

### How long does Level 1 take?

10-15 minutes to create `docs/PRD.md`. No more.

### Can I mix levels?

Yes. Different parts of the project can be at different levels. Document what matters most first.

---

## Getting Started Today

1. **Now**: Create `docs/` folder with `docs/PRD.md`
2. **This week**: Create first ADR for a recent decision
3. **This month**: Evaluate if you need RFC system

The goal is useful documentation, not perfect documentation.

---

## See Also

- [PRD.md](PRD.md) — Product Requirements
- [FAQ.md](FAQ.md) — Frequently asked questions
- [anti-patrones.md](anti-patrones.md) — Documentation anti-patterns
- [templates/TEMPLATE_GUIDE.md](templates/TEMPLATE_GUIDE.md) — Template usage guide
ADOPTIONEOF
)

  create_file "docs/adoption-guide.md" "$content"
  create_file "es/docs/adoption-guide.md" "$content"
}

# ==================================================================
# Task 3.3: ES v1.1 banners
# Adds v1.1 outdated-version banner to 6 Spanish documentation files.
# es/docs/adoption-guide.md gets the banner prepended (file exists from
# create_adoption_guide). Other 5 files are created from scratch.
# ==================================================================
create_es_banners() {
  echo ""
  echo -e "${BOLD}📄 Adding v1.1 banners to ES documentation...${NC}"

  local banner
  banner='> ⚠️ **NOTA**: Esta documentación corresponde a FlowDocs v1.1.
> La versión actual es v2.0 en inglés. Este contenido puede estar desactualizado.'

  # ----------------------------------------------------------------
  # Helper: prepend banner to an existing file (for adoption-guide)
  # ----------------------------------------------------------------
  _prepend_banner() {
    local path="$1"
    local btext="$2"

    if [ "$DRY_RUN" = true ]; then
      echo -e "  ${CYAN}🔍 Would add banner to:${NC} $path"
      ((CREATED_COUNT++)) || true
      return 0
    fi

    if [ ! -f "$path" ]; then
      echo -e "  ${YELLOW}⚠️  File not found, creating stub:${NC} $path"
      mkdir -p "$(dirname "$path")"
      printf '%s\n\n%s\n' "$btext" "[Documentation pending translation]" > "$path"
      ((CREATED_COUNT++)) || true
      return 0
    fi

    # Idempotency: skip if banner is already present (check first line)
    local first_line
    first_line=$(head -1 "$path")
    local banner_first_line
    banner_first_line=$(echo "$btext" | head -1)
    if [ "$first_line" = "$banner_first_line" ]; then
      echo -e "  ${YELLOW}⚠️  Banner already present:${NC} $path"
      ((SKIPPED_COUNT++)) || true
      return 0
    fi

    local tmpfile
    tmpfile=$(mktemp)
    printf '%s\n\n' "$btext" > "$tmpfile"
    cat "$path" >> "$tmpfile"
    mv "$tmpfile" "$path"
    echo -e "  ${GREEN}✅ Banner added:${NC} $path"
    ((CREATED_COUNT++)) || true
  }

  # ----------------------------------------------------------------
  # 1. es/docs/adoption-guide.md — prepend banner to existing file
  # ----------------------------------------------------------------
  _prepend_banner "es/docs/adoption-guide.md" "$banner"

  # ----------------------------------------------------------------
  # 2. es/README.md — banner + overview
  # ----------------------------------------------------------------
  local es_readme
  es_readme=$(cat << ESREADMEEOF
$banner

# FlowDoc

**Framework de documentación para equipos distribuidos — Agnóstico de herramientas, async-first, adopción gradual**

*Parte del ecosistema FlowForge: FlowForge minimiza el overhead SDD, FlowDoc es la documentación que fluye.*

---

Consulta la [documentación en inglés](../README.md) para la versión v2.0 actualizada.
ESREADMEEOF
)
  create_file "es/README.md" "$es_readme"

  # ----------------------------------------------------------------
  # 3. es/AGENTS.md — banner + agent rules
  # ----------------------------------------------------------------
  local es_agents
  es_agents=$(cat << ESAGENTSEOF
$banner

# AGENTS.md — FlowDoc (ES)

**Framework**: FlowDoc — Documentación que fluye con el trabajo
**Stack**: Documentación, SDD workflow

---

Consulta [AGENTS.md](../AGENTS.md) en inglés para la versión v2.0 actualizada.
ESAGENTSEOF
)
  create_file "es/AGENTS.md" "$es_agents"

  # ----------------------------------------------------------------
  # 4-6. FAQ, troubleshooting, anti-patrones — stubs with banner
  # ----------------------------------------------------------------
  local stub
  stub=$(cat << STUBEOF
$banner

---

Consulta la [documentación en inglés](../../docs/FAQ.md) para la versión v2.0 actualizada.
STUBEOF
)
  create_file "es/docs/FAQ.md" "$stub"

  stub=$(cat << STUBEOF
$banner

---

Consulta la [documentación en inglés](../../docs/troubleshooting.md) para la versión v2.0 actualizada.
STUBEOF
)
  create_file "es/docs/troubleshooting.md" "$stub"

  stub=$(cat << STUBEOF
$banner

---

Consulta la [documentación en inglés](../../docs/anti-patrones.md) para la versión v2.0 actualizada.
STUBEOF
)
  create_file "es/docs/anti-patrones.md" "$stub"
}

# ==================================================================
# Task 3.4: Architecture-specific reference READMEs
# Creates 4 README.md files under reference/{arch}/.
# Each is a signpost pointing to estructura.md for the full guide.
# ==================================================================
create_reference_readmes() {
  echo ""
  echo -e "${BOLD}📄 Generating reference architecture READMEs...${NC}"

  local archs=(
    "monolitico:Monolith:single-application"
    "microservicios:Microservices:distributed-services"
    "monorepo:Monorepo:multi-package"
    "serverless:Serverless:functions-first"
  )

  local entry name desc content
  for entry in "${archs[@]}"; do
    IFS=':' read -r name label desc <<< "$entry"

    content=$(cat << REFEOF
# ${label}

FlowDoc guide for ${desc} projects.

## Quick Start

See [estructura.md](estructura.md) for the full guide.

## What You'll Find

- \`${name}/estructura.md\` — Architecture structure
- \`${name}/templates/\` — Architecture-specific templates
- \`${name}/scripts/\` — Architecture-specific scripts
REFEOF
)
    create_file "reference/${name}/README.md" "$content"
  done
}

# ==================================================================
# Task 2.1-2.6: Codebase Exploration (--legacy mode)
# Bash-only exploration: searches for entry points, APIs, DB, and
# existing docs using find/ls. Skips entirely when --no-explore is set.
# ==================================================================

# Task 2.2: Detect entry points (main files, src/)
explore_entry_points() {
  local count=0
  # Search for common entry point files
  for pattern in "main.*" "index.*" "app.*" "Program.cs" "main.py" "main.go"; do
    count=0
    while IFS= read -r f && [ $count -lt 3 ]; do
      [ -n "$f" ] && echo "${f#./}"
      count=$((count + 1))
    done < <(find . -maxdepth 3 -name "$pattern" -type f 2>/dev/null || true)
  done
  # Check for src/ directory
  [ -d "src" ] && echo "src/ (directory)" || true
}

# Task 2.3: Detect API files (controllers, routes, handlers, etc.)
explore_apis() {
  local count=0
  # Search for API directories
  for dir in "controllers" "routes" "handlers" "endpoints" "api"; do
    count=0
    while IFS= read -r d && [ $count -lt 5 ]; do
      [ -n "$d" ] && echo "${d#./}/"
      count=$((count + 1))
    done < <(find . -maxdepth 3 -type d -name "$dir" 2>/dev/null | sort -u || true)
  done
  # Search for API-like files
  for pattern in "*Controller.*" "*Route*" "*Handler*"; do
    count=0
    while IFS= read -r f && [ $count -lt 5 ]; do
      [ -n "$f" ] && echo "${f#./}"
      count=$((count + 1))
    done < <(find . -maxdepth 3 -name "$pattern" -type f 2>/dev/null | sort -u || true)
  done
}

# Task 2.4: Detect DB files (models, entities, schema, migrations, SQL)
explore_db() {
  local count=0
  # Search for DB directories
  for dir in "models" "entities" "schema" "migrations" "database"; do
    count=0
    while IFS= read -r d && [ $count -lt 5 ]; do
      [ -n "$d" ] && echo "${d#./}/"
      count=$((count + 1))
    done < <(find . -maxdepth 3 -type d -name "$dir" 2>/dev/null | sort -u || true)
  done
  # Search for DB-like files
  for pattern in "*Model*" "*Entity*" "*.sql"; do
    count=0
    while IFS= read -r f && [ $count -lt 5 ]; do
      [ -n "$f" ] && echo "${f#./}"
      count=$((count + 1))
    done < <(find . -maxdepth 3 -name "$pattern" -type f 2>/dev/null | sort -u || true)
  done
}

# Task 2.5: Detect existing documentation
explore_docs() {
  [ -f "README.md" ] && echo "README.md" || true
  [ -f "PRD.md" ] && echo "PRD.md" || true
  [ -f "AGENTS.md" ] && echo "AGENTS.md" || true
  [ -f "CONTRIBUTING.md" ] && echo "CONTRIBUTING.md" || true
  [ -f "CHANGELOG.md" ] && echo "CHANGELOG.md" || true
  [ -d "docs" ] && echo "docs/ (directory)" || true
}

# Task 2.6: Generate exploration summary (--legacy mode entry point)
# Calls sub-detectors and formats the output.
explore_codebase() {
  echo ""
  echo -e "${BOLD}🔍 Codebase Exploration${NC}"
  echo -e "${BOLD}=====================${NC}"

  # Skip if --no-explore
  if [ "$NO_EXPLORE" = true ]; then
    echo ""
    echo -e "  ${YELLOW}⚠️  Exploration skipped (--no-explore flag set).${NC}"
    echo ""
    return 0
  fi

  local entries
  local apis
  local dbs
  local docs

  entries=$(explore_entry_points || true)
  apis=$(explore_apis || true)
  dbs=$(explore_db || true)
  docs=$(explore_docs || true)

  # Store in globals for Phase 3 structure generation
  EXPLORE_ENTRIES="$entries"
  EXPLORE_APIS="$apis"
  EXPLORE_DBS="$dbs"
  EXPLORE_DOCS="$docs"

  # ---- Entry Points ----
  echo ""
  if [ -n "$entries" ]; then
    echo -e "  📁 ${BOLD}Entry Points:${NC}"
    while IFS= read -r line; do
      [ -n "$line" ] && echo "    - $line"
    done <<< "$entries"
  else
    echo -e "  📁 ${BOLD}Entry Points:${NC} (none detected)"
  fi

  # ---- APIs ----
  echo ""
  if [ -n "$apis" ]; then
    echo -e "  🔌 ${BOLD}APIs:${NC}"
    while IFS= read -r line; do
      [ -n "$line" ] && echo "    - $line"
    done <<< "$apis"
  else
    echo -e "  🔌 ${BOLD}APIs:${NC} (none detected)"
  fi

  # ---- DB ----
  echo ""
  if [ -n "$dbs" ]; then
    echo -e "  💾 ${BOLD}DB:${NC}"
    while IFS= read -r line; do
      [ -n "$line" ] && echo "    - $line"
    done <<< "$dbs"
  else
    echo -e "  💾 ${BOLD}DB:${NC} (none detected)"
  fi

  # ---- Docs ----
  echo ""
  if [ -n "$docs" ]; then
    echo -e "  📚 ${BOLD}Docs:${NC}"
    while IFS= read -r line; do
      [ -n "$line" ] && echo "    - $line"
    done <<< "$docs"
  else
    echo -e "  📚 ${BOLD}Docs:${NC} (none detected)"
  fi
  echo ""
}

# ==================================================================
# PHASE 3: Legacy Structure Generation
# ==================================================================

# ------------------------------------------------------------------
# Task 3.1: Create docs/flowDocs/ directory structure
# Creates docs/flowDocs/ and docs/flowDocs/migrations/.
# Separate from docs/tasks/ — migration is its own workflow.
# ------------------------------------------------------------------
create_flowdocs_dirs() {
  echo ""
  echo -e "${BOLD}📁 Creating legacy flowDocs structure...${NC}"

  local dirs=(
    "docs/flowDocs"
    "docs/flowDocs/migrations"
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

# ------------------------------------------------------------------
# Task 3.2: Generate migration progress tracker
# Creates docs/flowDocs/flowdoc-migration-progress.md with
# project info, exploration summary, status table, and next steps.
# ------------------------------------------------------------------
create_flowdoc_progress() {
  echo ""
  echo -e "${BOLD}📄 Generating flowdoc-migration-progress.md...${NC}"

  local today
  today=$(date +%Y-%m-%d)

  local entries_list=""
  local apis_list=""
  local dbs_list=""
  local docs_list=""

  if [ -n "${EXPLORE_ENTRIES:-}" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && entries_list+="- ${line}"$'\n'
    done <<< "${EXPLORE_ENTRIES}"
  else
    entries_list="- None detected"
  fi

  if [ -n "${EXPLORE_APIS:-}" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && apis_list+="- ${line}"$'\n'
    done <<< "${EXPLORE_APIS}"
  else
    apis_list="- None detected"
  fi

  if [ -n "${EXPLORE_DBS:-}" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && dbs_list+="- ${line}"$'\n'
    done <<< "${EXPLORE_DBS}"
  else
    dbs_list="- None detected"
  fi

  if [ -n "${EXPLORE_DOCS:-}" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && docs_list+="- ${line}"$'\n'
    done <<< "${EXPLORE_DOCS}"
  else
    docs_list="- None detected"
  fi

  local content
  content=$(cat << PROGRESSEOF
# FlowDoc Migration Progress

## Project
**Name**: ${PROJECT_NAME:-[from PRD or detected]}
**Started**: ${today}
**Stack Detected**: ${STACK}

## Exploration Summary

### Entry Points
${entries_list}
### APIs
${apis_list}
### Database
${dbs_list}
### Existing Docs
${docs_list}
## Documentation Status

| HU | Area | Status | Date |
|----|------|--------|------|
| HU-001 | PRD | 🟡 In Progress | ${today} |
| HU-002 | RFC Legacy | 🔲 Pending | — |
| HU-003 | APIs | 🔲 Pending | — |
| HU-004 | DB Schema | 🔲 Pending | — |

## Next Steps
1. Run agent with docs/flowDocs/flowdoc-migration-prompt.md
2. Review each HU in docs/flowDocs/migrations/
3. Validate DB schema against reality
4. Update statuses as each HU is completed
PROGRESSEOF
  )

  create_file "docs/flowDocs/flowdoc-migration-progress.md" "$content"
}

# ------------------------------------------------------------------
# Task 3.3: Generate agent migration prompt
# Creates docs/flowDocs/flowdoc-migration-prompt.md with
# project overview, HU descriptions, exploration data, and agent rules.
# ------------------------------------------------------------------
create_flowdoc_prompt() {
  echo ""
  echo -e "${BOLD}📄 Generating flowdoc-migration-prompt.md...${NC}"

  local entries_list=""
  local apis_list=""
  local dbs_list=""
  local docs_list=""

  if [ -n "${EXPLORE_ENTRIES:-}" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && entries_list+="  - ${line}"$'\n'
    done <<< "${EXPLORE_ENTRIES}"
  else
    entries_list="  - None"
  fi

  if [ -n "${EXPLORE_APIS:-}" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && apis_list+="  - ${line}"$'\n'
    done <<< "${EXPLORE_APIS}"
  else
    apis_list="  - None"
  fi

  if [ -n "${EXPLORE_DBS:-}" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && dbs_list+="  - ${line}"$'\n'
    done <<< "${EXPLORE_DBS}"
  else
    dbs_list="  - None"
  fi

  if [ -n "${EXPLORE_DOCS:-}" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && docs_list+="  - ${line}"$'\n'
    done <<< "${EXPLORE_DOCS}"
  else
    docs_list="  - None"
  fi

  local content
  content=$(cat << PROMPTEOF
# FlowDoc Migration Prompt — Agent Instructions

## Project Overview
**Project**: ${PROJECT_NAME:-[name from PRD]}
**Stack**: ${STACK}

This prompt guides an AI agent through migrating existing project documentation
into the FlowDoc structure. Each HU (Historia de Usuario / User Story) focuses on
a specific documentation area.

## How to Use
1. Read the exploration data below
2. Complete each HU file in \`docs/flowDocs/migrations/\`
3. Update the status in \`docs/flowDocs/flowdoc-migration-progress.md\`
4. When all HUs are complete, run the validation

## Exploration Data

### Entry Points Found
${entries_list}
### APIs Found
${apis_list}
### DB Artifacts Found
${dbs_list}
### Existing Docs Found
${docs_list}
## HU Descriptions

### HU-001: PRD (Product Requirements Document)
**Goal**: Create or update \`docs/PRD.md\` with project purpose, users, tech stack.
**Template**: \`docs/flowDocs/migrations/HU-001-prd.md\`
**What to do**:
- Fill in Vision, Users, and Tech Stack sections
- If existing PRD exists, merge and update
- Mark dependencies and external services

### HU-002: RFC Legacy
**Goal**: Document legacy architectural decisions as RFCs/ADRs.
**Template**: \`docs/flowDocs/migrations/HU-002-rfc-legacy.md\`
**What to do**:
- Review existing architecture decisions
- Create ADR records for significant past decisions
- Document known tech debt and migration paths

### HU-003: APIs
**Goal**: Document all API endpoints and contracts.
**Template**: \`docs/flowDocs/migrations/HU-003-apis.md\`
**What to do**:
- Document all detected API endpoints
- Include request/response schemas
- Document authentication patterns

### HU-004: DB Schema
**Goal**: Document database schema, migrations, and models.
**Template**: \`docs/flowDocs/migrations/HU-004-db-schema.md\`
**What to do**:
- Document table/collection schemas
- Document migration history
- Document relationships and indexes

## Agent Rules
- Always ask for human review after completing each HU
- Never modify source code — only documentation
- Use \`docs/templates/\` for consistent formatting
- Update the status table after each HU completion
PROMPTEOF
  )

  create_file "docs/flowDocs/flowdoc-migration-prompt.md" "$content"
}

# ------------------------------------------------------------------
# Task 3.3b: Create AGENT_MANUAL.md
# Creates docs/flowDocs/AGENT_MANUAL.md - quick reference for agents
# on how to work with FlowDocs documentation.
# ------------------------------------------------------------------
create_flowdoc_agent_manual() {
  echo ""
  echo -e "${BOLD}📄 Generating AGENT_MANUAL.md...${NC}"

  local content
  content=$(cat << 'AGENTMANUALEOF'
# Agent Manual — FlowDocs

> When in doubt about documentation, start here.

---

## Golden Rule

**Don't know what to do? → Ask the developer. No guesses. No assumptions.**

---

## Decision Tree

```
Need to document something?
├── TECHNICAL DECISION → Already discussed?
│   ├── YES → Create ADR in `docs/architecture/adr/`
│   └── NO → Create RFC in `docs/architecture/rfc/`
│
├── REQUIREMENT → Create/update in `docs/PRD.md`
│
├── API CONTRACT → Update `docs/api/endpoints.md`
│
├── DB SCHEMA → Update `docs/database/schema.md`
│
├── DON'T KNOW the type → ASK the developer
│
└── Found OUTDATED docs?
    ├── YES → Update in the SAME PR as the code change
    └── NO → Continue with your task
```

---

## Quick Reference

| Situation | Action | Location |
|-----------|--------|----------|
| Pending technical decision | Create RFC | `docs/architecture/rfc/NNN-name.md` |
| Approved technical decision | Create ADR | `docs/architecture/adr/NNN-name.md` |
| Decision exists and changes | Update existing ADR | Same file |
| Decision is obsolete | Change status to `Deprecated` | Same ADR |
| New requirement | Update PRD | `docs/PRD.md` |
| API change | Update endpoints | `docs/api/endpoints.md` |
| DB change | Update schema | `docs/database/schema.md` |
| None of the above | **Ask** | — |

---

## Document States

### ADR / RFC
```
Draft → In Review → Accepted
                      ↓
                 Deprecated (if replaced)
```

### Rules
- **ADR in Draft > 1 month**: Ask dev — decision is stuck
- **RFC in Review > 2 weeks**: Ask dev — no consensus
- **Don't know the state**: Ask dev

---

## Naming Conventions

```
NNN-descriptive-name.md
```

| Type | Example |
|------|---------|
| ADR | `001-auth-jwt.md` |
| RFC | `001-auth-jwt-proposal.md` |

- NNN = sequential number (check latest in folder)
- Name = kebab-case, descriptive
- No spaces, no accents

---

## Minimum Required Format

### ADR
```markdown
# ADR-NNN: Title

- **Date**: YYYY-MM-DD
- **Status**: Draft | In Review | Accepted | Deprecated
- **Context**: Why this decision was made
- **Decision**: What was decided
- **Consequences**: Pros and cons
```

### RFC
```markdown
# RFC-NNN: Title

- **Author**: Your name
- **Status**: Draft | In Review
- **Problem**: What problem this solves
- **Proposed Solution**: Your proposal
- **Open Questions**: What still needs definition
```

---

## Don't Do This

- ❌ Modify `docs/` without dev approval
- ❌ Create ADR without prior RFC (unless dev asks)
- ❌ Delete existing documentation
- ❌ Update deprecated ADR (create new one instead)
- ❌ Invent conventions that don't exist

---

## When Updating Documentation

**Rule**: Docs are updated in the SAME PR that changes the code.

```
If you change code → Update docs in that same PR
```

No separate PR for docs.

---

## Pre-Commit Checklist

- [ ] Created or updated the correct document?
- [ ] ADR/RFC has the right status?
- [ ] Name follows NNN-name.md convention?
- [ ] Anything to ask the dev?

---

## When Everything Fails

1. Read `docs/anti-patrones.md` — might be described there
2. Read `docs/troubleshooting.md` — common problems and solutions
3. **Ask the developer** — don't guess

---

## See Also

- `docs/anti-patrones.md` — Signs something is wrong
- `docs/troubleshooting.md` — Problems and solutions
- `docs/templates/` — Templates for each document type
AGENTMANUALEOF
  )

  create_file "docs/flowDocs/AGENT_MANUAL.md" "$content"
}

# ------------------------------------------------------------------
# Task 3.4: Generate migration HU files
# Creates 4 HU templates in docs/flowDocs/migrations/:
#   HU-001-prd.md, HU-002-rfc-legacy.md, HU-003-apis.md, HU-004-db-schema.md
# Each pre-filled with exploration data, status, and checklist.
# ------------------------------------------------------------------
create_migration_hus() {
  echo ""
  echo -e "${BOLD}📄 Generating migration HU files...${NC}"

  local today
  today=$(date +%Y-%m-%d)

  local entries_list=""
  local apis_list=""
  local dbs_list=""
  local docs_list=""

  if [ -n "${EXPLORE_ENTRIES:-}" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && entries_list+="- ${line}"$'\n'
    done <<< "${EXPLORE_ENTRIES}"
  else
    entries_list="- None detected"
  fi

  if [ -n "${EXPLORE_APIS:-}" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && apis_list+="- ${line}"$'\n'
    done <<< "${EXPLORE_APIS}"
  else
    apis_list="- None detected"
  fi

  if [ -n "${EXPLORE_DBS:-}" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && dbs_list+="- ${line}"$'\n'
    done <<< "${EXPLORE_DBS}"
  else
    dbs_list="- None detected"
  fi

  if [ -n "${EXPLORE_DOCS:-}" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && docs_list+="- ${line}"$'\n'
    done <<< "${EXPLORE_DOCS}"
  else
    docs_list="- None detected"
  fi

  # --- HU-001: PRD ---
  local hu001
  hu001=$(cat << HU001EOF
# HU-001 — Product Requirements Document

**Status**: 🟡 In Progress
**Owner**: @dev
**Created**: ${today}
**Area**: PRD

---

## Exploration Data

### Entry Points
${entries_list}
### Existing Docs
${docs_list}
---

## Instructions

Fill in the following sections for \`docs/PRD.md\`:

### 🎯 Vision
[What is this project trying to achieve? What problem does it solve?]

### 👥 Users
| User | Needs | Pain Points |
|------|-------|-------------|
| [User 1] | [Needs] | [Pain points] |

### 🛠️ Tech Stack
[Fill from detected stack: ${STACK}]

### ✅ Requirements
#### Must Have
- [Requirement]

#### Should Have
- [Requirement]

#### Nice to Have
- [Requirement]

### 🚫 Out of Scope
- [What is NOT included]

---

## Review Checklist
- [ ] Vision is clear and specific
- [ ] Users are identified with real needs
- [ ] Tech stack matches project reality
- [ ] Requirements are prioritized
- [ ] Out of scope is explicitly stated
HU001EOF
  )

  # --- HU-002: RFC Legacy ---
  local hu002
  hu002=$(cat << HU002EOF
# HU-002 — RFC Legacy Decisions

**Status**: 🔲 Pending
**Owner**: @dev
**Created**: ${today}
**Area**: Architecture / RFC

---

## Exploration Data

### Entry Points
${entries_list}
### APIs Detected
${apis_list}
### Existing Docs
${docs_list}
---

## Instructions

This HU documents legacy architectural decisions that exist in the codebase
but have never been formally recorded.

### Decisions to Document
For each significant architecture decision found in the code:

1. **Decision Title** — Short, searchable name
2. **Context** — What was the situation?
3. **Decision** — What was chosen?
4. **Consequences** — What resulted from this choice?
5. **Status** — Accepted / Deprecated / Superseded

### Template
Use \`docs/templates/architecture/ADR_template.md\` as reference.

### Known Tech Debt
Document any tech debt discovered during exploration:
- [Example: Monolith needs splitting into services]

### Migration Path
If any decisions should be revisited:
- [Decision] → [Proposed change] → [Expected benefit]

---

## Review Checklist
- [ ] All significant architecture decisions are captured
- [ ] Tech debt is documented with estimated effort
- [ ] Migration paths are realistic and prioritized
HU002EOF
  )

  # --- HU-003: APIs ---
  local hu003
  hu003=$(cat << HU003EOF
# HU-003 — API Documentation

**Status**: 🔲 Pending
**Owner**: @dev
**Created**: ${today}
**Area**: APIs

---

## Exploration Data

### Detected API Artifacts
${apis_list}
### Detected Entry Points
${entries_list}
---

## Instructions

Document all API endpoints found in the codebase.

### Endpoint Format
For each endpoint, use the template from \`docs/templates/api/endpoints.md\`:

\`\`\`markdown
### GET /api/resource
**Auth**: [None / JWT / API Key]
**Description**: [What this endpoint does]
**Request**:
\`\`\`json
{}
\`\`\`
**Response** (200):
\`\`\`json
{}
\`\`\`
**Errors**:
- 401 Unauthorized
- 404 Not Found
\`\`\`

### Models
Document shared models/entities used across endpoints.

---

## Review Checklist
- [ ] All endpoints are documented with request/response examples
- [ ] Auth requirements are specified per endpoint
- [ ] Error responses are documented
- [ ] Models/entities are referenced
HU003EOF
  )

  # --- HU-004: DB Schema ---
  local hu004
  hu004=$(cat << HU004EOF
# HU-004 — Database Schema Documentation

**Status**: 🔲 Pending
**Owner**: @dev
**Created**: ${today}
**Area**: Database

---

## Exploration Data

### Detected DB Artifacts
${dbs_list}
### Detected Models/Entities
${dbs_list}
---

## Instructions

Document the database schema discovered in the codebase.

### Schema Format
Use the template from \`docs/templates/database/schema.md\`:

\`\`\`markdown
## Table: users
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PK | Primary key |
| email | VARCHAR(255) | UNIQUE, NOT NULL | User email |
\`\`\`

### Migrations
Document migration history:
- Migration files found
- Current schema version
- Pending migrations (if any)

### Relationships
Document table relationships:
- One-to-many
- Many-to-many
- Foreign keys

### Indexes
Document performance indexes:
- [Index name] on [columns] — [purpose]

---

## Review Checklist
- [ ] All tables/collections are documented with column types
- [ ] Primary keys and foreign keys are identified
- [ ] Indexes are documented
- [ ] Migration history is recorded
- [ ] Relationships between entities are clear
HU004EOF
  )

  create_file "docs/flowDocs/migrations/HU-001-prd.md" "$hu001"
  create_file "docs/flowDocs/migrations/HU-002-rfc-legacy.md" "$hu002"
  create_file "docs/flowDocs/migrations/HU-003-apis.md" "$hu003"
  create_file "docs/flowDocs/migrations/HU-004-db-schema.md" "$hu004"
}

# ------------------------------------------------------------------
# Task 3.5: Generate legacy PRD from exploration data
# Generates docs/PRD.md pre-filled with exploration results.
# Supports --overwrite to replace existing PRD.
# In non-interactive mode, uses exploration data for auto-fill.
# In interactive mode, asks 3 questions (pre-filled with detected values).
# ------------------------------------------------------------------
generate_legacy_prd() {
  echo ""
  echo -e "${BOLD}📋 Generating legacy PRD from exploration data...${NC}"

  # Skip in dry-run
  if [ "$DRY_RUN" = true ]; then
    echo -e "  ${CYAN}🔍 Would create:${NC} docs/PRD.md (from exploration data)"
    ((CREATED_COUNT++)) || true
    return 0
  fi

  # Check if PRD already exists
  # --force overwrites everything (including PRD)
  # --overwrite specifically targets PRD generation
  if [ -f "docs/PRD.md" ] && [ "$FORCE" != true ] && [ "$OVERWRITE" != true ]; then
    echo -e "  ${YELLOW}⚠️  docs/PRD.md already exists. Use --overwrite to replace.${NC}"
    echo "     Skipping PRD generation."
    ((SKIPPED_COUNT++)) || true
    return 0
  fi

  # Build exploration sections from globals
  local entries_list=""
  local apis_list=""
  local dbs_list=""
  local docs_list=""

  if [ -n "${EXPLORE_ENTRIES:-}" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && entries_list+="- ${line}"$'\n'
    done <<< "${EXPLORE_ENTRIES}"
  fi

  if [ -n "${EXPLORE_APIS:-}" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && apis_list+="- ${line}"$'\n'
    done <<< "${EXPLORE_APIS}"
  fi

  if [ -n "${EXPLORE_DBS:-}" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && dbs_list+="- ${line}"$'\n'
    done <<< "${EXPLORE_DBS}"
  fi

  if [ -n "${EXPLORE_DOCS:-}" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && docs_list+="- ${line}"$'\n'
    done <<< "${EXPLORE_DOCS}"
  fi

  # Non-interactive fallback: auto-generate from exploration data
  if [ ! -t 0 ]; then
    echo -e "  ${YELLOW}⚠️  Non-interactive mode — generating PRD from exploration data.${NC}"

    PROJECT_NAME="${PROJECT_NAME:-My Project}"

    local today
    today=$(date +%Y-%m-%d)

    local prd_content
    prd_content=$(cat << PRDEOF
# ${PROJECT_NAME} — Product Requirements Document

**Project:** ${PROJECT_NAME}
**Owner:** @dev
**Created:** ${today}
**Status:** Draft (auto-generated from legacy exploration)

> ⚠️ This PRD was auto-generated from codebase exploration.
> Review and complete each section before using it as source of truth.

---

## 🎯 Vision

[What is this project trying to achieve? What problem does it solve?]

## 👥 Users

| User | Needs | Pain Points |
|------|-------|-------------|
| [User 1] | [Needs] | [Pain points] |

## 🛠️ Tech Stack

**Detected**: ${STACK}

## 📁 What We Found in Your Codebase

### Project Structure
${entries_list:-None detected}

### APIs
${apis_list:-None detected}

### Database
${dbs_list:-None detected}

### Existing Documentation
${docs_list:-None detected}

## 👥 Team

- **Size & timezones**: [e.g., 3 people, GMT-3 and GMT+1]
- **Communication**: [e.g., Discord, Slack, Teams]

## ✅ Requirements

### Must Have
- [Requirement]

### Should Have
- [Requirement]

### Nice to Have
- [Requirement]

## 🚫 Out of Scope

- [What is NOT included in this phase]

## 📊 Success Metrics

- [Metric 1]: [Target]
- [Metric 2]: [Target]

## 📝 Notes

- Generated by FlowDoc init --legacy
- Exploration date: ${today}
- See docs/flowDocs/ for migration tracking
PRDEOF
    )

    create_file "docs/PRD.md" "$prd_content" true
    return 0
  fi

  # Interactive mode — ask questions pre-filled with detected values
  echo ""
  echo -e "${BOLD}Let's set up your PRD from exploration data:${NC}"
  echo ""
  echo ""

  local tech_stack team_info today
  today=$(date +%Y-%m-%d)

  # Q1: Project name
  read -r -p "  Project name [My Project]: " PROJECT_NAME
  PROJECT_NAME="${PROJECT_NAME:-My Project}"

  # Q2: Show detected stack, allow override
  echo ""
  echo -e "  ${CYAN}Detected stack: ${STACK}${NC}"
  read -r -p "  Tech stack [${STACK}]: " tech_stack
  tech_stack="${tech_stack:-${STACK}}"

  # Q3: Team
  read -r -p "  Team size and timezones [1 person, async]: " team_info
  team_info="${team_info:-1 person, async}"

  # Build tech stack items
  local tech_items=""
  IFS=',' read -ra techs <<< "$tech_stack"
  for tech in "${techs[@]}"; do
    tech=$(echo "$tech" | xargs)
    tech_items+="- ${tech}"$'\n'
  done

  local content
  content="# ${PROJECT_NAME} — Product Requirements Document

**Project:** ${PROJECT_NAME}
**Owner:** @dev
**Created:** ${today}
**Status:** Draft

> Generated by FlowDoc --legacy with exploration data.

---

## 🎯 Vision

[What is this project trying to achieve? What problem does it solve?]

## 👥 Users

| User | Needs | Pain Points |
|------|-------|-------------|
| [User 1] | [Needs] | [Pain points] |

## 🛠️ Tech Stack

${tech_items}
## 👥 Team

- **Size & timezones**: ${team_info}
- **Communication**: [e.g., Discord, Slack, Teams]

## 🔍 What We Found in Your Codebase

### Project Structure
${entries_list:-None detected}

### APIs
${apis_list:-None detected}

### Database
${dbs_list:-None detected}

### Existing Documentation
${docs_list:-None detected}

## ✅ Requirements

### Must Have
- [Requirement]

### Should Have
- [Requirement]

### Nice to Have
- [Requirement]

## 🚫 Out of Scope

- [What is NOT included in this phase]

## 📊 Success Metrics

- [Metric 1]: [Target]
- [Metric 2]: [Target]

## 📝 Notes

- Generated by FlowDoc init --legacy on ${today}
- See docs/flowDocs/flowdoc-migration-progress.md for migration status
- Review each section and fill in the blanks"

  create_file "docs/PRD.md" "$content" true
}

# ==================================================================
# Task 2.4: Enhanced summary output with colored counts
# Shows created/skipped counts, stack, and actionable next steps.
# ==================================================================
show_summary() {
  # ------------------------------------------------------------------
  # Task 4.3: Legacy mode summary — exploration summary + HU status + migration next steps
  # ------------------------------------------------------------------
  if [ "$LEGACY" = true ]; then
    _show_legacy_summary
    return 0
  fi

  # Normal new-project summary (unchanged)
  echo ""
  echo -e "${GREEN}========================================${NC}"
  echo -e "${GREEN}✅ FlowDoc Init v2.0 Complete${NC}"
  echo -e "${GREEN}========================================${NC}"
  echo ""

  # Created files (green if any, dim if none)
  if [ "$CREATED_COUNT" -gt 0 ]; then
    echo -e "  ${GREEN}✅ Created ${CREATED_COUNT} file(s)${NC}"
  else
    echo "  Created 0 files"
  fi

  # Skipped files (yellow if any)
  if [ "$SKIPPED_COUNT" -gt 0 ]; then
    echo -e "  ${YELLOW}⚠️  Skipped ${SKIPPED_COUNT} file(s)${NC}"
  fi

  echo "  Stack detected: ${STACK}"
  echo ""

  # List what was created
  echo -e "${BOLD}What was set up:${NC}"
  echo "  - docs/ directory structure (v2.0)"
  echo "  - docs/PRD.md (fill in your project details)"
  echo "  - AGENTS.md (customized for ${STACK})"
  echo "  - .gitignore.flowdoc-suggestions (review and rename to .gitignore)"
  echo "  - README.md (single entry point with quick start)"
  echo "  - docs/adoption-guide.md (3-level adoption guide, EN + ES)"
  echo "  - ES v1.1 banners (6 files marked as legacy)"
  echo "  - reference/*/README.md (4 architecture guides)"
  echo ""

  echo -e "${BOLD}Next steps:${NC}"
  echo "  1. Review and complete docs/PRD.md"
  echo "  2. Review AGENTS.md and customize for your team"
  echo "  3. Merge .gitignore.flowdoc-suggestions into .gitignore"
  echo "     (or rename it if no .gitignore exists)"
  echo "  4. Create your first user story in docs/tasks/"
  if [ "$DRY_RUN" = true ]; then
    echo ""
    echo -e "${CYAN}🔍 This was a dry run. No files were modified.${NC}"
    echo "   Run without --dry-run to create the structure."
  fi
  echo ""
}

# ------------------------------------------------------------------
# Internal: Legacy mode summary (called by show_summary when LEGACY=true)
# Shows exploration recap, HU status table, and migration next steps.
# ------------------------------------------------------------------
_show_legacy_summary() {
  echo ""
  echo -e "${GREEN}========================================${NC}"
  echo -e "${GREEN}✅ FlowDoc Legacy Adoption Complete${NC}"
  echo -e "${GREEN}========================================${NC}"
  echo ""

  # Counts
  if [ "$CREATED_COUNT" -gt 0 ]; then
    echo -e "  ${GREEN}✅ Created ${CREATED_COUNT} file(s)${NC}"
  fi
  if [ "$SKIPPED_COUNT" -gt 0 ]; then
    echo -e "  ${YELLOW}⚠️  Skipped ${SKIPPED_COUNT} file(s)${NC}"
  fi
  echo "  Stack detected: ${STACK}"
  echo ""

  # Exploration recap (condensed)
  if [ "$NO_EXPLORE" != true ]; then
    local e_count a_count d_count doc_count
    e_count=$(echo "${EXPLORE_ENTRIES:-}" | grep -c '[^[:space:]]' 2>/dev/null || true)
    a_count=$(echo "${EXPLORE_APIS:-}" | grep -c '[^[:space:]]' 2>/dev/null || true)
    d_count=$(echo "${EXPLORE_DBS:-}" | grep -c '[^[:space:]]' 2>/dev/null || true)
    doc_count=$(echo "${EXPLORE_DOCS:-}" | grep -c '[^[:space:]]' 2>/dev/null || true)
    echo -e "${BOLD}Exploration Results:${NC}"
    echo "  📁 Entry points: ${e_count} found"
    echo "  🔌 APIs: ${a_count} found"
    echo "  💾 DB artifacts: ${d_count} found"
    echo "  📚 Existing docs: ${doc_count} found"
  else
    echo -e "${BOLD}Exploration:${NC} skipped (--no-explore)"
  fi
  echo ""

  # HU Status table
  echo -e "${BOLD}Migration HU Status:${NC}"
  echo "  | HU     | Area         | Status          |"
  echo "  |--------|--------------|-----------------|"
  echo "  | HU-001 | PRD          | 🟡 In Progress   |"
  echo "  | HU-002 | RFC Legacy   | 🔲 Pending       |"
  echo "  | HU-003 | APIs         | 🔲 Pending       |"
  echo "  | HU-004 | DB Schema    | 🔲 Pending       |"
  echo ""

  # Next steps
  echo -e "${BOLD}Next steps:${NC}"
  echo "  1. Review and complete docs/PRD.md"
  echo "  2. Run agent with docs/flowDocs/flowdoc-migration-prompt.md"
  echo "  3. Review each HU in docs/flowDocs/migrations/"
  echo "  4. Track progress in docs/flowDocs/flowdoc-migration-progress.md"

  if [ "$DRY_RUN" = true ]; then
    echo ""
    echo -e "${CYAN}🔍 This was a dry run. No files were modified.${NC}"
    echo "   Run without --dry-run to create the structure."
  fi
  echo ""
}

print_summary() {
  echo ""
  echo -e "${GREEN}========================================${NC}"
  echo -e "${GREEN}✅ FlowDoc Init v2.0 Complete${NC}"
  echo -e "${GREEN}========================================${NC}"
  echo ""
  echo "  Files created: ${CREATED_COUNT}"
  echo "  Files skipped: ${SKIPPED_COUNT}"
  echo "  Stack detected: ${STACK}"
  echo ""
  echo "Next steps:"
  echo "  1. Review and complete docs/PRD.md"
  echo "  2. Create your first user story in docs/tasks/"
  echo "  3. Read docs/adoption-guide.md to choose your adoption level"
  if [ "$DRY_RUN" = true ]; then
    echo ""
    echo -e "${CYAN}🔍 This was a dry run. No files were modified.${NC}"
    echo "   Run without --dry-run to create the structure."
  fi
  echo ""
}

# ==================================================================
# Check mode: verify structure without migrating
# ==================================================================
check_dirs() {
  local failures=0
  echo ""
  echo -e "${BOLD}Checking directories...${NC}"
  for d in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$d" ]; then
      echo -e "  ${GREEN}✅${NC} $d/"
    else
      echo -e "  ${RED}❌${NC} $d/ — MISSING"
      ((failures++)) || true
    fi
  done
  return $failures
}

check_files() {
  local failures=0
  echo ""
  echo -e "${BOLD}Checking files...${NC}"
  for f in "${REQUIRED_FILES[@]}"; do
    if [ -f "$f" ]; then
      echo -e "  ${GREEN}✅${NC} $f"
    else
      echo -e "  ${RED}❌${NC} $f — MISSING"
      ((failures++)) || true
    fi
  done
  return $failures
}

run_check() {
  echo ""
  echo -e "${BOLD}=== FlowDoc Check ===${NC}"

  local total_failures=0

  check_dirs || ((total_failures+=$?)) || true
  check_files || ((total_failures+=$?)) || true

  echo ""
  echo -e "${BOLD}========================================${NC}"

  if [ "$total_failures" -gt 0 ]; then
    echo -e "${RED}❌ Check failed: $total_failures issue(s) found${NC}"
    echo ""
    exit 1
  else
    echo -e "${GREEN}✅ All checks passed${NC}"
    echo ""
    exit 0
  fi
}

# ==================================================================
# Main orchestration
# ==================================================================
main() {
  echo ""
  echo -e "${BOLD}🚀 FlowDoc Init v2.0${NC}"
  echo -e "${BOLD}===================${NC}"
  echo -e "  Bootstrapping FlowDoc v2.0 documentation structure"
  echo ""

  # Phase 1: Parse flags
  parse_flags "$@"

  # --check mode: verify structure without migrating
  if [ "$CHECK" = true ]; then
    run_check
    exit 0
  fi

  # Phase 1: Pre-checks
  echo -e "${BOLD}🔍 Pre-checks...${NC}"
  echo "  ✅ Working directory: $(pwd)"

  # Phase 1: Stack detection
  detect_stack

  # Task 4.2: Auto-detect hint — if code exists but user didn't use --legacy
  if [ "$LEGACY" != true ] && detect_existing_code; then
    echo ""
    echo -e "  ${YELLOW}📁 Existing code detected. Run with --legacy to adopt FlowDocs in legacy projects.${NC}"
    echo ""
  fi

  if [ "$DRY_RUN" = true ]; then
    echo ""
    echo -e "${CYAN}🔍 DRY RUN — showing what would be created:${NC}"
    echo ""
  fi

  # Phase 1: Directory structure + PRD + AGENTS.md + gitignore (skip for legacy)
  if [ "$LEGACY" != true ]; then
    guard_agents_md
    echo "  ✅ AGENTS.md check passed"
    guard_gitignore

    create_dirs
    create_prd
    create_agents_md
    create_gitignore_suggestions

    # Phase 3: Documentation files (new project only)
    create_readme
    create_adoption_guide
    create_es_banners
    create_reference_readmes
  fi

  # Legacy mode: codebase exploration (Phase 2) + structure generation (Phase 3)
  if [ "$LEGACY" = true ]; then
    explore_codebase
    # Phase 3: Legacy structure
    create_flowdocs_dirs
    create_dirs
    # Copy templates from FlowDocs repository
    local flowdoc_root
    flowdoc_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    if [ -d "$flowdoc_root/docs/templates" ]; then
      echo ""
      echo -e "${BOLD}📝 Copying templates and docs from FlowDocs...${NC}"
      cp -r "$flowdoc_root/docs/templates/"* "docs/templates/" 2>/dev/null || true
      cp -f "$flowdoc_root/docs/adoption-guide.md" "docs/adoption-guide.md" 2>/dev/null || true
      echo -e "  ${GREEN}✅ Templates and docs copied${NC}"
    fi
    create_flowdoc_progress
    create_flowdoc_prompt
    create_flowdoc_agent_manual
    create_migration_hus
    generate_legacy_prd
    # Only create AGENTS.md if one doesn't exist (preserve user's existing config)
    if [ ! -f "AGENTS.md" ]; then
      create_agents_md
    fi
  fi

  # Phase 2: Summary
  show_summary
}

# Entry point
main "$@"

#!/bin/bash
# FlowDoc Migration Script
# Usage: ./flowdoc-migration.sh
# Creates the FlowDoc structure and templates in the current directory.
# For legacy projects with existing SDD that want to adopt FlowDoc.

set -e

echo "🚀 FlowDoc Migration Script"
echo "============================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we're in a git repo (optional but recommended)
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}⚠️  Warning: Not a git repository. Consider running in one.${NC}"
    echo ""
fi

echo "📁 Creating FlowDoc structure..."

# Create main directories
mkdir -p docs/templates/user-stories
mkdir -p docs/templates/bug-fixes
mkdir -p docs/templates/refactors
mkdir -p docs/templates/architecture
mkdir -p docs/templates/database
mkdir -p docs/templates/api
mkdir -p docs/templates/PRD
mkdir -p docs/architecture/adr
mkdir -p docs/architecture/rfc
mkdir -p docs/tasks/HU-001-HU-099
mkdir -p docs/incidents
mkdir -p scripts

echo "✅ Directory structure created"
echo ""

# ============================================
# TEMPLATES
# ============================================

echo "📝 Creating templates..."

# Template: User Story SDD-Ready
cat > docs/templates/user-stories/template-user-story-sdd.md << 'TEMPLATE_EOF'
# HU-XXX: [Feature Name]

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

🧪 Ref: [How to verify this HU works - test cases, manual steps]

---

## 📦 Affected Areas

- `src/`
- `docs/api/`

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
- None

---

## 📖 Notes

[Any additional context]
TEMPLATE_EOF

# Template: User Story Simple
cat > docs/templates/user-stories/template-user-story.md << 'TEMPLATE_EOF'
# HU-XXX: [Feature Name]

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

[Any additional context]
TEMPLATE_EOF

# Template: Bug Fix SDD-Ready
cat > docs/templates/bug-fixes/template-bug-fix-sdd.md << 'TEMPLATE_EOF'
# BF-XXX: [Bug Title]

**Status**: 🟡 In Progress
**Owner**: @username
**Created**: YYYY-MM-DD
**Severity**: Critical | High | Medium | Low

---

## 🐛 Problem

[Description of the bug]

## 🔍 Root Cause

[What's causing the bug]

## 💡 Solution

[How to fix it]

## 🧪 Test Case

**GIVEN** [precondition]
**WHEN** [action]
**THEN** [expected behavior]

## 🔗 Related HU

[If any, link to the HU that introduced this bug]
TEMPLATE_EOF

# Template: Bug Fix Simple
cat > docs/templates/bug-fixes/template-bug-fix.md << 'TEMPLATE_EOF'
# BF-XXX: [Bug Title]

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

[What actually happens]
TEMPLATE_EOF

# Template: Refactor
cat > docs/templates/refactors/template-refactor.md << 'TEMPLATE_EOF'
# RF-XXX: [Refactor Name]

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
- [What doesn't change]

## ✅ Requirements

- [ ] No behavior change
- [ ] All existing tests pass
- [ ] Backward compatible

## 🧪 Verification

[How to verify the refactor didn't break anything]
TEMPLATE_EOF

# Template: RFC
cat > docs/templates/architecture/RFC_template.md << 'TEMPLATE_EOF'
# RFC-XXX: [Title]

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
- [ ] Cost/benefit analysis complete
TEMPLATE_EOF

# Template: ADR
cat > docs/templates/architecture/ADR_template.md << 'TEMPLATE_EOF'
# ADR-XXX: [Title]

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
|---------|----------|
| [Doc] | [Location] |
TEMPLATE_EOF

# Template: Database Schema
cat > docs/templates/database/schema.md << 'TEMPLATE_EOF'
# Database Schema

> Document the database schema for this project.

## Conventions

- Table names: `snake_case`
- Column names: `snake_case`
- Primary keys: `id` (UUID or SERIAL)
- Timestamps: `created_at`, `updated_at`

---

## Tables

### Table: [name]

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PK | Primary key |
| created_at | TIMESTAMP | NOT NULL | Creation timestamp |
| updated_at | TIMESTAMP | NOT NULL | Last update timestamp |

### Relationships

- `[table]` has many `[table]` (1:N)
- `[table]` belongs to `[table]` (N:1)

---

## Indexes

- `[table].[column]` — for `[purpose]`

## Migrations

`YYYY-MM-DD-initial-schema.sql` — Initial schema
TEMPLATE_EOF

# Template: API Endpoints
cat > docs/templates/api/endpoints.md << 'TEMPLATE_EOF'
# API Endpoints

> Document API contracts here.

## Conventions

- Base URL: `/api/v1`
- Authentication: Bearer token
- Errors: Standard HTTP codes + `{ error: string, code: string }`

---

## Auth

### POST /api/v1/auth/login

**Request:**
```json
{
  "email": "string",
  "password": "string"
}
```

**Response (200):**
```json
{
  "token": "string",
  "user": { "id": "string", "email": "string" }
}
```

**Errors:**
- 401: Invalid credentials

---

## [Resource]

### GET /api/v1/[resource]

**Headers:**
- `Authorization: Bearer {token}`

**Response (200):**
```json
{
  "data": [],
  "pagination": { "page": 1, "limit": 20, "total": 100 }
}
```
TEMPLATE_EOF

# Template: PRD
cat > docs/templates/PRD/PRD.md << 'TEMPLATE_EOF'
# Product Requirements Document (PRD)

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

- [What's not included]

## 📊 Success Metrics

- [Metric 1]: [Target]
- [Metric 2]: [Target]

## 📝 Notes

[Any additional context]
TEMPLATE_EOF

# Template: PRD base
cat > docs/templates/PRD/PRD_template.md << 'TEMPLATE_EOF'
# [Project Name] — Product Requirements Document

**Owner**: @Crhistian
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
- [What's included]

### Out of Scope
- [What's NOT included]

## 4. Users

| User | Description | Needs |
|------|-------------|-------|
| [User 1] | [Description] | [Needs] |

## 5. Functional Requirements

| ID | Requirement | Priority |
|----|-----------|-----------|
| RF-001 | [Requirement] | Must |

## 6. Non-Functional Requirements

| ID | Requirement | Criteria |
|----|-----------|----------|
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
|------|-------|------------|
| [Phase] | [Date] | [Deliverable] |
TEMPLATE_EOF

echo "✅ Templates created"
echo ""

# ============================================
# BASE DOCUMENTATION
# ============================================

echo "📚 Creating base documentation..."

# Template Guide
cat > docs/templates/TEMPLATE_GUIDE.md << 'TEMPLATE_EOF'
# Template Guide

> Quick reference for choosing the right template.

## User Stories

| Situation | Template |
|-----------|----------|
| Normal feature | `user-stories/template-user-story-sdd.md` |
| Small feature (< 2h) | `user-stories/template-user-story.md` |
| Refactor | `refactors/template-refactor.md` |

## Bug Fixes

| Situation | Template |
|-----------|----------|
| Bug with verification tests | `bug-fixes/template-bug-fix-sdd.md` |
| Trivial bug | `bug-fixes/template-bug-fix.md` |

## Architecture

| Situation | Template |
|-----------|----------|
| New decision (under discussion) | `architecture/RFC_template.md` |
| Decision already made | `architecture/ADR_template.md` |

## API & Database

| Document | Template |
|----------|---------|
| API Endpoints | `api/endpoints.md` |
| Database Schema | `database/schema.md` |

## Projects

| Document | Template |
|----------|---------|
| Product Requirements | `PRD/PRD.md` |

## How to Use

1. Copy template to `docs/tasks/` (for HUs) or relevant folder
2. Fill in the sections
3. Delete unused sections
4. Update status as work progresses

## Status Conventions

| Status | Meaning |
|--------|---------|
| 🟡 In Progress | Currently working on |
| 🟢 Done | Completed |
| 🔴 Blocked | Waiting on something |
| ⚫ Archived | Cancelled or superseded |
TEMPLATE_EOF

# Adoption Guide
cat > docs/adoption-guide.md << 'TEMPLATE_EOF'
# Adoption Guide — How to Adopt FlowDoc Based on Your Context

> You don't have to adopt everything at once. Choose the level that best fits your situation and grow from there.

---

## Adoption Levels

```
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
```

---

## Level 1: Documentation Only ✅

**Ideal for**: Teams of 1 person, small projects, starting to document without overhead.

### What to do

1. Create `docs/tasks/HU-001-your-feature.md`
2. Use template from `docs/templates/user-stories/`
3. Document: what it does, acceptance criteria

### When to move to Level 2

When you feel you need more structure.

---

## Level 2: Basic SDD ✅

**Ideal for**: 1-2 people who want structure without a team cycle.

Follow the full SDD cycle: Proposal → Spec → Design → Tasks → Apply → Verify → Archive

---

## Level 3: Adapted Cycle ✅

**Ideal for**: Teams of 2-5 people who want synchronization without excessive meetings.

### What to add

1. **Adapted planning** (not mandatory 15 days)
2. **Clear owner** on each HU
3. **Feature flags** for parallel work

---

## Level 4: Full Team ✅

**Ideal for**: Teams of 4+ people in different time zones.

15-day cycle + metrics + complete process.

---

## Getting Started

1. **Today**: Create `docs/tasks/HU-001-your-next-feature.md`
2. **This week**: Try the SDD cycle on one HU
3. **This month**: Evaluate if you need more structure

The goal is for documentation to be useful, not perfect. Iterate based on your context.
TEMPLATE_EOF

# FAQ
cat > docs/FAQ.md << 'TEMPLATE_EOF'
# FAQ — Frequently Asked Questions

> The most common questions when adopting FlowDoc.

---

## Getting Started

### Where do I start?

**Create a HU at `docs/tasks/HU-001-your-feature.md`.** It's that simple.

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

Based on **adapted Scrum** for distributed teams:

| Scrum Concept | Adaptation |
|---------------|------------|
| Sprint | 15-day cycle |
| Daily standup | 5 min async update |
| Sprint planning | Days 1-2 |
| Integration review | Days 12-14 |

---

## Tool Integration

### How do I integrate with GitHub Projects, Jira, etc.?

**It's not the framework's responsibility.** Integrating with your project management tool is your decision, your team's decision, or your company's decision.

---

## HUs That FAIL

### What if a HU can't be completed?

A HU is not a hard contract. You can:
- **Split** into smaller HUs
- **Archive** with reason: "blocked by X", "scope changed"
- **Create Bug Fix** to resolve issues

The important thing: **don't leave zombie HUs**.

---

## Your question not answered?

Open an issue or ask in the corresponding channel.
TEMPLATE_EOF

# Anti-patterns
cat > docs/anti-patrones.md << 'TEMPLATE_EOF'
# Anti-Patterns — Signs That FlowDoc Is Not Working

> If you see any of these signs, something needs adjusting.

---

## Documentation

### ❌ Outdated docs

**Sign**: Files in `docs/` don't reflect the reality of the code.

**Solution**: "Docs in the PR" rule — update documentation at the same time as code.

### ❌ Zombie HUs

**Sign**: HUs in "in progress" status for more than 2 cycles without progress.

**Solution**: Archive with documented reason. Don't leave indefinitely pending.

### ❌ Obsolete ADRs

**Sign**: ADRs that contradict current decisions.

**Solution**: Mark as `DEPRECATED` and link to the new ADR that replaces it.

---

## Process

### ❌ Unnecessary meetings

**Sign**: Status meetings that could be an async message.

**Solution**: If it doesn't need real-time interaction, it's Discord/Issue, not a meeting.

### ❌ In-person daily standups for async teams

**Sign**: Waiting for everyone to be online to do the daily.

**Solution**: 5-min async updates on Discord, configurable by time zone.

### ❌ 4+ hour planning sessions

**Sign**: Planning extends all day.

**Solution**: Max 4 hours. If it doesn't fit, the feature is too big.

---

## SDD

### ❌ Speccing for fun

**Sign**: All HUs have complete specs, but nobody reads them.

**Solution**: N1 just documentation. N2+ for real features. Don't create overhead by inertia.

### ❌ Design before understanding the problem

**Sign**: Starting with Design without going through Explore/Proposal.

**Solution**: SDD is Proposal → Spec → Design. Don't skip steps.

### ❌ Tasks without tests

**Sign**: Code tasks without their associated test task.

**Solution**: "Each code task includes its test task alongside."

---

## Team

### ❌ Seeking perfection

**Sign**: Not doing anything because "it's not ready".

**Solution**: Iterate. Something imperfectly documented > nothing. Perfect is the enemy of good.

### ❌ Imposing the framework

**Sign**: Forcing the team to follow everything to the letter.

**Solution**: Inspire, don't impose. Show value first.
TEMPLATE_EOF

# Troubleshooting
cat > docs/troubleshooting.md << 'TEMPLATE_EOF'
# Troubleshooting — Common Errors and Solutions

---

## SDD Commands

### Error: "Artifact not found"

**Cause**: No artifact exists for that change.

**Solution**: First create the artifact with `/sdd-new` or verify the name is correct.

### Error: "Permission denied" on scripts

**Cause**: The script doesn't have execute permissions.

**Solution**: `chmod +x scripts/*.sh`

---

## Structure

### Error: "docs/ does not exist"

**Cause**: Structure was not initialized.

**Solution**: Run `scripts/flowdoc-migration.sh` to create the structure.

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
| Work cycle | `docs/flowdoc-ciclo.md` |
| Adoption | `docs/adoption-guide.md` |
| Templates | `docs/templates/TEMPLATE_GUIDE.md` |
TEMPLATE_EOF

echo "✅ Base documentation created"
echo ""

# ============================================
# AGENTS.MD
# ============================================

echo "🤖 Creating AGENTS.md..."

cat > AGENTS.md << 'TEMPLATE_EOF'
# AGENTS.md — FlowDoc

**Framework**: FlowDoc — Documentation that flows with the work
**Ecosystem**: FlowForge (tool) + FlowDoc (framework)
**Stack**: Documentation (no code), SDD workflow, Engram/openspec for artifacts

---

## Stack and Technologies

### Main Framework
- **Name**: FlowDoc
- **Methodology**: SDD (Spec-Driven Development)
- **Artifact Store**: Engram (default), openspec (for teams)
- **Format**: Markdown Documentation
- **Architecture**: Adaptable (monolithic, microservices, monorepo, serverless, or hybrid)

### AI Tool Compatibility

The SDD workflow is **tool-independent**. Any agent that can read and write markdown files works:

| Tool | Compatibility |
|------|---------------|
| OpenCode | ✅ |
| Antigravity | ✅ |
| ClaudeCode | ✅ |
| Other agents | ✅ |

---

## Project Structure

```
docs/                        ← Source of truth
├── templates/              ← Templates (source of truth)
├── architecture/
│   ├── adr/                ← Architecture Decision Records
│   └── rfc/                ← Requests for Comments
├── tasks/                  ← User stories
│   └── HU-001-HU-099/      ← Folder by range
├── flowdoc-ciclo.md        ← Work cycle
├── adoption-guide.md        ← Adoption guide
└── FAQ.md                   ← Frequently asked questions

AGENTS.md                   ← Context for AI agents
```

---

## Conventions

### Commit Conventions (Conventional Commits)

```
feat: add reservation system with date picker
fix: resolve login timeout on mobile
refactor: extract payment logic to domain
docs: update API endpoint documentation
chore: update dependencies
```

### Branch Naming

```
feature/add-reservation-system
fix/login-timeout
refactor/order-service
docs/api-endpoints
hotfix/critical-security-patch
```

---

## Agent Rules

**This agent does NOT:**
- Make commits — that's the human's job
- Modify `AGENTS.md` without human approval
- Modify `docs/` or `openspec/` without human approval
- Merge to `main` or `staging`

**This agent DOES:**
- Generate code in feature branches
- Propose changes, but always with human review
- Read from `docs/` to understand context

---

## Testing in This Project

For projects that USE the framework:
- Tests according to the chosen stack (vitest, jest, xUnit, etc.)
- Minimum coverage: >80%
- Each code task includes its associated test
TEMPLATE_EOF

echo "✅ AGENTS.md created"
echo ""

# ============================================
# CHANGELOG
# ============================================

cat > CHANGELOG.md << 'TEMPLATE_EOF'
# Changelog

Documentation of changes and decisions adopted in the framework.

---

## YYYY-MM-DD — Migration to FlowDoc

### Structure Created

- `docs/` with templates, architecture, tasks
- `AGENTS.md` adapted to the project
- Base documentation: adoption-guide, FAQ, troubleshooting, anti-patterns

### Migration Checklist

See `scripts/flowdoc-legacy-checklist.md` for post-script manual steps.
TEMPLATE_EOF

echo "✅ CHANGELOG created"
echo ""

# ============================================
# ONBOARDING (lightweight)
# ============================================

cat > ONBOARDING.md << 'TEMPLATE_EOF'
# Onboarding — New Team Member

> Checklist for new team members.

---

## Day 1: Context

- [ ] Read `AGENTS.md` — how the team works
- [ ] Read `docs/flowdoc-ciclo.md` — work cycle
- [ ] Read `docs/adoption-guide.md` — adoption levels
- [ ] Have access to repo and tools

## Day 2-3: First Steps

- [ ] Review active HUs in `docs/tasks/`
- [ ] Identify dependencies
- [ ] Local project setup

## Day 4-5: First Contribution

- [ ] Take a small HU
- [ ] Follow the SDD cycle
- [ ] Code + test + docs

## Resources

- [FAQ](docs/FAQ.md) — Frequently asked questions
- [Troubleshooting](docs/troubleshooting.md) — Common errors
- [Anti-patterns](docs/anti-patrones.md) — What to avoid
TEMPLATE_EOF

echo "✅ ONBOARDING created"
echo ""

# ============================================
# GITIGNORE
# ============================================

cat > .gitignore << 'TEMPLATE_EOF'
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

# Agents
.engram/
openspec/

# Legacy templates (use docs/templates instead)
/templates/
TEMPLATE_EOF

echo "✅ .gitignore created"
echo ""

# ============================================
# SUMMARY
# ============================================

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ FlowDoc structure created successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Next steps:"
echo "1. Review docs/flowdoc-ciclo.md"
echo "2. Run scripts/flowdoc-legacy-checklist.md"
echo "3. Adapt AGENTS.md to your project"
echo ""
echo "Run: ls -la docs/"
echo ""

# List what was created
echo "Created structure:"
find docs/ -type f | sort
TEMPLATE_EOF

chmod +x scripts/flowdoc-migration.sh

echo ""
echo -e "${GREEN}✅ Script ready! Run with: ./scripts/flowdoc-migration.sh${NC}"

# FlowDoc Adoption Checklist

> Use this checklist after running `scripts/flowdoc-migration.sh` to complete the adoption of FlowDoc in your project.

---

## 🎯 Which Scenario Applies?

Run this to identify your situation:

```bash
# Check for existing documentation
find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" | head -20

# Check for existing SDD structure
ls -la docs/ 2>/dev/null || echo "No docs/ directory"
ls -la openspec/ 2>/dev/null || echo "No openspec/ directory"
ls -la AGENTS.md 2>/dev/null || echo "No AGENTS.md"
```

| Scenario | What you have | Use |
|----------|---------------|-----|
| **A. With existing SDD** | HUs, ADRs, RFCs, docs/ structure | → Go to Step 1 |
| **B. Without SDD (legacy)** | Existing code but no formal docs/ | → Go to Scenario B |
| **C. New project** | No code, project from scratch | → Go to Scenario C |

---

## Scenario A: Legacy Project WITH Existing SDD

> You have existing HUs, ADRs, RFCs — follow the full checklist.

---

## ⚠️ Before Starting

1. Run `scripts/flowdoc-migration.sh` (creates structure + templates)
2. Confirm you have a backup or are in a git repo

---

## Step 1: Inventory (Identify What Exists)

Run these commands to understand what you have:

```bash
# What documentation exists?
find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" | head -50

# What HUs exist?
find . -name "HU-*.md" -o -name "hu-*.md" -o -name "*user-story*.md" 2>/dev/null

# What ADRs exist?
find . -name "ADR-*.md" -o -name "adr-*.md" 2>/dev/null

# What RFCs exist?
find . -name "RFC-*.md" -o -name "rfc-*.md" 2>/dev/null

# Any existing AGENTS.md?
cat AGENTS.md 2>/dev/null || echo "No AGENTS.md found"

# Any openspec/ artifacts?
ls -la openspec/ 2>/dev/null || echo "No openspec/ found"
```

### Questions to Answer

| Question | Your Answer |
|----------|-------------|
| Where are the HUs? | |
| Where are the ADRs/RFCs? | |
| Is there an existing AGENTS.md? | |
| Are there existing templates? | |
| What's the current structure? | |

---

## Step 2: Map Existing HUs to FlowDoc Structure

For each HU you found:

```
OLD LOCATION                    → NEW LOCATION
----------------------------------------------------------------
docs/tasks/*.md                → docs/tasks/HU-001-HU-099/HU-XXX-*.md
docs/HU-*.md                   → docs/tasks/HU-001-HU-099/HU-XXX-*.md
hu-*.md                        → docs/tasks/HU-001-HU-099/HU-XXX-*.md
templates/user-stories/*.md     → docs/templates/user-stories/ (replace with FlowDoc templates)
```

### Actions

1. **Move HUs to correct location:**
   ```bash
   # Example - adapt to your actual paths
   mv docs/tasks/HU-001.md docs/tasks/HU-001-HU-099/
   mv docs/tasks/HU-002.md docs/tasks/HU-001-HU-099/
   ```

2. **Use FlowDoc templates** for new HUs (script already created them)
   - Don't rewrite existing HUs unless needed
   - New HUs use FlowDoc templates

### ⚠️ Important

- **HUs with active work**: Keep current status, just move file
- **HUs with done status**: Keep as done, just move file
- **HUs with no status**: Add status before moving
- **HU numbering**: FlowDoc uses HU-XXX format. If your existing HUs have different names, you may renumber or keep existing names (not a problem)

---

## Step 3: Move ADRs and RFCs to docs/architecture/

```
OLD LOCATION                    → NEW LOCATION
----------------------------------------------------------------
docs/architecture/adr/*.md     → docs/architecture/adr/
docs/adr/*.md                  → docs/architecture/adr/
architecture/*.md              → docs/architecture/
ADRs/*.md                      → docs/architecture/adr/
RFCs/*.md                      → docs/architecture/rfc/
```

### Actions

```bash
# Example - adapt to your actual paths
mv docs/adr/*.md docs/architecture/adr/
mv docs/rfc/*.md docs/architecture/rfc/
```

### Update References

If an ADR references another ADR or external file, update the links:

```markdown
# Before
[ADR-001](./../../adr/ADR-001.md)

# After
[ADR-001](./ADR-001.md)
```

---

## Step 4: Adapt AGENTS.md to Your Project

The script created a base `AGENTS.md`. You need to customize it:

### Required Changes

1. **Project name and description**
   ```markdown
   # Before (FlowDoc default)
   **Framework**: FlowDoc — Documentation that flows with the work
   **Ecosystem**: FlowForge (tool) + FlowDoc (framework)

   # After (your project)
   **Framework**: FlowDoc — Documentation that flows with the work
   **Project**: [Your Project] — [Description]
   ```

2. **Team information** (add or update)
   ```markdown
   ### Team Tools
   - **Version control**: Git + GitHub
   - **Communication**: Discord (async-first)
   - **Issues**: GitHub Issues
   ```

3. **Tech Stack** (update with your actual stack)
   ```markdown
   ### Project Stack
   - **Frontend**: React + TypeScript
   - **Backend**: Node.js + Express
   - **Database**: PostgreSQL
   ```

### Optional Changes

- Add project-specific conventions
- Add environment setup instructions
- Add team-specific rules

---

## Step 5: Integrate Existing openspec/ (if exists)

If you have `openspec/` with SDD artifacts:

```
openspec/
├── config.yaml
├── specs/
│   └── {domain}/
│       └── spec.md        → docs/{domain}/spec.md (consider consolidating)
└── changes/
    └── {change-name}/
        ├── proposal.md    → docs/tasks/HU-XXX-proposal.md (consider converting)
        ├── specs/
        ├── design.md
        └── tasks.md
```

### Decision: Keep openspec/ or Consolidate?

| Option | When to Use | Pros | Cons |
|--------|-------------|------|------|
| **Keep openspec/** | Active SDD work, team familiar with it | No change | Dual structure |
| **Consolidate to docs/** | Simplify, single source of truth | Unified docs | Migration effort |

### If Consolidating

```bash
# Move openspec artifacts to docs/
mv openspec/changes/*/proposal.md docs/tasks/HU-XXX-proposal.md 2>/dev/null || true
mv openspec/changes/*/design.md docs/tasks/HU-XXX-design.md 2>/dev/null || true
mv openspec/changes/*/tasks.md docs/tasks/HU-XXX-tasks.md 2>/dev/null || true
```

---

## Step 6: Clean Up Legacy Files

### Files to Remove (if safe)

```bash
# Only if you're sure they're not needed and have backups

# Deprecated templates
rm -rf templates/                    # Use docs/templates/ instead

# Duplicate docs (if consolidated)
# rm docs/old-structure.md           # Only after confirming new structure works

# Temporary files
rm -f *~ *.backup *.tmp
```

### ⚠️ Safety First

```bash
# Always git status before deleting
git status

# Only delete files you've confirmed are safe
git rm templates/  # Instead of rm -rf
```

---

## Step 7: Validate the Adoption

### Checklist

- [ ] All HUs moved to `docs/tasks/HU-001-HU-099/`
- [ ] All ADRs moved to `docs/architecture/adr/`
- [ ] All RFCs moved to `docs/architecture/rfc/`
- [ ] `docs/templates/` has all FlowDoc templates
- [ ] `AGENTS.md` customized to project
- [ ] `docs/flowdoc-ciclo.md` readable
- [ ] No broken internal links (run: `rg "\.\./" docs/`)

### Verify Structure

```bash
# Should show:
docs/
├── templates/
│   ├── user-stories/
│   ├── bug-fixes/
│   ├── refactors/
│   ├── architecture/
│   ├── database/
│   ├── api/
│   └── PRD/
├── architecture/
│   ├── adr/
│   └── rfc/
├── tasks/
│   └── HU-001-HU-099/
├── flowdoc-ciclo.md
├── adoption-guide.md
├── FAQ.md
└── troubleshooting.md

AGENTS.md
CHANGELOG.md
ONBOARDING.md
.gitignore
```

---

## Step 8: First Commit

```bash
git add .
git status

# Review what will be committed
git diff --staged --name-only

# Commit
git commit -m "feat: adopt FlowDoc framework

- Migrate existing docs to FlowDoc structure
- Add templates, AGENTS.md, onboarding
- Document team conventions in AGENTS.md

See docs/flowdoc-ciclo.md for work cycle reference."
```

---

## Common Issues

### "I have HUs with different naming"

FlowDoc recommends `HU-XXX-name.md` but doesn't require it. As long as they're in `docs/tasks/`, the agent will find them. Consider renaming over time.

### "My ADRs have different format"

ADRs in FlowDoc use `docs/architecture/adr/ADR-XXX-title.md`. Convert over time when ADRs are updated, not all at once.

### "I have existing openspec/ but also docs/"

Choose one as source of truth. See Step 5 for options. Most teams consolidate to `docs/` for simplicity.

### "The agent doesn't understand my project context"

Update `AGENTS.md` with:
- Project description
- Tech stack
- Team conventions
- Any project-specific rules

---

## Scenario B: Legacy Project WITHOUT SDD (Code Only)

> You have an existing project with code but no formal documentation. The agent will help document what exists.

---

### Step B-1: Agent Explores the Codebase

Prompt for the agent:

```
"The project has no formal documentation. Please:
1. Explore the project structure
2. Identify main modules
3. Identify API endpoints (if any)
4. Identify the database (if any)
5. Briefly describe what each module does

Save findings to docs/exploration.md"
```

### Step B-2: Create Initial Documentation HU

The agent creates the first HU to document the project:

```bash
# Create initial HU
cat > docs/tasks/HU-001-HU-099/HU-001-project-documentation.md << 'EOF'
# HU-001: Project Documentation

**Status**: 🟡 In Progress
**Owner**: @your-user
**Created**: YYYY-MM-DD
**Priority**: Must

---

## 🎯 Intent

Document the current structure and components of the project to have a baseline.

---

## 📋 Scope

### In Scope
- General project structure
- Main modules and responsibilities
- API endpoints (if applicable)
- Data model (if applicable)
- External dependencies

### Out of Scope
- Detailed documentation of each function
- Tests (that comes later)

---

## ✅ Requirements

### MUST
- [ ] Folder structure documented
- [ ] Each module has a responsibility description
- [ ] API endpoints documented (if any)
- [ ] Data model documented (if any)

---

## 🧪 Verification

🧪 Ref: Tech Lead reviews and approves the documentation

---

## 📦 Affected Areas

- `docs/exploration.md` — agent output
- `docs/PRD.md` — requirements document
- `docs/api/endpoints.md` — API contracts
- `docs/database/schema.md` — DB schema
EOF
```

### Step B-3: Agent Completes the HU

The agent executes the HU following the SDD cycle:
- Proposal → Spec → Design → Tasks → Apply → Verify → Archive

### Step B-4: Expected Results

When Scenario B is complete, you'll have:

```
docs/
├── exploration.md          ← What the agent discovered
├── PRD.md                 ← Requirements document
├── api/
│   └── endpoints.md       ← Documented endpoints
├── database/
│   └── schema.md          ← Documented schema
└── tasks/
    └── HU-001-HU-099/
        └── HU-001-project-documentation.md  ← Completed HU
```

---

## Scenario C: New Project (From Scratch)

> You don't have code yet. The agent guides you to document before writing code.

---

### Step C-1: Create PRD

The agent helps you create the Product Requirements Document:

```bash
# Copy template
cp docs/templates/PRD/PRD.md docs/PRD.md

# The agent asks you questions to fill it:
# - What problem does the project solve?
# - Who are the users?
# - What functionalities are core?
# - Are there technical constraints?
```

### Step C-2: Create First HU

```bash
cat > docs/tasks/HU-001-HU-099/HU-002-project-setup.md << 'EOF'
# HU-002: Initial Project Setup

**Status**: 🟡 In Progress
**Owner**: @your-user
**Created**: YYYY-MM-DD
**Priority**: Must

---

## 🎯 Intent

Create the base project structure with initial tooling.

---

## 📋 Scope

### In Scope
- Repository with .gitignore
- Initial folder structure
- Package.json / requirements.txt (based on stack)
- Linting and formatting configured
- Basic CI/CD (if applicable)

### Out of Scope
- Business code
- Feature documentation

---

## ✅ Requirements

### MUST
- [ ] Repo created with .gitignore
- [ ] Folder structure based on architecture
- [ ] Base dependencies installed
- [ ] Linting configured
- [ ] Initial README

---

## 🧪 Verification

🧪 Ref: `npm test` / `pytest` runs without errors after setup
EOF
```

### Step C-3: Recommended Flow

For new projects, the flow is:

```
1. PRD → What are we going to build?
2. First HU → Project setup
3. Next HUs → Real features

The agent documents BEFORE coding.
```

### Note on "User Doesn't Want to Fill Info"

If the user doesn't want or can't answer agent questions:

| Situation | What the agent does |
|-----------|---------------------|
| User doesn't know what to do | Agent asks one thing at a time, not everything together |
| User wants to decide quickly | Agent puts placeholder `[TBD]` and continues |
| User doesn't want to participate | Agent documents what it can from the code and marks "Pending: user decision" |

**Rule**: Better incomplete documentation than none. The agent marks what's missing with `⚠️ PENDING: [user decision]`.

---

## After Adoption

Once adoption is complete:

1. **Test the agent**: Ask "What HUs do we have?" and verify it finds them
2. **Create a new HU**: Use `docs/templates/` and verify the format
3. **Update team**: Share the new structure and conventions
4. **Iterate**: Adjust based on what works for your team

---

## Resources

| Resource | Purpose |
|----------|---------|
| [FlowDoc Adoption Guide](docs/adoption-guide.md) | How to adopt at your pace |
| [FlowDoc FAQ](docs/FAQ.md) | Common questions |
| [FlowDoc Anti-Patterns](docs/anti-patrones.md) | What to avoid |
| [FlowDoc Troubleshooting](docs/troubleshooting.md) | Common errors |
| [FlowDoc Cycle](docs/flowdoc-ciclo.md) | The 15-day work cycle |

---

**Last updated**: 2026-05-29

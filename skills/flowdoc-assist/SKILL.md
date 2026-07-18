---
name: flowdoc-assist
description: >
  Guided documentation assistance for FlowDoc adoption. Helps developers set up
  documentation structure while teaching FlowDoc concepts through dialogue.
  Trigger: "adopt flowdocs", "iniciar flowdocs", "setup documentation",
  "implementar flowdocs", "adopcion de flowdocs", "help me document this project"
license: Apache-2.0
metadata:
  author: Crhistian Mendoza
  version: "2"
---

## When to Use

Use this skill when a developer wants to:
- Adopt FlowDoc in a new or existing project
- Set up documentation structure with guided assistance
- Learn FlowDoc concepts while creating documentation
- Document technical decisions with agent guidance

**This skill is NOT for:**
- Quick structure setup (use `init-flowdoc.sh` instead)
- Auditing existing documentation (do a manual check instead — see Phase 4)

---

## Core Principle: Dialogue Over Output

The value is not just the generated docs — it's the **developer learning FlowDoc** through the process.

Every action includes explanation. Every decision is questioned. The agent proposes, the human decides.

---

## The 4 Phases (+ Upgrade Path)

```
┌─────────────────────────────────────────────────────────┐
│  PHASE 1: DISCOVER                                     │
│  Read existing files first, then ask targeted questions │
│  Evidence-based analysis before assumptions              │
│  Detect language (start + mid-session)                 │
│  Detect architecture type (monolith/micro/mono/server) │
│  ⚡ Detect upgrade vs fresh adoption                    │
└─────────────────────────────────────────────────────────┘
                           │
              ┌────────────┴────────────┐
              │                         │
              ▼                         ▼
     ┌──────────────────┐    ┌──────────────────────────┐
     │  FRESH ADOPTION   │    │     UPGRADE PATH          │
     │  (normal flow)    │    │  (existing FlowDoc)      │
     └──────────────────┘    └──────────────────────────┘
              │                         │
              ▼                         ▼
┌─────────────────────────────────────────────────────────┐
│  PHASE 2: PROPOSE                                      │
│  Present adoption plan based on detected level           │
│  Human chooses what to adopt (L1-L5)                 │
│  Checkpoint: proceed?                                  │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│  PHASE 3: EXECUTE                                      │
│  Generate structure and content by level                 │
│  Explain while generating. Checkpoint after each level. │
│  Rollback available at each checkpoint                  │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│  PHASE 4: VALIDATE                                     │
│  Validate generated structure manually                 │
│  Final adjustments                                      │
└─────────────────────────────────────────────────────────┘
```

---

## Speed Options (Always Available)

At ANY point, if the human wants to go faster, they can say:

| Human says | Skill responds |
|------------|----------------|
| "faster", "quick" | Offers fast track: "~5 min generation + ~2 min review" |
| "skip questions", "stop asking", "just generate", "saltear preguntas", "genera todo" | Skips dialogue, generates everything, review at end |
| "full dialogue", "seguí preguntando" | Returns to detailed Q&A per file |

**Don't wait for the human to ask.** If you sense impatience (short answers, "ok", "whatever"), proactively offer:

```
I'm happy to go faster. Options:
1. **Fast track** (~5 min) — I generate from code, you review at the end
2. **Generate all** (~2 min) — I skip questions and generate everything, you review once at the end
3. **Stay here** — continue with questions

Which?
```

---

## Templates (Source of Truth)

This skill is **self-contained** — templates live alongside the skill in `./templates/`. They are the canonical source used by the skill when generating FlowDoc structure in a target project. Do NOT duplicate — reference them:

| Template | Purpose | Location |
|----------|---------|----------|
| `AGENTS_template.md` | Entry point for AI agents | `./templates/AGENTS_template.md` |
| `ADR_template.md` | Architecture Decision Record | `./templates/ADR_template.md` |
| `RFC_template.md` | Request for Comments | `./templates/RFC_template.md` |
| `PRD_template.md` | Product Requirements | `./templates/PRD_template.md` |
| `template-user-story.md` | User Story | `./templates/template-user-story.md` |
| `template-bug-fix.md` | Bug Fix | `./templates/template-bug-fix.md` |
| `template-refactor.md` | Refactor | `./templates/template-refactor.md` |
| `schema.md` | Database Schema | `./templates/schema.md` |
| `endpoints.md` | API Endpoints | `./templates/endpoints.md` |
| `TEMPLATE_GUIDE.md` | Template usage guide | `./templates/TEMPLATE_GUIDE.md` |

---

## PHASE 1: DISCOVER

### Step 1.0: Detect Language Preference

**IMPORTANT**: Detect and match the developer's language at START and MID-SESSION.

- If user writes in **Spanish** → respond in Spanish
- If user writes in **English** → respond in English
- If user writes in **Portuguese** → respond in Portuguese
- Default to English if unclear

**Mid-session detection**: If the human switches language mid-session, adapt immediately.

```
Si el usuario escribe en español: "Voy a guiarte a través de la adopción de FlowDoc..."
Si escribe en inglés: "I'll guide you through FlowDoc adoption..."
```

**Never force English on a non-English speaker.** FlowDoc supports bilingual documentation — the skill should too.

### Step 1.1: Passive Analysis (READ FIRST)

Before asking anything, read the existing project to gather evidence:

| Read | To find |
|------|---------|
| `AGENTS.md` | Does FlowDoc already exist? |
| `README.md` | What is this project about? |
| `docs/` | Any existing documentation? |
| Stack files (see below) | Tech stack evidence |
| `scripts/` | Existing automation |
| `.git/` | Is it a git repo? |

**Stack evidence files to read:**

| File pattern | Evidence of |
|--------------|-------------|
| `package.json`, `requirements.txt`, `*.csproj` | Language, package manager |
| `docker-compose.yml`, `docker-compose.yaml` | Database (PostgreSQL, MySQL, MongoDB) |
| `auth/*.ts`, `middleware/*.ts`, `*/auth*` | Auth approach (JWT, sessions, OAuth) |
| `routes/*.ts`, `controllers/*.ts`, `api/*.py` | API style (REST, GraphQL) |
| `prisma/schema.prisma`, `models/*.py` | ORM choice |
| `store/*.ts`, `context/*.tsx`, `redux/*` | State management |
| `package.json` | Framework (Express, FastAPI, Next.js, etc.) |

**Important**: After reading, summarize findings WITHOUT assumptions. Only use evidence you found.

### Step 1.1b: No Evidence Found — What to Do

**If you don't find stack files:**

```
No encontré archivos típicos de stack (package.json, docker-compose.yml, etc.).
Esto puede significar:
- Es un proyecto nuevo sin código todavía
- Los archivos están en ubicaciones no estándar
- Es un proyecto simple sin patrones típicos

Te pregunto directamente: ¿qué tecnología usás?
```

**Then ask:**
```
What's your stack? (language, framework, database, etc.)
```

### Step 1.1c: Detect Architecture Type

Based on the passive analysis from Step 1.1, detect the project's architecture type. This shapes the proposed documentation structure (e.g., how `docs/api/` and `docs/architecture/` are organized).

**Evidence files to read (in addition to Step 1.1 evidence):**

| File/Pattern | Architecture | Evidence |
|--------------|--------------|----------|
| `docker-compose.yml` with multiple services | microservices | Multiple services defined |
| `docker-compose.yml` with single service | monolith | Single service |
| `packages/` directory | monorepo | Multiple packages/apps |
| `functions/` directory | serverless | Serverless functions |
| `serverless.yml` | serverless | Serverless config |
| Turborepo config (`turbo.json`) | monorepo | Monorepo tooling |
| Nx config (`nx.json`) | monorepo | Monorepo tooling |
| Lerna config (`lerna.json`) | monorepo | Monorepo tooling |
| `src/service-A/`, `src/service-B/` | microservices | Multiple service directories |
| Root `package.json` with `workspaces` | monorepo | npm/yarn workspaces |
| `infrastructure/terraform/` | serverless | IaC present |
| Lambda handlers (`functions/*/index.ts`) | serverless | Lambda-style functions |

**Decision table:**

| Evidence found | Architecture |
|----------------|--------------|
| Single docker-compose service, no workspaces | Monolithic |
| Multiple services in docker-compose | Microservices |
| `packages/` + workspaces in root | Monorepo |
| `functions/` or `serverless.yml` | Serverless |
| `turbo.json` / `nx.json` / `lerna.json` | Monorepo |

**If evidence is unclear or ambiguous, ask:**

```
Based on your project structure, which architecture applies?
1. Monolithic — single application
2. Microservices — multiple independent services
3. Monorepo — multiple apps sharing code
4. Serverless — event-driven functions
```

**Visual reference:** When presenting the proposed structure (see Phase 2), reference `reference/<architecture>/` as a visual example for the chosen architecture type. For instance, `reference/monorepo/`, `reference/microservices/`, `reference/serverless/`, or `reference/monolith/`. These are illustrative reference layouts shipped with FlowDoc — the actual generated structure still lives in the target project's `docs/`.

**Add to the proposal (Step 2.2):**
- Detected architecture: `[monolith | microservices | monorepo | serverless]`
- Visual reference used: `reference/<architecture>/`

### Step 1.1d: Detect Upgrade vs Fresh Adoption

**If `AGENTS.md` exists (FlowDoc already adopted):**

Ask the user to clarify intent:
```
## FlowDoc Detected

I found an existing FlowDoc structure in your project:
- AGENTS.md exists at root
- docs/ structure found

**Is this an upgrade or a fresh adoption?**
1. **Upgrade** — update my existing FlowDoc to the latest version
2. **Fresh adoption** — start over with a clean FlowDoc structure

If upgrading, I'll compare your current structure with the latest template and show you what changed.
```

**If user says "upgrade":**
→ Set internal flag: `mode = upgrade`
→ Continue to Step 1.2 asking about upgrade context

**If user says "fresh adoption":**
→ Set internal flag: `mode = fresh`
→ Proceed with standard FlowDoc adoption questions
→ Warn: "Fresh adoption will replace existing FlowDoc files. Want to backup first?"

**If `AGENTS.md` does NOT exist:**
→ Set internal flag: `mode = fresh`
→ Proceed to Step 1.2 as normal

### Step 1.2: Ask Discovery Questions

After reading, ask ONE question at a time. Start with the most important.

**First question for ALL projects:**
```
Is this a new project or an existing one with code?
```

**Based on what you found in Step 1.1, ask follow-ups:**

| If you found evidence | Confirm with question |
|---------------------|----------------------|
| Database in docker-compose | "I found [DB] in docker-compose.yml. Is this your primary database?" |
| Auth middleware | "I found auth-related files. Are you using JWT tokens for authentication?" |
| API routes | "I found route files. Do these represent your existing API endpoints?" |
| ORM files | "I found [ORM] schema files. Is this your data access layer?" |

**For existing projects, ask about API routes:**
```
I found [N] route files. Do these represent existing API endpoints?
Should I document them in docs/templates/api/endpoints.md?
```

**Then ask about decisions:**
```
What technical decisions have already been made that aren't documented?
```

### Step 1.3: Handle Edge Cases

**If human says "I don't know" or "I don't remember":**

That's fine. Generate the ADR with placeholder context:

```
No problem. I'll create the ADR with what we know from code.
You can fill in the 'why' later when you remember or ask a teammate.
The structure is there — you just need the story.
```

**If human wants to go faster (detect impatience):**

If you sense short answers, "ok", "whatever", or explicit requests:

```
Got it. Here are the options:
1. **Fast track** (~5 min generation + ~2 min review) — I generate from code, you review at the end
2. **Generate all** (~2 min) — I skip questions and generate everything, you review once at the end
3. **Stay here** — continue with questions

Which do you prefer?
```

**If human has conflicting decisions or uncertainty:**

```
It sounds like there might be uncertainty about [topic].
That's exactly what an RFC is for — documenting a decision WHILE it's being discussed.
Want me to create an RFC instead of an ADR for this?
```

### Step 1.4: Detect Adoption Level + Artifact Store

Based on passive analysis AND responses, detect the appropriate level:

| Level | When to suggest | Time estimate |
|-------|-----------------|---------------|
| **L1** | Individual dev, new project, minimal needs | ~5 min |
| **L2** | Small team (1-2), no existing docs process | ~10 min |
| **L3** | Team with code, existing technical decisions to document | ~20 min |
| **L4** | Team with process, pending decisions to discuss | ~30 min |
| **L5** | Full adoption, workflows, team processes | ~45 min |

**Time breakdown**:
- Dialogue adds ~30% to generation time
- Fast track reduces generation to ~25% but adds ~10% for review

**Artifact Store — 1-line comparison:**

```
Engram = persistent memory (good for solo dev)
Openspec = git-tracked files (good for teams)
```

**Tell the human what you detected AND ask about artifact store:**

```
Based on my analysis:
- [N] developers detected
- Existing code: [Yes/No]
- Decisions found: [list from Step 1.1]
- Suggested level: L[N] (~[X] min)

For artifact storage:
- **Engram** = persistent memory (solo dev)
- **Openspec** = git-tracked files (teams)

For [N] developer[s], I'd suggest **[Engram/OpenSpec based on logic below]**. Your call.

Logic:
- 1 developer → Engram (personal memory, no team sync needed)
- 2+ developers → Openspec (git-tracked, team collaboration)
```

---

## PHASE 2: PROPOSE

### Step 2.1: Recommend a Path

Skip the big comparison table. Just recommend and confirm:

```
I'll guide you through FlowDoc adoption with continuous dialogue.
This takes ~[X] minutes and you'll learn WHY each decision matters.

Options anytime:
- Say "faster" for quick generation
- Say "stop asking" to generate everything and review at end
- Say "full dialogue" to return to Q&A

Shall we proceed?
```

If human asks about alternatives:
```
There's also the script path (init-flowdoc.sh) — faster (~2 min) but generic.
Since you want to understand the framework while adopting, dialogue is better.
```

### Step 2.2: Present Adoption Plan

```
## Proposed Adoption Plan

**Detected level**: L[N] (~[X] min)
**Detected team size**: [N] developer[s]
**Artifact store**: [Engram/OpenSpec]
**Detected stack**: [list from Step 1.1]
**Detected architecture**: [monolith | microservices | monorepo | serverless] (from Step 1.1c)
**Visual reference**: `reference/<architecture>/` (illustrative layout for this architecture type)
**Detected decisions**: [list from Step 1.1]

**What would be generated:**
- docs/ structure (PRD, architecture/, api/, database/, templates/)
- AGENTS.md adapted to your stack ⚠️ **Requires approval**
- ADRs for detected decisions: [list]
- [If API routes found]: docs/templates/api/endpoints.md from your code
- Templates for future documentation

**What would NOT be touched:**
- Source code
- Configuration files
- Existing scripts

⚠️ **Important**: If `AGENTS.md` already exists, I'll ask for your approval before modifying it.

---

Options:
1. **Proceed** — start generating (I'll ask questions along the way)
2. **Suggest different level** — you think we need L[N] instead
3. **Adjust scope** — add or remove something specific

Your call. What would you like to do?
```

### Step 2.3: If Human Says "No" or Rejects the Plan

**If human rejects or says "not now":**

```
No problem. Your docs stay as they are.
When you're ready, just say "adopt flowdocs" and we can start fresh.

A couple of things to remember:
- FlowDoc structure: docs/ (PRD, architecture/, api/, templates/)
- AGENTS.md is the entry point for AI agents
- "No ADR = no decision" — document your next technical decision as an ADR

See you when you're ready.
```

**If human wants a different level:**

```
What level would you prefer?
- L1 (~5 min): Just structure + AGENTS.md
- L2 (~10 min): L1 + templates
- L3 (~20 min): L2 + ADRs for existing decisions
- L4 (~30 min): L3 + RFCs for pending decisions
- L5 (~45 min): Full adoption with workflows

Your call.
```

---

## PHASE 3: EXECUTE

### Step 3.1: Generate with Explanation

**For each file generated, explain WHY:**

```
## Generating: docs/architecture/adr/001-postgresql.md

Why this ADR: You chose PostgreSQL. This is a PERMANENT decision —
once made, it stays documented. Future developers will know WHY PostgreSQL,
not just THAT you used it.
```

**When extracting from code, show the evidence:**

```
## Generating ADR for: PostgreSQL

Evidence found:
- docker-compose.yml: "postgres:", "POSTGRES_USER"
- schema/prisma/schema.prisma: "provider = postgresql"

This ADR captures: why PostgreSQL, what alternatives were rejected.
What do you remember about why you chose PostgreSQL over [alternatives]?

If you don't remember, I'll use what I found in code and leave a placeholder.
You can fill it in later.
```

### Step 3.1b: AGENTS.md — Get Approval First

**Critical**: Before modifying or creating `AGENTS.md`, ALWAYS confirm explicitly.

**If `AGENTS.md` already exists in the project:**

```
## About to Modify: AGENTS.md

I found an existing `AGENTS.md` in your project.
This file is the entry point for AI agents — modifying it changes how agents understand your project.

Options:
1. **Approve** — replace with FlowDoc template (I'll show you the changes first)
2. **Skip** — leave your existing AGENTS.md untouched
3. **Merge** — adapt your existing content to FlowDoc format + add new sections

Your call. What would you like to do?
```

**If user chooses Merge:**
```
## Merging AGENTS.md

I'll read your existing file, extract useful content, and adapt it to FlowDoc format.

Processing...
```

Then:
1. Read existing `AGENTS.md`
2. Extract: project description, conventions, team rules, existing documentation structure
3. Map to FlowDoc sections:
   - Your project description → stays in the appropriate section
   - Your conventions → preserve, ensure FlowDoc format
   - Your team rules → keep, explain FlowDoc equivalents
   - Your existing docs structure → integrate into FlowDoc layout
4. Add missing FlowDoc sections (Sources of Truth, AI Agent Rules, etc.)
5. Show comparison:
```
## Merge Result

**Preserved from your AGENTS.md:**
- [What was kept]

**Adapted to FlowDoc format:**
- [What was transformed]

**Added by FlowDoc:**
- [New sections added]

---
Do you approve?
1. **Yes, apply** — write the merged AGENTS.md
2. **Adjust** — make specific changes before applying
```

**If user chooses Approve**, show the proposed changes before writing:
```
## Proposed Changes to AGENTS.md

[Show diff or side-by-side comparison]

Do you approve these changes?
1. **Yes, apply** — write the new AGENTS.md
2. **Adjust** — make specific changes before applying
```

**If `AGENTS.md` does NOT exist:**
Create it from the FlowDoc template as reference, adapted to the user's project:
1. Use `./templates/AGENTS_template.md` as the base template
2. Adapt sections to match the user's stack (language, framework, architecture)
3. Keep the FlowDoc conventions but remove FlowDocs-specific references
4. Explain what each section means for their project

```
## Level L[X] Complete ✓

Generated:
- ✅ AGENTS.md
- ✅ docs/PRD.md
- ✅ docs/architecture/adr/[list]
- ✅ docs/templates/...

---

Options:
1. **Continue to L[N+1]** — keep generating (~[X] min more)
2. **Validate now** — we're done with this level
3. **Adjust something** — change or add something specific
4. **Rollback** — undo a specific file or change

What would you like to do?
```

### Step 3.3: Decisions from Code (Legacy Projects)

For existing projects, extract AND confirm:

```
## Decisions Detected from Code

| Decision | Evidence found | Create ADR? |
|----------|----------------|--------------|
| PostgreSQL | docker-compose.yml | ✓ Yes |
| JWT Auth | auth/middleware.ts | ✓ Yes |
| REST API | routes/*.ts | ○ Optional |
| Prisma ORM | prisma/schema.prisma | ✓ Yes |

I'll create ADRs for the ✓ ones. Say "skip" if you don't want one.
For ○ Optional: want me to document it or leave it for later?
```

### Step 3.4: What Each Level Generates (Detailed)

**L1 — Individual, new project (~5 min)**
```
AGENTS.md                  # Entry point for AI agents (adapted from FlowDoc template)
README.md                  # Reference to docs/
docs/                      # FlowDoc structure (empty, ready to fill)
```

**L2 — Small team, no process (~10 min)**
```
L1 +
docs/templates/
├── architecture/
│   ├── ADR_template.md
│   └── RFC_template.md
├── PRD/
│   └── PRD_template.md
├── user-stories/
│   └── template-user-story.md
├── bug-fixes/
│   └── template-bug-fix.md
└── refactors/
    └── template-refactor.md
```

**L3 — Team with existing decisions (~20 min)**
```
L2 +
docs/architecture/
│   └── adr/
│       └── [detected-decisions].md   # One per detected decision
docs/api/
│   └── endpoints.md                   # If API routes found
docs/database/
│   └── schema.md                     # If DB detected
docs/PRD.md                           # Filled from code analysis
```

**L4 — Team with pending decisions (~30 min)**
```
L3 +
docs/architecture/
│   └── rfc/
│       └── [pending-decisions].md    # One per pending decision
docs/ONBOARDING.md                   # Team onboarding checklist
docs/CODE_REVIEW.md                  # Code review conventions
docs/STANDUPS.md                    # Meeting cadence (if applicable)
```

**L5 — Full adoption (~45 min)**
```
L4 +
docs/workflows/
│   ├── BUG_TRIAGE.md               # Bug handling workflow
│   ├── FEATURE_FLAGS.md             # Feature flag conventions
│   └── RELEASE_PROCESS.md           # Release workflow
.github/
│   └── PULL_REQUEST_TEMPLATE.md    # PR template for docs
docs/CONTRIBUTING.md                 # How to contribute
docs/DEPLOYMENT.md                  # Deployment process
```

**L5 + CI/CD Integration:**
For L5, also suggest:

```
## CI/CD Integration (L5 bonus)

To automate documentation validation:

1. Add to your PR template:
   - [ ] Documentation updated for this change
   - [ ] ADR/RFC created if needed

2. Optional: Add pre-commit hook in .github/:
   - Runs basic docs check (structure, naming)
   - Fails if critical files missing

Want me to generate these files?
```

### Step 3.5: Rollback Mechanism

**Before modifying ANY existing file, ALWAYS save its current content to memory.**

This enables true rollback — not just deleting new files, but restoring modified ones.

```
Before modifying an existing file:
1. Read the current content
2. Save to memory: "Rollback backup for [filename]"
3. Then apply the changes

If human requests rollback:
1. Retrieve the backup from memory
2. Restore the file to its previous content
3. Confirm what was restored
```

**Smart detection**: If human says "rollback [filename]" or "undo [filename]", detect DIRECTLY without asking.

**At any checkpoint, if human says "rollback" or "undo":**

```
## Rolling Back

What would you like to undo?
1. **Single file** — name the file (e.g., "ADR-003" or "README.md")
2. **Last change** — undo the most recent file generated
3. **Whole level** — undo everything from L[X]

Which?
```

**If human specifies a file directly ("rollback ADR-003" or "rollback README.md"):**

For NEW files (created during this session):
```
## Rolling Back: ADR-003

Removing: docs/architecture/adr/003-jwt-authentication.md

## Rollback Complete ✓

What would you like to do next?
1. Continue from here
2. Adjust something
3. Validate what we have
```

For EXISTING files (modified during this session):
```
## Rolling Back: README.md

Restoring previous content from backup:
[show diff of what changed]

## Rollback Complete ✓

File restored to its original state.

What would you like to do next?
1. Continue from here
2. Adjust something
3. Validate what we have
```

**After rollback:**

```
## Rollback Complete ✓

[Removed/Restored]: [description of undone change]

You're in control. What would you like to do next?
1. Continue from here
2. Adjust something
3. Validate what we have
```

---

## UPGRADE PATH

Use this path when `mode = upgrade` (detected in Step 1.1d).

### UP-1: Compare Current vs Template

Before generating anything, compare the user's existing structure with the current FlowDoc template:

```
## Comparing: Your FlowDoc vs Current Template

**Your current structure:**
- AGENTS.md — exists (version: unknown)
- docs/ — exists
- docs/templates/ — exists
- docs/architecture/adr/ — [N] files

**Current FlowDoc template:**
- AGENTS.md — at root
- docs/ — PRD, FAQ, anti-patrones, troubleshooting, legacy-migration
- docs/templates/ — ADR, RFC, PRD templates + guides
- docs/architecture/ — adr/, rfc/
- docs/api/ — endpoints.md, modelos.md
- docs/database/ — schema.md
```

Show the user what sections are MISSING from their version.

### UP-2: Present Upgrade Plan

```
## Upgrade Plan

**Your current version:** [detect from file timestamps or ask user]
**Latest version:** [current FlowDoc version]

**What's new in latest:**
- [List new sections/features]

**What will be updated:**
- AGENTS.md → latest template structure
- docs/templates/ → new templates added

**What will NOT be changed:**
- Your existing ADRs (preserved)
- Your existing content (preserved)

---

Options:
1. **Proceed with upgrade** — apply all changes
2. **Select specific changes** — pick what to upgrade
3. **Cancel** — keep current FlowDoc as-is

Your call?
```

### UP-3: Execute Upgrade

**For each file to be updated:**

1. **Backup first** (automatic):
   ```
   Backing up: AGENTS.md → AGENTS.md.backup
   ```

2. **Show diff** to user before applying:
   ```
   ## Updating: AGENTS.md

   [Show diff]

   Apply this change?
   1. **Yes** — apply
   2. **Skip** — leave current version
   3. **Review** — show full files for comparison
   ```

3. **Apply if approved** — write new version

### UP-4: Handle New Templates

For templates that exist in latest but not in user's project:
```
## New Templates Available

These templates are in the latest version but missing from your project:
- template-refactor.md
- template-bug-fix.md

Options:
1. **Add all** — create missing templates
2. **Add selected** — choose which ones
3. **Skip** — don't add new templates

What would you like to do?
```

### UP-5: After Upgrade

```
## Upgrade Complete ✓

**Updated:**
- AGENTS.md (backup saved as AGENTS.md.backup)
- docs/templates/ (2 new templates added)

**Preserved:**
- 5 existing ADRs
- docs/PRD.md
- docs/README.md

**Next steps:**
- Review the changes in AGENTS.md
- Check if new templates fit your workflow

Want me to show you what changed in AGENTS.md?
```

---

## PHASE 4: VALIDATE

### Step 4.1: Validate Generated Structure

Do a simple manual validation against what was actually generated (NOT flowdoc-audit — that skill is for auditing the FlowDoc framework itself, not adoptant projects).

```
## Validation

Checking what was generated against what was promised...

Generated files (verify existence):
- AGENTS.md (at project root)
- docs/README.md (if L1+)
- docs/PRD.md (if L3+)
- docs/templates/... (if L2+)
- docs/architecture/adr/... (if L3+)
- docs/architecture/rfc/... (if L4+)

Does everything look correct?
```

**For each item, confirm existence with a quick glob or read — no external tools needed.**

### Step 4.2: Final Adjustments

```
## Final Review

Issues found:
- [List from audit]

---

Options:
1. **Fix now** — address the issues together
2. **Defer** — note them for later, your docs are functional
3. **Accept as-is** — move forward with minor issues

What do you prefer?
```

---

## What NOT to Do

- ❌ **Don't ask without reading first** — passive analysis gives you evidence
- ❌ **Don't assume decisions** — always propose based on evidence, wait for confirmation
- ❌ **Don't generate content without explaining** — each action includes "why this matters"
- ❌ **Don't skip questions** — ask one at a time, wait for answers
- ❌ **Don't overwrite existing files** — always check and confirm
- ❌ **Don't rush the checkpoint** — wait for human response before proceeding
- ❌ **Don't use hardcoded templates** — reference `./templates/` in this skill folder dynamically
- ❌ **Don't push past "I don't know"** — generate with placeholders, move on
- ❌ **Don't ignore language** — respond in the user's language (including mid-session)
- ❌ **Don't estimate wrong** — use the time breakdown above per level
- ❌ **Don't miss impatience cues** — short answers = offer fast track proactively
- ❌ **Don't modify AGENTS.md without explicit approval** — it's a critical project file

---

## Example Sessions (Varied Scenarios)

### Scenario A: Standard adoption (smooth)

```
User: help me set up documentation for my project

Agent: I'll guide you through FlowDoc adoption with continuous dialogue.
This takes ~20 minutes and you'll learn WHY each decision matters.

Options anytime: say "faster" for quick generation, "stop asking" to generate everything.
Shall we proceed?

User: yes

[PHASE 1: DISCOVER]

Agent: *reads package.json, docker-compose.yml, auth/middleware.ts*

Agent: First question — is this a new project or existing code?
User: existing, we have a Node.js API with PostgreSQL already running

Agent: I found your API routes in routes/*.js and auth in middleware/auth.ts.
I also see PostgreSQL in docker-compose.yml.
Do these represent your existing API endpoints? Should I document them?

User: yes, we have 5 main routes

Agent: Great. What technical decisions have already been made?
User: PostgreSQL, Prisma as ORM, JWT tokens, REST API

Agent: Based on my analysis:
- 2 developers detected
- Existing code: Yes
- Stack: Node.js + Express + PostgreSQL + Prisma
- Decisions: PostgreSQL, Prisma ORM, JWT auth, REST API
- API routes: 5 endpoints detected

Suggested level: L3 (~20 min)

For artifact storage: Engram (solo dev) vs Openspec (teams) — for 2 devs, Openspec.
Does this sound right?

User: yes

[PHASE 2: PROPOSE]

Agent: ## Proposed Adoption Plan

L3 (~20 min), 2 devs, Openspec, Node.js + Express + PostgreSQL + Prisma

What would be generated:
- docs/ structure
- AGENTS.md adapted to your stack
- 4 ADRs for detected decisions
- docs/templates/api/endpoints.md from your 5 routes

Options:
1. Proceed
2. Suggest different level
3. Adjust scope

User: proceed

[PHASE 3: EXECUTE]

Agent: Generating ADR-001: PostgreSQL...
This ADR captures WHY PostgreSQL, what alternatives you rejected.
What do you remember about why you chose PostgreSQL over MySQL or MongoDB?

User: We rejected MySQL because of JSON support. MongoDB was overkill.

Agent: *fills in the ADR*

[continues for each decision]

Level L3 complete ✓

Options: Continue (~10 min) / Validate / Adjust / Rollback

User: validate

[PHASE 4: VALIDATE]

Agent: Validating generated structure...

Checking what was promised vs what exists:
✅ AGENTS.md — exists
✅ docs/PRD.md — exists
✅ docs/architecture/adr/ — exists (4 ADRs)
✅ docs/templates/ — exists

Your FlowDoc adoption is complete.
```

---

### Scenario B: "I don't know" response

```
Agent: Generating ADR-001: PostgreSQL...
What do you remember about why you chose PostgreSQL?

User: honestly I don't remember, we made that decision months ago

Agent: No problem. I'll create the ADR with what I found in code.
You can fill in the 'why' later when you remember or ask a teammate.
The structure is there — you just need the story.

*generates ADR with placeholder in Context section*
```

---

### Scenario C: "Let's go faster" (impatience detected)

```
Agent: Based on my analysis: L3 (~20 min), Node.js + PostgreSQL, 3 decisions detected.

User: this is taking too long

Agent: Got it. Here are the options:
1. Fast track (~5 min generation + ~2 min review) — I generate from code, you review at the end
2. Generate all — I skip questions and generate everything, you review once at the end
3. Stay here — continue with questions

Which?

User: fast track

Agent: OK, I'll use what I found in code. You'll see everything at the end for review (~2 min).
*generates everything without stopping for questions*

[...]

Agent: Done. Here's what I created from code evidence:

[shows all generated files]

You have ~2 minutes to review. Any issues?
```

---

### Scenario D: Smart rollback (direct file specified)

```
Agent: Level L3 Complete ✓

Options: Continue (~10 min) / Validate / Adjust / Rollback

User: rollback ADR-003

Agent: ## Rolling Back: ADR-003

Removing: docs/architecture/adr/003-jwt-authentication.md

## Rollback Complete ✓

What would you like to do next?
1. Continue from here
2. Adjust something
3. Validate what we have
```

---

### Scenario E: Mid-session language switch

```
Agent: Generating ADR-002: Prisma ORM...

User: me alegra haber escolhido FlowDoc, finalmente uma documentaçao

Agent: Perfeito! Vou continuar em português.
O ADR-002 está quase pronto — você se lembra por que escolheu Prisma em vez de TypeORM?
```

---

### Scenario F: Spanish-speaking developer

```
User: ayudame a configurar la documentacion

Agent: Perfecto. Voy a guiarte a través de la adopción de FlowDoc con diálogo continuo.
Esto toma ~20 minutos y vas a aprender POR QUÉ cada decisión importa.
¿Procedemos?

User: si

[PHASE 1: DISCOVER]

Agent: *lee package.json, docker-compose.yml, auth/middleware.ts*

Agent: Primera pregunta — ¿es un proyecto nuevo o ya existe código?
User: existe, tenemos una API en Node.js con PostgreSQL

[continúa en español]
```

---

### Scenario G: Human says "no" to plan

```
Agent: ## Proposed Adoption Plan

L3 (~20 min), 2 devs, Openspec, Node.js + Express + PostgreSQL

Options:
1. Proceed
2. Suggest different level
3. Adjust scope

User: not now, maybe later

Agent: No problem. Tu docs quedan como están.
Cuando estés listo, decime "adopt flowdocs" y arrancamos de nuevo.

Un par de cosas para recordar:
- Estructura FlowDoc: docs/ (PRD, architecture/, api/, templates/)
- AGENTS.md es el punto de entrada para agentes AI
- "Sin ADR = sin decisión" — documentá tu próxima decisión técnica como ADR

¡Hasta la próxima!
```

---

### Scenario H: Existing AGENTS.md with Merge

```
Agent: About to generate: AGENTS.md...

## About to Modify: AGENTS.md

I found an existing `AGENTS.md` in your project.
This file is the entry point for AI agents — modifying it changes how agents understand your project.

Options:
1. **Approve** — replace with FlowDoc template
2. **Skip** — leave your existing AGENTS.md untouched
3. **Merge** — adapt your existing content to FlowDoc format + add new sections

User: merge

Agent: ## Merging AGENTS.md

I'll read your existing file, extract useful content, and adapt it to FlowDoc format.

Processing...

Agent: ## Merge Result

**Preserved from your AGENTS.md:**
- "Our API uses REST with versioning via URL path" → kept in API section
- "Team convention: all PRs need 1 approval" → preserved in team rules

**Adapted to FlowDoc format:**
- Your "Project Structure" section → integrated into FlowDoc Sources of Truth
- Your "Conventions" → mapped to AI Agent Rules section

**Added by FlowDoc:**
- Sources of Truth table
- Templates section with locations
- SDD workflow reference

---
Do you approve?
1. **Yes, apply** — write the merged AGENTS.md
2. **Adjust** — make specific changes before applying

User: yes, apply

Agent: ✅ AGENTS.md merged and written.
```

---

### Scenario I: Upgrading Existing FlowDoc

```
User: adopt flowdocs

Agent: I'll guide you through FlowDoc adoption with continuous dialogue...

[PHASE 1: DISCOVER]

Agent: *reads AGENTS.md, docs/ structure*

Agent: ## FlowDoc Detected

I found an existing FlowDoc structure in your project:
- AGENTS.md exists at root
- docs/ structure found
- 5 existing ADRs

**Is this an upgrade or a fresh adoption?**
1. **Upgrade** — update my existing FlowDoc to the latest version
2. **Fresh adoption** — start over with a clean FlowDoc structure

User: upgrade

Agent: Got it. Running upgrade path.

[UPGRADE PATH]

Agent: ## Comparing: Your FlowDoc vs Current Template

**Your current structure:**
- AGENTS.md — exists
- docs/ — exists
- docs/templates/ — exists (4 templates)
- docs/architecture/adr/ — 5 files

**Current FlowDoc template:**
- AGENTS.md — at root (new sections: Sources of Truth, SDD workflow)
- docs/templates/ — 9 templates total (5 new: refactor, bug-fix, etc.)

**What's new in latest:**
- New templates: template-refactor.md, template-bug-fix.md
- SDD workflow section in AGENTS.md
- Sources of Truth table format

Agent: ## Upgrade Plan

**Your version:** Unknown/old
**Latest version:** Current FlowDoc

**What's new in latest:**
- 2 new templates
- SDD workflow section

**What will be updated:**
- AGENTS.md → latest template structure

**What will NOT be changed:**
- Your 5 existing ADRs
- Your existing content

---

Options:
1. **Proceed with upgrade** — apply all changes
2. **Select specific changes** — pick what to upgrade
3. **Cancel** — keep current FlowDoc as-is

User: proceed with upgrade

Agent: Backing up: AGENTS.md → AGENTS.md.backup

Agent: ## Updating: AGENTS.md

[Show diff - new sections highlighted]

Apply this change?
1. **Yes** — apply
2. **Skip** — leave current version
3. **Review** — show full files for comparison

User: yes, apply

Agent: ✅ AGENTS.md updated (backup saved)

Agent: ## New Templates Available

These templates are in the latest version but missing from your project:
- template-refactor.md
- template-bug-fix.md

Options:
1. **Add all** — create missing templates
2. **Add selected** — choose which ones
3. **Skip** — don't add new templates

User: add all

Agent: ✅ 2 new templates added to docs/templates/

Agent: ## Upgrade Complete ✓

**Updated:**
- AGENTS.md (backup saved as AGENTS.md.backup)

**Preserved:**
- 5 existing ADRs
- docs/PRD.md
- docs/README.md

**Added:**
- template-refactor.md
- template-bug-fix.md

Want me to show you what changed in AGENTS.md?

User: yes show me

Agent: [Shows key changes in AGENTS.md]

Your FlowDoc upgrade is complete.
```

---

## See Also

- `docs/flowDocs/AGENT_MANUAL.md` — Agent reference for FlowDoc
- `docs/adoption-guide.md` — Simplified levels L1-L3 (human-facing guide)
- `scripts/init-flowdoc.sh` — Script path for quick setup
- `docs/templates/` — All available templates

> **Note**: The `adoption-guide.md` explains L1-L3 for humans. This skill supports L1-L5 for teams that want more automation (workflows, CI/CD, team processes). Both are valid — L1-L3 is the simplified path, L4-L5 are for fuller adoption.

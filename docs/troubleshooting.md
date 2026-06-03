# Troubleshooting — Common Errors and Solutions

> Guide to frequent issues when using SDD with this framework.

---

## SDD Commands

### `/sdd-init` doesn't work

**Symptom**: The command doesn't respond or throws an error.

**Possible causes**:
1. You're not in a git project
2. The directory doesn't have write permissions
3. The SDD tool is not configured

**Solution**:
```bash
# Verify you're in a git repo
git status

# Verify permissions
ls -la

# If the project is empty, initialize git first
git init
git add .
git commit -m "chore: initial structure"

# Then try again
/sdd-init
```

---

### `/sdd-new` doesn't read HUs from `docs/tasks/`

**Symptom**: The agent generates everything from scratch instead of using your pre-written HU.

**Cause**: Missing the `--from-docs` flag.

**Solution**:
```bash
# ❌ Wrong - generates everything from scratch
/sdd-new my-feature

# ✅ Correct - reads from docs/tasks/HU-XXX.md
/sdd-new my-feature --from-docs
```

---

### Engram doesn't save context between sessions

**Symptom**: After closing and reopening OpenCode, the agent doesn't remember anything about the project.

**Cause**: `/sdd-init` wasn't run at the start of the session.

**Solution**:
```bash
# At the start of each session
/sdd-init

# Then you can continue with your work
/sdd-new my-feature --from-docs
```

---

### Incorrect artifact store mode

**Symptom**: Artifacts are saved somewhere you didn't expect.

**Available modes**:

| Mode | Where it saves | When to use it |
|------|----------------|----------------|
| `engram` | Local Engram database | Individual work |
| `openspec` | Files in `openspec/` | Teams (git-tracked) |
| `hybrid` | Both | Recovery + sharing |

**Change mode**:
```bash
# In OpenCode, use the configuration command
# or edit the project configuration

# Check current mode
/sdd-init

# For teams, use openspec mode from the start
```

---

### `sdd-context.md` generation fails

**Symptom**: Error when trying to generate the sub-agent context file.

**Possible causes**:
- File write failure (permissions, disk full) → this is a hard fail; fix permissions or disk space first
- `AGENTS.md` not found → create it following `docs/templates/AGENTS.md`
- Engram unavailable → omit the Engram Pointers section; the orchestrator continues without it

**See**: [ADR-009: SDD Sub-agent Context Pattern](./architecture/adr/009-sdd-subagent-context-pattern.md)

---

## Git & Branching

### Conflicts in `docs/` when pulling

**Symptom**: `git pull` shows conflicts in documentation files.

**Cause**: Two people edited the same documentation.

**Solution**:
```bash
# Option 1: Pull with rebase (if you know your changes come first)
git pull --rebase origin main

# Option 2: Resolve conflicts manually
git pull origin main
# Edit the conflicting files
git add .
git commit -m "chore: resolve conflicts in docs"
git push

# Option 3: Talk to the other dev BEFORE editing shared docs
```

**Prevention**: Communicate on Discord when you're going to edit shared docs.

---

### Can't push to `main` or `staging`

**Symptom**: Git rejects the push.

**Cause**: Protected branch, only Tech Lead can merge to these branches.

**Solution**:
```bash
# Create feature branch from dev
git checkout dev
git checkout -b feature/my-name-HU-XXX

# Work on the feature branch
# Open PR to dev (not to main/staging)
# Wait for approval
# Tech Lead merges to staging/main
```

---

### Self-merge (merging your own PR)

**Symptom**: The repo has a merge from your branch to itself.

**Cause**: Team rule violation.

**Rule**: No one merges their own PR. Always another member reviews and approves.

**Solution**:
```bash
# Don't do this:
git checkout main
git merge feature/my-branch  # ❌ Wrong

# Do this:
# 1. Open PR from GitHub UI
# 2. Request review from another member
# 3. Wait for approval
# 4. Someone else merges
```

---

## Documentation

### I don't know which template to use

| Situation | Template |
|-----------|----------|
| New feature | `templates/template-user-story-sdd.md` |
| Bug fix | `templates/template-bug-fix-sdd.md` |
| Refactor (no behavior change) | `templates/template-refactor.md` |
| New technical decision | `templates/RFC_template.md` |
| Approved technical decision | `templates/ADR_template.md` |
| Product document | `templates/PRD_template.md` |

---

### ADR is obsolete but I don't know how to mark it

**Solution**:
```markdown
# ADR-NNN: Title of the decision

- **Date**: YYYY-MM-DD
- **Status**: Deprecated
- **Replaced by**: ADR-MMM - New title
```

The ADR remains as historical record. It is not deleted.

---

### Documentation is outdated

**Symptom**: `docs/` doesn't reflect the current code.

**Rule**: Docs are updated in the SAME PR that changes the code.

**Solution**:
1. If you find outdated docs, create an issue with label `docs-stale`
2. Prioritize them in the next planning
3. Or fix them immediately if it's quick

---

## Feature Flags

### Feature flag doesn't work

**Symptom**: The feature doesn't appear even though the flag should be active.

**Possible causes**:

1. **Flag in code doesn't match name in config**
   ```typescript
   // ❌ Wrong
   if (featureFlags.HU_001) { }  // with underscore

   // ✅ Correct
   if (featureFlags['HU-001']) { }  // with hyphen, as defined
   ```

2. **Flag not activated in the environment**
   ```bash
   # In .env
   FLAG_HU001=false  # ❌ development
   // vs
   FLAG_HU001=true   # ✅ production
   ```

3. **Feature flag not merged to the correct branch**
   ```bash
   # The flag must be on the same branch as the feature
   git log --oneline | grep HU-001
   ```

---

## Legacy Projects

### The project is very large, where do I start?

**Rule**: Don't try to document everything. Only what you're working on.

**Strategy**:
1. Create `docs/architecture/adr/000-legacy-state.md` (inventory of what exists)
2. Choose ONE thing that will be changed in the next sprint
3. Create HU for that thing
4. Full SDD for that HU
5. Repeat

More details at: `docs/legacy-migration.md`

---

### The code has no tests, what do I do?

**Options**:

1. **If it's stable legacy code**: Don't write tests (it hasn't broken yet, don't touch it)
2. **If it's code that's going to change**: Write tests BEFORE the change (TDD)
3. **If it's new code**: Tests required from day one

**Minimum coverage**: >80% for new code.

---

## Communication

### No one responds on Discord for 24h

**SLA by timezone**:
- Discord: response in 4 business hours
- GitHub Issues: response in 24h

**If no response after SLA**:
1. Resend message mentioning the person
2. If it's a blocker, mention `@channel`
3. If after 48h there's still no response, escalate to Tech Lead

---

### Two people working on the same HU

**Cause**: Lack of async communication.

**Solution**:
1. Announce immediately on Discord: "I'm working on HU-XXX"
2. Split the HU if it's too large
3. Create subtasks if they're independent

---

## Quick References

| Problem | Reference file |
|---------|----------------|
| How to structure docs | `README.md` → Structure section |
| How to write HU | `templates/template-user-story-sdd.md` |
| Work cycle | `docs/flowdoc-ciclo.md` |
| Legacy migration | `docs/legacy-migration.md` |
| Branching strategy | `docs/flowdoc-ciclo.md` → branching section |
| New member onboarding | `ONBOARDING.md` |

---

**Problem not listed?** Open an issue in the repo or ask on Discord.
# FlowDoc: Work Cycle — 15 Working Days

> **Based on Scrum** adapted for distributed teams and async work. If you know Scrum, you'll recognize the concepts. If not, adapt them to your methodology.

```
Days 1-2:   Planning & Contract
Days 3-11:  Execution (with weekly sync)
Days 12-14: Integration & Verify
Day 15:     Retrospective
```

| Scrum Concept | Adaptation |
|---------------|------------|
| Sprint | 15-day cycle |
| Daily standup | 5-min async update |
| Sprint planning | Days 1-2 |
| Integration review | Days 12-14 |
| Retrospective | Day 15 |

---

## Entry Point: The HU is the Planning Unit

**The HU (User Story) IS the planning. Without it, there's nothing to develop.**

In Scrum, a User Story in the backlog tells you what to build. In FlowDoc, it's the same:

```
docs/tasks/                              ← HU Backlog
├── HU-001-HU-099/
│   ├── HU-001-onboarding.md ← "What we need to build"
│   ├── HU-002-login.md
│   └── HU-003-reservations.md
└── ...
```

### The HU Defines Everything

| Question | Answer |
|----------|--------|
| **What are we building?** | The HU describes it |
| **What's in scope?** | The HU defines it |
| **When is it done?** | The HU's verification criteria |
| **What does the agent work on?** | The HU — with `--from-docs` |

### The15-Day Cycle is Just the Rhythm

The cycle doesn't CREATE the work — it provides rhythm to execute HUs:

```
1. HU Backlog exists (docs/tasks/HU-001-HU-099/)
       ↓
2. Planning (Days 1-2): Add new HUs, assign owners, map dependencies
       ↓
3. Each HU goes through SDD cycle (Proposal → Spec → Design → Tasks → Apply → Verify → Archive)
       ↓
4. Integration (Days 12-14): All completed HUs come together
       ↓
5. Retrospective (Day 15): Review, then start next cycle
```

### Key Principle

> **No HU = No development. The HU is mandatory.**

Just like in Scrum you can't start a Sprint without backlog items, in FlowDoc you can't start development without a HU.

---

## Async Communication Charter

| Channel | For | SLA |
|---------|-----|-----|
| Discord | Quick questions, blockers, daily updates | 4 business hours |
| GitHub Issues | Bugs, features, trackable tasks | 24h |
| Quick call | Decisions requiring back-and-forth | As needed |

### Technical Decisions
- Discussion happens on Discord or call (no process, as usual).
- **Once decided**: create ADR in `docs/architecture/adr/`. 2 minutes.
- Golden rule: **if there's no ADR, the decision doesn't exist**.

### Conflict Resolution Process

1. **Proposal**: Comment on Discord and write the corresponding RFC
2. **Discussion**: Debate asynchronously on Discord
3. **If no consensus**: Synchronous meeting (max 2 hours) — debate and decide there
4. **Decision recorded**: Create ADR in `docs/architecture/adr/`
5. **Obsolete ADR**: Mark as `DEPRECATED` with link to the new ADR that replaces it

### AI Agent Governance

**Principles:**
- Agents are assistance tools, not responsible parties. The dev is always responsible for the code they deliver.
- Agents **DO NOT make commits**. The dev reviews, commits, and opens the PR.
- Agents DO NOT modify `AGENTS.md`, `docs/`, or `openspec/` without human approval.
- Agents DO NOT merge to `main` or `staging`. They can only generate code in feature branches.

**Usage Rules:**
- Each HU has an owner who decides which agent to use and when.
- Do not launch simultaneous agents on the same task.
- The agent always works with `--from-docs` — never generates anything from scratch.
- The human ALWAYS reviews the agent's output before committing.

**Configuration:**
- Each project's `AGENTS.md` is created and maintained by the Tech Lead.
- Updated when project rules or stack change.
- If a developer needs to change something in `AGENTS.md`, open an RFC first.

### Meeting Cadence

| Type | Frequency | Duration | Who |
|------|-----------|----------|-----|
| **Planning** | Cycle start (Day 1) | 2h | Full team |
| **Weekly Sync** | Day 7 of each cycle | 30 min | Full team |
| **Integration Review** | Day 12 | 1h | Full team |
| **Retrospective** | Day 15 | 1h | Full team |
| **Technical decision** | Only if no async consensus | Max 2h | Involved + moderator |
| **1:1 / Onboarding** | As needed | Variable | Owner + new member |

**Rule**: If it doesn't need real-time interaction, it's not a meeting — it's Discord or an Issue.
**Timezone rotation**: If the team spans more than 2 timezones, rotate synchronous meeting times so it doesn't always disadvantage the same team.

### Living Documentation

Docs are as important as code. If they're not updated, they lose all value.

**Rules:**
- **Docs are updated in the PR**: If a PR changes an endpoint, API docs are updated in the SAME PR. If not, the PR doesn't pass.
- **Docs review in Retrospective**: Day 15, quick scan — any outdated docs? Obsolete ADRs?
- **Label `docs-stale`**: If someone finds an outdated doc, create an issue with label `docs-stale`. Prioritize in the next cycle.

**Doc owner**: Tech Lead is responsible for keeping docs up to date. But each developer is responsible for the docs they touch.

### Rules
- If you need +2 paragraphs to explain, it's not Discord — it's an Issue or document.
- No @everyone. Use @person or @channel only if it's a blocker.
- Respect SLAs according to each person's timezone.
- Daily async updates (Phase 2): max 5 min.

---

## Phase 1: Planning & Contract (Days 1-2)

**Maximum duration**: 4 hours total

### 1.1 Feature List Collab (2 hours, all together)

- 2-hour virtual meeting
- Write all features in a shared document
- Prioritize with impact vs effort matrix
- Select maximum 5-6 features for the 15 days
- Rule: if a feature doesn't fit in 3-4 days, split it

### 1.1.5 Feature Flag Strategy

Every new feature that isn't a hotfix is developed behind a feature flag.

**Naming**: `{HU-ID}[-optional-subfeature]`
- `HU-001` — unique flag for the complete feature
- `HU-003-v2` — gradual migration
- `HU-005-experimental` — A/B testing

**Rules:**
- The flag is defined in Planning along with the HU. No flag defined, don't start.
- Code merges to `dev` with flag in `false`. Feature sleeps, breaks nothing.
- Flag is activated in `staging` for integration review (day 12).
- Flag is activated in `production` after validated release (day 14).
- Flag and old code it replaces are **REMOVED** in the next cycle. A living flag for more than 2 cycles is technical debt.

**Why:**
- Allows merging to `dev` from day 3 without fear of breaking anything.
- Makes `staging` usable all cycle, not just the last 3 days.
- Immediate rollback: deactivating a flag is instant, no deploy required.
- Each dev works independently without blocking others.

**Suggested tools:**
- Environment variables (initial phase)
- LaunchDarkly, Flagsmith or Unleash (when the team grows)

### 1.2 Task Contract (1 hour)

For each feature:
```
FEATURE: [name]
OWNER: @user (only one)
DEPENDENCIES: [what it needs from others]
DEADLINE: Day [X]
DONE_WHEN: [what "delivered" means]
```

### 1.3 Dependency Map (30 min)

Explicitly document dependencies:
- "Pedro: you can't start X until Maria defines Y"

### 1.4 Branching Strategy

```
main                 ← Production. Only from staging via release.
staging             ← Pre-production. Integration review + smoke tests.
dev                 ← Daily integration. PRs from feature branches.
feature-{user}-{HU}  ← individual work per HU.
```

**Flow**:
1. Each developer creates `feature-{their-name}-{HU}` from `dev`
2. HU done → open PR to `dev` (minimum 1 approval, tests passing)
3. Day 12: `dev` → `staging` (release candidate, integration review)
4. Integration review passes → `staging` → `main` (production)
5. **Hotfix**: `hotfix-{name}-{desc}` from `main` → PR to `main` and to `dev`

**Rules**:
- Nobody merges their own PR
- Only Tech Lead merges `staging` and `main`
- If two HUs depend on each other, merge the one with the base dependency first

### 1.5 Project Definition of Done

Agree on what "delivered" means. This same list is verified in Phase 3.

- [ ] **Unit tests**: all HU scenarios have 🧪 Ref and pass
- [ ] **Feature flag defined and merged in `false`**: feature isn't live until release activates it
- [ ] **Integration tests**: passing
- [ ] **Smoke tests on staging**: feature works after deploy
- [ ] **Documentation updated**: API docs, ADR if applicable
- [ ] **Code review approved** (by someone who DIDN'T write the code)
- [ ] **Deployed to staging**
- [ ] **Conscious technical debt**: if something was left pending, documented with issue

### 1.6 Release Checklist (staging → main)

Verified before any production deploy:

- [ ] All DoD items are fulfilled
- [ ] Integration review passed on staging
- [ ] Smoke tests on staging pass
- [ ] Tech Lead approves release
- [ ] Changelog updated (new features, fixed bugs)
- [ ] Version tag created (semver: v1.x.x)
- [ ] **Release feature flags activated in production**: only this cycle's flags
- [ ] **Previous cycle flags removed**: no orphaned flags accumulating technical debt

### 1.7 Hotfix Process

For urgent fixes in production:

1. Create branch `hotfix-{name}-{desc}` from `main`
2. Resolve the problem (quick fix, not the root cause)
3. Open PR → minimum 1 review → merge to `main` AND to `dev`
4. Tech Lead merges
5. Document in changelog

---

## Phase 2: Execution (Days 3-11)

**Testing rule**: each code task includes its test task alongside it.
Nothing is considered "completed" until the associated test exists and passes.

**SDD rule**: if working from a pre-written HU, use `/sdd-new <name> --from-docs`.
Without `--from-docs` the agent DOES NOT read the HU and generates everything from scratch.

### 2.1 Async Updates (daily, 5 min)

Format:
```
Feature X: [in progress/blocked/completed]
Blocked: [yes/no] - If yes, by whom
Tests: [amount written / amount pending per HU]
```

Rule: If you're blocked, NOTIFY IMMEDIATELY. Don't wait for the weekly.

### 2.2 Weekly Sync (Day 7, 30 min)

Agenda:
1. What was completed? (5 min)
2. What's blocked? (10 min - resolve there)
3. What needs adjusting? (10 min)
4. Next step (5 min)

---

## Phase 3: Integration & Verify (Days 12-14)

**Rule**: NO INDIVIDUAL CODE REVIEW. Integration Review is needed: "does everything work together?"

Checklist (against DoD agreed in Planning 1.5):
- [ ] **All DoD items are fulfilled**
- [ ] **Integration review**: consumers (web + mobile) work with the same endpoints
- [ ] **Documented pending items**: what wasn't finished and why

Don't duplicate DoD here — DoD lives in Planning and is verified here.

---

## Phase 3.5: Release (Day 14)

Once Integration Review passes and DoD is fulfilled:

1. Tech Lead reviews Release Checklist (see 1.6)
2. If all OK: `staging` → `main`
3. Create version tag: `git tag -a v1.x.x -m "Release 1.x.x"`
4. Push tag: `git push origin v1.x.x`
5. Notify team on Discord: "✅ Release v1.x.x in production"

---

## Phase 4: Retrospective (Day 15, 1 hour)

Format:
1. What worked well? (keep doing)
2. What didn't work? (STOP doing)
3. What did we learn? (for next project)

Document in maximum one page.

---

## Incident Process

### When Production Breaks

1. **Detect**: Someone notifies on Discord with `@channel - INCIDENT: [brief description]`
2. **Hotfix**: Follow the 1.7 process
3. **Postmortem** (within 48h): Document with:
   ```
   ## Incident: [name]
   **Date**: [YYYY-MM-DD]
   **Impact**: [what users affected, for how long]
   **Root cause**: [what triggered it]
   **Fix applied**: [what was done to resolve it]
   **Prevention**: [what is done to prevent it from happening again]
   **ADRs created/updated**: [if applicable]
   ```

### Rules
- Postmortem is **mandatory** for incidents that affected users
- It's not to find blame — it's to improve the system
- Saved in `docs/incidents/YYYY-MM-DD-name.md`

---

## Rollback Strategy

When a production release causes serious problems:

**Rollback criteria:**
- Error affecting >50% of users
- Data loss or corruption
- Response time > 5x normal
- Critical feature broken (login, payments, etc.)

**Procedure:**
1. **Detect**: Someone notifies on Discord with `@channel - ROLLBACK: [affected version]`
2. **Revert tag**: `git tag -d v1.x.x && git push --delete origin v1.x.x`
3. **Revert code**: `git revert v1.x.x` (or `git reset --hard v1.x-1.x` if necessary)
4. **Immediate deploy**: Re-deploy the previous stable version
5. **Communicate**: Notify team on Discord: "⚠️ Rollback of v1.x.x performed. Stable version: v1.x-1.x"
6. **Postmortem**: Within 48h, document what failed and how to prevent it

**Rule**: Rollback isn't failure — it's a safety tool. Document it, learn from it, improve.

---

## See Also

- [ONBOARDING.md](../ONBOARDING.md) — Checklist for new members (onboarding)
- [docs/adoption-guide.md](./adoption-guide.md) — Gradual adoption guide
- [docs/FAQ.md](./FAQ.md) — Frequently asked questions

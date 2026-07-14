# Proposal: FlowDoc Adoption Experience Redesign

## Intent

New users can't find a clear starting point (6 competing entry points), the "5-minute setup" promise is false (30–60 min real), the migration script creates v1.1 content that v2.0 deprecated, and the ES translation is stuck at v1.1 contradicting EN v2.0.

## Scope

### In Scope
- `scripts/init-flowdoc.sh` — interactive, real 5-min setup
- `README.md` — single entry point, expandable sections for depth
- `docs/adoption-guide.md` — EN/ES unified to 3 levels (L1: docs only, L2: ADRs, L3: RFCs)
- ES v1.1 banners on all outdated ES files
- `reference/` linked from adoption-guide and README
- `scripts/flowdoc-migration.sh` — deprecated for new users or refactored

### Out of Scope
- Full ES translation to v2.0 (banners are honest workaround)
- `reference/` content changes (linking only)
- Breaking changes for existing FlowDoc users

## Capabilities

No new or modified capabilities — documentation/UX change only.

| Type | Status |
|------|--------|
| New | None |
| Modified | None |

## Approach

1. **init-flowdoc.sh**: Interactive bash script — detects stack, creates v2.0 `docs/` structure, asks 3 questions for PRD, generates adapted AGENTS.md, runs in <5 min
2. **README**: One line "Run `bash scripts/init-flowdoc.sh`", expandable sections for "understand first" and "manual setup"
3. **adoption-guide unification**: EN/ES both show L1 (docs only) → L2 (ADRs) → L3 (RFCs + full). ES is translated from EN v2.0, not rewritten
4. **ES v1.1 banners**: Added to `es/README.md`, `es/AGENTS.md`, `es/docs/adoption-guide.md` — "⚠️ This is v1.1 documentation. English v2.0 may differ."
5. **reference/ linking**: From adoption-guide — "For your architecture type, see reference/[type]/". README gets brief mention
6. **migration script**: Mark as deprecated for new users OR refactor to call init-flowdoc.sh + legacy path

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `README.md` | Modified | Single entry point, optional depth via expand |
| `QUICKSTART.md` | Removed | Inlined into README expandable section |
| `scripts/init-flowdoc.sh` | New | Interactive 5-min setup |
| `scripts/flowdoc-migration.sh` | Modified | Marked deprecated or refactored |
| `docs/adoption-guide.md` | Modified | 3-level EN v2.0 version |
| `docs/is-it-for-me.md` | Modified | Links to README entry point |
| `es/README.md` | Modified | v1.1 banner |
| `es/docs/adoption-guide.md` | Modified | v1.1 banner + translated to EN 3-level |
| `es/AGENTS.md` | Modified | v1.1 banner |
| `reference/` | Linked | Referenced from adoption flow |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Existing users confused by migration script change | Low | Mark as "legacy", keep functional |
| ES never updated to v2.0 | High | Honest v1.1 banner is acceptable |
| "5 minutes" still optimistic | Medium | User testing after launch, iterate |

## Rollback Plan

- Revert README.md / adoption-guide.md to previous git version
- Keep init-flowdoc.sh as optional — don't remove old entry points immediately
- flowdoc-migration.sh stays intact, just relabeled

## Dependencies

None — self-contained documentation change.

## Success Criteria

- [ ] New user adopts FlowDoc in <5 min via one script
- [ ] README has one clear entry point, no competing options
- [ ] EN and ES adoption-guide show same 3 levels (v2.0)
- [ ] All outdated ES files display v1.1 banners
- [ ] reference/ guides linked from adoption flow
- [ ] flowdoc-migration.sh is deprecated or clearly distinguished

# Proposal — extract @taskboard/ui as published package

## Intent
Promote `packages/shared/ui` from workspace-internal to a published package so partner teams can consume without forking.

## Scope
- Add `bunchee` build step.
- Scoped to `packages/shared/ui`.
- No changes to other packages yet.

## Approach
- Version with changesets.
- CI workflow publishes on tagged main.
- Keep `workspace:*` resolvable as: published version OR local link when present.

## Risks
- Different react versions in peers.
- Bundle split between RN Web and DOM components.

## Out of scope
- CSS-in-JS migration.

---

**Status**: Draft
**Author**: @platform-lead
**Date**: 2026-07-18
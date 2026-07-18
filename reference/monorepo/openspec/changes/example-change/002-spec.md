# Spec — publish @taskboard/ui

## Requirements

### REQ-1 Build with bunchee
- `npm run build` produces ESM + CJS + `types/index.d.ts` in `dist/`.

### REQ-2 Changesets
- Every change to `packages/shared/ui/**` requires `.changeset/*.md`.
- Release flow: CI bumps versions + publishes to npm.

### REQ-3 Peer deps
- `react` and `react-dom` as peerDependencies (range `^17 || ^18`).

## Scenarios

### Scenario: local dev in monorepo
- GIVEN workspace install
- WHEN consumer package depends `"@taskboard/ui": "workspace:*"`
- THEN resolves to local source, no publish required.

### Scenario: external consumer
- GIVEN partner clones config-only repo
- WHEN `npm i @taskboard/ui`
- THEN receives latest published version, RN-Web friendly, tree-shakeable.

### Scenario: bad peer
- GIVEN consumer without React
- WHEN install @taskboard/ui
- THEN npm warns peer unmet.
# Design — publish @taskboard/ui

## Tools
- **Bunchee** for zero-config TS library bundling (ESM+CJS+d.ts).
- **Changesets** for versioning + changelog.
- **GitHub Actions** + `changesets/action@v1` for publish on main.

## Pipeline
```
PR author adds .changeset/*.md
   ↓
CI: changeset bot opens "Version Packages" PR
   ↓
Merge Version PR → action publishes to npm + tags
```

## Package layout
```
packages/shared/ui/
├── src/
│   ├── index.ts
│   ├── Button.tsx
│   └── Card.tsx
├── dist/          # generated
│   ├── index.mjs
│   ├── index.cjs
│   └── types/
├── package.json
└── CHANGELOG.md
```

## Decisions
- Ship DOM-first; RN-Web compatibility deferred (separate build entry).
- No barrel re-export from root → keep tree-shakeable.

## Open questions
- Should we use tsup instead of bunchee? (Defer; revisit at 1 review.)
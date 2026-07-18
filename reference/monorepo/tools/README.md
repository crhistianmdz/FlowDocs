# tools/

Workspace-level dev tooling. Reserved for shared configs (eslint, tsconfig bases, generators).

Suggested layout (when needed):
```
tools/
├── tsconfig.base.json
├── eslint.base.js
└── generators/
```

For now intentionally empty: defer until a real shared config is needed across packages; avoids premature sharing.
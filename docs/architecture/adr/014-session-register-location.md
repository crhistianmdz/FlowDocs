# ADR-014: Session Register Location and Format

- **Date**: 2026-08-05
- **Related RFC**: [RFC-005](./005-specialist-architecture.md)
- **Status**: Accepted

---

## Context

Each specialist session generates metadata about what was done. This needs to be persisted for audit, rollback reference, and cross-specialist coordination. The register must not pollute the git history but should survive tool restarts.

---

## Decision

Session registers live in `docs/.flowdoc/sessions/` with timestamp-based naming:

```
docs/.flowdoc/
└── sessions/
    ├── 2026-08-05_1430_register.json
    └── 2026-08-05_1600_register.json
```

The `docs/.flowdoc/` directory is **excluded from git** (`.gitignore`).

Register contains: session metadata, invoked specialists, documents created/updated/closed, pending updates, issues found, and summary stats.

---

## Consequences

- **Positive**: Complete audit trail per session; easy to find session by timestamp; local-only (not pushed)
- **Negative**: No team sharing of session data
- **Neutral**: Register is tool-generated, human-readable but not meant for manual editing

---

## See Also

- [RFC-005 — Register Schema](../rfc/005-specialist-architecture.md#5-session-register)

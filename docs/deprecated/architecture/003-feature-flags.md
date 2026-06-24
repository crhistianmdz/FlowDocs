# RFC-003: Mandatory Feature Flags for New Features

- **Status**: Approved
- **Author(s)**: @Crhistian
- **Date**: 2026-05-29
- **Project**: Framework for Distributed Teams

---

## 1. Summary

Every new feature that is not a hotfix must be developed behind a feature flag. The flag must remain `false` until the release is validated in staging and production. The goal is to enable safe parallel work without breaking the shared codebase.

---

## 2. Context

- **Technical problem**: In distributed teams working in parallel, a developer can merge code that breaks another developer's functionality. Feature flags allow each developer to work in isolation without affecting others until the feature is ready.
- **Why this needs to be decided now**: Without feature flags, parallel work is risky. We need a mechanism so multiple people can work simultaneously on `dev` without stepping on each other.
- **Alternatives considered**:
  1. **Long feature branches**: Each developer stays on their branch until done. Problem: integration hell at the end, huge merge conflicts.
  2. **Optional feature flags (recommended)**: Each team decides whether to use them or not. Problem: inconsistencies, some teams use them and others don't.
  3. **Mandatory feature flags (chosen)**: Every new feature requires a flag. Consistency across teams.

---

## 3. Technical Decision

### 3.1 Flag Naming

```
{HU-ID}[-optional-subfeature]

Examples:
HU-001              → Flag: HU-001 (complete feature)
HU-003-v2           → Flag: HU-003-v2 (version 2 of the feature)
HU-005-experimental → Flag: HU-005-exp (A/B testing)
```

### 3.2 Flag Rules

| Phase | Flag Status | What it means |
|-------|-------------|---------------|
| Development (days 3-11) | `false` | Feature exists in code but is not active |
| Staging (days 12-14) | `true` | Feature active for integration review |
| Production | `true` (release validated) | Feature live for users |
| Post-release | **REMOVE** | Flag and old code are removed |

**Golden rule**: A flag cannot be active for more than **2 cycles** (30 days). If it remains active, it is technical debt.

### 3.3 Implementation

**Conceptual example** (pseudocode):

```typescript
// Example: Angular component
@Component({...})
export class OrderListComponent {
  // Flag check in the component
  isNewOrderFlowEnabled = featureFlags['HU-001'];

  // Conditional template
  // @if (isNewOrderFlowEnabled) {
  //   <new-order-flow />
  // } @else {
  //   <legacy-order-flow />
  // }
}

// Example: Backend endpoint
app.post('/api/orders', async (req, res) => {
  if (featureFlags['HU-001']) {
    return newOrderFlow(req, res);
  }
  return legacyOrderFlow(req, res);
});
```

### 3.4 Feature Flag Provider

| Maturity | Tool | When to use |
|----------|------|-------------|
| **L1: Environment variables** | `.env` | Start, small teams |
| **L2: Runtime config** | JSON/YAML on server | Multiple environments, manual testing |
| **L3: Dedicated service** | LaunchDarkly, Flagsmith, Unleash | Large teams, multiple simultaneous features |

---

## 4. Workflow with Feature Flags

### Development (days 3-11)

1. Create feature branch: `feature/kaito-HU-001`
2. Implement feature with flag in `false`
3. Merge to `dev` (flag remains `false`)
4. Other developers work normally, unaffected

### Integration (days 12-14)

1. Activate flag in staging
2. Integration review with feature active
3. If it passes → prepare release
4. If it doesn't pass → deactivate flag, continue development

### Release (day 14+)

1. Tech Lead approves release
2. Activate flag in production
3. Monitor metrics
4. Remove flag in next cycle (don't leave debt)

---

## 5. Fast Rollback

**Key benefit**: Deactivating a flag is instantaneous, no deploy required.

```
Problem in production with HU-001:
  1. Deactivate flag HU-001 → Config: false
  2. Old feature returns automatically
  3. No deploy, no code rollback
```

vs

```
Traditional rollback:
  1. git revert v1.x.x
  2. Re-deploy
  3. 5-15 min of downtime
```

---

## 6. Costs and Resources

- **Initial setup**: ~15 min (configure flag, implement conditional)
- **Maintenance**: Remove flag post-release (~15 min)
- **Dedicated tool**: $0 (L1-L2) or ~$100-500/month (L3)

---

## 7. Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Accumulated flags (technical debt) | Medium | Rule: max 2 cycles per flag, tracked in tech-debt.md |
| Dual code (if/else) becomes complex | Medium | Refactor post-flag-removal |
| Poorly named/confusing flag | Low | Use consistent naming: HU-NNN |
| Forgetting to activate/deactivate flag | Medium | Checklist in DoD, automate where possible |

---

## 8. Approval Status

| Role | Person | Status | Date |
|------|--------|--------|------|
| Tech Lead | @Crhistian | Approved | 2026-05-29 |

---

## 9. Changelog

| Date | Change | Author |
|------|--------|--------|
| 2026-05-29 | Initial version | @Crhistian |

---

## 10. Related Documents

- **RFC-001**: docs/ documentation structure
- **RFC-002**: 15-day work cycle
- **docs/flowdoc-ciclo.md**: Section 1.1.5 Feature Flag Strategy
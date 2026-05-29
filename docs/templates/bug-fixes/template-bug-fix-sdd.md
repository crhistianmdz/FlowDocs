# Template: Bug Fix (SDD-Ready)

> Copy this template when you need to fix a bug or error.
> SDD-compatible: spec → design → tasks.

**Title**: [Short bug title]

---

## Bug Description

**Current behavior**:
[What is currently happening - describe the bug]

**Expected behavior**:
[What should happen - describe the correct behavior]

---

## Steps to Reproduce

1. [Step 1]
2. [Step 2]
3. [Step 3]

---

## Test Scenarios (SDD Spec)

Each scenario describes a verifiable behavior. Use Given/When/Then format.
**🧪 Ref**: link to test file that verifies this scenario (completed during implementation).

### Happy Path (after fix)

- [ ] **Bug fixed**
  **GIVEN** [condition where bug occurred]
  **WHEN** [same action as before]
  **THEN** [now correct behavior]
  **🧪 Ref**: `tests/...` → "[test name]"

### Edge Cases

- [ ] **[Edge case name]**
  **GIVEN** [precondition]
  **WHEN** [action]
  **THEN** [expected result]
  **🧪 Ref**: `tests/...` → "[test name]"

### Error Cases (error handling)

- [ ] **[Error name]**
  **GIVEN** [precondition]
  **WHEN** [action]
  **THEN** [expected result]
  **🧪 Ref**: `tests/...` → "[test name]"

---

## Acceptance Criteria

- [ ] Bug no longer occurs
- [ ] [Specific verified behavior 1]
- [ ] [Specific verified behavior 2]
- [ ] Each scenario has its 🧪 Ref and test passes
- [ ] Documentation updated (API docs and/or ADR if applicable)

---

## Tasks (Fix + Test)

Each fix includes its test alongside.

- [ ] **Fix**: [specific fix 1]
- [ ] **Test**: [test that verifies fix 1]
- [ ] **Fix**: [specific fix 2]
- [ ] **Test**: [test that verifies fix 2]

---

## Notes (Optional)

- [Error logs if any]
- [References to relevant code]
- [Root cause if known]

## Technical Debt (if applicable)

- [What was left pending, why, and how it will be resolved later]

---

## Contract (for Coordination Layer)

- **Owner**: @username
- **Deadline**: Day [X]
- **Dependencies**: [what this needs from others or "none"]

---

## For SDD (input to workflow)

- **Change name**: [name in kebab-case, e.g: fix-login-error]
- **Type**: bug-fix
- **Description**: [one line describing the bug]
- **Domain affected**: [which part of the system is affected]

---

## Usage Example

```bash
# Copy the template
cp docs/tasks/template-bug-fix-sdd.md docs/tasks/fix-login-error.md

# Edit with the bug content
# Then run sdd-new
/sdd-new fix-login-error
```
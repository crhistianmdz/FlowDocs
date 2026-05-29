# Template: User Story (SDD-Ready)

> Copy this template when you need to implement a new feature or functionality.
> SDD-compatible: proposal → spec → design → tasks.

**Title**: [Short feature name]

---

## As a user...

**As**: [user type]
**I want**: [action I want to perform]
**To**: [benefit / reason]

---

## Acceptance Criteria

- [ ] [Criterion 1 - expected behavior]
- [ ] [Criterion 2 - expected behavior]
- [ ] [Criterion 3 - expected behavior]
- [ ] Documentation updated (API docs and/or ADR if applicable)

---

## Scenarios (SDD Spec)

Each scenario describes a verifiable behavior. Use Given/When/Then format.
**🧪 Ref**: link to test file that verifies this scenario (completed during implementation).

### Happy Path

- [ ] **Main scenario**
  **GIVEN** [precondition]
  **WHEN** [action]
  **THEN** [expected result]
  **🧪 Ref**: `tests/...` → "[test name]"

### Edge Cases

- [ ] **[Edge case name]**
  **GIVEN** [precondition]
  **WHEN** [action]
  **THEN** [expected result]
  **🧪 Ref**: `tests/...` → "[test name]"

### Error Cases

- [ ] **[Error name]**
  **GIVEN** [precondition]
  **WHEN** [action]
  **THEN** [expected result]
  **🧪 Ref**: `tests/...` → "[test name]"

---

## Tasks (Implementation + Tests)

Each code task includes its test task alongside.

- [ ] **Code**: [technical task 1]
- [ ] **Test**: [test that verifies task 1]
- [ ] **Code**: [technical task 2]
- [ ] **Test**: [test that verifies task 2]

---

## Notes (Optional)

- [Additional information]
- [Dependencies]
- [References to existing code]

## Technical Debt (if applicable)

- [What was left pending, why, and how it will be resolved later]

---

## Contract (for Coordination Layer)

- **Owner**: @username
- **Deadline**: Day [X]
- **Dependencies**: [what this needs from others]

---

## For SDD (input to workflow)

- **Change name**: [name in kebab-case, e.g: add-user-auth]
- **Type**: feature
- **Description**: [one line describing what it does]
- **Domain affected**: [if you know which part of the system it affects]

---

## Usage Example

```bash
# Copy the template
cp docs/tasks/template-user-story-sdd.md docs/tasks/my-new-feature.md

# Edit with the feature content
# Then run sdd-new
/sdd-new my-new-feature
```
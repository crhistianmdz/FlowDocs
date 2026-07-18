# Template: Refactor

> Copy this template when you need to refactor existing code.
> Use only when the change does not modify behavior, only structure.

**Title**: [Short refactor name]

---

## Objective

**Why refactoring is needed**:
[Explain the reason: duplicated code, hard to maintain, performance, etc.]

---

## Current Code

**Affected files**:
- `[path/to/file1.ext]`
- `[path/to/file2.ext]`

**Identified problems**:
1. [Problem 1]
2. [Problem 2]

---

## Proposed Design

**Pattern to use**: [pattern name if applicable]

**New files** (if applicable):
- `[path/to/new-file.ext]`

**Modified files**:
- `[path/to/file.ext]` - [what changes]

---

## Acceptance Criteria

- [ ] Existing functionality continues to work the same
- [ ] Existing tests pass before and after the refactor
- [ ] [Specific criterion 1]
- [ ] [Specific criterion 2]

---

## Tasks (Refactor + Verification)

Each refactor includes test verification.

- [ ] **Refactor**: [task 1]
- [ ] **Verify**: existing tests still pass
- [ ] **Refactor**: [task 2]
- [ ] **Verify**: existing tests still pass
- [ ] **Test**: [new test if refactor changes interfaces or exposes new cases]

---

## Notes (Optional)

- [Performance considerations]
- [Dependencies]

---

## Contract (for Coordination Layer)

- **Owner**: @username
- **Deadline**: Day [X]
- **Dependencies**: [what this needs from others or "none"]

---

## Usage Example

```bash
# Copy the template
cp docs/tasks/template-refactor.md docs/tasks/refactor-auth-service.md

# Edit with the refactor content
# Then run sdd-new
/sdd-new refactor-auth-service
```
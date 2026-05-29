# HU-002: Add HU validation in pre-commit

## General Information

- **ID**: HU-002
- **Priority**: P2
- **Module**: DevOps / Scripts
- **Estimated**: 4 hours

---

## User Story

**As** developer  
**I want** the pre-commit script to validate that HUs in `docs/tasks/` have the correct format  
**So that** invalid HU files don't break the `hu-to-issues` scripts

---

## Acceptance Criteria

### Functional

- [ ] Pre-commit hook rejects HUs without `**Title**:` field with valid content
- [ ] Pre-commit hook rejects HUs without `**Owner**:` field in the Contract section
- [ ] Pre-commit hook rejects HUs without `**Status**:` field at the end of the file
- [ ] Hook accepts valid HUs without blocker

### Non-Functional

- [ ] Hook is fast (< 1 second per file)
- [ ] Clear error message indicating what's missing
- [ ] Tests covering validation of valid and invalid cases

---

## Scenarios (SDD Spec)

### Happy Path

- [ ] **Valid HU passes validation**
  **GIVEN** An HU with all required fields (`**Title**:`, `**Owner**:`, `**Status**:`)
  **WHEN** Developer runs `git commit` with that HU
  **THEN** Commit proceeds without errors
  **🧪 Ref**: `scripts/validate-hu.test.sh` → "accepts valid HU"

- [ ] **HU with Given/When/Then scenarios passes validation**
  **GIVEN** An HU with sections `### Happy Path`, `### Edge Cases` and `### Error Cases`
  **WHEN** Each scenario has correct format (GIVEN/WHEN/THEN)
  **THEN** Commit proceeds
  **🧪 Ref**: `scripts/validate-hu.test.sh` → "accepts HU with all scenario types"

### Edge Cases

- [ ] **HU without title**
  **GIVEN** An HU where `**Title**:` is missing or empty
  **WHEN** Developer tries to commit
  **THEN** Hook rejects with message: "HU must have a non-empty **Title** field"
  **🧪 Ref**: `scripts/validate-hu.test.sh` → "rejects HU without title"

- [ ] **HU without owner in Contract**
  **GIVEN** An HU without Contract section or without `**Owner**:` field
  **WHEN** Developer tries to commit
  **THEN** Hook rejects with message: "HU must have **Owner** in Contract section"
  **🧪 Ref**: `scripts/validate-hu.test.sh` → "rejects HU without owner"

- [ ] **HU without status**
  **GIVEN** An HU without `**Status**:` at the end of the file
  **WHEN** Developer tries to commit
  **THEN** Hook rejects with message: "HU must have a **Status** field"
  **🧪 Ref**: `scripts/validate-hu.test.sh` → "rejects HU without status"

- [ ] **HU with placeholder title**
  **GIVEN** An HU with `**Title**: [Short feature name]` (unchanged)
  **WHEN** Developer tries to commit
  **THEN** Hook rejects with message: "HU **Title** is still the placeholder value"
  **🧪 Ref**: `scripts/validate-hu.test.sh` → "rejects HU with placeholder title"

- [ ] **Multiple HUs, only one invalid**
  **GIVEN** A commit that includes `HU-001-valid.md` and `HU-002-invalid.md`
  **WHEN** Developer tries to commit
  **THEN** Hook rejects and shows which HU is invalid
  **🧪 Ref**: `scripts/validate-hu.test.sh` → "rejects when any HU in commit is invalid"

### Error Cases

- [ ] **HU with invalid characters in title**
  **GIVEN** An HU with special characters in the title (e.g.: `<>:"|?*`)
  **WHEN** Developer tries to commit
  **THEN** Hook rejects with message indicating invalid characters
  **🧪 Ref**: `scripts/validate-hu.test.sh` → "rejects HU with invalid filename characters"

---

## API Endpoints Required

N/A — it's a local script, no API.

---

## DB Changes

N/A — no database required.

---

## UI Components

N/A — it's a CLI hook, no UI.

---

## Dependencies

| Dependency | Why |
|------------|-----|
| Git pre-commit hook | Execution platform |
| Shell script (`validate-hu.sh`) | Validation logic |
| Test script (`validate-hu.test.sh`) | Validation verification |

---

## Testing Checklist

- [ ] Unit test: valid HU validation
- [ ] Unit test: HU without title validation
- [ ] Unit test: HU without owner validation
- [ ] Unit test: HU without status validation
- [ ] Unit test: HU with placeholder validation
- [ ] Unit test: invalid characters validation
- [ ] Integration test: hook rejects commit with invalid HU
- [ ] Integration test: hook accepts commit with valid HU
- [ ] Manual test: verify hook is installed correctly

---

## Contract (for Coordination Layer)

- **Owner**: @Crhistian
- **Deadline**: Day 8 of current cycle
- **Dependencies**: None
- **Blocking**: Does not block other HUs

---

## Feature Flag

- **Name**: HU-002-validation
- **Initial state**: `false` (local validation only, doesn't block other commits)
- **Activation**: When tested and approved

---

## Notes

- Script must work on Linux, macOS and Windows (Git Bash/WSL)
- Tests must be cross-platform using portable shell
- Hook only validates files in `docs/tasks/` matching pattern `HU-*.md`

---

## Definition of Done

- [ ] Script `validate-hu.sh` created and working
- [ ] Tests `validate-hu.test.sh` passing (>80% coverage)
- [ ] Pre-commit hook installed in `.git/hooks/`
- [ ] Documentation updated (`docs/troubleshooting.md` or new section)
- [ ] Code review approved
- [ ] PR merged to main

---

**Created**: 2026-05-29  
**Author**: @Crhistian  
**Status**: 📋 Backlog

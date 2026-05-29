# HU-001: Improve onboarding for new members to the framework

## General Information

- **ID**: HU-001
- **Priority**: P1
- **Module**: Documentation / Process
- **Estimated**: 5 hours

---

## User Story

**As** a new team member  
**I want** to understand the framework structure and how to work with SDD in maximum 4 days  
**So that** I can make my first supervised contribution without blocking anyone

---

## Acceptance Criteria

### Functional

- [ ] The onboarding checklist is in `ONBOARDING.md` and has day-by-day breakdown
- [ ] There is a real PR example from the framework until it's merged
- [ ] Doc templates have real examples, not just placeholders
- [ ] `AGENTS.md-example.md` is functional for any agent (not just the Restaurant App)

### Existing Docs

- [ ] `docs/PRD.md` created with a real framework example
- [ ] `docs/architecture/adr/001-persistencia-engram.md` created
- [ ] `docs/tasks/HU-001-onboarding-docs.md` (this HU)

### Structure

- [ ] The `docs/` structure is complete according to README.md
- [ ] `AGENTS.md-example.md` is renamed to `AGENTS.md` at the root

---

## Scenarios (SDD Spec)

### Happy Path

- [ ] **New member completes onboarding in 4 days**
  **GIVEN** A developer joins the team with zero context of the framework
  **WHEN** They follow the `ONBOARDING.md` checklist day by day
  **THEN** They can make their first contribution on day 4 with supervision
  **🧪 Ref**: Integration test with simulated newcomer

- [ ] **Agent can work with framework from scratch**
  **GIVEN** A new agent (OpenCode or Antigravity) accesses the repo
  **WHEN** They read `AGENTS.md` at the root
  **THEN** They understand: stack, structure, workflow, commands
  **🧪 Ref**: Manual by Tech Lead

### Edge Cases

- [ ] **New member without prior SDD experience**
  **GIVEN** Developer joins without experience in Spec-Driven Development
  **WHEN** They read `AGENTS.md` and `docs/flowdoc-ciclo.md`
  **THEN** They understand the full flow and can get started
  **🧪 Ref**: New member feedback

- [ ] **Agent without internet access searches docs**
  **GIVEN** Offline agent with access only to the repo
  **WHEN** They read `docs/`
  **THEN** They have all information needed for SDD
  **🧪 Ref**: Offline test

---

## API Endpoints Required

N/A — this HU is purely documentation.

---

## DB Changes

N/A — not applicable.

---

## UI Components (if frontend)

N/A — not applicable.

---

## Dependencies

None — it's new content.

---

## Testing Checklist

- [ ] Review of `ONBOARDING.md` by existing member
- [ ] "Simulated onboarding" test with someone new
- [ ] Validate that agent can read all docs without errors

---

## Contract (for Coordination Layer)

- **Owner**: @Crhistian
- **Deadline**: Day 8 (end of current cycle)
- **Dependencies**: None
- **Blocking**: Does not block other HUs

---

## Notes

- This HU is meta-work: documenting the framework itself that is being used
- The "Restaurant App" example in `AGENTS.md-example.md` serves as reference but is NOT the framework itself
- The goal is that any team can copy this structure to their project

---

## Definition of Done

- [ ] `docs/PRD.md` exists with real content
- [ ] `docs/architecture/adr/001-persistencia-engram.md` exists
- [ ] `docs/tasks/HU-001-onboarding-docs.md` exists (this HU)
- [ ] `ONBOARDING.md` has concrete examples, not generic ones
- [ ] Code review approved by another team member
- [ ] PR merged to main

---

**Created**: 2026-05-29  
**Author**: @Crhistian  
**Status**: 📋 Backlog

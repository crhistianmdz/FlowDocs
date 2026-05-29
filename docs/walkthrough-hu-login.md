# Walkthrough: End-to-End Login HU

> This document follows a HU (HU-042: User Login) through the entire SDD cycle.
> The goal is to show what each phase looks like in practice.

---

## The User Story

```
docs/tasks/HU-001-HU-099/HU-042-login.md
```

```markdown
# HU-042: User Login

## User Story

**As** a registered user  
**I want** to be able to log in with email and password  
**So that** I can access my account and view my data

---

## Acceptance Criteria

- [ ] User can log in with email and password
- [ ] Error is shown if credentials are incorrect
- [ ] User is redirected to dashboard after login
- [ ] JWT token is saved correctly

---

## Contract

- **Owner**: @Crhistian
- **Deadline**: Day 8
- **Dependencies**: None
- **Status**: 📋 Backlog
```

---

## Phase 1: Proposal

When we run `/sdd-new login --from-docs`, the agent generates the proposal.

```
openspec/changes/login/
├── 001-proposal.md
```

```markdown
# Proposal: User Login

## Intent

Implement user authentication with email and password.
The system will use JWT for stateless sessions.

## Scope

### In
- Endpoint POST /api/auth/login
- Credential validation against DB
- JWT generation (access + refresh token)
- HTTP-only cookie for refresh token

### Out
- OAuth social login (will be another HU)
- Multi-factor authentication
- Password reset

## Affected Areas

- `src/auth/` - authentication module
- `src/middleware/auth.ts` - validation middleware
- `docs/api/endpoints.md` - update with new endpoint

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| JWT in memory vs localStorage | High | Use httpOnly cookie |
| Brute force | Medium | Rate limiting on login |

## Rollback

1. Revert changes in `src/auth/`
2. Deactivate flag `HU-042-login`
3. Deploy previous version
```

---

## Phase 2: Spec

After approving the proposal, `/sdd-continue login` generates the spec.

```
openspec/changes/login/
├── 001-proposal.md
├── 002-spec.md
```

```markdown
# Spec: User Login

## Requirements

### MUST

- System must validate email with valid format
- System must verify password against hash in DB
- System must return JWT with 15 min expiration
- System must set refresh token in httpOnly cookie

### SHOULD

- System must log failed login attempts
- System must return remaining time until lockout

### MAY

- System may remember device for 30 days

---

## Scenarios

### Happy Path: Successful Login

**GIVEN** registered user with email "kaito@test.com" and correct password  
**WHEN** POST /api/auth/login with { email: "kaito@test.com", password: "password123" }  
**THEN** response includes { accessToken: "jwt...", user: { id, email, role } }  
**AND** refresh token is in httpOnly cookie  
**🧪 Ref**: `tests/auth/login.test.ts` → "should return token on valid credentials"

### Edge Case: Invalid Email

**GIVEN** user with email "invalid-email"  
**WHEN** POST /api/auth/login  
**THEN** response is 400 with { error: "Invalid email format" }  
**🧪 Ref**: `tests/auth/login.test.ts` → "should reject invalid email format"

### Edge Case: Wrong Password

**GIVEN** user with password "wrongpassword"  
**WHEN** POST /api/auth/login with correct password  
**THEN** response is 401 with { error: "Invalid credentials" }  
**AND** log indicates "Failed login attempt for kaito@test.com"  
**🧪 Ref**: `tests/auth/login.test.ts` → "should reject wrong password"

### Error Case: User Does Not Exist

**GIVEN** email "nonexistent@test.com" not registered  
**WHEN** POST /api/auth/login  
**THEN** response is 401 with { error: "Invalid credentials" }  
**AND** it is not revealed whether the email exists or not (security)  
**🧪 Ref**: `tests/auth/login.test.ts` → "should not reveal if email exists"

---

## Verification

1. Unit tests passing for all scenarios
2. Integration test with real DB
3. Manual test on staging with real credentials
```

---

## Phase 3: Design

The agent generates the design based on the spec.

```
openspec/changes/login/
├── 001-proposal.md
├── 002-spec.md
├── 003-design.md
```

```markdown
# Design: User Login

## Architecture

### Auth Module

```
src/auth/
├── auth.controller.ts    # Handle HTTP requests
├── auth.service.ts        # Business logic
├── auth.repository.ts     # DB queries
├── jwt.util.ts           # Token generation/validation
└── types.ts              # DTOs
```

### Flow

```
Request → Middleware (validate) → Controller → Service → Repository → DB
          ↓
     JWT Validation (for protected routes)
```

## Data Models

### Request

```typescript
interface LoginRequest {
  email: string;    // required, valid email format
  password: string; // required, min 8 chars
}
```

### Response

```typescript
interface LoginResponse {
  accessToken: string; // JWT
  user: {
    id: string;
    email: string;
    role: 'admin' | 'user';
  };
}
```

## Security

| Measure | Implementation |
|---------|----------------|
| Password hashing | bcrypt with cost 12 |
| JWT secret | env.JWT_SECRET, min 32 chars |
| Token expiration | 15 minutes |
| Refresh token | httpOnly cookie, 7 days |
| Rate limiting | 5 attempts per minute per IP |

## API Contract

### POST /api/auth/login

**Request Body**:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (200)**:
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "role": "user"
  }
}
```

**Response (400)**:
```json
{
  "error": "Invalid email format"
}
```

**Response (401)**:
```json
{
  "error": "Invalid credentials"
}
```

## Dependencies

| Dependency | Version | Purpose |
|------------|---------|---------|
| jsonwebtoken | ^9.0 | JWT generation |
| bcrypt | ^5.1 | Password hashing |
| zod | ^3.22 | Schema validation |

## DB Schema

```sql
-- No new tables needed
-- Uses existing users table
SELECT id, email, password_hash, role FROM users WHERE email = $1;
```

## Testing Strategy

| Level | Tool | Coverage |
|-------|------|----------|
| Unit | vitest | Service logic, JWT utils |
| Integration | vitest + test DB | Full flow |
| E2E | playwright | Login page |
```

---

## Phase 4: Tasks

The agent generates the specific tasks to implement.

```
openspec/changes/login/
├── 001-proposal.md
├── 002-spec.md
├── 003-design.md
├── 004-tasks.md
```

```markdown
# Tasks: User Login

## Implementation Tasks

### 1. Setup

- [ ] **Task**: Create `src/auth/` structure
- [ ] **Task**: Install dependencies (jsonwebtoken, bcrypt, zod)
- [ ] **Task**: Define types in `types.ts`

### 2. JWT Utils

- [ ] **Task**: Implement `jwt.util.ts` - signToken()
- [ ] **Task**: Implement `jwt.util.ts` - verifyToken()
- [ ] **Test**: Unit tests for jwt.util

### 3. Auth Service

- [ ] **Task**: Implement `auth.service.ts` - validateCredentials()
- [ ] **Task**: Implement `auth.service.ts` - generateTokens()
- [ ] **Test**: Unit tests for auth.service

### 4. Auth Repository

- [ ] **Task**: Implement `auth.repository.ts` - findUserByEmail()
- [ ] **Test**: Integration test with test DB

### 5. Auth Controller

- [ ] **Task**: Implement `auth.controller.ts` - POST /login
- [ ] **Task**: Add schema validation with zod
- [ ] **Test**: Unit test for controller

### 6. Middleware

- [ ] **Task**: Implement `src/middleware/auth.ts`
- [ ] **Task**: Add auth middleware to protected routes
- [ ] **Test**: Integration test for middleware

### 7. Integration

- [ ] **Task**: Add POST /api/auth/login route in app.ts
- [ ] **Task**: Update `docs/api/endpoints.md`
- [ ] **Test**: Full flow integration test

### 8. Feature Flag

- [ ] **Task**: Add `HU-042-login` flag in config
- [ ] **Task**: Implement conditional in endpoint
- [ ] **Test**: Verify flag disabled = 404

---

## Task Dependencies

```
1.Setup
   ↓
2.JWT Utils ──→ 3.Auth Service
                      ↓
4.Auth Repository ──→ 3.Auth Service
                            ↓
                       5.Auth Controller
                            ↓
                       6.Middleware ──→ 7.Integration
                            │
                       8.Feature Flag
```

---

## Definition of Done

- [ ] All unit tests passing
- [ ] Complete login integration test passing
- [ ] Feature flag on false in dev
- [ ] API documentation updated
- [ ] Code review approved
```

---

## Phase 5: Apply

The developer (or agent working with supervision) implements the tasks according to the design.

**Note**: In this phase real code is written. The agent generates code, the human reviews before committing.

### Suggested Commits

```bash
# Commit 1: Setup and types
feat: HU-042 - setup auth module structure

# Commit 2: JWT utils
feat: HU-042 - implement JWT token generation and validation

# Commit 3: Auth service
feat: HU-042 - implement auth service with credential validation

# Commit 4: Auth repository
feat: HU-042 - implement auth repository with DB queries

# Commit 5: Auth controller
feat: HU-042 - implement login endpoint with validation

# Commit 6: Middleware
feat: HU-042 - add auth middleware for protected routes

# Commit 7: Integration and docs
feat: HU-042 - integrate login endpoint and update API docs
```

---

## Phase 6: Verify

After implementing, specs are verified against the code.

```markdown
# Verify: User Login

## Spec vs Implementation Checklist

### Happy Path: Successful Login

- [x] `auth.service.ts` validates credentials against bcrypt
- [x] `jwt.util.ts` generates JWT with claims { userId, email, role }
- [x] Response includes accessToken and user object
- [x] Refresh token set in httpOnly cookie

### Edge Case: Invalid Email

- [x] Zod schema validates email format
- [x] Response 400 with "Invalid email format"
- [x] Test in `auth.test.ts` → "should reject invalid email"

### Edge Case: Wrong Password

- [x] bcrypt.compare() verifies password
- [x] Response 401 with "Invalid credentials"
- [x] Failed attempt log implemented
- [x] Test in `auth.test.ts` → "should reject wrong password"

### Error Case: User Does Not Exist

- [x] Does not reveal if email exists
- [x] Same error message as wrong password
- [x] Test in `auth.test.ts` → "should not reveal email existence"

### Non-Functional

- [x] Rate limiting: 5 requests/minute per IP
- [x] JWT expires in 15 minutes
- [x] Refresh token in httpOnly cookie
- [x] Password hash with bcrypt cost 12

---

## Test Results

| Test | Status |
|------|--------|
| Unit: jwt.util | ✅ Passing |
| Unit: auth.service | ✅ Passing |
| Unit: auth.controller | ✅ Passing |
| Integration: login flow | ✅ Passing |
| E2E: login page | ✅ Passing |

**Coverage**: 85%

---

## Verification Summary

✅ All spec scenarios implemented  
✅ All tests passing  
✅ Coverage > 80%  
✅ Documentation updated  
✅ Feature flag working  

**Ready for archive.**
```

---

## Phase 7: Archive

The change is archived and specs are synced to main.

```
openspec/changes/login/
├── 001-proposal.md
├── 002-spec.md
├── 003-design.md
├── 004-tasks.md
├── 005-verify.md
└── state.yaml  (status: archived)
```

### delta-spec.md (sync to main)

```markdown
# Auth Module - Login Feature

## Added

### API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/auth/login | Authenticate user |

### New Files

- `src/auth/auth.controller.ts`
- `src/auth/auth.service.ts`
- `src/auth/auth.repository.ts`
- `src/auth/jwt.util.ts`
- `src/auth/types.ts`
- `src/middleware/auth.ts`

### New Dependencies

- jsonwebtoken ^9.0
- bcrypt ^5.1
- zod ^3.22

## Updated

- `docs/api/endpoints.md` - Added POST /api/auth/login
- `app.ts` - Added /api/auth routes

## Feature Flag

- Name: `HU-042-login`
- Default: false
- Activate on: staging (day 12), production (day 14)
- Remove on: next cycle
```

---

## Cycle Summary

```
┌──────────────────────────────────────────────────────────────┐
│                    HU-042: Login                             │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  📋 Backlog                                                  │
│     ↓                                                        │
│  📝 Proposal        → 001-proposal.md                        │
│     ↓                                                        │
│  📄 Spec           → 002-spec.md (Given/When/Then)          │
│     ↓                                                        │
│  🏗️  Design         → 003-design.md (architecture, API)      │
│     ↓                                                        │
│  ✅ Tasks          → 004-tasks.md (checklist)               │
│     ↓                                                        │
│  💻 Apply          → Implemented code + tests                │
│     ↓                                                        │
│  🔍 Verify         → 005-verify.md (spec vs code)           │
│     ↓                                                        │
│  📦 Archive        → state.yaml (archived) + delta-spec.md   │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## Generated Artifacts

| Artifact | Location | Purpose |
|----------|----------|---------|
| Proposal | `openspec/changes/login/001-proposal.md` | Intent, scope, risks |
| Spec | `openspec/changes/login/002-spec.md` | Requirements, scenarios |
| Design | `openspec/changes/login/003-design.md` | Architecture, code |
| Tasks | `openspec/changes/login/004-tasks.md` | Implementation checklist |
| Verify | `openspec/changes/login/005-verify.md` | Validation against specs |
| Delta Spec | `openspec/changes/login/delta-spec.md` | Sync to main docs |

---

## Next HU

After archive, create new HU:

```bash
# Create new HU
cp docs/templates/user-stories/template-user-story-sdd.md \
   docs/tasks/HU-001-HU-099/HU-043-refresh-token.md

# Start SDD
/sdd-new refresh-token --from-docs
```

---

## See also

- [TEMPLATE_GUIDE.md](../templates/TEMPLATE_GUIDE.md)
- [Workflow Cycle](./flowdoc-ciclo.md)
- [ADR-003: 15-Day Cycle](../architecture/adr/003-ciclo-15-dias.md)
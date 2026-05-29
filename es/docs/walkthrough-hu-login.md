# Walkthrough: HU de Login de Principio a Fin

> Este documento sigue una HU (HU-042: Login de usuario) a través de todo el ciclo SDD.
> El objetivo es mostrar cómo se ve cada fase en la práctica.

---

## La Historia de Usuario

```
docs/tasks/HU-001-HU-099/HU-042-login.md
```

```markdown
# HU-042: Login de usuario

## User Story

**Como** usuario registrado  
**Quiero** poder iniciar sesión con email y contraseña  
**Para** acceder a mi cuenta y ver mis datos

---

## Criterios de Aceptación

- [ ] El usuario puede iniciar sesión con email y contraseña
- [ ] Se muestra error si las credenciales son incorrectas
- [ ] El usuario es redirigido al dashboard después del login
- [ ] El token JWT se guarda correctamente

---

## Contract

- **Owner**: @Crhistian
- **Deadline**: Día 8
- **Dependencies**: Ninguna
- **Status**: 📋 Backlog
```

---

## Fase 1: Proposal

Cuando ejecutamos `/sdd-new login --from-docs`, el agent genera el proposal.

```
openspec/changes/login/
├── 001-proposal.md
```

```markdown
# Proposal: Login de usuario

## Intent

Implementar autenticación de usuarios con email y contraseña.
El sistema usará JWT para sesiones stateless.

## Scope

### In
- Endpoint POST /api/auth/login
- Validación de credenciales contra DB
- Generación de JWT (access + refresh token)
- HTTP-only cookie para refresh token

### Out
- OAuth social login (será otra HU)
- Multi-factor authentication
- Password reset

## Affected Areas

- `src/auth/` - módulo de autenticación
- `src/middleware/auth.ts` - middleware de validación
- `docs/api/endpoints.md` - actualizar con nuevo endpoint

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| JWT en memory vs localStorage | Alto | Usar httpOnly cookie |
| Brute force | Medio | Rate limiting en login |

## Rollback

1. Revertir cambios en `src/auth/`
2. Desactivar flag `HU-042-login`
3. Deployar versión anterior
```

---

## Fase 2: Spec

Después de approve el proposal, `/sdd-continue login` genera la spec.

```
openspec/changes/login/
├── 001-proposal.md
├── 002-spec.md
```

```markdown
# Spec: Login de usuario

## Requirements

### MUST

- El sistema debe validar email con formato válido
- El sistema debe verificar contraseña contra hash en DB
- El sistema debe retornar JWT con 15 min de expiración
- El sistema debe setear refresh token en httpOnly cookie

### SHOULD

- El sistema debe loguear intentos de login fallidos
- El sistema debe retornar tiempo restante hasta lockout

### MAY

- El sistema puede recordar el dispositivo por 30 días

---

## Scenarios

### Happy Path: Login exitoso

**GIVEN** usuario registrado con email "kaito@test.com" y password correcto  
**WHEN** POST /api/auth/login con { email: "kaito@test.com", password: "password123" }  
**THEN** el response incluye { accessToken: "jwt...", user: { id, email, role } }  
**AND** el refresh token está en httpOnly cookie  
**🧪 Ref**: `tests/auth/login.test.ts` → "should return token on valid credentials"

### Edge Case: Email inválido

**GIVEN** usuario con email "invalid-email"  
**WHEN** POST /api/auth/login  
**THEN** el response es 400 con { error: "Invalid email format" }  
**🧪 Ref**: `tests/auth/login.test.ts` → "should reject invalid email format"

### Edge Case: Password incorrecto

**GIVEN** usuario con password "wrongpassword"  
**WHEN** POST /api/auth/login con password correcta  
**THEN** el response es 401 con { error: "Invalid credentials" }  
**AND** el log indica "Failed login attempt for kaito@test.com"  
**🧪 Ref**: `tests/auth/login.test.ts` → "should reject wrong password"

### Error Case: Usuario no existe

**GIVEN** email "nonexistent@test.com" no registrado  
**WHEN** POST /api/auth/login  
**THEN** el response es 401 con { error: "Invalid credentials" }  
**AND** no se revela si el email existe o no (security)  
**🧪 Ref**: `tests/auth/login.test.ts` → "should not reveal if email exists"

---

## Verification

1. Unit tests pasando para todos los escenarios
2. Integration test con DB real
3. Manual test en staging con credenciales reales
```

---

## Fase 3: Design

El agent genera el design basado en la spec.

```
openspec/changes/login/
├── 001-proposal.md
├── 002-spec.md
├── 003-design.md
```

```markdown
# Design: Login de usuario

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

## Fase 4: Tasks

El agent genera las tareas específicas para implementar.

```
openspec/changes/login/
├── 001-proposal.md
├── 002-spec.md
├── 003-design.md
├── 004-tasks.md
```

```markdown
# Tasks: Login de usuario

## Implementation Tasks

### 1. Setup

- [ ] **Task**: Crear estructura `src/auth/`
- [ ] **Task**: Instalar dependencias (jsonwebtoken, bcrypt, zod)
- [ ] **Task**: Definir tipos en `types.ts`

### 2. JWT Utils

- [ ] **Task**: Implementar `jwt.util.ts` - signToken()
- [ ] **Task**: Implementar `jwt.util.ts` - verifyToken()
- [ ] **Test**: Unit tests para jwt.util

### 3. Auth Service

- [ ] **Task**: Implementar `auth.service.ts` - validateCredentials()
- [ ] **Task**: Implementar `auth.service.ts` - generateTokens()
- [ ] **Test**: Unit tests para auth.service

### 4. Auth Repository

- [ ] **Task**: Implementar `auth.repository.ts` - findUserByEmail()
- [ ] **Test**: Integration test con test DB

### 5. Auth Controller

- [ ] **Task**: Implementar `auth.controller.ts` - POST /login
- [ ] **Task**: Agregar validación de schema con zod
- [ ] **Test**: Unit test para controller

### 6. Middleware

- [ ] **Task**: Implementar `src/middleware/auth.ts`
- [ ] **Task**: Agregar auth middleware a rutas protegidas
- [ ] **Test**: Integration test para middleware

### 7. Integration

- [ ] **Task**: Agregar ruta POST /api/auth/login en app.ts
- [ ] **Task**: Actualizar `docs/api/endpoints.md`
- [ ] **Test**: Integration test completo del flujo

### 8. Feature Flag

- [ ] **Task**: Agregar `HU-042-login` flag en config
- [ ] **Task**: Implementar condicional en endpoint
- [ ] **Test**: Verificar flag deshabilitado = 404

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

- [ ] Todos los tests unitarios pasando
- [ ] Integration test de login completo pasando
- [ ] Feature flag en false en dev
- [ ] Documentación de API actualizada
- [ ] Code review aprobado
```

---

## Fase 5: Apply

El developer (o agent trabajando con supervisión) implementa las tareas según el design.

**Nota**: En esta fase se escribe código real. El agent genera código, el humano revisa antes de commitear.

### Commits sugeridos

```bash
# Commit 1: Setup y tipos
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

# Commit 7: Integration y docs
feat: HU-042 - integrate login endpoint and update API docs
```

---

## Fase 6: Verify

Después de implementar, se verifican los specs contra el código.

```markdown
# Verify: Login de usuario

## Spec vs Implementation Checklist

### Happy Path: Login exitoso

- [x] `auth.service.ts` valida credenciales contra bcrypt
- [x] `jwt.util.ts` genera JWT con claims { userId, email, role }
- [x] Response incluye accessToken y user object
- [x] Refresh token setado en httpOnly cookie

### Edge Case: Email inválido

- [x] Zod schema valida formato de email
- [x] Response 400 con "Invalid email format"
- [x] Test en `auth.test.ts` → "should reject invalid email"

### Edge Case: Password incorrecto

- [x] bcrypt.compare() verifica password
- [x] Response 401 con "Invalid credentials"
- [x] Log de intento fallido implementado
- [x] Test en `auth.test.ts` → "should reject wrong password"

### Error Case: Usuario no existe

- [x] No se revela si email existe
- [x] Mismo mensaje de error que password incorrecto
- [x] Test en `auth.test.ts` → "should not reveal email existence"

### Non-Functional

- [x] Rate limiting: 5 requests/minuto por IP
- [x] JWT expira en 15 minutos
- [x] Refresh token en httpOnly cookie
- [x] Password hash con bcrypt cost 12

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

✅ Todos los escenarios de spec implementados  
✅ Todos los tests pasando  
✅ Coverage > 80%  
✅ Documentación actualizada  
✅ Feature flag funcionando  

**Listo para archive.**
```

---

## Fase 7: Archive

El change se archiva y los specs se syncn al main.

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
- Activar en: staging (día 12), production (día 14)
- Remover en: próximo ciclo
```

---

## Resumen del Ciclo

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
│  💻 Apply          → Código implementado + tests             │
│     ↓                                                        │
│  🔍 Verify         → 005-verify.md (spec vs code)           │
│     ↓                                                        │
│  📦 Archive        → state.yaml (archived) + delta-spec.md   │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## Artefacts Generados

| Artifact | Ubicación | Propósito |
|----------|-----------|-----------|
| Proposal | `openspec/changes/login/001-proposal.md` | Intención, scope, riesgos |
| Spec | `openspec/changes/login/002-spec.md` | Requisitos, escenarios |
| Design | `openspec/changes/login/003-design.md` | Arquitectura, código |
| Tasks | `openspec/changes/login/004-tasks.md` | Checklist de implementación |
| Verify | `openspec/changes/login/005-verify.md` | Validación contra specs |
| Delta Spec | `openspec/changes/login/delta-spec.md` | Sync a main docs |

---

## Siguiente HU

Después de archive, crear nueva HU:

```bash
# Crear nueva HU
cp docs/templates/user-stories/template-user-story-sdd.md \
   docs/tasks/HU-001-HU-099/HU-043-refresh-token.md

# Iniciar SDD
/sdd-new refresh-token --from-docs
```

---

## Ver también

- [TEMPLATE_GUIDE.md](../templates/TEMPLATE_GUIDE.md)
- [Ciclo de Trabajo](./flowdoc-ciclo.md)
- [ADR-003: Ciclo de 15 días](../architecture/adr/003-ciclo-15-dias.md)
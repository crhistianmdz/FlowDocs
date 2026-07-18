# HU-001: Login de usuarios

## Información General
- **ID**: HU-001
- **Prioridad**: P0
- **Módulo**: backend + frontend (shared)
- **Estimado**: 2 días

---

## User Story

**Como** usuario registrado
**Quiero** iniciar sesión con email y contraseña
**Para** acceder a mis tableros de tareas

---

## Criterios de Aceptación

### Funcionales
- [ ] Debe validar formato de email
- [ ] Debe rechazar contraseñas menores a 8 caracteres
- [ ] Debe retornar error claro cuando las credenciales son inválidas
- [ ] Debe redirigir al `/dashboard` después del login exitoso
- [ ] Debe persistir la sesión vía refresh-token (cookie httpOnly)

### No Funcionales
- [ ] Performance: respuesta < 300ms p95
- [ ] Accesibilidad: WCAG 2.1 AA — labels asociados, focus visible
- [ ] Testing: >85% coverage en auth.service.ts y LoginForm.tsx
- [ ] TypeScript: strict mode, no `any`

---

## API Endpoints Required

| Method | Endpoint            | Use    | Request Body              | Response                          |
|--------|---------------------|--------|---------------------------|-----------------------------------|
| POST   | /api/auth/login     | Login  | `{ email, password }`     | `{ accessToken, user }`           |
| POST   | /api/auth/refresh   | Refresh| (cookie)                   | `{ accessToken }`                 |
| GET    | /api/auth/me        | Perfil | —                          | `{ id, email, role, companyId }`  |

**Ver**: `docs/api/endpoints.md`

---

## DB Changes

- [ ] Sin cambios. Tabla `users` ya existe (ver `docs/database/schema.md`).

---

## UI Components (frontend)

- [ ] Página: `src/pages/LoginPage.tsx`
- [ ] Componente: `src/components/LoginForm.tsx`
- [ ] Hook: `src/hooks/useAuth.ts`
- [ ] Schema: `src/schemas/login.schema.ts` (Zod)
- [ ] Tipo: `src/types/auth.types.ts`

---

## Dependencies

- [ ] ADR-002 (auth strategy) debe estar aceptado
- [ ] Tabla `users` con seed de al menos 1 usuario admin

---

## Testing Checklist

- [ ] Unit: `auth.service.ts` (login success/failure, refresh rotation)
- [ ] Unit: `login.schema.ts` (Zod edge cases)
- [ ] Unit: `useAuth.ts` hook
- [ ] Integration: `LoginForm.tsx` con @testing-library/react
- [ ] E2E: flujo completo de login (Playwright, opcional)

---

## Risks

| Risk                         | Impact | Mitigation                           |
|-------------------------------|--------|--------------------------------------|
| Refresh token leakage XSS     | Alto   | Cookie httpOnly + CSP estricta       |
| Brute-force en /auth/login    | Medio  | Rate-limit 5/15min/IP + lock temporal |

---

## Definition of Done

- [ ] Código implementado
- [ ] Tests escritos y pasando (>85%)
- [ ] Code review aprobado
- [ ] Docs actualizadas (api/endpoints.md)
- [ ] Deploy a staging
- [ ] QA passed

---

**Created**: 2026-01-22
**Author**: @backend-lead
**Status**: 🔄 In Progress
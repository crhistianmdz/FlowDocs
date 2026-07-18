# HU-001: Login (web)

## Información General
- **ID**: HU-001
- **Prioridad**: P0
- **Módulo**: web
- **Estimado**: 2 días

## User Story

**Como** usuario de la versión web
**Quiero** iniciar sesión desde el navegador
**Para** acceder a mis tableros

## Criterios de Aceptación

### Funcionales
- [ ] Formulario en `/login` con email (Zod-validated) + password (≥8)
- [ ] POST `/api/auth/login` (api HU-001)
- [ ] Guarda `accessToken` en memoria (no localStorage)
- [ ] On success → redirect `/dashboard`
- [ ] Muestra error claro en credenciales inválidas

### No Funcionales
- [ ] p95 login screen < 1.5s FMP
- [ ] Cobertura ≥85% en `LoginForm.tsx`, `useLogin.ts`
- [ ] WCAG 2.1 AA — labels, focus, contrast

## Dependencies
- [ ] `@taskboard/types` shipped `AuthResponse`
- [ ] `@taskboard/ui` Button exported
- [ ] api HU-001 deployed to staging

## UI Components
- [ ] `packages/web/src/pages/LoginPage.tsx`
- [ ] `packages/web/src/components/LoginForm.tsx`
- [ ] `packages/web/src/hooks/useLogin.ts`
- [ ] `packages/web/src/schemas/login.schema.ts`

## Definition of Done
- [ ] Implementado + tests ≥85% (Vitest + RTL)
- [ ] Lighthouse a11y 100
- [ ] Deploy preview + QA manual

---

**Created**: 2026-03-20
**Author**: @web-lead
**Status**: 🔄 In Progress
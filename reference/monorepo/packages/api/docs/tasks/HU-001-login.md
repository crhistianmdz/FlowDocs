# HU-001: Login (api)

## Información General
- **ID**: HU-001
- **Prioridad**: P0
- **Módulo**: api
- **Estimado**: 1.5 días

## User Story

**Como** servicio backend
**Quiero** validar credenciales de usuario y emitir tokens JWT
**Para** que los clientes (web + mobile) puedan autenticarse

## Criterios de Aceptación

### Funcionales
- [ ] POST `/api/auth/login` con `{ email, password }`
- [ ] bcrypt verify + lookup en `users` table
- [ ] Retorna `{ accessToken, user }` (ver `@taskboard/types` `AuthResponse`)
- [ ] Refresh token en cookie httpOnly Secure SameSite=Strict
- [ ] Rate-limit 5 intentos / 15min / IP
- [ ] GET `/api/auth/me` retorna perfil del portador
- [ ] GET `/api/auth/verify` para consumers internos (web/mobile)

### No Funcionales
- [ ] p95 < 250ms (sin WS)
- [ ] Cobertura ≥85% en `auth.ts`
- [ ] Tipos canónicos en `@taskboard/types`

## Dependencies
- [ ] `@taskboard/types` `AuthResponse` publicado (workspace link)
- [ ] Base de datos migrations applied

## Definition of Done
- [ ] Implementado + tests ≥85%
- [ ] Contract de tipos consumido por web y mobile
- [ ] Deploy a staging + smoke test cross-package

---

**Created**: 2026-03-20
**Author**: @api-lead
**Status**: ✅ Done
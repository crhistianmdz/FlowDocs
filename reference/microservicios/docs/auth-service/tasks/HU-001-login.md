# HU-001: Login (auth-service)

## Información General
- **ID**: HU-001
- **Prioridad**: P0
- **Módulo**: auth-service
- **Estimado**: 2 días

## User Story

**Como** cliente
**Quiero** iniciar sesión con email y contraseña
**Para** acceder a la plataforma y realizar pedidos

## Criterios de Aceptación

### Funcionales
- [ ] POST `/api/auth/login` retorna `accessToken` + `user`
- [ ] Refresh token en cookie httpOnly (Secure, SameSite=Strict)
- [ ] Rate-limit 5 intentos / 15min / IP
- [ ] Respuestas de error estandarizadas (VALIDATION_ERROR, INVALID_CREDENTIALS)

### No Funcionales
- [ ] p95 < 250ms
- [ ] Cobertura ≥85% en `auth.service.ts`
- [ ] Pact contract test contra `orders-service` (`verify`)

## API Required

| Method | Endpoint            | Notes                       |
|--------|---------------------|-----------------------------|
| POST   | /api/auth/login     | HU-001                       |
| POST   | /api/auth/refresh   | Rotación con detección       |
| GET    | /api/auth/verify    | Consumido por orders-service |

**Ver**: `auth-service/API/endpoints.md` y `SHARED/contratos.md`.

## Dependencies
- [ ] Ninguna (hoja de la DAG).

## Testing
- [ ] Unit: login, refresh, verify (Vitest)
- [ ] Pact: contract `verify` con orders-service como consumer
- [ ] Integration: Testcontainers PostgreSQL

## Definition of Done
- [ ] Implementado + tests ≥85%
- [ ] Docs actualizadas (endpoints.md, schema.md)
- [ ] Deploy a staging + smoke test

---

**Created**: 2026-02-05
**Author**: @auth-lead
**Status**: ✅ Done
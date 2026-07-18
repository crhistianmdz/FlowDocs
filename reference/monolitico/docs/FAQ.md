# FAQ — TaskManager (monolith reference)

## ¿Dónde agrego una nueva feature?
1. Crea la HU en `docs/tasks/HU-XXX-name.md` (usa `TEMPLATE.md`).
2. Si hay decisión técnica → crea RFC en `docs/architecture/rfc/`.
3. Implementa en `src/` (components / services / hooks).
4. Actualiza `docs/api/endpoints.md` y `docs/database/schema.md` en el mismo PR.

## ¿Cuándo creo un ADR?
Cuando una decisión técnica es **permanente** y afecta al resto del sistema. Si todavía se discute → RFC. Cuando se aprueba → ADR.

## ¿Por qué monolito y no microservicios?
MVP optimiza velocidad de iteración y despliegue único. Ver `ADR-001` y `ADR-002` para contexto.

## ¿Puedo sumar campo a una tabla existente?
Sí, pero requiere migración Prisma + actualizar `schema.md` + endpoint afectado en `endpoints.md`, en el mismo PR.

---

**Last Updated**: 2026-07-18
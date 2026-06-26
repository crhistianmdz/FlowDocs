# HU-XXX: [Título de la Historia de Usuario]

## Información General
- **ID**: HU-XXX
- **Prioridad**: P0 / P1 / P2 / P3
- **Módulo**: frontend / backend / shared
- **Estimado**: X horas / días

---

## User Story

**Como** [rol: administrador / usuario / etc.]  
**Quiero** [acción que el usuario quiere realizar]  
**Para** [beneficio o valor de negocio que obtiene]

---

## Criterios de Aceptación

### Funcionales
- [ ] Criterio 1 (ej: Debe validar email con formato correcto)
- [ ] Criterio 2 (ej: Debe mostrar error si el password es < 8 caracteres)
- [ ] Criterio 3 (ej: Debe redirigir al dashboard después del login)

### No Funcionales
- [ ] Performance: < 2s page load, < 500ms API calls
- [ ] Accesibilidad: WCAG 2.1 AA (si es frontend)
- [ ] Testing: >80% coverage (vitest + @testing-library/react)
- [ ] TypeScript: Strict mode, no `any`

---

## API Endpoints Required

| Method | Endpoint | Use | Request Body | Response |
|--------|----------|-----|--------------|----------|
| POST | /api/auth/login | Login | `{ email, password }` | `{ accessToken, user }` |
| GET | /api/users | List users | - | `User[]` |

**Ver documentación completa**: `docs/API/endpoints.md`

---

## DB Changes (si aplica)

- [ ] Nueva tabla: `nombre_tabla`
- [ ] Nueva columna: `tabla.columna` (tipo, constraints)
- [ ] Índice: `tabla(columna)`
- [ ] Migración requerida: `docs/DB/migrations.md`

**Ver schema**: `docs/DB/schema.md`

---

## UI Components (si es frontend)

- [ ] Página: `NamePage.tsx`
- [ ] Componente: `NameComponent.tsx`
- [ ] Hook: `useName.ts`
- [ ] Schema: `name.schema.ts` (Zod)
- [ ] Tipo: `name.types.ts` (TypeScript)

---

## Dependencies

- [ ] HU-YYY debe estar completada primero
- [ ] Módulo de Auth migrado
- [ ] API endpoint disponible

---

## Testing Checklist

- [ ] Unit tests: services/utils (vitest)
- [ ] Unit tests: schemas (vitest)
- [ ] Unit tests: hooks (vitest)
- [ ] Integration tests: components (@testing-library/react)
- [ ] Integration tests: flows (E2E si aplica)
- [ ] Manual testing: verificar criterios de aceptación

---

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| API inestable | Alto | Mock services, contract testing |
| DB schema change | Medio | Migración backwards compatible |
| Performance issue | Bajo | Lazy loading, virtualization |

---

## Notes

- Cualquier consideración especial
- Decisiones de diseño importantes
- Links a discusiones o issues relacionados

---

## Definition of Done

- [ ] Código implementado
- [ ] Tests escritos y pasando (>80% coverage)
- [ ] Code review aprobado
- [ ] Documentación actualizada (API, DB, etc.)
- [ ] Deploy a staging (si aplica)
- [ ] QA passed (si aplica)

---

**Created**: YYYY-MM-DD  
**Author**: @person-name  
**Status**: 📋 Backlog / 🔄 In Progress / ✅ Done / ❌ Blocked

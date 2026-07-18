# Manual del Agente — FlowDocs

> Cuando dudés con la documentación, empezá por acá.

---

## Regla de oro

**¿No sabés qué hacer? → Preguntá al developer. Sin adivinar. Sin asumir.**

---

## Árbol de decisiones

```
¿Necesitás documentar algo?
├── DECISIÓN TÉCNICA → ¿Ya se discutió?
│   ├── SÍ → Crear ADR en `docs/architecture/adr/`
│   └── NO → Crear RFC en `docs/architecture/rfc/`
│
├── REQUERIMIENTO → Crear/actualizar en `docs/PRD.md`
│
├── CONTRATO DE API → Actualizar `docs/templates/api/endpoints.md`
│
├── ESQUEMA DB → Actualizar `docs/templates/database/schema.md`
│
├── NO SABÉS el tipo → PREGUNTAR al developer
│
└── ¿Encontraste docs OUTDATED?
    ├── SÍ → Actualizar en el MISMO PR que cambia el código
    └── NO → Seguí con tu tarea
```

---

## Quick Reference

| Situación | Acción | Ubicación |
|-----------|--------|-----------|
| Decisión técnica pendiente | Crear RFC | `docs/architecture/rfc/NNN-nombre.md` |
| Decisión técnica aprobada | Crear ADR | `docs/architecture/adr/NNN-nombre.md` |
| Decisión existe y cambia | Actualizar ADR existente | Mismo archivo |
| Decisión obsoleta | Cambiar status a `Deprecated` | Mismo ADR |
| Nuevo requerimiento | Actualizar PRD | `docs/PRD.md` |
| Cambio en API | Actualizar endpoints | `docs/templates/api/endpoints.md` |
| Cambio en DB | Actualizar schema | `docs/templates/database/schema.md` |
| Ninguna de las anteriores | **Preguntar** | — |

---

## Estados de documentos

### ADR / RFC
```
Draft → In Review → Accepted
                      ↓
                 Deprecated (si se reemplaza)
```

### Reglas
- **ADR en Draft > 1 mes**: Preguntá al dev — decisión trabada
- **RFC en Review > 2 semanas**: Preguntá al dev — no hay consenso
- **No sabés el estado**: Preguntá al dev

---

## Convenciones de nombre

```
NNN-descriptive-name.md
```

| Tipo | Ejemplo |
|------|---------|
| ADR | `001-auth-jwt.md` |
| RFC | `001-auth-jwt-proposal.md` |

- NNN = número correlativo (ver último en la carpeta)
- Nombre = kebab-case, descriptivo
- Sin espacios, sin tildes

---

## Formato mínimo obligatorio

### ADR
```markdown
# ADR-NNN: Título

- **Date**: YYYY-MM-DD
- **Status**: Draft | In Review | Accepted | Deprecated
- **Context**: Por qué se tomó esta decisión
- **Decision**: Qué se decidió
- **Consequences**: Pros y contras
```

### RFC
```markdown
# RFC-NNN: Título

- **Author**: Tu nombre
- **Status**: Draft | In Review
- **Problem**: Qué problema resuelve
- **Proposed Solution**: Tu propuesta
- **Open Questions**: Qué falta definir
```

---

## No hagas esto

- ❌ Modificar `docs/` sin approval del dev
- ❌ Crear ADR sin RFC previo (a menos que el dev lo pida)
- ❌ Borrar documentación existente
- ❌ Actualizar ADR deprecated (creá uno nuevo)
- ❌ Inventar convenciones que no existen

---

## Cuando actualizás documentación

**Regla**: Los docs se actualizan en el MISMO PR que cambia el código.

```
Si hacés un cambio en el código → Actualizá los docs en ese mismo PR
```

No hagas PR separado para docs.

---

## Checklist antes de commit

- [ ] ¿Creaste o actualizaste el documento correcto?
- [ ] ¿El ADR/RFC tiene el status correcto?
- [ ] ¿El nombre sigue la convención NNN-nombre.md?
- [ ] ¿Hay algo para preguntarle al dev?

---

## Cuando todo falla

1. Leé `docs/anti-patrones.md` — puede estar descripto ahí
2. Leé `docs/troubleshooting.md` — problemas comunes y soluciones
3. **Preguntá al developer** — no adivines

---

## Ver también

- `docs/anti-patrones.md` — Señales de que algo está mal
- `docs/troubleshooting.md` — Problemas y soluciones
- `docs/templates/` — Templates para cada tipo de documento

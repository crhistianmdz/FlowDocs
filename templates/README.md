# ⚠️ DEPRECATED

Esta carpeta está deprecated.

## Por qué

`docs/templates/` es el **source of truth** para todos los templates del framework (ver ADR-007).

## Qué hacer

**Usa `docs/templates/` en lugar de esta carpeta.**

```
# ❌ DEPRECATED - No usar
cp ~/Documentos/newPropuestaFrameworkTrabajo/templates/*.md tu-proyecto/

# ✅ CORRECTO - Usar docs/templates/
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/user-stories/* tu-proyecto/docs/templates/user-stories/
```

## Estructura actual de `docs/templates/`

```
docs/templates/
├── TEMPLATE_GUIDE.md
├── user-stories/
├── bug-fixes/
├── refactors/
├── architecture/
├── database/
├── api/
└── PRD/
```

## Por qué mantenemos esta carpeta

Esta carpeta se mantiene por **compatibilidad hacia atrás** y como referencia histórica. No se eliminará físicamente para evitar romper enlaces o scripts que puedan existir.

## Ver también

- [ADR-007: docs/templates/ como Source of Truth](../docs/architecture/adr/007-estructura-templates.md)
- [TEMPLATE_GUIDE.md](../docs/templates/TEMPLATE_GUIDE.md)
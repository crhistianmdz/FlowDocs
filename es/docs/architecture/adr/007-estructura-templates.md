# ADR-007: docs/templates/ como Source of Truth

**Fecha**: 2026-05-29  
**RFC relacionado**: Ninguno (decisión de organización del framework)  
**Estado**: Aceptado

---

## Contexto

El framework tiene templates en múltiples ubicaciones:
- `/templates/` — templates genéricos
- `/architectures/monolitico/templates/` — ejemplos específicos
- `/architectures/microservicios/templates/` — ejemplos específicos

Esta dispersión causa confusión sobre cuál usar y cuál es la fuente de verdad. Los desarrolladores nuevos no saben si deben copiar desde `/templates/` o desde `architectures/*/templates/`.

Los agents de IA necesitan saber cuál es la ubicación canónica para proponer cambios correctos.

---

## Decisión

**`docs/templates/` es el source of truth** para todos los templates del framework.

```
docs/templates/           ← Source of truth (copiar desde aquí)
├── user-stories/         ← Templates de user stories
├── bug-fixes/            ← Templates de bug fixes
├── refactors/            ← Templates de refactors
├── architecture/         ← RFC y ADR templates
├── database/             ← Schema templates
├── api/                  ← Endpoint y modelo templates
└── PRD/                  ← PRD templates

architectures/*/          ← Ejemplos de referencia (no modificar)
├── monolitico/
├── microservicios/
├── monorepo/
└── serverless/
```

### Regla fundamental

**Siempre se copia desde `docs/templates/`**. `architectures/*/` son ejemplos de referencia, no templates para copiar directamente.

---

## Estructura de `docs/templates/`

| Carpeta | Contenido |
|---------|-----------|
| `user-stories/` | `template-user-story.md`, `template-user-story-sdd.md` |
| `bug-fixes/` | `template-bug-fix.md`, `template-bug-fix-sdd.md` |
| `refactors/` | `template-refactor.md` |
| `architecture/` | `RFC_template.md`, `ADR_template.md` |
| `database/` | `schema.md` (ejemplo genérico) |
| `api/` | `endpoints.md`, `modelos.md` (ejemplos genéricos) |
| `PRD/` | `PRD.md` (template principal) |

---

## `architectures/` como Referencia

Cada carpeta de arquitectura incluye:

```
architectures/monolitico/
├── estructura.md              ← Guía de la estructura
├── templates/                 ← COPIAS de ejemplos (no son templates)
│   ├── HU-TEMPLATE.md
│   ├── API-endpoints.md
│   └── DB-schema.md
└── scripts/
    └── init-monolith.sh

architectures/microservicios/
├── estructura.md
├── templates/
│   ├── modulo-README.md
│   ├── contratos.md
│   └── HU-TEMPLATE.md
└── scripts/
    └── init-microservices.sh
```

**Importante**: Los archivos en `architectures/*/templates/` son **copias de ejemplo**, no se copian directamente a proyectos nuevos. Se usan como referencia de qué se espera en cada tipo de arquitectura.

---

## Por qué no unificar todo en `templates/`

1. **`docs/` es el source of truth** según el ADR-002 (docs/ como source of truth)
2. **`architectures/` como ejemplos** permite visualizar cómo se ve la estructura completa en cada caso
3. **Escalabilidad**: agregar una nueva arquitectura no requiere cambiar la estructura de templates
4. **Consistencia**: developers siempre van a `docs/templates/` sin confuse

---

## Consecuencias

### ✅ Positivo

- Una sola ubicación para templates (sin ambigüedad)
- `architectures/` queda limpio como referencia
- Agents y developers saben dónde ir
- Estructura consistente con la decisión de docs/ como source of truth (ADR-002)

### ❌ Negativo

- Hay dos conjuntos de archivos similares (docs/templates/ vs architectures/*/templates/)
- Requiere mantener ambas estructuras sincronizadas al principio

### 🔄 Neutral

- `architectures/` no se borra, queda como documentación de referencia
- A futuro se podría deprecar `templates/` raíz y solo usar `docs/templates/`

---

## Migration Path

1. **Corto plazo**: Crear `docs/templates/` con la estructura correcta
2. **Mediano plazo**: Los scripts de inicialización copian desde `docs/templates/`, no desde `architectures/*/`
3. **Largo plazo**: `templates/` raíz queda como deprecated, `docs/templates/` es el único lugar

---

## Documentos Relacionados

| Documento | Ubicación |
|-----------|-----------|
| docs/ como source of truth | ADR-002 |
| Guía de templates | `docs/templates/TEMPLATE_GUIDE.md` |
| Inicialización | `scripts/init-*.sh` (por actualizar) |

---

## Checklist de Implementación

- [ ] `docs/templates/` creado con subcarpetas
- [ ] Templates movidos/copiados a `docs/templates/`
- [ ] `TEMPLATE_GUIDE.md` actualizado con nueva estructura
- [ ] Scripts de inicialización actualizados (copian desde docs/templates/)
- [ ] `architectures/*/templates/` marcado como "ejemplos de referencia" en sus README
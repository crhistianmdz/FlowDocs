# Changelog

Documentación de cambios y decisiones adoptadas en el framework.

---

## 2026-05-29 — Nombre del Framework: FlowDoc

### Decisión de Naming

El framework se llama **FlowDoc**.

| Proyecto | Propósito |
|----------|-----------|
| **FlowDoc** | Framework de documentación que fluye con el trabajo |
| **FlowForge** | Tool que minimiza overhead SDD, optimiza tiempo/recursos |

Ver [ADR-008: Nombre del Framework: FlowDoc](docs/architecture/adr/008-nombre-flowdoc.md).

### Nuevos ADRs

| ADR | Título |
|-----|--------|
| ADR-008 | Nombre del Framework: FlowDoc |

### Estructura Actualizada

- `framework-coordinacion.md` movido a `docs/flowdoc-ciclo.md`
- `propuesta-unificada-equipo.md` deprecado, movido a `docs/architecture/rfc/004-propuesta-unificada-equipo-deprecada.md`

### Estructura Bilingüe

El framework ahora es bilingüe (EN primary, ES secondary):

| Ruta | Contenido |
|------|-----------|
| `README.md` | English (primary) |
| `AGENTS.md` | English (primary) |
| `docs/*.md` | English documentation |
| `es/` | Spanish translations |

Ver [`es/`](es/) folder para versión en español.`

---

## 2026-05-29 — Sesión de Completado de Estructura

### Nuevos ADRs

| ADR | Título |
|-----|--------|
| ADR-005 | Organización de HUs por rangos de 100 |
| ADR-006 | Cuatro arquitecturas soportadas |
| ADR-007 | docs/templates/ como source of truth |

### Nuevos RFCs

| RFC | Título |
|-----|--------|
| RFC-001 | Estructura de documentación docs/ |
| RFC-002 | Ciclo de trabajo de 15 días |
| RFC-003 | Feature flags obligatorios |

### Nuevos templates en docs/

```
docs/templates/
├── TEMPLATE_GUIDE.md
├── user-stories/
│   ├── template-user-story.md
│   └── template-user-story-sdd.md
├── bug-fixes/
│   ├── template-bug-fix.md
│   └── template-bug-fix-sdd.md
├── refactors/
│   └── template-refactor.md
├── architecture/
│   ├── RFC_template.md
│   └── ADR_template.md
├── database/
│   └── schema.md
├── api/
│   └── endpoints.md
└── PRD/
    ├── PRD.md
    └── PRD_template.md
```

### Nuevas HUs de ejemplo

| HU | Título |
|----|--------|
| HU-001 | Mejorar onboarding de nuevos miembros |
| HU-002 | Agregar validación de HUs en pre-commit |

### Documentación creada

| Documento | Propósito |
|-----------|-----------|
| `docs/PRD.md` | PRD del propio framework |
| `docs/legacy-migration.md` | Guía para adaptar proyectos legacy a SDD |
| `docs/troubleshooting.md` | Errores comunes y soluciones |
| `docs/walkthrough-hu-login.md` | Ejemplo completo de HU por ciclo SDD |
| `docs/adoption-guide.md` | Guía de adopción en niveles |
| `docs/FAQ.md` | Preguntas frecuentes |
| `docs/anti-patrones.md` | Señales de que el framework no está funcionando |
| `docs/architecture-diagram.md` | Diagramas Mermaid de la arquitectura |
| `docs/api/endpoints.md` | Ejemplo genérico de endpoints |
| `docs/api/modelos.md` | Ejemplo genérico de modelos/DTOs |
| `docs/database/schema.md` | Ejemplo genérico de schema |

### Cambios

| Área | Cambio |
|------|--------|
| **Templates** | Unificación en `docs/templates/` como source of truth |
| **/templates/** | Deprecated con README explicativo |
| **scripts/** | Actualizados para soportar estructura con subcarpetas (HU-001-HU-099/) |
| **TEMPLATE_GUIDE.md** | Actualizado con nueva estructura de docs/templates/ |
| **QUICKSTART.md** | Actualizado con paths correctos |
| **architectures/** | Actualizadas notas sobre source of truth |

### Decisiones adoptadas

1. **`docs/` como source of truth** — Todo vive en docs/, architectures/ son ejemplos
2. **Rangos de 100 para HUs** — Dividir docs/tasks/ en carpetas HU-001-HU-099/ cuando sea necesario
3. **Feature flags obligatorios** — Toda feature nueva con flag
4. **Ciclo de 15 días** — Planning(1-2) → Execution(3-11) → Integration(12-14) → Retro(15)

---

## Estructura final de docs/

```
docs/
├── PRD.md
├── legacy-migration.md
├── troubleshooting.md
├── tech-debt.md
├── api/
│   ├── endpoints.md
│   └── modelos.md
├── architecture/
│   ├── rfc/
│   │   ├── 001-estructura-docs.md
│   │   ├── 002-ciclo-15-dias.md
│   │   └── 003-feature-flags.md
│   └── adr/
│       ├── 001-persistencia-engram.md
│       ├── 002-docs-source-of-truth.md
│       ├── 003-ciclo-15-dias.md
│       ├── 004-feature-flags.md
│       ├── 005-organizacion-hu.md
│       ├── 006-cuatro-arquitecturas.md
│       └── 007-estructura-templates.md
├── database/
│   └── schema.md
├── tasks/
│   └── HU-001-HU-099/
│       ├── HU-001-onboarding-docs.md
│       └── HU-002-validacion-hus.md
└── templates/
    ├── TEMPLATE_GUIDE.md
    └── [plantillas por categoría]
```

---

## Recursos

- [ADR-007: docs/templates/ como Source of Truth](architecture/adr/007-estructura-templates.md)
- [TEMPLATE_GUIDE.md](templates/TEMPLATE_GUIDE.md)
- [Ciclo de Trabajo](docs/flowdoc-ciclo.md)
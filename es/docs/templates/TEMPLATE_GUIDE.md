# Guía de Templates — Cuándo y Cuál Usar

> Esta guía explica qué templates existen, por qué hay dos versiones de algunos, y cuándo usar cada uno.

---

## Overview de Templates

```
docs/templates/               ← Source of truth (copiar desde aquí)
├── TEMPLATE_GUIDE.md         ← Esta guía
├── user-stories/
│   ├── template-user-story.md       ← User Story (simple)
│   └── template-user-story-detailed.md   ← User Story (SDD-Ready) ⭐
├── bug-fixes/
│   ├── template-bug-fix.md          ← Bug Fix (simple)
│   └── template-bug-fix-detailed.md      ← Bug Fix (SDD-Ready) ⭐
├── refactors/
│   └── template-refactor.md         ← Refactor
├── architecture/
│   ├── RFC_template.md              ← Request for Comments
│   └── ADR_template.md              ← Architecture Decision Record
├── database/
│   └── schema.md                    ← Database Schema genérico
├── api/
│   ├── endpoints.md                 ← API Endpoints ejemplo
│   └── modelos.md                   ← Modelos/DTOs ejemplo
└── PRD/
    ├── PRD.md                       ← Product Requirements Document
    └── PRD_template.md              ← PRD Template con secciones ML/AI

reference/*/               ← Ejemplos de referencia (no modificar)
├── monolitico/
├── microservicios/
├── monorepo/
└── serverless/
```

### Carpetas de Referencia — Estructuras visuales completas para cada arquitectura

Las carpetas `reference/<arquitectura>/` muestran **estructuras visuales completas** para cada una de las cuatro arquitecturas soportadas. Cada una contiene un layout de proyecto representativo — con el árbol de `docs/` esperado, un layout de `src/` de ejemplo, scripts de ejemplo, configuración, un `estructura.md` que describe el layout y un `.agent-context.md` para los agents de IA.

Su propósito es hacer que la organización de carpetas sea **concreta y visible de un vistazo**, para que puedas comparar arquitecturas sin reconstruirlas desde prosa. Son **ejemplos de solo lectura**, no templates para copiar en un proyecto — `docs/templates/` sigue siendo el source of truth para los templates escritos por humanos.

> Ver [ADR-012 — Estructuras de Referencia Visual para Arquitecturas](../architecture/adr/012-estructuras-de-referencia-visual.md) para la justificación de la decisión.

---

## Por qué dos versiones (simple vs SDD-Ready)?

### La diferencia

| Característica | Simple | SDD-Ready |
|----------------|--------|-----------|
| User Story básica | ✅ | ✅ |
| Criterios de aceptación | ✅ | ✅ |
| Escenarios Given/When/Then | ❌ | ✅ |
| Referencia de tests (🧪 Ref) | ❌ | ✅ |
| Feature Flag integration | ❌ | ✅ |
| Contract Layer (owner, deadline) | ❌ | ✅ |
| Deuda técnica documentada | ❌ | ✅ |

### El "por qué"

**Simple**: Para equipos que están comenzando con SDD o para tareas pequeñas donde la ceremonia completa sería overhead.

**SDD-Ready**: Para features reales donde necesitás trazabilidad completa entre lo que se especifica y los tests que lo verifican.

---

## Cuándo usar cada template

### User Stories

| Caso | Template | Ejemplo |
|------|----------|---------|
| Tarea muy pequeña, 1-2h | Simple | Fix typo, cambiar copy |
| Feature normal, 1-3 días | SDD-Ready | Login, CRUD, búsqueda |
| Feature compleja, 3+ días | SDD-Ready + dividir | Módulo de pagos |

**Recomendación**: Si no estás seguro, usa **SDD-Ready**. El overhead extra vale la pena.

---

### Bug Fixes

| Caso | Template | Por qué |
|------|----------|---------|
| Bug obvio, fix trivial | Simple | Solo verificar que no se rompa nada |
| Bug con causa raíz no clara | SDD-Ready | Necesitás entender el escenario completo |
| Bug que requiere test | SDD-Ready | 🧪 Ref te ayuda a trackear qué test verifica el fix |

**Recomendación**: La mayoría de los bugs deberían usar **SDD-Ready** porque necesitás asegurar que no se repitan.

---

### Refactors

| Caso | Template |
|------|----------|
| Refactor pequeño, mismo comportamiento | `template-refactor.md` |
| Refactor grande con cambios de API | SDD-Ready + ADR si hay decisión de arquitectura |

---

### PRD

| Template | Cuándo usar |
|----------|-------------|
| `PRD.md` | Nuevo proyecto, documento vivo del producto |
| `PRD_template.md` | Template detallado con secciones de ML/AI (usar si aplica) |

---

### RFC vs ADR

| Template | Estado | Uso |
|----------|--------|-----|
| `RFC_template.md` | En Discusión | Cuando estás evaluando una decisión técnica |
| `ADR_template.md` | Aprobado | Cuando la decisión ya está tomada y es permanente |

**Flujo**: RFC (discusión) → ADR (decisión registrada)

---

## Guía rápida de decisión

```
¿Necesitás documentar una decisión técnica?
├── ¿Ya está decidida?
│   ├── SÍ → Crear ADR (docs/templates/architecture/ADR_template.md)
│   └── NO → Crear RFC (docs/templates/architecture/RFC_template.md)
│
¿Necesitás una nueva feature?
├── ¿Es muy pequeña (< 2h)?
│   └── USAR: docs/templates/user-stories/template-user-story.md
└── ¿Es normal o grande?
    └── USAR: docs/templates/user-stories/template-user-story-detailed.md ⭐
    └── Si es grande → dividir en HUs más pequeñas
    └── Si requiere decisión técnica → RFC primero
│
¿Encontraste un bug?
├── ¿El fix es obvio y trivial?
│   └── USAR: docs/templates/bug-fixes/template-bug-fix.md
└── ¿Necesitás verificar que no se repita?
    └── USAR: docs/templates/bug-fixes/template-bug-fix-detailed.md
    └── ¿Hay decisión de arquitectura involucrada?
        └── ADR después del fix
│
¿Vas a refactorizar?
└── USAR: docs/templates/refactors/template-refactor.md
    └── Si cambia API o arquitectura → ADR también
│
¿Documentar producto?
└── USAR: docs/templates/PRD/PRD.md (nuevo proyecto)
    └── Si es proyecto con ML/AI → docs/templates/PRD/PRD_template.md
```
¿Necesitás documentar una decisión técnica?
├── ¿Ya está decidida?
│   ├── SÍ → Crear ADR (template ADR_template.md)
│   └── NO → Crear RFC (template RFC_template.md)
│
¿Necesitás una nueva feature?
├── ¿Es muy pequeña (< 2h)?
│   └── USAR: template-user-story.md
└── ¿Es normal o grande?
    └── USAR: template-user-story-detailed.md ⭐
    └── Si es grande → dividir en HUs más pequeñas
    └── Si requiere decisión técnica → RFC primero
│
¿Encontraste un bug?
├── ¿El fix es obvio y trivial?
│   └── USAR: template-bug-fix.md
└── ¿Necesitás verificar que no se repita?
    └── USAR: template-bug-fix-detailed.md
    └── ¿Hay decisión de arquitectura involucrada?
        └── ADR después del fix
│
¿Vas a refactorizar?
└── USAR: template-refactor.md
    └── Si cambia API o arquitectura → ADR también
│
¿Documentar producto?
└── USAR: PRD.md (nuevo proyecto)
    └── Si es proyecto con ML/AI → PRD_template.md
```

---

## Tips

1. **No usar templates por inercia**: Si la tarea es trivial, usá el template simple. Si es importante, usá SDD-Ready.

2. **Dividir HUs grandes**: Si una HU tiene más de 5 escenarios Given/When/Then, probablemente debería dividirse.

3. **Los 🧪 Ref importan**: Cada escenario necesita un test que lo verifique. Si no hay test, el escenario no está completo.

4. **El ADR no se borra**: Cuando una decisión cambia, se crea un nuevo ADR y se marca el viejo como `DEPRECATED`. No se borra.

---

## Recursos

- Template SDD-Ready: `docs/templates/user-stories/template-user-story-detailed.md`
- Template SDD-Ready: `docs/templates/bug-fixes/template-bug-fix-detailed.md`
- Template Refactor: `docs/templates/refactors/template-refactor.md`
- Template RFC: `docs/templates/architecture/RFC_template.md`
- Template ADR: `docs/templates/architecture/ADR_template.md`
- Template PRD: `docs/templates/PRD/PRD.md`
- Ciclo SDD: `docs/deprecated/workflow/flowdoc-ciclo.md` (deprecated)
- Guía de troubleshooting: `docs/troubleshooting.md`
- Decisión de estructura: `docs/architecture/adr/007-estructura-templates.md`

---

## Organización de HUs en el Filesystem

A medida que un proyecto crece, acumular muchas HUs en una sola carpeta puede afectar el rendimiento del filesystem y hacer difícil encontrar archivos específicos.

### Regla: Rangos de 100

```
docs/tasks/
├── HU-001-HU-099/           ← Fase 1
│   ├── HU-001-primera-feature.md
│   └── ...
├── HU-100-HU-199/           ← Fase 2 (crear cuando HU-099 existe)
│   └── ...
├── HU-200-HU-299/           ← Fase 3 (crear cuando HU-199 existe)
│   └── ...
```

### Cuándo aplicar

| Cantidad de HUs | Estrategia |
|-----------------|------------|
| < 50 | Carpeta plana (no necesario dividir) |
| 50-99 | Considerar crear siguiente carpeta |
| ≥ 100 | Obligatorio — dividir por rango |

### Cómo crear la carpeta siguiente

1. Cuando la última HU del rango existe (ej: HU-099), crear la carpeta del siguiente rango
2. No crear carpetas vacías por anticipado
3. Mover la HU correspondiente al rango

```bash
# Cuando HU-099 está completa
mkdir -p docs/tasks/HU-100-HU-199

# Mover la primera HU del nuevo rango
mv docs/tasks/HU-100-login.md docs/tasks/HU-100-HU-199/
```

### En commits

El path completo de la HU cambia al incluir la carpeta:

```
docs/tasks/HU-001-HU-099/HU-042-login.md
```

```bash
# Commit message sigue igual
git add docs/tasks/HU-001-HU-099/HU-042-login.md
git commit -m "feat: HU-042 - add login page"
```

### Scripts

Los scripts como `hu-to-issues.sh` detectan automáticamente la carpeta según el número de HU.

Ver ADR-005 para más detalles sobre la decisión.
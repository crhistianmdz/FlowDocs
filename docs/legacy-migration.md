# Guía de Migración: Proyecto Legacy a SDD

> Cómo adaptar un proyecto existente al esquema de trabajo SDD sin reescribir todo de golpe.

---

## Cuándo Migrar

| Señal | Descripción |
|-------|-------------|
| Proyecto > 6 meses | Documentación desactualizada o inexistente |
| Equipo > 3 personas | Cada uno trabaja de forma distinta |
| Onboarding > 1 semana | Newcomers no saben dónde está nada |
| Cambios frecuente | Código nuevo pero sin estrategia |

Si tu proyecto tiene 2+ de estas señales, es hora de migrar.

---

## Principio Fundamental

**No se reescribe todo de golpe.** SDD funciona incrementalmente:

1. Primero: estructura de docs + AGENTS.md
2. Después: cada nuevo feature o refactor sigue SDD
3. El código legacy se documenta cuando se toca

---

## Fase 1: Estructura Base (Día 1)

### 1.1 Crear carpeta `docs/`

```bash
cd tu-proyecto
mkdir -p docs/architecture/rfc
mkdir -p docs/architecture/adr
mkdir -p docs/api
mkdir -p docs/database
mkdir -p docs/tasks
```

### 1.2 Copiar templates

```bash
# Si usas este framework como base
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/*/*.md tu-proyecto/docs/templates/

# O copia individualmente los que necesites
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/user-stories/template-user-story-sdd.md tu-proyecto/docs/tasks/TEMPLATE.md
```

### 1.3 Crear `AGENTS.md` en la raíz

Ver `AGENTS.md-ejemplo.md` en este repo como referencia.

El objetivo es que cualquier agent (OpenCode, Antigravity, otro) pueda leer este archivo y entender:
- Stack tecnológico del proyecto
- Estructura de carpetas
- Convenciones del equipo
- Cómo trabajar con SDD

### 1.4 Documentar estado actual

Crear `docs/architecture/adr/000-legacy-state.md` con:

```markdown
# ADR-000: Estado Legacy

**Fecha**: YYYY-MM-DD

## Contexto

Proyecto existente con X años/meses de desarrollo.
Stack: [tecnologías actuales]
Equipo: [tamaño, zonas horarias]

## Decisiones Tomadas Previamente

| Decisión | RFC/ADR | Estado |
|----------|---------|--------|
| [Decisión 1] | N/A | Legacy (sin documento) |

## Deuda Técnica Conocida

| # | Área | Impacto | Propuesta |
|---|------|---------|-----------|
| 1 | [Área] | [Alto/Medio/Bajo] | [Solución] |

## Lo que existe (inventory)

- **Frontend**: [qué hay, qué stack]
- **Backend**: [qué hay, qué stack]
- **DB**: [qué hay, qué motor]
- **APIs externas**: [cuáles]
```

---

## Fase 2: Primera HU desde Legacy (Día 2-3)

### 2.1 Elegir algo que se va a tocar

**Regla**: No documentar código que no se va a tocar. Solo crear HUs para:

1. Features nuevos
2. Refactors planificados
3. Bugs que se van a fixear
4. Debt técnica que se va a pagar

### 2.2 Crear primera HU

Copiar template y documentar lo que existe:

```bash
cp docs/tasks/TEMPLATE.md docs/tasks/HU-001-nombre.md
```

Llenar con:
- User story del cambio
- Escenarios Given/When/Then
- API endpoints afectados (si hay)
- DB changes (si hay)
- Dependencies con código legacy

### 2.3 Primer SDD cycle

```bash
/sdd-new HU-001-nombre --from-docs
```

El agent va a proponer, spec, design, tasks basándose en:
- Lo que escribiste en la HU
- El contexto de `AGENTS.md`
- El código existente (si el agent puede leerlo)

---

## Fase 3: Integración Gradual (Sprint 1 en adelante)

### Ciclo de 15 días adaptado

| Día | Acción |
|-----|--------|
| 1-2 | Planning: elegir HUs del backlog legacy |
| 3-11 | Execution: SDD para cada HU |
| 12-14 | Integration: verificar que todo funciona junto |
| 15 | Retro: qué aprendimos, actualizar docs |

### Regla del Legacy

**Por cada HU que toques, actualizar docs:**

| Si la HU toca... | Actualizar... |
|-----------------|---------------|
| API endpoint nuevo | `docs/api/endpoints.md` |
| DB schema nuevo | `docs/database/schema.md` |
| Decisión técnica | Crear ADR en `docs/architecture/adr/` |
| Nuevo módulo/feature | `docs/tasks/HU-XXX.md` |

**El código legacy se documenta SOLO cuando se toca.**

---

## Fase 4: Estructura Completa (Mes 2-3)

Después de 2-3 ciclos, vas a tener:

```
tu-proyecto/
├── docs/
│   ├── PRD.md                    ← Creado en fase 1
│   ├── architecture/
│   │   ├── rfc/                  ← Nuevos RFCs del equipo
│   │   └── adr/
│   │       ├── 000-legacy-state.md  ← Estado inicial
│   │       └── 001-*.md          ← Decisiones nuevas
│   ├── api/
│   │   └── endpoints.md         ← Endpoints documentados
│   ├── database/
│   │   └── schema.md            ← Schema documentado
│   └── tasks/
│       └── HU-*.md             ← HUs completadas
├── AGENTS.md                     ← Punto de entrada para agents
└── src/                          ← Tu código legacy
```

---

## Errores Comunes

| Error | Por qué | Solución |
|-------|---------|----------|
| Intentar documentar TODO antes de trabajar | Paralysis | Solo documentar lo que se toca |
| No crear AGENTS.md | Agent no sabe contexto | Crearlo Día 1 |
| Saltarse el RFC para decisiones legacy | Decisiones perdidas | Crear ADR retroactivo con lo que se sabe |
| HU muy grande | Legacy es enorme | Dividir en partes pequenas |
| No actualizar docs en el PR | Docs desactualizadas | Rule: same PR, same docs update |

---

## Checklist de Migración

- [ ] `docs/` creada con subcarpetas
- [ ] `AGENTS.md` creado en raíz
- [ ] `ADR-000-legacy-state.md` documentando lo que existe
- [ ] Primera HU creada para algo que se va a tocar
- [ ] `/sdd-init` corrido en el proyecto
- [ ] Primera HU passada por SDD completo
- [ ] Documentación actualizada en el mismo PR

---

## Recursos

- Template HU: `templates/template-user-story-sdd.md`
- Template ADR: `templates/ADR_template.md`
- Template RFC: `templates/RFC_template.md`
- Ejemplo AGENTS.md: `AGENTS.md-ejemplo.md`
- Ciclo de trabajo: `docs/flowdoc-ciclo.md`
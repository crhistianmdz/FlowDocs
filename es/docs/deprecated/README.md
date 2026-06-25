# Deprecated — FlowDocs Workflow Components

**Fecha**: 2026-06-24
**Razón**: FlowDocs v2.0 se enfoca puramente en estructura de documentación, no en workflow de entrega.

---

## Qué hay acá

Esta carpeta contiene los componentes del **workflow de entrega** que fueron removidos en v2.0. Se mantienen para referencia histórica en git.

### Workflow (es/docs/deprecated/workflow/)

| Archivo | Descripción |
|---------|-------------|
| `flowdoc-ciclo.md` | Ciclo de trabajo de 15 días (Planning → Execution → Integration → Retrospective) |
| `walkthrough-hu-login.md` | Ejemplo completo de una HU a través del ciclo SDD completo |
| `architecture-diagram.md` | Diagramas Mermaid del ciclo de trabajo y flujo SDD |

### Architecture Decisions (es/docs/deprecated/architecture/)

| Archivo | Descripción |
|---------|-------------|
| `009-sdd-subagent-context-pattern.md` | ADR: SDD Sub-agent Context Pattern (referencia para usuarios de SDD) |
| `003-ciclo-15-dias.md` | ADR: Ciclo de Trabajo de 15 Días |
| `004-feature-flags.md` | ADR: Feature Flags Obligatorios |
| `002-ciclo-15-dias.md` | RFC: Discusión Ciclo de Trabajo de 15 Días |
| `003-feature-flags.md` | RFC: Discusión Feature Flags |

---

## Por qué están deprecados

FlowDocs v2.0 ahora es **solo documentación**. El equipo decidió:

1. **La documentación es la fortaleza**: El sistema ADR/RFC/templates es lo que hace valioso a FlowDocs
2. **El workflow agrega complejidad**: El ciclo de 15 días, feature flags y ceremonias de entrega eran overhead para la mayoría de los casos de uso
3. **Los AI agents se benefician más de docs puras**: Cualquier herramienta AI puede leer `docs/` sin necesidad de entender planeación de sprints

---

## Si necesitás el workflow

Estos componentes son completamente funcionales y funcionaban bien para equipos que necesitaban:
- Estructura tipo sprint
- Feature flags para desarrollo paralelo
- Fases de integración/verificación

Volvé a copiarlos a tu proyecto si tu equipo necesita este nivel de coordinación.

---

## Ver también

- [FlowDocs README](../README.md) — Framework actual (solo documentación)
- [docs/PRD.md](../PRD.md) — Requisitos de Producto (reescrito)
- [docs/adoption-guide.md](../adoption-guide.md) — Niveles de adopción (simplificado)
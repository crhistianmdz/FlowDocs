# Índice de Architecture Decision Records

> **Auto-mantenido**: Al crear un nuevo ADR, agregalo a este índice.
>
> **Formato de ID**: `NNN-nombre-descriptivo.md` (ej: `001-mi-decision.md`) — los números nunca se reutilizan.
> **Estados**: `Draft` → `In Review` → `Accepted` (o `Deprecated` / `Superseded by ADR-NNN`).
> **¿Por qué hay huecos en la numeración?** Los ADRs deprecated mantienen su número como referencia histórica. Un hueco dice "algo estuvo aquí pero ya no está activo".

---

## Todos los ADRs

| ID | Título | Estado | Fecha |
|----|--------|--------|-------|
| ADR-001 | Persistencia Engram para Artefactos SDD | Accepted | 2026-05-29 |
| ADR-002 | docs/ como Fuente de Verdad | Accepted | 2026-05-29 |
| ADR-003 | Ciclo de Trabajo de 15 Días | Deprecated | 2026-05-29 |
| ADR-004 | Feature Flags Obligatorios | Deprecated | 2026-05-29 |
| ADR-005 | Organización de HUs por rangos de 100 | Accepted | 2026-05-29 |
| ADR-006 | Cuatro Arquitecturas Soportadas | Accepted | 2026-05-29 |
| ADR-007 | Estructura de Templates (docs/templates/ como source of truth) | Accepted | 2026-05-29 |
| ADR-008 | Nombre del Framework: FlowDoc | Accepted | 2026-05-29 |
| ADR-009 | SDD Sub-agent Context Pattern | Deprecated | 2026-05-29 |
| ADR-010 | Reservado — Nunca Creado (hueco documentado) | Deprecated | 2026-08-05 |
| ADR-011 | Plantillas de Skills Autocontenidos e Índice ADR | Accepted | 2026-07-18 |
| ADR-012 | Estructuras de Referencia Visual para Patrones de Arquitectura | Accepted | 2026-07-18 |
| ADR-013 | Arquitectura de Orquestador de Especialistas | Accepted | 2026-08-05 |
| ADR-014 | Ubicación del Registro de Sesión y Formato | Accepted | 2026-08-05 |
| ADR-015 | Protocolo de Comunicación entre Especialistas | Accepted | 2026-08-05 |
| ADR-016 | Reglas de Ejecución Paralela para Especialistas | Accepted | 2026-08-05 |

---

## Por Estado

### Accepted
- [ADR-001 — Persistencia Engram](./001-persistencia-engram.md)
- [ADR-002 — docs/ como Fuente de Verdad](./002-docs-source-of-truth.md)
- [ADR-005 — Organización de HUs](./005-organizacion-hu.md)
- [ADR-006 — Cuatro Arquitecturas](./006-cuatro-arquitecturas.md)
- [ADR-007 — Estructura de Templates](./007-estructura-templates.md)
- [ADR-008 — Nombre FlowDoc](./008-nombre-flowdoc.md)
- [ADR-011 — Plantillas de Skills Autocontenidos](./011-self-contained-skill-and-index.md)
- [ADR-012 — Estructuras de Referencia Visual](./012-estructuras-de-referencia-visual.md)
- [ADR-013 — Arquitectura de Orquestador](./013-arquitectura-orquestador-especialistas.md)
- [ADR-014 — Ubicación del Registro de Sesión](./014-ubicacion-del-registro-de-sesion.md)
- [ADR-015 — Protocolo de Comunicación](./015-protocolo-de-comunicacion-entre-especialistas.md)
- [ADR-016 — Reglas de Ejecución Paralela](./016-reglas-de-ejecucion-paralela.md)

### Deprecated
<!-- Los ADRs deprecated mantienen su número para referencia histórica. NO reutilices números. -->
- ADR-003 — Ciclo de Trabajo de 15 Días → `../deprecated/architecture/003-ciclo-15-dias.md`
- ADR-004 — Feature Flags Obligatorios → `../deprecated/architecture/004-feature-flags.md`
- ADR-009 — SDD Sub-agent Context Pattern → `../deprecated/architecture/009-sdd-subagent-context-pattern.md`
- ADR-010 — Reservado — Nunca Creado → `../deprecated/architecture/010-reservado-nunca-creado.md`

### En Revisión
<!-- Agregar ADRs actualmente en revisión aquí -->

### Borrador
<!-- Agregar ADRs en estado borrador aquí -->

---

## Definiciones de Estado

| Estado | Significado |
|--------|------------|
| Draft | Siendo escrito, aún no circuló |
| In Review | Bajo discusión (generalmente junto con un RFC) |
| Accepted | Decisión tomada y en efecto |
| Deprecated | Ya no está en efecto (mantenido por historia) |
| Superseded | Reemplazado por un ADR posterior (vincular) |

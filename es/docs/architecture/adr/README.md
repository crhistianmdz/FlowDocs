# Architecture Decision Records

**Registro permanente de decisiones técnicas.**

---

## Índice de ADRs

| # | Título | Estado | EN | ES |
|---|--------|--------|----|----|
| 001 | Persistencia Engram | Accepted | ✅ | ✅ |
| 002 | docs/ como Source of Truth | Accepted | ✅ | ✅ |
| 003 | Ciclo de Trabajo de 15 Días | **Deprecated** | ⚠️ `../deprecated/architecture/003-ciclo-15-dias.md` | ✅ |
| 004 | Feature Flags Obligatorios | **Deprecated** | ⚠️ `../deprecated/architecture/004-feature-flags.md` | ✅ |
| 005 | Organización de HUs | Accepted | ✅ | ✅ |
| 006 | Cuatro Arquitecturas | Accepted | ✅ | ✅ |
| 007 | Estructura de Templates | Accepted | ✅ | ✅ |
| 008 | Nombre FlowDoc | Accepted | ✅ | ✅ |
| 009 | SDD Sub-agent Context Pattern | **Deprecated** | ⚠️ `../deprecated/architecture/009-sdd-subagent-context-pattern.md` | ⚠️ `../../deprecated/architecture/009-sdd-subagent-context-pattern.md` |
| 012 | Estructuras de Referencia Visual para Arquitecturas | Accepted | ✅ `../../../docs/architecture/adr/012-visual-reference-structures.md` | ✅ `./012-estructuras-de-referencia-visual.md` |

---

## ¿Por qué hay huecos en la numeración?

Los números **nunca se reutilizan**. Cuando un ADR se deprecó, mantiene su número como referencia histórica. El hueco dice "algo estuvo aquí pero ya no está activo".

## Definiciones de Estado

| Estado | Significado |
|--------|-------------|
| **Accepted** | Decisión activa, en uso |
| **Deprecated** | Reemplazado por FlowDocs v2.0 (documentation-only) o una decisión posterior |

---

## Crear un ADR

1. Copiá `../../templates/architecture/ADR_template.md`
2. Usá el siguiente número disponible
3. El estado empieza como `Draft` → `In Review` → `Accepted`

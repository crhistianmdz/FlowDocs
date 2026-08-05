# Architecture Decision Records

**Registro permanente de decisiones técnicas.**

> **Nota**: Para el índice detallado con secciones por estado, ver [INDEX.md](./INDEX.md)

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
| 010 | Reservado — Nunca Creado | **Deprecated** | ✅ | ✅ |
| 011 | Plantillas de Skills Autocontenidos | Accepted | ✅ | ✅ |
| 012 | Estructuras de Referencia Visual para Arquitecturas | Accepted | ✅ | ✅ |
| 013 | Arquitectura de Orquestador de Especialistas | Accepted | ✅ | ✅ |
| 014 | Ubicación del Registro de Sesión | Accepted | ✅ | ✅ |
| 015 | Protocolo de Comunicación entre Especialistas | Accepted | ✅ | ✅ |
| 016 | Reglas de Ejecución Paralela para Especialistas | Accepted | ✅ | ✅ |

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

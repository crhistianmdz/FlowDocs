# RFC 006: Decision Gates en Skills FlowDoc

> **Status**: Accepted
> **Author(s)**: Kaito
> **Date**: 2026-08-25
> **Project**: FlowDocs

---

## 1. Summary

Propuesta de implementar **Decision Gates** (tablas de decisión) en las 9 skills del framework FlowDoc, siguiendo el estándar LLM-first skill structure. Los Decision Gates codifican situaciones específicas y sus acciones correspondientes, haciendo el comportamiento de cada skill predecible y auditable.

---

## 2. Context

### ¿Qué problema resuelve?

Las skills actuales tienen comportamiento implícito ante situaciones ambiguas. Por ejemplo:
- `flowdoc-prd`: ¿sobrescribir o actualizar cuando `docs/PRD.md` ya existe?
- `flowdoc-rfc`: ¿qué hacer cuando un RFC está "In Review" por más de 2 semanas?
- `flowdoc-api`: ¿cómo proceder cuando no se encuentran rutas?

### ¿Por qué decidir esto ahora?

Durante la auditoría de portability (2026-08-25), se identificó que 7 de 9 skills carecen de Decision Gates explícitos. Sin ellos:
- El comportamiento ante situaciones límite es impredecible
- No hay forma auditable de saber qué hizo cada skill
- La consistencia entre skills es accidental, no diseñada

### Alternativas consideradas

| Alternativa | Descripción | Desventaja |
|-------------|-------------|------------|
| **A) No implementar** | Mantener comportamiento implícito | Impredecibilidad, difícil auditar |
| **B) Decision Gates informales** | Documentar en comentarios o reglas sueltas | No son accionables por el agent |
| **C) Decision Gates formales** (esta propuesta) | Tablas explícitas en cada skill | Requiere decisión del author para cada situación |
| **D) Hard Rules únicamente** | Solo errores hard-coded | Muy rígido, no permite flexibilidad |

---

## 3. Technical Decision

### 3.1 Estructura de Decision Gate

| Campo | Descripción |
|-------|-------------|
| `Situación` | Condición que dispara el gate |
| `Acción` | Comportamiento default |
| `Tipo` | `error` (bloquea) / `warning` (continúa con alerta) / `info` (solo log) |

### 3.2 Skills y Situaciones Propuestas

#### flowdoc-discover

| Situación | Acción propuesta | Tipo |
|-----------|------------------|------|
| Arquitectura unclear desde evidencia | Ask user | warning |
| Proyecto vacío/no-code | Partial report + flag | info |
| No es repositorio git | Proceed anyway | info |
| Invocado por especialista | Scope investigación a lo necesario | info |
| FlowDoc no encontrado | Report "not adopted" + recomendaciones | warning |

#### flowdoc-prd

| Situación | Acción propuesta | Tipo |
|-----------|------------------|------|
| `docs/PRD.md` existe y no vacío | Update mode | info |
| `docs/PRD.md` existe pero stub | Create mode (sobrescribir) | warning |
| `docs/PRD.md` no existe | Create mode | info |
| Template faltante | Fallback o crear | warning |

#### flowdoc-rfc

| Situación | Acción propuesta | Tipo |
|-----------|------------------|------|
| RFC# N ya existe | Update o crear nuevo # | warning |
| Status "In Review" > 2 semanas | Warning al orchestrator | warning |
| ADR ya existe para misma decisión | Warn duplicate | warning |

#### flowdoc-adr

| Situación | Acción propuesta | Tipo |
|-----------|------------------|------|
| ADR ya existe para misma decisión | Update o deprecated check | warning |
| `INDEX.md` no existe | Crearlo | info |
| ADR# ya usado | Buscar siguiente número libre | info |

#### flowdoc-api

| Situación | Acción propuesta | Tipo |
|-----------|------------------|------|
| Template faltante | Usar formato embebido en skill | warning |
| Rutas no encontradas | Report honesto | info |
| Handler ambiguo | Placeholder o skip | warning |

#### flowdoc-db

| Situación | Acción propuesta | Tipo |
|-----------|------------------|------|
| Schema no encontrado | Ask user | error |
| Múltiples databases | Secciones separadas | info |
| Template faltante | Usar patrón embebido | warning |

#### flowdoc-hu

| Situación | Acción propuesta | Tipo |
|-----------|------------------|------|
| HU existe | Pre-dev vs Post-dev | info |
| Phase no especificado | Ask | warning |
| Decisions técnicas detectadas | Report ADR need | info |

#### flowdoc-review

| Situación | Acción propuesta | Tipo |
|-----------|------------------|------|
| Template faltante | Error + skip | error |
| `issues[]` vacío | Summary sin issues | info |
| Session register no existe | Crear minimal | info |

---

## 4. Infraestructura

*N/A — Esta decisión es de documentación, no de infraestructura.*

---

## 5. Security Considerations

*N/A*

---

## 6. Costs and Resources

*N/A*

---

## 7. Risks

| Risk | Impact | Mitigation |
|------|--------|-----------|
| Author no valida situaciones | Medium | Implementar solo después de approval |
| Decision Gates rígidos limitan flexibilidad | Medium | Usar `warning` donde haya ambigüedad |
| Sobredocumentación (gates para todo) | Low | Solo situaciones reales, no invented scenarios |
| Skills existentes rompen con nuevos gates | Low | Probar en isolation antes de merge |

---

## 8. Approval Status

| Role | Person | Status | Date |
|------|--------|--------|------|
| Tech Lead | Kaito | Approved | 2026-08-25 |
| Author (flowdoc-assist) | - | Pending | - |

---

## 9. Change History

| Date | Change | Author |
|------|--------|--------|
| 2026-08-25 | Initial version | Kaito |

---

> **Once approved → create an ADR** at `docs/architecture/adr/ADR-NNN.md`
> using `templates/ADR_template.md`. The ADR is the permanent record of the decision.
> The RFC remains as history of the discussion.

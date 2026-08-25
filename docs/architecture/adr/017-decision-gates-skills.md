# ADR-017: Decision Gates en Skills FlowDoc

- **Date**: 2026-08-25
- **Related RFC**: [RFC-006 — Decision Gates en Skills FlowDoc](../rfc/006-decision-gates-skills.md)
- **Status**: Accepted

---

## Context

Las skills del framework FlowDoc carecen de Decision Gates explícitos. Esto genera comportamiento implícito ante situaciones ambiguas (ej: ¿sobrescribir o actualizar `docs/PRD.md` si ya existe?). Sin gates documentados, el comportamiento es impredecible y difícil de auditar. Durante la auditoría de portability (2026-08-25) se identificó que 7 de 9 skills no tenían Decision Gates formales.

---

## Decision

Se implementan **Decision Gates** como sección estándar en todas las skills del framework, siguiendo el formato de tabla:

| Campo | Descripción |
|-------|-------------|
| `Situación` | Condición que dispara el gate |
| `Acción` | Comportamiento default |
| `Tipo` | `error` (bloquea) / `warning` (continúa con alerta) / `info` (solo log) |

Cada skill define sus propios gates basados en sus situaciones reales. Los gates se encuentran en la documentación de auditoría (`docs/observaciones/skill-decision-gates-audit.md`) y serán integrados skill por skill.

---

## Consequences

- **Positive**: Comportamiento predecible y auditable; transiciones de estado claras; autor puede validar gates antes de implementación
- **Negative**: Requiere actualización skill por skill; posible rigidez si se define demasiado
- **Neutral**: Decision Gates conviven con Hard Rules y Output Contract existentes
- **Accepted technical debt**: Los gates se implementan gradualmente; algunos pueden requerir ajustes post-implementación

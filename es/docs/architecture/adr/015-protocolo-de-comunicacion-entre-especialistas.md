# ADR-015: Protocolo de Comunicación entre Especialistas

- **Fecha**: 2026-08-05
- **RFC Relacionado**: [RFC-005](./005-specialist-architecture.md)
- **Estado**: Aceptado

---

## Contexto

Los especialistas necesitan coordinarse sin crear acoplamiento estrecho. Un especialista puede detectar que otro documento necesita actualizarse (por ejemplo, cambio de API afecta al PRD), pero no debe modificar documentos fuera de su alcance.

---

## Decisión

Tres reglas de comunicación:

1. **Orquestador → Especialista**: Pasa contexto base (rutas, documentos existentes, referencias de plantillas) vía prompt
2. **Especialista → Orquestador**: Escribe resultados en `docs/`, actualiza el registro, reporta actualizaciones cruzadas pendientes
3. **Especialista ↔ Especialista**: **Sin comunicación directa**. Si un especialista necesita investigación, invoca `flowdoc-discover`. Si detecta impacto en otro documento, reporta al orquestador

Caso especial: **El especialista de API NUNCA toca el PRD**. Si cambios de API afectan al PRD, el especialista de API reporta al orquestador, quien rutea a `flowdoc-prd`.

---

## Consecuencias

- **Positivo**: Propiedad clara; sin conflictos accidentales de documentos; fácil rastrear linaje de actualizaciones
- **Negativo**: Salto extra para actualizaciones cruzadas (especialista → orquestador → otro especialista)
- **Neutral**: Sigue el principio de responsabilidad única

---

## Ver También

- [RFC-005 — Protocolo de Comunicación](../rfc/005-specialist-architecture.md#6-communication-protocol)

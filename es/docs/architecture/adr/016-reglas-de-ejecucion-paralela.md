# ADR-016: Reglas de Ejecución Paralela para Especialistas

- **Fecha**: 2026-08-05
- **RFC Relacionado**: [RFC-005](./005-specialist-architecture.md)
- **Estado**: Aceptado

---

## Contexto

Algunos especialistas podrían ejecutarse teóricamente en paralelo para ahorrar tiempo, pero ejecutar todos en paralelo arriesga conflictos de documentos y estado inconsistente. Se necesitan reglas para definir cuándo la paralelización es segura.

---

## Decisión

**Secuencial por defecto**. Todos los especialistas se ejecutan uno tras otro.

**Paralelo permitido solo para el especialista ADR** cuando:

1. Todas las decisiones técnicas ya están identificadas por PRD/RFC
2. Los ADR no dependen entre sí
3. El orquestador realizó un checkpoint antes de lanzar tareas en paralelo

El orquestador actúa como coordinador y es responsable de detectar cuándo la ejecución paralela es segura.

---

## Consecuencias

- **Positivo**: Sin conflictos de documentos; orden de ejecución predecible; fácil de depurar
- **Negativo**: Más lento que la ejecución paralela potencial
- **Neutral**: Paralelismo reservado para casos probados como seguros (múltiples ADR independientes)

---

## Ver También

- [RFC-005 — Reglas de Ejecución Paralela](../rfc/005-specialist-architecture.md#7-parallel-execution-rules)

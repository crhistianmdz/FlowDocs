# ADR-013: Arquitectura del Orquestador de Especialistas

- **Fecha**: 2026-08-05
- **RFC Relacionado**: [RFC-005](./005-specialist-architecture.md)
- **Estado**: Aceptado

---

## Contexto

FlowDoc necesitaba una forma de manejar la generación de documentación que fuera modular, testeable y permitiera tanto la orquestación completa como la invocación directa de especialistas. El skill monolithico `flowdoc-assist` tenía limitaciones en pruebas, paralelización y flexibilidad del usuario.

---

## Decisión

Dividir `flowdoc-assist` en un **orquestador** que coordina **skills especializados**, cada uno experto en su dominio documental.

```
flowdoc-assist (ORQUESTADOR)
├── flowdoc-discover   (investigación profunda)
├── flowdoc-prd       (PRD)
├── flowdoc-rfc       (RFC)
├── flowdoc-adr       (ADR)
├── flowdoc-api       (API)
├── flowdoc-db        (DB)
├── flowdoc-hu        (HU + post-dev)
└── flowdoc-review    (validación)
```

Cada especialista es **autocontenido e invocable de forma independiente**. El orquestador mantiene el diálogo, detecta las necesidades del proyecto y coordina la ejecución.

---

## Consecuencias

- **Positivo**: Especialistas testeables de forma independiente; usuarios pueden invocar uno directamente; ejecución paralela posible para ADR
- **Negativo**: Más archivos a mantener; complejidad de orquestación
- **Neutral**: Mismo resultado final, diferente camino

---

## Ver También

- [RFC-005 — Arquitectura de Especialistas](../rfc/005-specialist-architecture.md)
- ADR-011: Plantillas de Skills Autocontenidos

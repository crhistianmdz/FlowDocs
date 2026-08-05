# ADR-014: Ubicación y Formato del Registro de Sesión

- **Fecha**: 2026-08-05
- **RFC Relacionado**: [RFC-005](./005-specialist-architecture.md)
- **Estado**: Aceptado

---

## Contexto

Cada sesión de especialista genera metadatos sobre lo realizado. Estos datos necesitan persistirse para auditoría, referencia de rollback y coordinación entre especialistas. El registro no debe contaminar el historial de git pero debe sobrevivir a reinicios de herramientas.

---

## Decisión

Los registros de sesión residen en `docs/.flowdoc/sessions/` con nomenclatura basada en marcas de tiempo:

```
docs/.flowdoc/
└── sessions/
    ├── 2026-08-05_1430_register.json
    └── 2026-08-05_1600_register.json
```

El directorio `docs/.flowdoc/` está **excluido de git** (`.gitignore`).

El registro contiene: metadatos de sesión, especialistas invocados, documentos creados/actualizados/cerrados, actualizaciones pendientes, problemas encontrados y estadísticas resumidas.

---

## Consecuencias

- **Positivo**: Traza de auditoría completa por sesión; fácil encontrar sesión por marca de tiempo; solo local (no se hace push)
- **Negativo**: Sin compartición de datos de sesión entre equipos
- **Neutral**: El registro es generado por la herramienta, legible por humanos pero no destinado a edición manual

---

## Ver También

- [RFC-005 — Esquema del Registro](../rfc/005-specialist-architecture.md#5-session-register)

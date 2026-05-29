# ADR-002: docs/ como Source of Truth

**Fecha**: 2026-05-29  
**RFC relacionado**: [RFC-001: Estructura de Documentación](./rfc/001-estructura-docs.md)  
**Estado**: Aceptado

---

## Contexto

En equipos distribuidos, la documentación suele estar dispersa en Drive, Notion, Slack, READMEs en distintas carpetas. Esto causa: imposibilidad de encontrar decisiones pasadas, decisiones tomadas sin registro, y onboarding lento. Necesitábamos un lugar único y consistente para toda la documentación del proyecto.

---

## Decisión

Establecemos `docs/` como el único lugar donde vive la documentación, con la siguiente estructura:

```
docs/
├── PRD.md                       ← Product Requirements
├── architecture/
│   ├── rfc/                     ← Propuestas en discusión
│   └── adr/                     ← Decisiones aprobadas (inmutable)
├── api/                         ← Contratos de API
├── database/                    ← Schema de BD
└── tasks/                       ← Historias de usuario
```

Cada tipo de documento tiene un propósito claro y un momento definido para crearse. La regla fundamental es: **"Si no hay ADR, la decisión no existe."**

---

## Consecuencias

### ✅ Positivo

- Un solo lugar donde buscar documentación
- Decisiones técnicas siempre tienen tracking
- Onboarding más rápido (todo está en docs/)
- Git-tracked con historial de cambios

### ❌ Negativo

- Overhead por decisión técnica (30 min extra para RFC + ADR)
- Requiere disciplina del equipo para mantener docs actualizados
- Puede haber resistencia inicial ("es mucho papeleo")

### 🔄 Neutral

- Documentos "se vuelven obsoletos" si no se mantienen — requiere proceso
- Equipos pequeños pueden sentir overhead — se puede adaptar

---

## Decisiones Relacionadas

| Decisión | Ubicación |
|----------|-----------|
| Persistencia de artifacts | ADR-001 |
| Ciclo de trabajo | ADR-003 |
| Feature flags | ADR-004 |
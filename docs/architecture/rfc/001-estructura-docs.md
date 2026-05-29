# RFC-001: Estructura de Documentación — docs/ como Source of Truth

- **Estado**: Aprobado
- **Autor(es)**: @kaito
- **Fecha**: 2026-05-29
- **Proyecto**: Framework de Trabajo para Equipos Distribuidos

---

## 1. Resumen

Establecer `docs/` como el único lugar donde vive la documentación del proyecto, con subcarpetas especializadas (PRD, RFC, ADR, HU, API, DB). El objetivo es que cualquier agente de IA o humano pueda encontrar la información que necesita sin buscar en múltiples lugares.

---

## 2. Contexto

- **Problema técnico**: En equipos distribuidos, la documentación suele estar dispersa: en Drive, Notion, Slack, READMEs en distintas carpetas, etc. Esto causa:
  - Imposibilidad de encontrar decisiones pasadas
  - Decisiones tomadas sin registro ( "¿por qué se hizo así?" → "no sé")
  - Onboarding lento para nuevos miembros
- **Por qué es necesario decidir esto ahora**: El framework busca ser adoptado por equipos que usan OpenCode y Antigravity. Sin una estructura clara, cada equipo documenta de forma distinta.
- **Alternativas consideradas**:
  1. **Notion/Confluence como central**: Require licencias, no es git-tracked, agents no lo leen bien
  2. **Solo READMEs en código**: Se vuelve largo y difícil de navegar
  3. **Google Drive compartido**: Sin control de versiones, difícil de rastrear

---

## 3. Decisión Técnica

### 3.1 Estructura Elegida

```
docs/
├── PRD.md                       ← Product Requirements (qué construye el equipo)
├── architecture/
│   ├── rfc/                     ← Request for Comments (discusión abierta)
│   │   └── NNN-nombre.md
│   └── adr/                     ← Architecture Decision Records (decisión final)
│       └── NNN-nombre.md
├── api/
│   ├── endpoints.md             ← Contratos de API
│   └── modelos.md               ← DTOs y tipos de datos
├── database/
│   └── schema.md                ← Esquema de base de datos
└── tasks/
    └── HU-*.md                  ← Historias de usuario
```

### 3.2 Responsabilidad de Cada Documento

| Documento | Propósito | Cuándo se crea | Inmutable |
|-----------|-----------|----------------|-----------|
| **PRD** | Qué se construye y por qué | Inicio del proyecto | No (evolución) |
| **RFC** | Propuesta técnica en discusión | Antes de decisiones grandes | Se convierte en ADR o se descarta |
| **ADR** | Decisión técnica aceptada | Después de RFC aprobado | Sí (se marca obsoleto si cambia) |
| **HU** | Feature a implementar | Planning de cada ciclo | No (se actualiza con cambios) |
| **API docs** | Contratos de endpoints y modelos | Con cada cambio de API | No |

### 3.3 Regla Fundamental

**"Si no hay ADR, la decisión no existe."**

Cualquier decisión técnica significativa debe pasar por el ciclo: Discusión (RFC) → Aprobación (ADR). Las decisiones informales en chat no se consideran decisiones documentadas.

---

## 4. Infraestructura

No aplica (documentación, no código).

---

## 5. Consideraciones de Seguridad

- **Git-tracked**: Toda la documentación está en el repo de Git, con historial de cambios
- **Code review**: Los cambios en `docs/` pasan por PR, igual que código
- **Branch protection**: `main` protegido para evitar sobreescritura sin revisión

---

## 6. Costos y Recursos

- **Tiempo de setup inicial**: ~1 hora (crear carpetas y templates)
- **Tiempo de mantenimiento**: ~15 min por PR que incluya docs actualizados
- **Overhead por decisión**: ~30 min para escribir RFC + ADR

---

## 7. Riesgos

| Riesgo | Impacto | Mitigación |
|--------|---------|------------|
| Documentación desactualizada | Medio | Regla: docs se actualizan en el mismo PR que el código |
| Team no sigue la estructura | Medio | Onboarding incluye training, DoD incluye check de docs |
| ADRs se duplican | Bajo | ADR tiene número correlativo, revisar antes de crear nuevo |

---

## 8. Estado de Aprobación

| Rol | Persona | Estado | Fecha |
|-----|---------|--------|-------|
| Tech Lead | @kaito | Aprobado | 2026-05-29 |

---

## 9. Historial de Cambios

| Fecha | Cambio | Autor |
|-------|--------|-------|
| 2026-05-29 | Versión inicial | @kaito |

---

## 10. Documentos Relacionados

- **ADR-001**: Persistencia con Engram para SDD Artifacts
- **RFC-002**: Ciclo de trabajo de 15 días
- **RFC-003**: Feature Flags obligatorios
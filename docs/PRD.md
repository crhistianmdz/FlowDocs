# PRD: Framework de Trabajo para Equipos Distribuidos

**Versión**: 1.0  
**Última actualización**: 2026-05-29  
**Owner**: @Crhistian

---

## 1. Resumen del Producto

**Framework de Trabajo** es una plantilla de documentación + flujo de trabajo SDD diseñada para que equipos de 4+ personas en distintos países puedan coordinar trabajo de desarrollo de software de forma **asíncrona, consistente y documentada**.

### Problema que resuelve

- Equipos distribuidos sin estructura clara de documentación
- Cada miembro trabaja de forma distinta según su herramienta (OpenCode vs Antigravity)
- Knowledge loss cuando alguien se va o está offline
- Onboarding lento para nuevos miembros

### Solución

Un framework unificado donde **la documentación es el source of truth**, independientemente de la herramienta de IA que se use.

---

## 2. Usuarios Objetivo

| Usuario | Necesidad |
|---------|-----------|
| **Devs en equipos distribuidos** | Saber exactamente dónde está cada cosa, cómo trabajar, qué hacer |
| **Tech Leads** | Controlar el proceso, mantener docs actualizados, onboarding rápido |
| **Newcomers** | Entender el proyecto en 4 días con checklist estructurado |

### Requisitos del equipo

- 4+ personas en distintas zonas horarias
- Usan GitHub + Discord (o similar async channel)
- Trabajan con SDD (Spec-Driven Development)

---

## 3. Alcance del Framework

### ✅ Dentro del alcance

- Estructura de `docs/` con PRD, RFC, ADR, HUs, API contracts
- Ciclo de trabajo de 15 días (Planning → Execution → Integration → Retrospective)
- Workflow SDD: proposal → spec → design → tasks → apply → verify → archive
- Feature flags para deployments graduales
- Branching strategy (dev → staging → main)
- Onboarding checklist de 4 días
- Templates para cada tipo de documento

### ❌ Fuera del alcance

- Código de aplicación (es solo documentación)
- Infraestructura específica (Docker, K8s, etc.)
- Herramientas de comunicación (Discord, GitHub son externas)
- Test runners específicos (cada proyecto elige los suyos)

---

## 4. Goals (Metas)

| Meta | Métrica | Estado |
|------|---------|--------|
| Documentación accesible para AI agents | Cualquier agent puede trabajar con SDD desde `docs/` | ✅ Implementado |
| Consistencia entre herramientas | OpenCode y Antigravity usan mismo flujo | ✅ Implementado |
| Onboarding en 4 días | Newcomer funcional en 4 días | 📋 Por validar |
| Docs como source of truth | Sin ADR = decisión no existe | ✅ Implementado |
| Feature flags para trabajo paralelo | Sin bloqueos entre devs | ✅ Implementado |

---

## 5. Estructura de Documentación

```
docs/
├── PRD.md                       ← Este archivo
├── architecture/
│   ├── rfc/                     ← Propuestas técnicas (discusión)
│   └── adr/                     ← Decisiones registradas (inmutable)
├── api/
│   ├── endpoints.md             ← Contratos de API
│   └── modelos.md               ← DTOs y contratos de datos
├── database/
│   └── schema.md                ← Esquema de BD (si aplica)
└── tasks/
    └── HU-*.md                  ← Historias de usuario
```

---

## 6. Artefactos Clave

### SDD Artifacts (openspec/)

Los artifacts SDD se guardan en `openspec/changes/{change-name}/`:
- `proposal.md` — Intención, alcance, enfoque
- `spec.md` — Requisitos y escenarios
- `design.md` — Decisiones técnicas
- `tasks.md` — Checklist de implementación

### AGENTS.md

Archivo en la raíz de cada proyecto. Es el **punto de entrada** para que cualquier agent de IA entienda:
- Stack tecnológico
- Estructura del proyecto
- Convenciones del equipo
- Workflow SDD

---

## 7. Modelo de Madurez

El framework evoluciona en niveles:

| Nivel | Descripción | Estado |
|-------|-------------|--------|
| **L1: Estructura** | Docs en `docs/`, AGENTS.md creado | ✅ |
| **L2: workflow** | Ciclo de 15 días funcionando | ✅ |
| **L3: SDD completo** | Todas las fases SDD se usan | 📋 |
| **L4: Medición** | Métricas de calidad (coverage, DORA) | 📋 |

---

## 8. Anti-Patrones a Evitar

| Anti-Patrón | Por qué es malo | Alternativa |
|-------------|-----------------|-------------|
| Decisiones sin ADR | Nadie sabe por qué se hizo así | Crear ADR antes de implementar |
| Docs desactualizados | Confunden más que ayudar | Docs se actualizan en el mismo PR |
|feature sin feature flag | Rompe el trabajo de otros | Flag en `false` hasta integración |
| Reuniones sin agenda | Tiempo perdido | Async primero, reunión solo si necesario |
| Self-merge | Sin revisión | Otro debe aprobar el PR |

---

## 9. Roadmap

### Fase 1: Foundation ✅
- [x] Estructura de docs
- [x] Templates SDD
- [x] Ciclo de 15 días
- [x] Onboarding checklist
- [x] Governance de agents

### Fase 2: Validación (próximo ciclo)
- [ ] Usar framework en proyecto real
- [ ] Medir tiempo de onboarding
- [ ] Ajustar templates según feedback

### Fase 3: Extensión
- [ ] Guía de migración para legacy
- [ ] Templates para microservices
- [ ] Integración con GitHub Projects

---

## 10. Referencias

- SDD Spec: https://github.com/Gentleman-Programming/gentle-ai
- OpenCode Docs: https://opencode.ai/docs/es
- Google Antigravity: https://antigravity.google/
- Templates: `docs/templates/`
- Arquitecturas: `/architectures/`
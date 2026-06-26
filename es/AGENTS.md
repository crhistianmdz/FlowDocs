# AGENTS.md — FlowDoc

**Framework**: FlowDoc — Documentación que fluye con el trabajo
**Ecosistema**: FlowForge (tool) + FlowDoc (framework)
**Stack**: Documentación (sin código), SDD workflow, Engram/openspec para artifacts

---

## Stack y Tecnologías

### Framework Principal
- **Nombre**: FlowDoc
- **Metodología**: SDD (Spec-Driven Development)
- **Artifact Store**: Engram (por defecto), openspec (para equipos)
- **Formato**: Documentación Markdown
- **Arquitectura**: Adaptable (monolítico, microservicios, monorepo, serverless, o híbrida)

### Compatibilidad con Herramientas de IA

El workflow SDD es **independiente de la herramienta**. Cualquier agent que pueda leer y escribir archivos markdown funciona:

| Herramienta | Compatibilidad | Notas |
|-------------|---------------|-------|
| OpenCode | ✅ | SDD commands nativos |
| Antigravity | ✅ | SDD commands nativos |
| ClaudeCode | ✅ | Compatible con docs/ |
| Otros agents | ✅ | Leen `docs/` como source of truth |

**Lo importante**: `docs/` es el source of truth. El agent que uses es secundario.

### Herramientas de Equipo
- **Control de versiones**: Git + GitHub
- **Comunicación**: Discord (async-first)
- **Issues**: GitHub Issues

---

## Estructura del Proyecto

```
newPropuestaFrameworkTrabajo/
├── docs/                          ← DOCUMENTACIÓN (source of truth)
│   ├── PRD.md                     ← Product Requirements
│   ├── architecture/
│   │   ├── rfc/                   ← Request for Comments (discusión)
│   │   └── adr/                   ← Architecture Decision Records (inmutable)
│   ├── api/
│   │   ├── endpoints.md           ← Contratos de API
│   │   └── modelos.md            ← DTOs
│   ├── database/
│   │   └── schema.md             ← Esquema de BD
│   └── tasks/
│       └── HU-*.md               ← Historias de usuario
├── templates/                     ← ⚠️ DEPRECATED, usar docs/templates/
├── reference/                 ← Guías por tipo de arquitectura
│   ├── monolitico/
│   ├── microservicios/
│   ├── monorepo/
│   └── serverless/
├── scripts/                       ← Automatizaciones
│   ├── hu-to-issues.sh
│   └── hu-to-issues.ps1
├── .context/                      ← Config de contexto para sub-agents SDD (ver ADR-009)
│   └── flowDocs.config.json
├── docs/flowdoc-ciclo.md         ← Ciclo de trabajo
├── ONBOARDING.md                  ← Checklist para nuevos miembros
├── QUICKSTART.md                  ← Guía rápida
├── adoption-guide.md              ← Guía de adopción por niveles
├── FAQ.md                        ← Preguntas frecuentes
└── README.md                      ← Este archivo
```

---

## Fuentes de Verdad

### Documentación Core
- **PRD**: `docs/PRD.md`
- **Arquitectura decisions**: `docs/architecture/adr/`
- **RFC (discusión)**: `docs/architecture/rfc/`
- **User stories**: `docs/tasks/`
- **API contracts**: `docs/api/`

### Convenciones
- **Ciclo de trabajo**: `docs/flowdoc-ciclo.md`
- **Unificación de equipos**: [RFC-004 (deprecated)](docs/architecture/rfc/004-propuesta-unificada-equipo-deprecada.md) — Ver AGENTS.md para la versión actual
- **Onboarding**: `ONBOARDING.md`

---

## Convenciones del Framework

### Convenciones de Archivos

| Tipo | Formato | Ubicación |
|------|---------|-----------|
| RFC | `NNN-nombre-descriptivo.md` | `docs/architecture/rfc/` |
| ADR | `NNN-nombre-descriptivo.md` | `docs/architecture/adr/` |
| HU | `HU-NNN-nombre.md` | `docs/tasks/` |
| Template | varies by type | `docs/templates/` |

### Convenciones de Commits (Conventional Commits)

```
feat: add reservation system with date picker
fix: resolve login timeout on mobile
refactor: extract payment logic to domain
docs: update API endpoint documentation
chore: update dependencies
```

### Branch Naming

```
feature/add-reservation-system
fix/login-timeout
refactor/order-service
docs/api-endpoints
hotfix/critical-security-patch
```

---

## Workflow SDD

### Comandos

| Comando | Qué hace |
|---------|----------|
| `/sdd-init` | Inicializar proyecto SDD, detectar stack |
| `/sdd-new <nombre>` | Crear nuevo change (explore + propose) |
| `/sdd-new <nombre> --from-docs` | Crear desde HU pre-escrita en `docs/tasks/` |
| `/sdd-continue <nombre>` | Continuar siguiente fase |
| `/sdd-apply <nombre>` | Implementar tareas |
| `/sdd-verify <nombre>` | Validar contra specs |
| `/sdd-archive <nombre>` | Archivar change completado |

### Ciclo SDD

```
proposal → spec → design → tasks → apply → verify → archive
    ↑           ↑        ↑       ↑        ↑        ↑
 explore    (opcional según complejidad del change)
```

### Artifact Store Modes

| Mode | Uso | Compartible |
|------|-----|-------------|
| `engram` | Trabajo individual | ❌ |
| `openspec` | Equipos, git-tracked | ✅ |
| `hybrid` | Individual + recovery | ✅ |

- **`.context/flowDocs.config.json`**: Configuración a nivel proyecto para el SDD Sub-agent Context Pattern (ver ADR-009). Guarda preferencias del usuario, sugerencias descartadas, y configuraciones opt-in. La config local de desarrollo en `.context/flowDocs.config.local.json` tiene precedencia.

---

## Reglas para Agents

**Este agent NO:**
- Hace commits — eso lo hace el humano
- Modifica `AGENTS.md` sin aprobación humana
- Modifica `docs/` o `openspec/` sin aprobación humana
- Mergea a `main` ni `staging`

**Este agent SÍ:**
- Genera código en feature branches
- Propone cambios, pero siempre con revisión humana
- Lee de `docs/` para entender contexto

---

## Testing en Este Proyecto

Este es un proyecto de **documentación**. No hay tests automatizados para el framework mismo.

Para proyectos que USAN el framework:
- Tests según el stack elegido (vitest, jest, xUnit, etc.)
- Coverage mínimo: >80%
- Cada tarea de código incluye su test asociado

---

##	Errores Comunes

| Error | Solución |
|-------|----------|
| SDD no lee las HUs | Usar `--from-docs` en el comando |
| Engram no guarda contexto | Correr `/sdd-init` al inicio de cada sesión |
| Conflictos en docs/ | Comunicar cambios antes de editar |
| HU muy grande | Dividir en HUs de 1-3 días |

Más soluciones en: `docs/troubleshooting.md`

---

## Recursos

| Recurso | Link |
|---------|------|
| SDD Spec | https://github.com/Gentleman-Programming/gentle-ai |
| OpenCode Docs | https://opencode.ai/docs/es |
| Google Antigravity | https://antigravity.google/ |
| ClaudeCode Docs | https://docs.claude.ai |
| Engram (memoria persistente) | https://github.com/antigravity-dev/engram |

---

## Guías de Apoyo

| Guía | Propósito |
|------|-----------|
| `docs/adoption-guide.md` | Cómo adoptar el framework en niveles |
| `docs/FAQ.md` | Preguntas frecuentes |
| `docs/troubleshooting.md` | Errores comunes y soluciones |
| `docs/legacy-migration.md` | Adaptar proyecto existente a SDD |

---

**Última actualización**: 2026-05-29
**Maintained by**: @Crhistian

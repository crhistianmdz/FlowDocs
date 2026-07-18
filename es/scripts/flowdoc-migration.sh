#!/bin/bash
# Script de Migración FlowDoc
# Uso: ./flowdoc-migration.sh
# Crea la estructura y templates de FlowDoc en el directorio actual.
# Para proyectos legacy con SDD existente que quieren adoptar FlowDoc.

set -e

echo "🚀 Script de Migración FlowDoc"
echo "============================"
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sin Color

# Verificar si estamos en un repo git (opcional pero recomendado)
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}⚠️  Advertencia: No es un repositorio git. Considera correr en uno.${NC}"
    echo ""
fi

echo "📁 Creando estructura FlowDoc..."

# Crear directorios principales
mkdir -p docs/templates/user-stories
mkdir -p docs/templates/bug-fixes
mkdir -p docs/templates/refactors
mkdir -p docs/templates/architecture
mkdir -p docs/templates/database
mkdir -p docs/templates/api
mkdir -p docs/templates/PRD
mkdir -p docs/architecture/adr
mkdir -p docs/architecture/rfc
mkdir -p docs/tasks/HU-001-HU-099
mkdir -p docs/incidents
mkdir -p scripts

echo "✅ Estructura de directorios creada"
echo ""

# ============================================
# TEMPLATES
# ============================================

echo "📝 Creando templates..."

# Template: User Story SDD-Ready
cat > docs/templates/user-stories/template-user-story-detailed.md << 'TEMPLATE_EOF'
# HU-XXX: [Feature Name]

**Status**: 🟡 In Progress
**Owner**: @username
**Created**: YYYY-MM-DD
**Priority**: Must | Should | Could | Wont

---

## 🎯 Intent

[Brief description of what this feature does and why it matters.]

---

## 📋 Scope

### In Scope
- [What this HU includes]

### Out of Scope
- [What this HU explicitly does NOT include]

---

## ✅ Requirements

### MUST (obligatorio)
- [Hard requirement]

### SHOULD (altamente deseable)
- [Important but not critical]

### MAY (nice to have)
- [Enhancements if time permits]

---

## 🧪 Scenarios

### Happy Path

**GIVEN** [precondition]
**WHEN** [action]
**THEN** [expected result]

### Edge Cases

**GIVEN** [precondition]
**WHEN** [action]
**THEN** [expected result]

### Error Cases

**GIVEN** [precondition]
**WHEN** [action]
**THEN** [error handling]

---

## 🧪 Verification

🧪 Ref: [How to verify this HU works - test cases, manual steps]

---

## 📦 Affected Areas

- `src/`
- `docs/api/`

---

## ⚠️ Risks

| Risk | Mitigation |
|------|------------|
| [Risk] | [Mitigation] |

---

## 🔄 Rollback Plan

[How to revert if this fails]

---

## 🔗 Dependencies

- HU-XXX (must complete first)
- None

---

## 📖 Notes

[Any additional context]
TEMPLATE_EOF

# Template: User Story Simple
cat > docs/templates/user-stories/template-user-story.md << 'TEMPLATE_EOF'
# HU-XXX: [Feature Name]

**Status**: 🟡 In Progress
**Owner**: @username
**Created**: YYYY-MM-DD

---

## Description

[What this feature does]

## Criteria

- [ ] [Acceptance criterion 1]
- [ ] [Acceptance criterion 2]

## Notes

[Any additional context]
TEMPLATE_EOF

# Template: Bug Fix SDD-Ready
cat > docs/templates/bug-fixes/template-bug-fix-detailed.md << 'TEMPLATE_EOF'
# BF-XXX: [Bug Title]

**Status**: 🟡 In Progress
**Owner**: @username
**Created**: YYYY-MM-DD
**Severity**: Critical | High | Medium | Low

---

## 🐛 Problem

[Description of the bug]

## 🔍 Root Cause

[What's causing the bug]

## 💡 Solution

[How to fix it]

## 🧪 Test Case

**GIVEN** [precondition]
**WHEN** [action]
**THEN** [expected behavior]

## 🔗 Related HU

[If any, link to the HU that introduced this bug]
TEMPLATE_EOF

# Template: Bug Fix Simple
cat > docs/templates/bug-fixes/template-bug-fix.md << 'TEMPLATE_EOF'
# BF-XXX: [Bug Title]

**Status**: 🟡 In Progress
**Owner**: @username
**Severity**: Critical | High | Medium | Low

---

## Problem

[Description of the bug]

## Steps to Reproduce

1. [Step 1]
2. [Step 2]
3. [Step 3]

## Expected Behavior

[What should happen]

## Actual Behavior

[What actually happens]
TEMPLATE_EOF

# Template: Refactor
cat > docs/templates/refactors/template-refactor.md << 'TEMPLATE_EOF'
# RF-XXX: [Refactor Name]

**Status**: 🟡 In Progress
**Owner**: @username
**Created**: YYYY-MM-DD

---

## 🎯 Intent

[Why this refactor is needed]

## 📋 Scope

### In Scope
- [What changes]

### Out of Scope
- [What doesn't change]

## ✅ Requirements

- [ ] No behavior change
- [ ] All existing tests pass
- [ ] Backward compatible

## 🧪 Verification

[How to verify the refactor didn't break anything]
TEMPLATE_EOF

# Template: RFC
cat > docs/templates/architecture/RFC_template.md << 'TEMPLATE_EOF'
# RFC-XXX: [Title]

**Author**: @username
**Status**: Draft | Discussion | Accepted | Rejected
**Created**: YYYY-MM-DD

---

## Summary

[One paragraph: what is this RFC trying to solve]

## Motivation

[Why is this needed? What problem does it solve?]

## Proposed Solution

[Detailed description of the proposed solution]

## Alternatives Considered

| Alternative | Pros | Cons |
|-------------|------|------|
| [Alt 1] | [Pros] | [Cons] |

## Decision

[What is being decided]

## Timeline

- **Proposal**: YYYY-MM-DD
- **Discussion**: YYYY-MM-DD
- **Decision**: YYYY-MM-DD

## Checklist

- [ ] All stakeholders have reviewed
- [ ] Risks identified and mitigated
- [ ] Cost/benefit analysis complete
TEMPLATE_EOF

# Template: ADR
cat > docs/templates/architecture/ADR_template.md << 'TEMPLATE_EOF'
# ADR-XXX: [Title]

**Date**: YYYY-MM-DD
**RFC related**: RFC-XXX (if any)
**Status**: Proposed | Accepted | Deprecated

---

## Context

[What is the decision being made? What is the situation?]

## Decision

[What is being decided]

## Consequences

### ✅ Positive
- [Benefit 1]

### ❌ Negative
- [Drawback 1]

### 🔄 Neutral
- [Side effect]

## Migration

[If applicable, how to migrate from previous state]

## Documentos Relacionados

| Documento | Ubicación |
|-----------|-----------|
| [Doc] | [Location] |
TEMPLATE_EOF

# Template: Database Schema
cat > docs/templates/database/schema.md << 'TEMPLATE_EOF'
# Database Schema

> Document the database schema for this project.

## Conventions

- Table names: `snake_case`
- Column names: `snake_case`
- Primary keys: `id` (UUID or SERIAL)
- Timestamps: `created_at`, `updated_at`

---

## Tables

### Table: [name]

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PK | Primary key |
| created_at | TIMESTAMP | NOT NULL | Creation timestamp |
| updated_at | TIMESTAMP | NOT NULL | Last update timestamp |

### Relationships

- `[table]` has many `[table]` (1:N)
- `[table]` belongs to `[table]` (N:1)

---

## Indexes

- `[table].[column]` — for `[purpose]`

## Migrations

`YYYY-MM-DD-initial-schema.sql` — Initial schema
TEMPLATE_EOF

# Template: API Endpoints
cat > docs/templates/api/endpoints.md << 'TEMPLATE_EOF'
# API Endpoints

> Document API contracts here.

## Conventions

- Base URL: `/api/v1`
- Authentication: Bearer token
- Errors: Standard HTTP codes + `{ error: string, code: string }`

---

## Auth

### POST /api/v1/auth/login

**Request:**
```json
{
  "email": "string",
  "password": "string"
}
```

**Response (200):**
```json
{
  "token": "string",
  "user": { "id": "string", "email": "string" }
}
```

**Errors:**
- 401: Invalid credentials

---

## [Resource]

### GET /api/v1/[resource]

**Headers:**
- `Authorization: Bearer {token}`

**Response (200):**
```json
{
  "data": [],
  "pagination": { "page": 1, "limit": 20, "total": 100 }
}
```
TEMPLATE_EOF

# Template: PRD
cat > docs/templates/PRD/PRD.md << 'TEMPLATE_EOF'
# Product Requirements Document (PRD)

**Project**: [Name]
**Owner**: @username
**Created**: YYYY-MM-DD
**Status**: Draft | In Review | Approved

---

## 🎯 Vision

[What is this project trying to achieve?]

## 👥 Users

| User | Needs | Pain Points |
|------|-------|-------------|
| [User 1] | [Needs] | [Pain points] |

## ✅ Requirements

### Must Have
- [Requirement]

### Should Have
- [Requirement]

### Nice to Have
- [Requirement]

## 🚫 Out of Scope

- [What's not included]

## 📊 Success Metrics

- [Metric 1]: [Target]
- [Metric 2]: [Target]

## 📝 Notes

[Any additional context]
TEMPLATE_EOF

# Template: PRD base
cat > docs/templates/PRD/PRD_template.md << 'TEMPLATE_EOF'
# [Project Name] — Product Requirements Document

**Owner**: @Crhistian
**Versión**: 1.0
**Última actualización**: YYYY-MM-DD

---

## 1. Resumen Ejecutivo

[One paragraph explaining the project]

## 2. Objetivos

- [Primary objective]
- [Secondary objective]

## 3. Alcance

### In Scope
- [What's included]

### Out of Scope
- [What's NOT included]

## 4. Usuarios

| Usuario | Descripción | Necesidades |
|---------|-------------|-------------|
| [User 1] | [Description] | [Needs] |

## 5. Requisitos Funcionales

| ID | Requisito | Prioridad |
|----|-----------|-----------|
| RF-001 | [Requirement] | Must |

## 6. Requisitos No Funcionales

| ID | Requisito | Criterio |
|----|-----------|----------|
| RNF-001 | [Requirement] | [Criteria] |

## 7. API Contracts

[Link to docs/templates/api/endpoints.md]

## 8. Tech Stack

| Componente | Tecnología |
|------------|------------|
| Frontend | [Tech] |
| Backend | [Tech] |
| Database | [Tech] |

## 9. Timeline

| Fase | Fecha | Entregable |
|------|-------|------------|
| [Phase] | [Date] | [Deliverable] |
TEMPLATE_EOF

echo "✅ Templates creados"
echo ""

# ============================================
# BASE DOCUMENTATION
# ============================================

echo "📚 Creando documentación base..."

# Template Guide
cat > docs/templates/TEMPLATE_GUIDE.md << 'TEMPLATE_EOF'
# Template Guide

> Quick reference for choosing the right template.

## User Stories

| Situation | Template |
|-----------|----------|
| Feature normal | `user-stories/template-user-story-detailed.md` |
| Feature pequeña (< 2h) | `user-stories/template-user-story.md` |
| Refactor | `refactors/template-refactor.md` |

## Bug Fixes

| Situation | Template |
|-----------|----------|
| Bug con test de verificación | `bug-fixes/template-bug-fix-detailed.md` |
| Bug trivial | `bug-fixes/template-bug-fix.md` |

## Architecture

| Situation | Template |
|-----------|----------|
| Nueva decisión (en discusión) | `architecture/RFC_template.md` |
| Decisión ya tomada | `architecture/ADR_template.md` |

## API & Database

| Document | Template |
|----------|---------|
| API Endpoints | `api/endpoints.md` |
| Database Schema | `database/schema.md` |

## Projects

| Document | Template |
|----------|---------|
| Product Requirements | `PRD/PRD.md` |

## How to Use

1. Copy template to `docs/tasks/` (for HUs) or relevant folder
2. Fill in the sections
3. Delete unused sections
4. Update status as work progresses

## Status Conventions

| Status | Meaning |
|--------|---------|
| 🟡 In Progress | Currently working on |
| 🟢 Done | Completed |
| 🔴 Blocked | Waiting on something |
| ⚫ Archived | Cancelled or superseded |
TEMPLATE_EOF

# Adoption Guide
cat > docs/adoption-guide.md << 'TEMPLATE_EOF'
# Guía de Adopción — Cómo Adoptar FlowDoc según tu Contexto

> No tienes que adoptarlo todo de golpe. Elige el nivel que mejor se adapte a tu situación y crezca desde ahí.

---

## Niveles de Adopción

```
┌─────────────────────────────────────────────────────────────┐
│  Nivel 4: Equipo Completo                                   │
│  Ciclo de 15 días + Métricas + Proceso completo              │
├─────────────────────────────────────────────────────────────┤
│  Nivel 3: Equipo Coordinado                                  │
│  Ciclo adaptado + Planning + Integración                    │
├─────────────────────────────────────────────────────────────┤
│  Nivel 2: SDD Básico                                         │
│  Proposal → Spec → Design → Tasks → Apply → Verify          │
├─────────────────────────────────────────────────────────────┤
│  Nivel 1: Solo Documentación                                 │
│  HUs en docs/tasks/, sin ceremonia SDD                        │
└─────────────────────────────────────────────────────────────┘
```

---

## Nivel 1: Solo Documentación ✅

**Ideal para**: Equipos de 1 persona, proyectos pequeños, comenzar a documentar sin overhead.

### Qué hacer

1. Crear `docs/tasks/HU-001-tu-feature.md`
2. Usar template de `docs/templates/user-stories/`
3. Documentar: qué hace, criterios de aceptación

### Cuándo pasar al Nivel 2

Cuando sientas que necesitás más estructura.

---

## Nivel 2: SDD Básico ✅

**Ideal para**: 1-2 personas que quieren estructura sin ciclo de equipo.

Seguir el ciclo SDD completo: Proposal → Spec → Design → Tasks → Apply → Verify → Archive

---

## Nivel 3: Ciclo Adaptado ✅

**Ideal para**: Equipos de 2-5 personas que quieren sincronización sin reuniones excesivas.

### Qué agregar

1. **Planning adaptado** (no 15 días obligatorios)
2. **Owner claro** en cada HU
3. **Feature flags** para trabajo paralelo

---

## Nivel 4: Equipo Completo ✅

**Ideal para**: Equipos de 4+ personas en distintas zonas horarias.

Ciclo de 15 días + métricas + proceso completo.

---

## Empezar

1. **Hoy**: Crear `docs/tasks/HU-001-tu-proxima-feature.md`
2. **Esta semana**: Probar el ciclo SDD en una HU
3. **Este mes**: Evaluar si necesitás más estructura

El objetivo es que la documentación sea útil, no perfecta. Iterá según tu contexto.
TEMPLATE_EOF

# FAQ
cat > docs/FAQ.md << 'TEMPLATE_EOF'
# FAQ — Preguntas Frecuentes

> Las dudas más comunes cuando adoptas FlowDoc.

---

## Empezar

### ¿Por dónde empiezo?

**Crea una HU en `docs/tasks/HU-001-tu-feature.md`.** Así de simple.

### ¿Cuánto tiempo toma documentar una HU?

| Nivel | Tiempo |
|-------|--------|
| HU simple | 10-15 min |
| HU SDD-Ready | 30-45 min |
| HU completa | 1-2 horas |

---

## El Ciclo de 15 Días

### ¿Son obligatorios los 15 días?

No. El ciclo de 15 días es una **referencia**, no una obligación.

### ¿De dónde viene el ciclo?

Basado en **Scrum adaptado** para equipos distribuidos:

| Concepto Scrum | Adaptación |
|----------------|------------|
| Sprint | Ciclo de 15 días |
| Daily standup | Async update de 5 min |
| Sprint planning | Días 1-2 |
| Integration review | Días 12-14 |

---

## Integración con Herramientas

### ¿Cómo integro con GitHub Projects, Jira, etc.?

**No es responsabilidad del framework.** La integración con tu tool de project management es decisión tuya, de tu equipo, o de tu empresa.

---

## HUs que FALLAN

### ¿Qué pasa si una HU no se puede completar?

Una HU no es un contrato hard. Se puede:
- **Dividir** en HUs más pequeñas
- **Archivar** con razón: "bloqueada por X", "scope cambió"
- **Crear Bug Fix** para resolver problemas

Lo importante: **no dejar HUs zombies**.

---

## ¿Tu pregunta no está respondida?

Abre un issue o preguntá en el canal correspondiente.
TEMPLATE_EOF

# Anti-patterns
cat > docs/anti-patrones.md << 'TEMPLATE_EOF'
# Anti-Patrones — Señales de que FlowDoc no está funcionando

> Si ves alguna de estas señales, algo necesita ajustarse.

---

## Documentación

### ❌ Docs desactualizadas

**Señal**: Los archivos en `docs/` no reflejan la realidad del código.

**Solución**: Regla "docs en el PR" — actualizar documentación al mismo tiempo que el código.

### ❌ HU zombies

**Señal**: HUs en estado "in progress" por más de 2 ciclos sin avance.

**Solución**: Archivar con razón documentada. No dejar indefinitely pending.

### ❌ ADRs obsoletos

**Señal**: ADRs que contradicen decisiones actuales.

**Solución**: Marcar como `DEPRECATED` y linkear al nuevo ADR que lo reemplaza.

---

## Proceso

### ❌ Reuniones innecesarias

**Señal**: Reuniones de status que podrían ser un mensaje async.

**Solución**: Si no necesita interacción en tiempo real, es Discord/Issue, no reunión.

### ❌ Daily standups presenciales para async teams

**Señal**:Esperar a que todos estén online para hacer daily.

**Solución**: Async updates de 5 min en Discord, configurable por zona horaria.

### ❌ Planning de 4+ horas

**Señal**: El planning se extiende todo el día.

**Solución**: Máx 4 horas. Si no entra, la feature es muy grande.

---

## SDD

### ❌ Speccing por diversión

**Señal**: Todas las HUs tienen spec completo, pero nadie las lee.

**Solución**: N1 solo documentación. N2+ para features reales. No hacer overhead por inercia.

### ❌ Diseño antes de entender el problema

**Señal**: Empezar con Design sin haber pasado por Explore/Proposal.

**Solución**: SDD esProposal → Spec → Design. No saltar pasos.

### ❌ Tasks sin tests

**Señal**: Tasks de código sin su tarea de test asociada.

**Solución**: "Cada tarea de código incluye su tarea de test al lado."

---

## Equipo

### ❌ Buscar la perfección

**Señal**: No hacer nada porque "no está listo".

**Solución**: Iterar. Algo documentado imperfecto > nada. Perfecto es enemigo de bueno.

### ❌ Imponer el framework

**Señal**: Forzar al equipo a seguir todo al pie de la letra.

**Solución**: Inspirar, no imponer. Mostrar valor primero.
TEMPLATE_EOF

# Troubleshooting
cat > docs/troubleshooting.md << 'TEMPLATE_EOF'
# Troubleshooting — Errores Comunes y Soluciones

---

## SDD Commands

### Error: "Artifact not found"

**Causa**: No existe el artifact para ese change.

**Solución**: Crear primero el artifact con `/sdd-new` o verificar que el nombre es correcto.

### Error: "Permission denied" en scripts

**Causa**: El script no tiene permisos de ejecución.

**Solución**: `chmod +x scripts/*.sh`

---

## Estructura

### Error: "docs/ no existe"

**Causa**: No se inicializó la estructura.

**Solución**: Ejecutar `scripts/flowdoc-migration.sh` para crear la estructura.

---

## HU Status

### HU lleva 3+ ciclos sin completar

**Causa**: Subestimación o bloqueos persistentes.

**Solución**:
- Dividir en HUs más pequeñas
- Archivar con razón documentada
- Verificar dependencias

---

## Recursos

| Problema | Recurso |
|----------|----------|
| Ciclo de trabajo | `docs/flowdoc-ciclo.md` |
| Adopción | `docs/adoption-guide.md` |
| Templates | `docs/templates/TEMPLATE_GUIDE.md` |
TEMPLATE_EOF

echo "✅ Documentación base creada"
echo ""

# ============================================
# AGENTS.MD
# ============================================

echo "🤖 Creando AGENTS.md..."

cat > AGENTS.md << 'TEMPLATE_EOF'
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

| Herramienta | Compatibilidad |
|-------------|---------------|
| OpenCode | ✅ |
| Antigravity | ✅ |
| ClaudeCode | ✅ |
| Otros agents | ✅ |

---

## Estructura del Proyecto

```
docs/                        ← Source of truth
├── templates/              ← Templates (source of truth)
├── architecture/
│   ├── adr/                ← Architecture Decision Records
│   └── rfc/                ← Requests for Comments
├── tasks/                  ← Historias de usuario
│   └── HU-001-HU-099/      ← Carpeta por rango
├── flowdoc-ciclo.md        ← Ciclo de trabajo
├── adoption-guide.md        ← Guía de adopción
└── FAQ.md                   ← Preguntas frecuentes

AGENTS.md                   ← Contexto para agents de IA
```

---

## Convenciones

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

Para proyectos que USAN el framework:
- Tests según el stack elegido (vitest, jest, xUnit, etc.)
- Coverage mínimo: >80%
- Cada tarea de código incluye su test asociado
TEMPLATE_EOF

echo "✅ AGENTS.md creado"
echo ""

# ============================================
# CHANGELOG
# ============================================

cat > CHANGELOG.md << 'TEMPLATE_EOF'
# Changelog

Documentación de cambios y decisiones adoptadas en el framework.

---

## YYYY-MM-DD — Migración a FlowDoc

### Estructura Creada

- `docs/` con templates, architecture, tasks
- `AGENTS.md` adaptado al proyecto
- Documentación base: adoption-guide, FAQ, troubleshooting, anti-patrones

### Checklist de Migración

Ver `scripts/flowdoc-legacy-checklist.md` para los pasos manuales post-script.
TEMPLATE_EOF

echo "✅ CHANGELOG creado"
echo ""

# ============================================
# ONBOARDING (lightweight)
# ============================================

cat > ONBOARDING.md << 'TEMPLATE_EOF'
# Onboarding — Nuevo Miembro

> Checklist para nuevos miembros del equipo.

---

## Día 1: Contexto

- [ ] Leer `AGENTS.md` — cómo funciona el equipo
- [ ] Leer `docs/flowdoc-ciclo.md` — ciclo de trabajo
- [ ] Leer `docs/adoption-guide.md` — niveles de adopción
- [ ] Tener acceso al repo y herramientas

## Día 2-3: Primeros Pasos

- [ ] Revisar HUs activas en `docs/tasks/`
- [ ] Identificar dependencies
- [ ] Setup local del proyecto

## Día 4-5: Primera Contribución

- [ ] Tomar HU pequeña
- [ ] Seguir el ciclo SDD
- [ ] Código + test + docs

## Recursos

- [FAQ](docs/FAQ.md) — Preguntas frecuentes
- [Troubleshooting](docs/troubleshooting.md) — Errores comunes
- [Anti-patrones](docs/anti-patrones.md) — Qué evitar
TEMPLATE_EOF

echo "✅ ONBOARDING creado"
echo ""

# ============================================
# GITIGNORE
# ============================================

cat > .gitignore << 'TEMPLATE_EOF'
# Dependencies
node_modules/
vendor/

# Build outputs
dist/
build/
*.log

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/

# Environment
.env
.env.local

# Agents
.engram/
openspec/

# Legacy templates (use docs/templates instead)
/templates/
TEMPLATE_EOF

echo "✅ .gitignore creado"
echo ""

# ============================================
# SUMMARY
# ============================================

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ Estructura FlowDoc creada exitosamente!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Próximos pasos:"
echo "1. Revisar docs/flowdoc-ciclo.md"
echo "2. Ejecutar scripts/flowdoc-legacy-checklist.md"
echo "3. Adaptar AGENTS.md a tu proyecto"
echo ""
echo "Ejecutar: ls -la docs/"
echo ""

# List what was created
echo "Estructura creada:"
find docs/ -type f | sort
TEMPLATE_EOF

chmod +x scripts/flowdoc-migration.sh

echo ""
echo -e "${GREEN}✅ Script listo! Ejecutar con: ./scripts/flowdoc-migration.sh${NC}"

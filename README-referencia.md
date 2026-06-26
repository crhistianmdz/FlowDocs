# Framework de Trabajo SDD para Equipos

**Spec-Driven Development (SDD)** — Patrón para trabajar en equipo con documentación viva y artifacts versionados.

---

## 🎯 ¿Qué es Este Framework?

Es una **plantilla reutilizable** para iniciar cualquier proyecto de software con:

- ✅ **Documentación viva** (PRD, RFC, HUs)
- ✅ **Artifacts SDD** versionados (proposal, spec, design, tasks)
- ✅ **Flujo de equipo** claro (4+ personas)
- ✅ **Multi-arquitectura** (monolítico, microservicios, monorepo)

---

## 📁 Estructura del Framework

```
propuestaFrameworkTrabajo/
├── monolitico/          ← Para proyectos monolíticos o frontend-only
├── microservicios/      ← Para proyectos con múltiples servicios
└── shared/              ← Templates compartidos (PRD, RFC, convenciones)
```

---

## 🚀 Cómo Usar Este Framework

### 1. Elegir Arquitectura

| Arquitectura | Cuándo Usar |
|--------------|-------------|
| **monolitico** | Frontend-only, backend único, o proyectos pequeños (< 5 personas) |
| **microservicios** | Múltiples servicios independientes, equipos por módulo, escalabilidad |

### 2. Inicializar Proyecto

```bash
# Para monolítico
cp -r ~/Documentos/propuestaFrameworkTrabajo/monolitico/* /tu/proyecto/

# Para microservicios
cp -r ~/Documentos/propuestaFrameworkTrabajo/microservicios/* /tu/proyecto/

# Templates compartidos (opcional)
cp -r ~/Documentos/propuestaFrameworkTrabajo/shared/* /tu/proyecto/docs/
```

### 3. Personalizar

1. Editar `.agent/context.md` con la info de TU proyecto
2. Crear primera HU en `docs/tasks/HU-001-*.md`
3. Correr `/sdd-init` en el proyecto
4. Empezar a trabajar: `/sdd-new HU-001-* --from-docs`

---

## 📋 Flujo de Trabajo en Equipo

### Diario (Cada Persona)

```bash
# 1. Sincronizar
git pull origin main

# 2. Inicializar sesión SDD
/sdd-init

# 3. Trabajar en HU
/sdd-new HU-XXX-nombre --from-docs

# 4. Commit y push
git add .
git commit -m "feat: HU-XXX - descripción"
git push origin main
```

### Convenciones

| Regla | Descripción |
|-------|-------------|
| **Una HU = un cambio** | Cada HU es un `openspec/changes/<hu-name>/` |
| **Commit por fase** | Commitear cuando una fase completa (proposal, spec, etc.) |
| **PR review** | Al menos 1 aprobación antes de merge |
| **Docs vivos** | Actualizar docs cuando el código cambia |

---

## 📄 Templates Incluidos

| Template | Ubicación | Propósito |
|----------|-----------|-----------|
| `template-user-story.md` | docs/templates/user-stories/ | User Story simple |
| `template-user-story-detailed.md` | docs/templates/user-stories/ | User Story SDD-Ready |
| `template-bug-fix.md` | docs/templates/bug-fixes/ | Bug Fix simple |
| `template-bug-fix-detailed.md` | docs/templates/bug-fixes/ | Bug Fix SDD-Ready |
| `template-refactor.md` | docs/templates/refactors/ | Refactor |
| `RFC_template.md` | docs/templates/architecture/ | Request for Comments |
| `ADR_template.md` | docs/templates/architecture/ | Architecture Decision Record |
| `PRD.md` | docs/templates/PRD/ | Product Requirements Document |
| `endpoints.md` | docs/templates/api/ | API Endpoints ejemplo |
| `schema.md` | docs/templates/database/ | Database Schema ejemplo |

---

## 🎯 Casos de Uso

### Caso 1: Frontend-Only (React, Angular, Vue)

Usar **monolitico/**:
- `docs/API/frontend-components.md` (componentes, props, estados)
- `docs/tasks/*.md` (HUs de UI)
- Sin DB (o DB local con schema simple)

### Caso 2: Backend Monolítico (Node, Go, Python)

Usar **monolitico/**:
- `docs/API/backend-api.md` (endpoints, requests, responses)
- `docs/DB/schema.md` (tablas, relaciones)
- `docs/tasks/*.md` (HUs de backend)

### Caso 3: Microservicios (Múltiples Servicios)

Usar **microservicios/**:
- `docs/<servicio>/API/` (API específica de cada servicio)
- `docs/<servicio>/DB/` (DB específica de cada servicio)
- `docs/SHARED/` (contratos entre servicios, arquitectura global)

### Caso 4: Monorepo (Frontend + Backend)

Usar **monolitico/** con estructura modular:
- `docs/frontend/` (componentes, estados)
- `docs/backend/` (API, DB)
- `docs/SHARED/` (contratos, tipos compartidos)

---

## ⚠️ Reglas de Oro

| Regla | Por Qué |
|-------|---------|
| **Docs en el repo** | Todo el equipo ve lo mismo |
| **HUs cortas** | 1-3 días de trabajo máximo |
| **Commit frecuente** | No más de 1 día sin commitear |
| **PRD vivo** | Actualizar cuando el scope cambia |
| **Una fuente de verdad** | No duplicar información |

---

## 📚 Recursos Adicionales

| Recurso | Descripción |
|---------|-------------|
| [SDD Spec](https://github.com/antigravity-dev/sdd) | Especificación oficial de SDD |
| [Engram](https://github.com/antigravity-dev/engram) | Memoria persistente para agentes |
| [Agent Teams Lite](https://github.com/antigravity-dev/agent-teams-lite) | Framework de orchestración |

---

**Versión**: 1.0  
**Creado**: 2026-05-13  
**Autor**: Equipo inventarioHumo  
**Licencia**: MIT (usar libremente)

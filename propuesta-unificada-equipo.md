# Propuesta: Framework Unificado para Equipo Híbrido

## Contexto del Equipo

- **Integrantes**: 4 personas en distintos países
- **Herramientas**: 
  - Algunos usan **OpenCode** con SDD + Engram
  - Otros usan **Google Antigravity** con SDD + Engram
- **Objetivo**: Unificar el proceso de trabajo para que todos usen el mismo flujo SDD

---

## El Problema

Cuando un equipo usa dos herramientas diferentes (OpenCode y Antigravity), surgen problemas de:
- **Inconsistencia**: Cada persona trabaja de forma distinta
- **Descoordinación**: Difficulty para compartir contexto
- **Duplicación**: misma feature documentada de formas diferentes

---

## La Solución: Framework Unificado SDD

El objetivo es que **el workflow sea idéntico** independientemente de la herramienta usada.

### Principios Fundamentales

1. **Docs-first**: La documentación es el único source of truth
2. **Artifact structure**: Misma estructura de archivos para ambos equipos
3. **Workflow equivalence**: Mismo ciclo de 15 días para todos

---

## Ciclo de Trabajo: 15 Días Útiles

```
Días 1-2:   Planning & Contract
Días 3-11:  Execution (con sync semanal)
Días 12-14: Integration & Verify
Días 15:    Retrospective
```

### Phase 1: Planning & Contract (Días 1-2)

- Feature list collab (todos juntos)
- Task contract (owner, deadline, dependencies)
- Dependency map
- Definition of Done

### Phase 2: Execution (Días 3-11)

- Async updates diarios (5 min)
- Weekly sync (día 7, 30 min)
- Si estás bloqueado, AVISAR INMEDIATAMENTE

### Phase 3: Integration & Verify (Días 12-14)

- Integration review
- Testing conjunto
- Verificar contra specs

### Phase 4: Retrospective (Día 15)

- ¿Qué funcionó bien?
- ¿Qué no funcionó?
- ¿Qué aprendimos?

---

## Estructura de Archivos Compartida

```
proyecto/
├── docs/                          ← DOCUMENTACIÓN (compartida)
│   ├── estructura.md
│   ├── api/
│   │   ├── endpoints.md
│   │   └── modelos.md
│   ├── database/
│   │   └── esquema.md
│   └── standards/
│       └── codigo-estandar.md
│
├── AGENTS.md                      ← Contexto del proyecto
│
├── openspec/                      ← SDD ARTIFACTS
│   ├── config.yaml
│   ├── specs/
│   │   └── {dominio}/
│   │       └── spec.md
│   └── changes/
│       └── {change-name}/
│           ├── proposal.md
│           ├── specs/
│           ├── design.md
│           └── tasks.md
│
└── .engram/                       ← Engram sync (exportado)
```

---

## Comparación de Comandos

| Fase SDD | OpenCode | Antigravity | Equivalente |
|----------|----------|-------------|-------------|
| **Init** | `/sdd-init` | Agent Manager → Initialize | ✅ |
| **New Feature** | `/sdd-new` | Agent → Describe task | ✅ |
| **Explore** | sdd-explore | Agent exploration | ✅ |
| **Propose** | sdd-propose | Agent plan generation | ✅ |
| **Spec** | sdd-spec | Agent spec creation | ✅ |
| **Design** | sdd-design | Implementation plan | ✅ |
| **Tasks** | sdd-tasks | Agent task list | ✅ |
| **Apply** | sdd-apply | Agent executes | ✅ |
| **Verify** | sdd-verify | Agent verification | ✅ |

---

## SDD Phases Detalladas

### Phase 1: Explore
- Investigar el codebase
- Analizar requirements
- Documentar hallazgos

### Phase 2: Proposal
- **Intent**: What problem solving?
- **Scope**: In/Out of scope
- **Approach**: High-level technical approach
- **Affected Areas**: Files/modules affected
- **Risks**: Identified risks + mitigation
- **Rollback Plan**: How to revert if fails

### Phase 3: Spec (Requirements)
- **Requirements**: MUST, SHALL, SHOULD, MAY
- **Scenarios**: Given/When/Then format
  - Happy path
  - Edge cases
  - Error cases
- **Verification**: How to validate

### Phase 4: Design
- **Architecture decisions**
- **Data models**
- **API contracts**
- **Sequence diagrams** (if complex)

### Phase 5: Tasks
- **Hierarchical tasks**: 1.1, 1.2, etc.
- **Grouped by phase**: infrastructure, implementation, testing
- **Small enough**: Complete in one session

### Phase 6: Apply
- Implement code following spec + design
- Follow existing patterns

### Phase 7: Verify
- Run tests
- Compare implementation against every spec scenario

### Phase 8: Archive
- Sync delta specs to main specs
- Archive completed change

---

## Artifact Store Modes

| Mode | OpenCode | Antigravity | Recomendación |
|------|----------|-------------|---------------|
| **engram** | ✅ Memoría | ⚠️ Configurable | Individual work |
| **openspec** | ✅ Archivos | ⚠️ Manual | Equipo (git-tracked) |
| **hybrid** | ✅ Ambos | ⚠️ Configurable | Mejor opción |

---

## Workflow Diagram

```
                    ┌─────────────────────────────────────┐
                    │       PLANNING & CONTRACT          │
                    │  (Días 1-2)                         │
                    │  - Feature list                     │
                    │  - Task contract                    │
                    │  - Dependency map                   │
                    └──────────────────┬──────────────────┘
                                       ▼
┌────────────────────────────────────┐      ┌────────────────────────────────────┐
│         EXPLORE                    │      │         PROPOSE                     │
│  - Investigate codebase           │ ───▶ │  - Intent                           │
│  - Analyze requirements           │      │  - Scope                            │
│  - Document findings              │      │  - Approach                         │
└────────────────────────────────────┘      │  - Affected areas                   │
                                          │  - Risks                             │
                                          └──────────────────┬──────────────────┘
                                                             ▼
                                          ┌────────────────────────────────────┐
                                          │            SPEC                    │
                                          │  - Requirements (MUST/SHALL)       │
                                          │  - Scenarios (Given/When/Then)    │
                                          │  - Happy path                     │
                                          │  - Edge cases                    │
                                          │  - Error cases                   │
                                          └──────────────────┬──────────────────┘
                                                             ▼
                                          ┌────────────────────────────────────┐
                                          │           DESIGN                   │
                                          │  - Architecture decisions         │
                                          │  - Data models                    │
                                          │  - API contracts                  │
                                          │  - Sequence diagrams              │
                                          └──────────────────┬──────────────────┘
                                                             ▼
                                          ┌────────────────────────────────────┐
                                          │           TASKS                    │
                                          │  - Hierarchical (1.1, 1.2)        │
                                          │  - Grouped by phase               │
                                          │  - Small enough                   │
                                          └──────────────────┬──────────────────┘
                                                             ▼
                    ┌─────────────────────────────────────┐
                    │           APPLY                     │
                    │  - Implement code                   │
                    │  - Follow spec + design              │
                    └──────────────────┬──────────────────┘
                                       ▼
                    ┌─────────────────────────────────────┐
                    │           VERIFY                     │
                    │  - Run tests                        │
                    │  - Compare vs spec scenarios         │
                    └──────────────────┬──────────────────┘
                                       ▼
                    ┌─────────────────────────────────────┐
                    │          ARCHIVE                     │
                    │  - Sync deltas to main specs        │
                    │  - Archive change                   │
                    └─────────────────────────────────────┘
```

---

## Templates SDD

Los templates están en:
```
/home/kaito/Documentos/plantillas-sdd/
├── template-user-story-sdd.md    ← Para features
├── template-bug-fix-sdd.md       ← Para bugs
├── template-refactor.md         ← Para refactors
└── PRD_template.md              ← Para proyectos completos
```

### Template Usage

```bash
# Para nueva feature
cp /home/kaito/Documentos/plantillas-sdd/template-user-story-sdd.md docs/tasks/mi-feature.md

# Para bug
cp /home/kaito/Documentos/plantillas-sdd/template-bug-fix-sdd.md docs/tasks/fix-bug.md
```

---

## Git Workflow

### Branch Naming
```
feature/add-reservation-system
fix/login-timeout
refactor/order-service
docs/api-endpoints
```

### Commit Messages (Conventional)
```
feat: add reservation system with date picker
fix: resolve login timeout on mobile
refactor: extract payment logic to domain
docs: update API endpoint documentation
```

---

## Definition of Done (DoD)

- [ ] Código escrito y funcionando
- [ ] Tests unitarios pasando
- [ ] Code review aprobada (mínimo 1 reviewer)
- [ ] Desplegado a staging
- [ ] Un teammate que NO escribió el código lo probó

---

## Equipo y Contacto

| Rol | Nombre | Zona Horaria | Especialidad | Contacto |
|-----|--------|--------------|--------------|----------|
| Backend | | | .NET, API | @ |
| Frontend | | | Angular, React | @ |
| Mobile | | | Flutter, React Native | @ |
| Fullstack | | | General | @ |

---

## Notas

1. **docs/ es el source of truth**: Toda la documentación debe estar en docs/
2. **openspec/ para artifacts**: Los artifacts SDD van en openspec/
3. **Engram funciona en ambos**: La memoria persistente está disponible en OpenCode y Antigravity
4. **Same workflow**: El ciclo de 15 días aplica para todos
5. **Sync temprano y seguido**: Communication async daily + weekly sync

---

## Referencias

- Framework de coordinación: `/home/kaito/Documentos/frameworkTrabajo/framework-coordinacion.md`
- Templates SDD: `/home/kaito/Documentos/plantillas-sdd/`
- AGENTS.md ejemplo: `/home/kaito/Documentos/frameworkTrabajo/AGENTS.md-ejemplo.md`
- Gentle-ai docs: https://github.com/Gentleman-Programming/gentle-ai
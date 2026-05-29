# Framework de Trabajo - Equipo Distribuido

**Para equipos de 4+ personas en distintos países usando SDD con OpenCode y/o Antigravity**

---

## 📁 Estructura del Framework

```
newPropuestaFrameworkTrabajo/
├── README.md                    ← Este archivo
├── CHANGELOG.md                 ← Registro de cambios
├── AGENTS.md                    ← Contexto para agents de IA
├── ONBOARDING.md                ← Checklist para nuevos miembros
├── QUICKSTART.md                ← Guía rápida de inicio
├── framework-coordinacion.md     ← Ciclo de 15 días
├── propuesta-unificada-equipo.md ← Unificación OpenCode + Antigravity
├── docs/                        ← Source of truth (ver más abajo)
├── templates/                   ← ⚠️ DEPRECATED, usar docs/templates/
└── scripts/                     ← Automatizaciones
    ├── hu-to-issues.sh          ← Linux/macOS
    ├── hu-to-issues.ps1         ← Windows PowerShell
    └── hu-to-issues.bat         ← Windows doble click
```

## 📂 Estructura de Docs

```
docs/                                ← Source of truth
├── PRD.md                          ← Requerimientos del producto
├── CHANGELOG.md                    ← Registro de cambios del framework
├── legacy-migration.md             ← Guía para adaptar proyectos legacy
├── troubleshooting.md             ← Errores comunes y soluciones
├── tech-debt.md                    ← Registro de deuda técnica
├── api/
│   ├── endpoints.md                ← Contratos de API
│   └── modelos.md                  ← DTOs y modelos
├── architecture/
│   ├── rfc/                        ← Request for Comments
│   │   ├── 001-estructura-docs.md
│   │   ├── 002-ciclo-15-dias.md
│   │   └── 003-feature-flags.md
│   └── adr/                        ← Architecture Decision Records
│       ├── 001-persistencia-engram.md
│       ├── 002-docs-source-of-truth.md
│       ├── 003-ciclo-15-dias.md
│       ├── 004-feature-flags.md
│       ├── 005-organizacion-hu.md
│       ├── 006-cuatro-arquitecturas.md
│       └── 007-estructura-templates.md
├── database/
│   └── schema.md                   ← Esquema de base de datos
├── tasks/                          ← Historias de usuario
│   └── HU-001-HU-099/              ← Carpeta por rango (ver ADR-005)
│       ├── HU-001-onboarding-docs.md
│       └── HU-002-validacion-hus.md
└── templates/                      ← Templates (source of truth)
    ├── TEMPLATE_GUIDE.md           ← Guía de uso
    ├── user-stories/
    ├── bug-fixes/
    ├── refactors/
    ├── architecture/
    ├── database/
    ├── api/
    └── PRD/
```

### Dónde va cada documento

| Documento | Ubicación | Descripción |
|-----------|-----------|-------------|
| **PRD** | `docs/PRD.md` | Documento de requerimientos del proyecto |
| **RFC** | `docs/architecture/rfc/` | Propuestas técnicas (antes de decidir) |
| **ADR** | `docs/architecture/adr/` | Decisiones registradas (después de aprobar) |
| **HU** | `docs/tasks/` | Historias de usuario para implementar |
| **API Docs** | `docs/api/` | Endpoints, modelos, contratos |
| **DB Schema** | `docs/database/` | Esquema de base de datos |

---

## 🚀 Quick Start

### 1. Nuevo Proyecto

```bash
# Copiar estructura a tu proyecto
cp -r ~/Documentos/newPropuestaFrameworkTrabajo/* /tu/proyecto/
```

### 2. Inicializar

```bash
# OpenCode
/init
/sdd-init

# Configurar Project Board en GitHub
```

### 3. Flujo de Trabajo

| Fase | Días | Acción |
|------|------|--------|
| Planning | 1-2 | Crear HUs en docs/tasks/ |
| Script | - | Ejecutar hu-to-issues para crear GitHub Issues |
| Execution | 3-11 | Trabajar en los issues |
| Integration | 12-14 | Integration review |
| Retrospective | 15 | Documentar lecciones |

---

## 📋 Templates

Los templates están en **`docs/templates/`** (source of truth). Ver `docs/templates/TEMPLATE_GUIDE.md` para guía de uso.

| Template | Ubicación | Uso |
|----------|-----------|-----|
| User Story Simple | `docs/templates/user-stories/` | Features pequeñas (< 2h) |
| User Story SDD-Ready | `docs/templates/user-stories/` | Features normales, con Given/When/Then |
| Bug Fix Simple | `docs/templates/bug-fixes/` | Bugs triviales |
| Bug Fix SDD-Ready | `docs/templates/bug-fixes/` | Bugs con test de verificación |
| Refactor | `docs/templates/refactors/` | Refactors sin cambio de comportamiento |
| RFC | `docs/templates/architecture/` | Propuestas técnicas en discusión |
| ADR | `docs/templates/architecture/` | Decisiones técnicas aprobadas |
| PRD | `docs/templates/PRD/` | Documento de requerimientos de producto |

**⚠️ La carpeta `/templates/` está deprecated.** Usar `docs/templates/`.

---

## 🔧 Scripts

### Linux/macOS
```bash
./scripts/hu-to-issues.sh
```

### Windows (doble click)
```
./scripts/hu-to-issues.bat
```

---

## 📖 Documentación

- **docs/adoption-guide.md** → Guía de adopción gradual en niveles
- **docs/FAQ.md** → Preguntas frecuentes
- **docs/troubleshooting.md** → Errores comunes y soluciones
- **docs/anti-patrones.md** → Señales de que el framework no está funcionando
- **docs/walkthrough-hu-login.md** → Ejemplo completo de HU por ciclo SDD
- **docs/architecture-diagram.md** → Diagramas de la arquitectura (Mermaid)
- **framework-coordinacion.md** → Ciclo de trabajo adaptable
- **propuesta-unificada-equipo.md** → Unificación de herramientas de IA
- **AGENTS.md** → Contexto para agents de IA

---

## 🔄 Compatibilidad con Herramientas

El framework es **independiente de la herramienta** que uses:

| Herramienta | ¿Compatible? |
|-------------|---------------|
| OpenCode + SDD | ✅ |
| Antigravity + SDD | ✅ |
| ClaudeCode + SDD | ✅ |
| Cualquier agent que lea docs/ | ✅ |

El workflow SDD es el mismo. Lo único que cambia es cómo ejecutas los comandos.

---

## ⚠️ Reglas de Oro

| Regla | Descripción |
|-------|-------------|
| Docs en el repo | Todo en docs/ y openspec/ |
| Una HU = un cambio | Una feature = un change |
| Branch naming | `feature-{usuario}-{HU}` desde `dev` |
| Nadie mergea su propio PR | Siempre otro par revisa y mergea |
| Commit frecuente | No más de 1 día sin commitear |
| Async-first | Comunicación escrita antes que reuniones. Si no hay ADR, la decisión no existe |
| Owner claro | Cada HU tiene un responsable |

---

## 📚 Recursos

- [SDD Spec](https://github.com/Gentleman-Programming/gentle-ai)
- [OpenCode Docs](https://opencode.ai/docs/es)
- [Google Antigravity](https://antigravity.google/)
- [ClaudeCode Docs](https://docs.claude.ai)
- [Engram (memoria persistente)](https://github.com/antigravity-dev/engram)

---

## 🏗️ Arquitecturas Soportadas

| Arquitectura | Cuándo Usar | Ubicación |
|--------------|-------------|-----------|
| **Monolítico** | Frontend-only, backend único, < 5 personas | `architectures/monolitico/` |
| **Microservicios** | Múltiples servicios independientes, equipos por módulo | `architectures/microservicios/` |
| **Monorepo** | Múltiples paquetes/apps en un repo | `architectures/monorepo/` |
| **Serverless** | Funciones en la nube, tráfico variable | `architectures/serverless/` |

### Inicializar Proyecto

```bash
# Monolítico
./architectures/monolitico/scripts/init-monolith.sh mi-proyecto

# Microservicios
./architectures/microservicios/scripts/init-microservices.sh mi-proyecto auth inventory orders
```

### Estructura Monolítico
```
proyecto/
├── .agent/context.md
├── docs/
│   ├── PRD.md
│   ├── RFC.md
│   ├── API/
│   ├── DB/
│   └── tasks/
├── openspec/
└── src/
```

### Estructura Microservicios
```
proyecto/
├── .agent/context.md
├── docs/
│   ├── SHARED/              ← Contratos, RFC, PRD global
│   ├── auth-service/        ← Cada servicio tiene su docs
│   ├── inventory-service/
│   └── orders-service/
├── openspec/
└── src/
    ├── auth-service/
    ├── inventory-service/
    └── orders-service/
```

### Estructura Monorepo
```
proyecto/
├── .agent/context.md
├── packages/
│   ├── shared/              ← Paquetes compartidos
│   ├── web-app/
│   └── mobile-app/
├── tools/
├── docs/
│   ├── PRD.md
│   ├── RFC.md
│   └── shared/
└── package.json             ← Root workspace
```

### Estructura Serverless
```
proyecto/
├── .agent/context.md
├── functions/               ← Funciones serverless
│   ├── auth/
│   ├── users/
│   └── orders/
├── infrastructure/          ← IaC
│   └── terraform/
├── shared/
├── docs/
│   ├── PRD.md
│   ├── RFC.md
│   └── functions/
├── openspec/
└── serverless.yml
```

---

**Versión**: 1.1  
**Actualizado**: 2026-05-29
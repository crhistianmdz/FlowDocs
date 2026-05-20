# Framework de Trabajo - Equipo Distribuido

**Para equipos de 4+ personas en distintos países usando SDD con OpenCode y/o Antigravity**

---

## 📁 Estructura del Framework

```
newPropuestaFrameworkTrabajo/
├── README.md                    ← Este archivo
├── README-referencia.md         ← Referencia adicional
├── framework-coordinacion.md     ← Ciclo de 15 días
├── propuesta-unificada-equipo.md ← Unificación OpenCode + Antigravity
├── AGENTS.md-ejemplo.md         ← Ejemplo de configuración
├── templates/                    ← Templates SDD
│   ├── template-user-story-sdd.md
│   ├── template-bug-fix-sdd.md
│   ├── template-refactor.md
│   ├── PRD_template.md
│   └── RFC_template.md
└── scripts/                     ← Automatizaciones
    ├── hu-to-issues.sh          ← Linux/macOS
    ├── hu-to-issues.ps1         ← Windows PowerShell
    └── hu-to-issues.bat         ← Windows doble click
```

## 📂 Estructura de Docs en el Proyecto

```
docs/
├── PRD.md                       ← Documento de requerimientos
├── architecture/
│   ├── rfc/
│   │   └── 001-mi-feature.md    ← RFCs técnicos (propuestas)
│   └── adr/
│       └── 001-mi-decision.md   ← ADRs (decisiones registradas)
├── api/
│   ├── endpoints.md              ← Endpoints de API
│   └── modelos.md                ← Modelos/DTOs
├── database/
│   └── schema.md                 ← Esquema de BD
├── tasks/
│   └── HU-001-nombre.md          ← Historias de usuario
└── templates/                    ← Copia de templates para referencia
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

| Template | Uso |
|----------|-----|
| `template-user-story-sdd.md` | Nuevas features |
| `template-bug-fix-sdd.md` | Bug fixes |
| `template-refactor.md` | Refactors |

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

- **framework-coordinacion.md** → Ciclo de 15 días para equipo
- **propuesta-unificada-equipo.md** → Unificación OpenCode + Antigravity
- **AGENTS.md-ejemplo.md** → Cómo configurar el contexto del proyecto

---

## ⚠️ Reglas de Oro

| Regla | Descripción |
|-------|-------------|
| Docs en el repo | Todo en docs/ y openspec/ |
| Una HU = un cambio | Una feature = un change |
| Commit frecuente | No más de 1 día sin commitear |
| Async-first | Comunicación escrita antes que reuniones |
| Owner claro | Cada HU tiene un responsable |

---

## 📚 Recursos

- [SDD Spec](https://github.com/Gentleman-Programming/gentle-ai)
- [OpenCode Docs](https://opencode.ai/docs/es)
- [Google Antigravity](https://antigravity.google/)

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

**Versión**: 1.0  
**Actualizado**: 2026-05-19
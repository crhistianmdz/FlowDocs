# Estructura de Proyecto Monorepo

Para proyectos con múltiples apps (web, mobile, API) que comparten código, tipos y utilidades. Un solo repositorio, múltiples paquetes, una sola fuente de verdad.

---

## 📁 Estructura de Carpetas

```
<proyecto>/
├── .agent/
│   └── context.md                ← Contexto SDD (con lista de paquetes)
├── packages/
│   ├── shared/                   ← Paquetes compartidos entre apps
│   │   ├── ui/                   ← Componentes UI reutilizables
│   │   ├── utils/                ← Helpers comunes
│   │   └── types/                ← Tipos TypeScript compartidos
│   ├── web/                      ← App web (React/Vue/Next.js)
│   │   ├── src/
│   │   ├── docs/
│   │   │   └── tasks/            ← HUs específicas del package web
│   │   └── package.json
│   ├── mobile/                   ← App móvil (React Native/Flutter)
│   │   ├── lib/
│   │   ├── docs/
│   │   │   └── tasks/            ← HUs específicas del package mobile
│   │   └── pubspec.yaml
│   └── api/                      ← API/Backend compartido
│       ├── src/
│       ├── docs/
│       │   └── tasks/            ← HUs específicas del package api
│       └── package.json
├── tools/                        ← Scripts y tooling
├── docs/                         ← Documentación transversal
│   ├── PRD.md                    ← PRD general del producto
│   ├── RFC.md                    ← Decisiones arquitectura globales
│   ├── arquitectura.md           ← Diagrama general del sistema
│   └── shared/                   ← Documentación de paquetes compartidos
├── openspec/
│   └── changes/
│       └── <change-name>/        ← Artifacts SDD por cambio
│           ├── 001-proposal.md
│           ├── 002-spec.md
│           ├── 003-design.md
│           ├── 004-tasks.md
│           └── state.yaml
├── scripts/                      ← Automatización (ver init-monorepo.sh)
│   └── init-monorepo.sh
├── package.json                  ← Root workspace
└── turbo.json                    ← Turborepo config (si aplica)
```

---

## 📄 Archivos Clave

### `.agent/context.md`

**Diferencia con monolítico**: Incluye lista explícita de paquetes con su tipo (app/package), owner, stack y dependencias entre ellos.

**Contenido mínimo**:
- Nombre y tipo de proyecto (monorepo)
- Lista de paquetes: `packages/web`, `packages/mobile`, `packages/api`, `packages/shared/*`
- Stack por paquete (web: React, mobile: RN, api: Node.js)
- Dependencias entre paquetes (quién consume a `shared/ui`)
- Ubicación de docs por paquete (`packages/{name}/docs/`)
- Decisiones de monorepo tooling (Turborepo, Nx, workspaces)

---

### `packages/<name>/docs/tasks/`

**Propósito**: Historias de usuario específicas de cada paquete. Cada package tiene su propia carpeta `docs/tasks/` con HUs que solo lo afectan a él.

**Convención de nombrado**:
- `packages/web/docs/tasks/HU-XXX-*.md`
- `packages/mobile/docs/tasks/HU-XXX-*.md`
- `packages/api/docs/tasks/HU-XXX-*.md`

**HU cross-package**: Si una HU afecta a varios paquetes, vive en `docs/shared/tasks/` (raíz) y referencia a cada paquete afectado.

---

### `docs/arquitectura.md`

**Propósito**: Diagrama general mostrando dependencias entre paquetes y flujo de datos.

**Contenido**:
- Diagrama de packages (quién depende de quién)
- Flujo: `web → api → DB`
- Flujo: `mobile → api → DB`
- Shared: `web + mobile → shared/ui`, `web + api → shared/types`

---

## 🚀 Inicialización

```bash
# Inicializar estructura base desde la raíz del repositorio FlowDocs
./reference/monorepo/scripts/init-monorepo.sh mi-proyecto

# O copiar templates manualmente
cp ./docs/templates/user-stories/* packages/web/docs/tasks/ 2>/dev/null || true
```

**Nota**: La carpeta `templates/` contiene **ejemplos de referencia**, no los templates oficiales. Los templates reales están en `docs/templates/` (ver ADR-007).

**Ver script**: `scripts/init-monorepo.sh`

---

## 📦 Documentación por Paquete

Cada paquete tiene su propia carpeta `docs/` con la documentación que **solo a ese paquete corresponde**. La documentación transversal (PRD, arquitectura, RFC) vive en `docs/` (raíz).

```
packages/web/
├── src/
└── docs/
    ├── README.md            ← Overview del package web
    ├── architecture.md      ← Decisiones técnicas del web
    └── tasks/               ← HUs del web
        ├── TEMPLATE.md
        ├── HU-001-login.md
        └── HU-002-dashboard.md
```

```
packages/api/
├── src/
└── docs/
    ├── README.md
    ├── API/
    │   └── endpoints.md     ← Endpoints del API
    ├── DB/
    │   └── schema.md        ← Esquema de DB del API
    └── tasks/
        ├── TEMPLATE.md
        └── HU-001-login-endpoint.md
```

---

## 📋 Organización de HUs por Paquete

| Tipo de HU | Ubicación | Ejemplo |
|------------|-----------|---------|
| **Específica de web** | `packages/web/docs/tasks/` | `HU-001-login-form.md` |
| **Específica de mobile** | `packages/mobile/docs/tasks/` | `HU-001-login-screen.md` |
| **Específica de api** | `packages/api/docs/tasks/` | `HU-001-auth-endpoint.md` |
| **Cross-package** | `docs/shared/tasks/` | `HU-010-auth-flow.md` (afecta web + api + mobile) |

**Convención de IDs**: Cada package numera sus HUs independientemente (web: HU-001, mobile: HU-001, api: HU-001). Para evitar colisiones, se prefija el paquete al referenciar: `web/HU-001`, `api/HU-003`, etc.

---

## 📊 Ejemplo: taskboard (SaaS de gestión de tareas)

```
taskboard/
├── .agent/
│   └── context.md
├── packages/
│   ├── shared/
│   │   ├── ui/                ← Componentes React compartidos (Button, Card)
│   │   ├── utils/             ← Helpers (formatDate, validators)
│   │   └── types/             ← Tipos TS (Task, User, Project)
│   │       └── package.json
│   ├── web/                   ← React web app (Next.js)
│   │   ├── src/
│   │   │   ├── pages/
│   │   │   ├── components/
│   │   │   └── hooks/
│   │   ├── docs/
│   │   │   ├── README.md
│   │   │   └── tasks/
│   │   │       ├── TEMPLATE.md
│   │   │       ├── HU-001-board-view.md
│   │   │       └── HU-002-drag-drop.md
│   │   └── package.json
│   ├── mobile/                ← React Native app
│   │   ├── lib/
│   │   ├── docs/
│   │   │   ├── README.md
│   │   │   └── tasks/
│   │   │       ├── TEMPLATE.md
│   │   │       └── HU-001-offline-sync.md
│   │   └── package.json
│   └── api/                   ← Node.js + Express API
│       ├── src/
│       ├── docs/
│       │   ├── README.md
│       │   ├── API/endpoints.md
│       │   ├── DB/schema.md
│       │   └── tasks/
│       │       ├── TEMPLATE.md
│       │       └── HU-001-task-crud.md
│       └── package.json
├── docs/                      ← Documentación transversal
│   ├── PRD.md
│   ├── RFC.md
│   ├── arquitectura.md
│   └── shared/
│       └── tasks/
│           └── HU-010-auth-flow.md  ← Cross-package
├── openspec/changes/
│   └── prd-rfc-taskboard/
│       ├── 001-proposal.md
│       ├── 003-design.md
│       └── 004-tasks.md
├── scripts/
│   └── init-monorepo.sh
├── package.json               ← Root workspace (npm/yarn workspaces)
└── turbo.json
```

---

## ⚠️ Cuándo Usar Esta Estructura

| Caso | Usar Esta Estructura |
|------|---------------------|
| **Múltiples apps (web + mobile)** | ✅ Sí |
| **Paquetes reutilizables** | ✅ Sí |
| **Código compartido entre apps** | ✅ Sí |
| **Equipos trabajando en diferentes apps** | ✅ Sí |
| **Tipos compartidos entre frontend y backend** | ✅ Sí |
| **Proyecto simple (una sola app, sin shared code)** | ❌ Usar monolitico/ |

---

## ⚠️ Cuándo NO Usar Esta Estructura

| Caso | Usar En Su Lugar |
|------|------------------|
| **Una sola app, sin compartir código** | `monolitico/` |
| **Servicios con deploy y DB independientes** | `microservicios/` |
| **Event-driven,家家 funciones aisladas** | `serverless/` |

---

## ✅ Ventajas

| Ventaja | Descripción |
|---------|-------------|
| **Código compartido** | `shared/` se actualiza una vez, todas las apps lo consumen |
| **Una fuente de verdad** | Tipos y contratos viven en `shared/types/`, sin drift |
| **Difusión de cambios fácil** | Cambiar `shared/ui` → todas las apps se actualizan |
| **Atomic commits** | Un commit puede tocar web + api + shared a la vez |
| **Visibilidad** | Una sola repo, ves todo el sistema en un vistazo |

---

## ⚠️ Consideraciones

| Consideración | Solución |
|---------------|----------|
| **Complejidad de build** | Usar Turborepo/Nx con caching de builds |
| **Learning curve** | Documentar convenciones en `.agent/context.md` |
| **Acoplamiento** | Limitar dependencias: apps no dependen entre sí, solo de `shared/` |
| **Versionado** | Usar changesets para versionar paquetes publicables |
| **CI/CD por paquete** | Pipeline por paquete para evitar rebuilds innecesarios |

---

## 🛠️ Tools Comunes

| Tool | Cuándo |
|------|--------|
| **Turborepo** | Monorepos JS con caching y pipelines |
| **Nx** | Monorepos grandes con generación de código |
| **Lerna** | Publicación de paquetes a npm (legacy) |
| **Yarn workspaces** | Simple y nativo |
| **NPM workspaces** | Estándar sin dependencias extra |
| **Pnpm workspaces** | Rápido y eficiente en disco |
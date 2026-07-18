# Estructura de Proyecto Monolítico

Para proyectos frontend-only, backend único, o monorepos pequeños.

---

## 📁 Estructura de Carpetas

```
<proyecto>/
├── .agent/
│   └── context.md              ← Contexto SDD (leer automáticamente)
├── docs/
│   ├── PRODUCTO/
│   │   ├── PRD.md              ← Product Requirements Document
│   │   └── roadmap.md          ← Timeline y fases
│   ├── TECNICO/
│   │   ├── RFC.md              ← Request for Comments
│   │   ├── arquitectura.md     ← Diagramas y patrones
│   │   └── decisiones.md       ← ADRs (Architecture Decision Records)
│   ├── API/
│   │   ├── endpoints.md        ← Endpoints (backend o frontend components)
│   │   ├── contracts.md        ← Contratos entre módulos
│   │   └── errores.md          ← Códigos de error
│   ├── DB/
│   │   ├── schema.md           ← Esquema de base de datos
│   │   └── migrations.md       ← Historial de migraciones
│   └── tasks/
│       ├── TEMPLATE.md         ← Template para HUs
│       └── HU-XXX-*.md         ← Historias de usuario
├── openspec/
│   └── changes/
│       └── <change-name>/      ← Artifacts SDD por cambio
│           ├── 001-proposal.md
│           ├── 002-spec.md
│           ├── 003-design.md
│           ├── 004-tasks.md
│           └── state.yaml
└── src/
    ├── components/             ← (frontend)
    ├── pages/                  ← (frontend)
    ├── services/               ← (API client)
    ├── hooks/                  ← (custom hooks)
    ├── contexts/               ← (React Context)
    └── utils/                  ← (funciones compartidas)
```

---

## 📄 Archivos Clave

### `.agent/context.md`

**Propósito**: Contexto que SDD lee automáticamente para entender el proyecto.

**Contenido mínimo**:
- Nombre y tipo de proyecto
- Stack tecnológico
- Estado actual (qué existe, qué falta)
- Decisiones clave (state, forms, testing)
- Ubicación de documentación (PRD, RFC, API, DB)
- Instrucciones para trabajar con HUs

**Ver template**: `.agent-context.md`

---

### `docs/tasks/TEMPLATE.md`

**Propósito**: Template estándar para Historias de Usuario.

**Campos requeridos**:
- ID y prioridad
- User story (As un... Quiero... Para...)
- Criterios de aceptación
- API endpoints (si aplica)
- DB changes (si aplica)
- UI components (si aplica)
- Dependencies

**Ver template**: `templates/HU-TEMPLATE.md`

---

### `docs/API/endpoints.md`

**Propósito**: Documentación de endpoints o componentes.

**Para backend**:
- Método, endpoint, descripción
- Request body (schema)
- Response body (schema)
- Error codes

**Para frontend**:
- Nombre del componente
- Props (tipo, requerido, default)
- Estados internos
- Eventos emitidos

**Ver template**: `templates/API-endpoints.md`

---

### `docs/DB/schema.md`

**Propósito**: Esquema de base de datos.

**Contenido**:
- Tablas con columnas y tipos
- Relaciones (FK, UK)
- Índices
- Migraciones

**Ver template**: `templates/DB-schema.md`

---

## 🚀 Inicialización

```bash
# Copiar estructura base (desde la raíz del repositorio FlowDocs)
cp ./reference/monolitico/.agent-context.md .agent/context.md

# Copiar templates desde docs/templates/ (source of truth)
cp ./docs/templates/user-stories/* docs/templates/user-stories/
cp ./docs/templates/bug-fixes/* docs/templates/bug-fixes/
cp ./docs/templates/refactors/* docs/templates/refactors/
cp ./docs/templates/PRD/* docs/templates/PRD/

# O usar el script automático
./reference/monolitico/scripts/init-monolith.sh mi-proyecto
```

**Nota**: La carpeta `templates/` dentro de `reference/monolitico/` contiene **ejemplos de referencia**, no los templates oficiales. Los templates reales están en `docs/templates/` (ver ADR-007).

**Ver script**: `scripts/init-monolith.sh`

---

## 📊 Ejemplo: taskmanager

Una app simple de gestión de tareas (Node.js + Express + PostgreSQL + React).

```
taskmanager/
├── .agent/
│   └── context.md
├── docs/
│   ├── PRODUCTO/
│   │   ├── PRD.md                ← Requisitos del producto
│   │   └── roadmap.md            ← Fases y timeline
│   ├── TECNICO/
│   │   ├── arquitectura.md       ← Diagramas y patrones
│   │   └── decisiones.md         ← ADRs
│   ├── API/
│   │   ├── endpoints.md          ← API REST del backend
│   │   └── errores.md           ← Códigos de error
│   ├── DB/
│   │   ├── schema.md             ← Esquema de PostgreSQL
│   │   └── migrations.md
│   └── tasks/
│       ├── TEMPLATE.md
│       └── HU-001-task-crud.md
├── openspec/
│   └── changes/
│       └── prd-rfc-taskmanager/
│           ├── 001-proposal.md
│           ├── 003-design.md
│           └── 004-tasks.md
└── src/
    ├── server/                   ← Express API
    │   ├── routes/
    │   ├── models/
    │   └── services/
    ├── client/                   ← React frontend
    │   ├── components/
    │   ├── pages/
    │   └── hooks/
    └── shared/                   ← Tipos y utilidades compartidas
```

---

## ⚠️ Cuándo NO Usar Esta Estructura

| Caso | Usar En Su Lugar |
|------|------------------|
| **Múltiples servicios independientes** | microservicios/ |
| **Equipos separados por módulo** | microservicios/ |
| **Cada módulo tiene su propia DB** | microservicios/ |
| **Contratos explícitos entre servicios** | microservicios/ |

---

## ✅ Ventajas

| Ventaja | Descripción |
|---------|-------------|
| **Simple** | Una sola estructura de docs |
| **Clara** | Todo el equipo sabe dónde está cada cosa |
| **Escalable** | Funciona para 1-10 personas |
| **Flexible** | Adaptable a frontend, backend, o fullstack |

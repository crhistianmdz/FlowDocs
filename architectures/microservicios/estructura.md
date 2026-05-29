# Estructura de Proyecto Multi-Módulo / Microservicios

Para proyectos con múltiples servicios independientes, equipos por módulo, o arquitecturas distribuidas.

---

## 📁 Estructura de Carpetas

```
<proyecto>/
├── .agent/
│   └── context.md              ← Contexto SDD (con lista de módulos)
├── docs/
│   ├── SHARED/                 ← Documentación compartida (todos los módulos)
│   │   ├── PRD.md              ← PRD general del producto
│   │   ├── RFC.md              ← Decisiones arquitectónicas globales
│   │   ├── arquitectura.md     ← Diagrama general del sistema
│   │   ├── convenciones.md     ← Estándares de código (todos los módulos)
│   │   ├── contratos.md        ← Contratos entre servicios
│   │   └── deployments.md      ← CI/CD, envs, variables globales
│   │
│   ├── <modulo-1>/             ← Módulo autocontenido (ej: auth-service)
│   │   ├── README.md           ← Overview del módulo
│   │   ├── API/
│   │   │   ├── endpoints.md    ← Endpoints específicos de este módulo
│   │   │   └── contracts.md    ← Contratos con otros módulos
│   │   ├── DB/
│   │   │   ├── schema.md       ← Esquema de ESTE módulo
│   │   │   └── migrations.md   ← Migraciones de ESTE módulo
│   │   └── tasks/
│   │       ├── TEMPLATE.md
│   │       └── HU-XXX-*.md
│   │
│   ├── <modulo-2>/             ← Otro módulo (ej: inventory-service)
│   │   ├── README.md
│   │   ├── API/
│   │   ├── DB/
│   │   └── tasks/
│   │
│   └── <modulo-3>/             ← Otro módulo (ej: orders-service)
│       ├── README.md
│       ├── API/
│       ├── DB/
│       └── tasks/
│
├── openspec/
│   └── changes/
│       ├── HU-001-auth-login/        ← Change de un módulo específico
│       ├── HU-002-inventory-crud/    ← Change de otro módulo
│       └── prd-rfc-general/          ← Change transversal (afecta todo)
│
├── src/
│   ├── auth-service/
│   ├── inventory-service/
│   └── orders-service/
│
└── docker-compose.yml                ← Orquestación de servicios
```

---

## 📄 Archivos Clave

### `.agent/context.md`

**Diferencia con monolítico**: Incluye lista explícita de módulos con su ubicación y owner.

**Contenido adicional**:
- Lista de módulos con path, owner, stack, status
- Documentación por módulo (`docs/<modulo>/`)
- Contratos inter-módulos
- Instrucciones para trabajar con `--module` flag

**Ver template**: `.agent-context.md`

---

### `docs/<modulo>/README.md`

**Propósito**: Overview del módulo (qué hace, dependencies, cómo correrlo).

**Contenido mínimo**:
- Descripción en 1-2 oraciones
- Responsabilidades del módulo
- Tech stack específico
- API endpoints (link a `API/endpoints.md`)
- DB schema (link a `DB/schema.md`)
- Dependencies con otros módulos
- Cómo correr localmente
- Owner del módulo

**Ver template**: `templates/modulo-README.md`

---

### `docs/SHARED/contratos.md`

**Propósito**: Definir cómo los módulos se comunican entre sí.

**Contenido**:
- Módulo A → Módulo B: qué endpoint usa, para qué
- Esquemas compartidos (DTOs, tipos)
- Versionado de contratos (v1, v2)
- Breaking changes policy

**Ver template**: `templates/contratos.md`

---

## 🚀 Inicialización

```bash
# Copiar estructura base
cp ~/Documentos/propuestaFrameworkTrabajo/microservicios/.agent-context.md .agent/context.md

# Copiar templates desde docs/templates/ (source of truth)
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/user-stories/* docs/templates/user-stories/
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/bug-fixes/* docs/templates/bug-fixes/
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/refactors/* docs/templates/refactors/
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/PRD/* docs/templates/PRD/
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/architecture/* docs/templates/architecture/

# O usar el script automático
~/Documentos/newPropuestaFrameworkTrabajo/microservicios/scripts/init-microservices.sh mi-proyecto auth inventory orders
```

**Nota**: La carpeta `templates/` dentro de `architectures/microservicios/` contiene **ejemplos de referencia**, no los templates oficiales. Los templates reales están en `docs/templates/` (ver ADR-007).

**Ver script**: `scripts/init-microservices.sh`

---

## 📊 Ejemplo Real: Sistema de Restaurantes

```
restaurante-system/
├── .agent/
│   └── context.md
├── docs/
│   ├── SHARED/
│   │   ├── PRD.md
│   │   ├── RFC.md
│   │   ├── arquitectura.md
│   │   └── contratos.md
│   ├── auth-service/
│   │   ├── README.md
│   │   ├── API/endpoints.md
│   │   ├── DB/schema.md
│   │   └── tasks/HU-001-login.md
│   ├── inventory-service/
│   │   ├── README.md
│   │   ├── API/endpoints.md
│   │   ├── DB/schema.md
│   │   └── tasks/
│   └── orders-service/
│       ├── README.md
│       ├── API/endpoints.md
│       ├── DB/schema.md
│       └── tasks/
├── openspec/changes/
│   ├── HU-001-auth-login/
│   └── HU-002-inventory-crud/
└── src/
    ├── auth-service/
    ├── inventory-service/
    └── orders-service/
```

---

## 🔗 Contratos Entre Módulos

### Ejemplo: Orders → Auth

```markdown
## Orders Service → Auth Service

**Propósito**: Validar JWT de requests entrantes.

**Endpoint**: `GET /api/auth/verify`

**Request**:
```
Authorization: Bearer <JWT>
```

**Response**:
```json
{
  "valid": true,
  "userId": "uuid",
  "role": "admin",
  "idEmpresa": 1
}
```

**Responsabilidad**:
- Orders service: enviar JWT en header
- Auth service: validar y devolver info del usuario
```

---

## ⚠️ Cuándo Usar Esta Estructura

| Caso | Usar Esta Estructura |
|------|---------------------|
| **Múltiples servicios independientes** | ✅ Sí |
| **Equipos separados por módulo** | ✅ Sí |
| **Cada módulo tiene su propia DB** | ✅ Sí |
| **Contratos explícitos entre servicios** | ✅ Sí |
| **Deploy independiente por módulo** | ✅ Sí |

---

## ✅ Ventajas

| Ventaja | Descripción |
|---------|-------------|
| **Autocontenido** | Cada módulo tiene TODO (API, DB, tasks) |
| **Escalable** | Podés agregar 10 módulos sin colapsar `docs/` |
| **Team autonomy** | Team A toca `docs/auth-service/`, no rompe `docs/inventory-service/` |
| **Claro** | Cuando trabajás en "orders", todo está en `docs/orders-service/` |
| **Contratos explícitos** | `contratos.md` define cómo los módulos se comunican |

---

## ⚠️ Consideraciones

| Consideración | Solución |
|---------------|----------|
| **Documentación duplicada** | `docs/SHARED/` para lo común, cada módulo solo lo específico |
| **Cambios transversales** | Usar `docs/SHARED/tasks/` para HUs que afectan múltiples módulos |
| **Versionado de contratos** | `contratos-v1.md`, `contratos-v2.md` si hay breaking changes |
| **Descubribilidad** | `docs/SHARED/arquitectura.md` debe tener el diagrama completo del sistema |

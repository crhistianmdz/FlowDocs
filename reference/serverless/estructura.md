# Estructura de Proyecto Serverless

Para proyectos event-driven, tráfico variable, pago por uso y funciones aisladas. Cada función es una unidad independiente con su propia documentación.

---

## 📁 Estructura de Carpetas

```
<proyecto>/
├── .agent/
│   └── context.md                ← Contexto SDD (con lista de funciones)
├── functions/                    ← Funciones serverless
│   ├── <name>/                   ← Cada función es autocontenida
│   │   ├── index.ts              ← Handler (entry point)
│   │   ├── package.json
│   │   └── docs/                 ← Docs específicas de la función
│   │       ├── README.md
│   │       └── events.md         ← Triggers, inputs/outputs
│   └── ...
├── infrastructure/               ← Infrastructure as Code
│   ├── terraform/
│   │   ├── main.tf               ← Recursos principales
│   │   ├── variables.tf          ← Variables de entrada
│   │   └── outputs.tf            ← Outputs (ARNs, IDs)
│   └── docker/
│       └── local-dev/            ← Para testing local
├── shared/                       ← Código compartido entre funciones
│   ├── types/                    ← Tipos compartidos (event schemas)
│   └── utils/                    ← Helpers comunes
├── docs/                         ← Documentación transversal
│   ├── PRD.md                    ← PRD general del producto
│   ├── RFC.md                    ← Decisiones arquitectura
│   ├── arquitectura.md           ← Diagrama de flujo event-driven
│   └── functions/                ← Docs cross-cutting de funciones
│       ├── overview.md           ← Lista y mapa de funciones
│       └── events-flow.md        ← Cómo se encadenan eventos
├── openspec/
│   └── changes/
│       └── <change-name>/        ← Artifacts SDD por cambio
├── scripts/                      ← Automatización (init-serverless.sh)
│   └── init-serverless.sh
└── serverless.yml                ← Config serverless framework
```

---

## 📄 Archivos Clave

### `.agent/context.md`

**Diferencia con monolítico**: Incluye lista explícita de funciones con su trigger, runtime, owner y dependencias.

**Contenido mínimo**:
- Nombre y tipo de proyecto (serverless)
- Lista de funciones: `functions/<name>` con trigger (S3, API GW, cron, SQS)
- Runtime por función (Node.js, Python, Go)
- Stack de IaC (Terraform, CDK, SAM)
- Proveedor cloud (AWS, GCP, Azure, Vercel)
- Mapa de eventos (qué función dispara a cuál)

---

### `functions/<name>/docs/`

**Propósito**: Cada función tiene su propia documentación. Patrones, triggers, schemas de input/output y decisiones locales viven aquí.

**Contenido**:
- `README.md`: qué hace la función, trigger, runtime, dependencias
- `events.md`: schemas de eventos (input/output), ejemplos de payloads
- `decisions.md` (opcional): decisiones técnicas locales

---

### `docs/functions/overview.md`

**Propósito**: Mapa global de funciones y cómo se relacionan.

**Contenido**:
- Tabla de funciones: nombre, trigger, runtime, propósito
- Diagrama de flujo de eventos
- Dependencias entre funciones (función A → cola SQS → función B)

---

## 🚀 Inicialización

```bash
# Inicializar estructura base desde la raíz del repositorio FlowDocs
./reference/serverless/scripts/init-serverless.sh mi-proyecto

# O crear manualmente la estructura de funciones
mkdir -p functions/{upload,resize,thumbnail}/docs
mkdir -p infrastructure/terraform
mkdir -p shared/{types,utils}
```

**Nota**: La carpeta `templates/` contiene **ejemplos de referencia**, no los templates oficiales. Los templates reales están en `docs/templates/` (ver ADR-007).

**Ver script**: `scripts/init-serverless.sh`

---

## 📊 Ejemplo: image-processor

Pipeline de procesamiento de imágenes: upload → resize → thumbnail, todo disparado por eventos S3.

```
image-processor/
├── .agent/
│   └── context.md
├── functions/
│   ├── upload/                   ← S3 trigger, genera job de procesamiento
│   │   ├── index.ts              ← Handler: PUT → SQS
│   │   ├── package.json
│   │   └── docs/
│   │       ├── README.md         ← Trigger: S3 ObjectCreated
│   │       └── events.md         ← Schema del evento S3
│   ├── resize/                  ← Lambda + Sharp, redimensiona imágenes
│   │   ├── index.ts              ← Handler: SQS → Sharp → S3 (output)
│   │   ├── package.json
│   │   └── docs/
│   │       ├── README.md         ← Trigger: SQS queue
│   │       └── events.md         ← Schema del mensaje SQS
│   └── thumbnail/                ← Genera thumbnails
│       ├── index.ts              ← Handler: S3 ObjectCreated (output bucket)
│       ├── package.json
│       └── docs/
│           └── README.md
├── infrastructure/
│   └── terraform/
│       ├── main.tf               ← S3 buckets, SQS, Lambda permissions
│       ├── variables.tf          ← Bucket names, region, memory
│       └── outputs.tf            ← Bucket ARNs, queue URLs
├── shared/
│   ├── types/
│   │   └── events.ts             ← Tipos de eventos (S3Event, SQSMessage)
│   └── utils/
│       └── logger.ts             ← Logger común
├── docs/
│   ├── PRD.md                    ← Requisitos del producto
│   ├── RFC.md                    ← Decisiones (Lambda vs Fargate, etc.)
│   ├── arquitectura.md           ← Diagrama: S3 → Lambda → SQS → Lambda
│   └── functions/
│       ├── overview.md           ← Mapa de las 3 funciones
│       └── events-flow.md        ← Cómo se encadenan
├── openspec/changes/
│   └── prd-rfc-image-processor/
│       ├── 001-proposal.md
│       ├── 003-design.md
│       └── 004-tasks.md
├── scripts/
│   └── init-serverless.sh
└── serverless.yml                ← Config serverless framework
```

### Flujo de eventos

```
[Usuario sube imagen]
       ↓
S3 bucket (input) ──trigger──> [upload function]
       ↓                           ↓
       │                      genera job en SQS
       ↓                           ↓
S3 bucket (output) <──write── [resize function]
       ↓
       ├──trigger──> [thumbnail function]
                          ↓
                    S3 bucket (thumbnails)
```

---

## 🧩 Documentación por Función

Cada función es una unidad independiente. Su documentación vive junto al código, bajo `functions/<name>/docs/`.

```
functions/resize/
├── index.ts
├── package.json
└── docs/
    ├── README.md           ← Overview: qué hace, trigger, runtime
    ├── events.md           ← Schemas de input/output, ejemplos
    └── decisions.md        ← (opcional) Decisiones locales
```

**Contenido mínimo de `README.md`**:
- Nombre y propósito (1-2 oraciones)
- Trigger (S3, API GW, SQS, cron, HTTP)
- Runtime y versión (Node.js 20, Python 3.12)
- Timeout y memoria configurados
- Env vars requeridas
- Dependencias a otras funciones o recursos
- Owner

---

## ⚠️ Cuándo Usar Esta Estructura

| Caso | Usar Esta Estructura |
|------|---------------------|
| **Event-driven** | ✅ Sí |
| **Tráfico variable o impredecible** | ✅ Sí |
| **Costo por uso (pay-per-execution)** | ✅ Sí |
| **Sin gestión de servidores** | ✅ Sí |
| **Pipelines de procesamiento** | ✅ Sí |
| **Cron jobs aislados** | ✅ Sí |
| **Baja latencia consistente requerida** | ❌ Usar monolitico/microservicios |
| **Proceso pesado y continuo** | ❌ Usar microservicios |
| **Estado en memoria entre requests** | ❌ Functions son stateless |

---

## ⚠️ Cuándo NO Usar Esta Estructura

| Caso | Usar En Su Lugar |
|------|------------------|
| **Una sola app con estado** | `monolitico/` |
| **Servicios con DB propia y deploy independiente** | `microservicios/` |
| **Web + mobile + api compartiendo código** | `monorepo/` |

---

## ✅ Ventajas

| Ventaja | Descripción |
|---------|-------------|
| **Sin server management** | El cloud escala y mantiene la infra |
| **Escalado automático** | De 0 a N ejecuciones simultáneas |
| **Pago por uso** | Solo pagás las ejecuciones reales |
| **Deploy rápido** | Cada función se deploya independientemente |
| **Aislamiento** | Una función no rompe las otras |

---

## ⚠️ Consideraciones

| Consideración | Solución |
|---------------|----------|
| **Cold starts** | Provisioned concurrency para funciones críticas |
| **Vendor lock-in** | Usar `shared/` para abstraer interfaces cloud |
| **Testing local complejo** | `infrastructure/docker/local-dev/` para emular triggers |
| **Límites de ejecución** | Timeout, memoria máx: documentar en `README.md` |
| **Observabilidad** | Centralizar logs y traces (X-Ray, Datadog) |
| **Coordinación** | `docs/functions/events-flow.md` para mapear dependencias |

---

## 🛠️ Proveedores y Frameworks

| Proveedor | Framework Recomendado | IaC |
|-----------|----------------------|-----|
| **AWS** | Serverless Framework, SAM, CDK | Terraform, CDK |
| **GCP** | Functions Framework | Terraform |
| **Azure** | Serverless Framework | Terraform, Bicep |
| **Vercel** | Vercel CLI (Functions) | Vercel config |
| **Netlify** | Netlify CLI (Functions) | Netlify config |
| **Cloudflare** | Wrangler (Workers) | Wrangler config |
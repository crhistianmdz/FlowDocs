# Estructura - Serverless

## Estructura de Proyecto

```
mi-proyecto/
├── .agent/
│   └── context.md
├── functions/               ← Funciones serverless
│   ├── auth/
│   │   ├── index.ts         ← Handler
│   │   ├── package.json
│   │   └── docs/
│   ├── users/
│   │   ├── index.ts
│   │   ├── package.json
│   │   └── docs/
│   └── orders/
│       ├── index.ts
│       ├── package.json
│       └── docs/
├── infrastructure/          ← IaC
│   ├── terraform/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── docker/
│       └── local-dev/      ← Para testing local
├── shared/                 ← Código compartido
│   ├── types/
│   └── utils/
├── docs/
│   ├── PRD.md
│   ├── RFC.md
│   └── functions/
├── openspec/
└── serverless.yml          ← Config serverless
```

## Cuándo Usar Serverless

| Caso | Respuesta |
|------|-----------|
| Traffic variable | ✅ Sí |
| Costo por uso | ✅ Sí |
| Sin gestión de servidores | ✅ Sí |
| Rápido desarrollo | ✅Sí |
| Baja latencia requerida | ❌ No usar |
| Proceso pesado continuo | ❌ No usar |

## Pros y Contras

| Pros | Contras |
|------|----------|
| Sin server management | Cold starts |
| Escalado automático | Vendor lock-in |
| Pago por uso | Testing local complejo |
| Deploy rápido | Límites de ejecución |

## Proveedores y Frameworks

| Proveedor | Framework Recomendado |
|-----------|----------------------|
| AWS | Serverless Framework, SAM, CDK |
| GCP | Functions Framework |
| Azure | Serverless Framework |
| Vercel | Vercel CLI (Functions) |
| Netlify | Netlify CLI (Functions) |
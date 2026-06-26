# ADR-006: Cuatro Arquitecturas Soportadas

**Fecha**: 2026-05-29  
**RFC relacionado**: Ninguno (decisión de diseño del framework)  
**Estado**: Aceptado

---

## Contexto

El framework de trabajo está diseñado para adaptarse a distintos tipos de proyectos y equipos. No existe una única estructura que funcione para todos los casos. Un proyecto frontend-only tiene necesidades distintas a un sistema de microservicios con múltiples equipos.

Los equipos que adopten el framework necesitan:
- Estructura clara que matches su arquitectura de software
- Documents que reflejen su realidad (endpoints, schemas, contracts)
- Capacidad de escalar la estructura si el proyecto crece

---

## Decisión

El framework soporta **cuatro arquitecturas** predefinidas, cada una con su propia estructura de `docs/`, templates y scripts de inicialización.

### Las 4 Arquitecturas

| Arquitectura | Cuándo usar | Estructura docs/ |
|--------------|-------------|------------------|
| **Monolítico** | Frontend-only, backend único, < 5 personas | `docs/` plana |
| **Microservicios** | Múltiples servicios, equipos por módulo, DB separadas | `docs/SHARED/` + `docs/<modulo>/` |
| **Monorepo** | Múltiples paquetes/apps en un repo | Paquetes en `packages/` |
| **Serverless** | Funciones en la nube, tráfico variable | `functions/` + `infrastructure/` |

### Arquitectura Híbrida (Adaptable)

**No estás limitado a elegir una sola arquitectura.** Tu proyecto real probablemente es una mezcla:

| Ejemplo | Descripción |
|---------|-------------|
| **Monolítico con módulos** | Un codebase pero con módulos claros que podrían separarse |
| **Monorepo + Microservicios** | Algunos módulos son services separados |
| **Monolítico + Serverless** | API principal monolítica + funciones lambdas para tareas específicas |
| **Backend monolítico + Frontend separado** | API REST única + múltiples frontends |

**Regla**: Usa la estructura que mejor matches tu proyecto real. Si es híbrido, documentá por qué en tu `docs/architecture/`.

Para equipos starting nuevo: elegí la estructura que más se acerque a tu realidad y adaptá según necesites.

---

## Criterios de Selección

### Monolítico ✅ Ideal para:

| Criterio | Threshold |
|----------|-----------|
| Tamaño equipo | 1-10 personas |
| Complejidad | Un solo codebase |
| Base de datos | Una DB compartida |
| Deployment | Un seul deploy |
| Cambios | La mayoría cruza todo el sistema |

**Ejemplos**: App web SPA, API REST simple, herramienta CLI

---

### Microservicios ✅ Ideal para:

| Criterio | Threshold |
|----------|-----------|
| Tamaño equipo | 5+ personas |
| Complejidad | Múltiples servicios independientes |
| Base de datos | Una por servicio (o compartido con límites) |
| Deployment | Deploy independiente por servicio |
| Cambios | Los cambios son por módulo, no por sistema |

**Ejemplos**: E-commerce (auth, inventory, orders, payments como servicios separados)

---

### Monorepo ✅ Ideal para:

| Criterio | Threshold |
|----------|-----------|
| Tamaño equipo | 3+ personas |
| Stack | Múltiples paquetes (web + mobile + shared) |
| Base de datos | Compartida o por paquete |
| Deployment | Múltiples apps desde un repo |
| Compartición | Código compartido entre packages |

**Ejemplos**: React Native app + web app + shared utilities

---

### Serverless ✅ Ideal para:

| Criterio | Threshold |
|----------|-----------|
| Tipo workload | Funciones event-driven |
| Tráfico | Variable o impredecible |
| Scaling | Automático |
| Budget | Pay-per-use preferido |

**Ejemplos**: APIs basadas en Lambda/Cloud Functions, webhooks, event processors

---

## Estructura de Carpetas por Arquitectura

### Monolítico

```
<proyecto>/
├── docs/
│   ├── PRD.md
│   ├── architecture/adr/
│   ├── api/endpoints.md
│   ├── database/schema.md
│   └── tasks/HU-*.md
├── .agent/context.md
└── src/
```

### Microservicios

```
<proyecto>/
├── docs/
│   ├── SHARED/                 ← Contratos globales, RFCs compartidos
│   │   ├── PRD.md
│   │   ├── contratos.md
│   │   └── architecture/
│   ├── auth-service/           ← Cada servicio autocontenido
│   │   ├── API/
│   │   ├── DB/
│   │   └── tasks/
│   ├── inventory-service/
│   └── orders-service/
├── .agent/context.md
└── src/
    ├── auth-service/
    ├── inventory-service/
    └── orders-service/
```

### Monorepo

```
<proyecto>/
├── packages/
│   ├── shared/                 ← Paquetes compartidos
│   ├── web-app/                ← Web application
│   └── mobile-app/             ← Mobile application
├── docs/
│   ├── PRD.md
│   ├── architecture/
│   ├── api/
│   └── tasks/
├── .agent/context.md
└── package.json (root workspace)
```

### Serverless

```
<proyecto>/
├── functions/                  ← Funciones serverless
│   ├── auth/
│   ├── users/
│   └── orders/
├── infrastructure/             ← IaC (Terraform, CDK, etc.)
│   └── terraform/
├── shared/                      ← Código compartido entre funciones
├── docs/
│   ├── PRD.md
│   ├── architecture/
│   ├── api/
│   └── tasks/
└── serverless.yml
```

---

## Reglas de Transición

| Transición | Posible | Cómo |
|------------|--------|------|
| Monolítico → Microservicios | ✅ Sí | Cuando hay equipos separados por módulo |
| Monolítico → Monorepo | ✅ Sí | Cuando se agregan múltiples apps |
| Microservicios → Monorepo | ❌ No | Estructuras diferentes |
| Cualquiera → Serverless | ⚠️ Parcial | Requiere re-arquitectura |

**Nota**: Crecer de monolítico a microservicios es una decisión grande. Documentar con ADR si ocurre.

---

## Consecuencias

### ✅ Positivo

- Framework adaptable a cualquier tipo de proyecto
- El equipo elige la estructura que matches su realidad
- Los templates de cada arquitectura incluyen ejemplos relevantes
- Scripts de inicialización automatizan el setup

### ❌ Negativo

- Más documentación para mantener (4 arquitecturas vs 1)
- El nuevo equipo podría confuse al elegir arquitectura
- Algunas secciones de templates se repiten entre arquitecturas

### 🔄 Neutral

- La elección de arquitectura es al inicio, pero se puede adaptar después
- El SDD workflow es idéntico independientemente de la arquitectura

---

## Documentos Relacionados

| Documento | Ubicación |
|-----------|-----------|
| Guía Monolítico | `reference/monolitico/estructura.md` |
| Guía Microservicios | `reference/microservicios/estructura.md` |
| Guía Monorepo | `reference/monorepo/estructura.md` |
| Guía Serverless | `reference/serverless/estructura.md` |
| Inicialización Monolítico | `reference/monolitico/scripts/init-monolith.sh` |
| Inicialización Microservicios | `reference/microservicios/scripts/init-microservices.sh` |
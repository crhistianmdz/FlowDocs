# AGENTS.md - Restaurant App (Equipo Distribuido)

**Proyecto**: Sistema de gestión para restaurante
**Equipo**: 4 desarrolladores en diferentes países
**Stack**: Backend .NET, Frontend Angular, Mobile Flutter

---

## Stack y Tecnologías

### Backend
- Framework: .NET 8
- ORM: Entity Framework Core
- Base de datos: PostgreSQL (producción), SQLite (dev)
- API: REST con Swagger/OpenAPI
- Auth: JWT

### Frontend Web
- Framework: Angular 17+
- Estado: Signals
- UI: TailwindCSS
- Host: https://restaurant-web.com

### Mobile (Flutter)
- Estado: BLoC
- API: Mismo backend REST
- Push Notifications: Firebase

---

## Estructura del Proyecto

```
restaurant-app/
├── backend/
│   ├── src/
│   │   ├── Restaurant.Api/        # Controllers, DTOs
│   │   ├── Restaurant.Core/       # Domain entities, interfaces
│   │   ├── Restaurant.Infrastructure/ # EF, external services
│   │   └── Restaurant.Application/ # Use cases, services
│   └── tests/
├── web/
│   ├── src/app/
│   │   ├── features/              # Features por módulo
│   │   ├── shared/                # Componentes compartidos
│   │   └── core/                  # Auth, interceptors, services
│   └── src/
└── mobile/
    ├── lib/
    │   ├── features/              # Screens y lógica
    │   ├── core/                  # API client, auth
    │   └── shared/                # Widgets compartidos
    └── test/
```

---

## Fuentes de Verdad

### RFC (Decisiones Técnicas)
@docs/RFC.md

**Resumen de decisiones técnicas:**
- Auth: JWT con refresh tokens (RFC-001)
- Database: PostgreSQL con Entity Framework (RFC-002)
- API: REST con OpenAPI/Swagger (RFC-003)
- Frontend: Angular 17 con Signals (RFC-004)
- Mobile: Flutter con BLoC (RFC-005)

### PRD (Requisitos de Producto)
@docs/PRD.md

**Resumen de requisitos:**
- 1000 usuarios concurrentes
- Soporte web + móvil
- Sistema de reservas con confirmación automática
- Gestión de inventario en tiempo real
- Reportes y métricas

---

## Documentación de Referencia

### Arquitectura
@docs/arquitectura.md              ← Diagrama de componentes
@docs/estructura-capas.md          ← Clean Architecture explained

### API
@docs/api/endpoints.md             ← Todos los endpoints REST
@docs/api/modelos.md                ← DTOs y contratos

### Base de Datos
@docs/database/esquema.md          ← Diagramas ER
@docs/database/migraciones.md      ← Historia de migrations

### Frontend Web
@docs/frontend/vistas.md            ← Wireframes, layouts
@docs/frontend/componentes.md       ← Biblioteca de componentes

### Mobile
@docs/mobile/pantallas.md           ← Screens y flujos
@docs/mobile/navegacion.md          ← Navigation graph

### Convenciones de Código
@docs/standards/codigo-estandar.md  ← Reglas del equipo
@docs/standards/patrones.md         ← Patrones usados

---

## Workflow del Equipo

### Ciclo de Trabajo: 15 Días Útiles

| Fase | Días | Actividades |
|------|------|-------------|
| **Planning & Contract** | 1-2 | Feature list collab, task contract, dependency map, DoD |
| **Execution** | 3-11 | Async updates (diario), weekly sync (día 7) |
| **Integration & Verify** | 12-14 | Integration review, testing conjunto |
| **Retrospective** | 15 | Lessons learned, documentación |

### Comunicación

- **Daily async**: Update de 1 línea en Slack antes de las 12:00 UTC
  ```
  Formato: Feature X: [en progreso/bloqueado/completado] | Bloqueado: sí/no
  ```
- **Weekly sync**: 30 min (día 7 del ciclo)
- **Regla clave**: SI ESTÁS BLOQUEADO, AVISAR INMEDIATAMENTE - no esperar al weekly

### Definition of Done (DoD)

- [ ] Código escrito y funcionando
- [ ] Tests unitarios pasando
- [ ] Code review aprobada (mínimo 1 reviewer)
- [ ] Desplegado a staging
- [ ] Un teammate que NO escribió el código lo probó

---

## SDD Configuration

### Artifact Store
- **Mode**: `hybrid` (archivos + engram)
- **Por qué**: Permite trabajo equipo (openspec) + recuperación (engram)

### Commands SDD
- `/sdd-init` → Inicializar proyecto SDD
- `/sdd-new <nombre>` → Crear nuevo change (explore + propose)
- `/sdd-continue <nombre>` → Continuar fase siguiente
- `/sdd-apply <nombre>` → Implementar tareas
- `/sdd-verify <nombre>` → Validar contra specs
- `/sdd-archive <nombre>` → Archivar change completado

### Ubicación de Specs
- Specs existentes: `openspec/specs/{domain}/spec.md`
- Changes activos: `openspec/changes/{change-name}/`
- Templates SDD: `/home/kaito/Documentos/plantillas-sdd/`

---

## Comandos del Proyecto

### Backend (.NET)
```bash
dotnet run                  # Levantar API
dotnet test                 # Tests unitarios
dotnet ef migrations add    # Crear migración
dotnet ef database update   # Aplicar migraciones
```

### Frontend Web (Angular)
```bash
npm run start              # Dev server
npm run build              # Production build
npm run test               # Unit tests
npm run test:watch         # Unit tests watch
npm run e2e                # E2E tests
```

### Mobile (Flutter)
```bash
flutter run                # Run en device/emulator
flutter test               # Unit tests
flutter build apk          # Build Android
```

---

## Reglas de Código del Equipo

### Estándar SDD
- Cada feature nuevo sigue el ciclo: proposal → spec → design → tasks → apply
- NO se escribe código antes de tener proposal aprobado
- NO se hace merge sin specs escritas

### Clean Architecture
- Domain layer: SIN dependencias externas
- Application layer: usa Domain interfaces
- Infrastructure: implementa Domain interfaces
- Controllers: solo orquestan, SIN lógica de negocio

### Git Flow
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

### Code Review Rules
- Mínimo 1 aprobación requerida
- NO self-merge
- Reviewer debe probar el cambio localmente
- Si el cambio es >400 líneas, solicitar más reviewers

---

## Equipo

| Rol | Nombre | Zona Horaria | Especialidad | Contacto |
|-----|--------|--------------|--------------|----------|
| Backend Lead | Juan | UTC-3 (Argentina) | .NET, API, PostgreSQL | @juan |
| Frontend Lead | María | UTC+1 (España) | Angular, Signals | @maria |
| Mobile Lead | Pedro | UTC-5 (Colombia) | Flutter, Firebase | @pedro |
| Fullstack | José | UTC+0 (UK) | General, DevOps | @jose |

### Regla de Dependencias
Cuando una tarea depende de otra persona:
1. Documentar la dependencia en el task contract
2. Mencionar al responsable con @ en async updates
3. Si pasan más de 24h bloqueado, escalar al weekly sync

---

## Notas Importantes para OpenCode

1. **WorkAsync-First**: El equipo no está en la misma timezone. Preferir documentación escrita sobre reuniones.

2. **API-First**: Para proyectos con web + móvil, SIEMPRE definir la API antes de desarrollar frontends. Un solo backend, múltiples consumidores.

3. **Contract Before Code**: Nunca iniciar implementación sin tener el task contract definido (owner, deadline, dependencies, done when).

4. **Feature Flags**: Usar feature flags para deployments graduales y trabajo paralelo seguro.

5. **Testing**: Mínimo 80% coverage en domain layer. Tests de integración para APIs.
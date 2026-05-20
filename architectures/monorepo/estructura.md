# Estructura - Monorepo

## Estructura de Proyecto

```
mi-proyecto/
├── .agent/
│   └── context.md
├── packages/
│   ├── shared/              ← Paquetes compartidos
│   │   ├── ui/             ← Componentes UI
│   │   ├── utils/          ← Utilidades
│   │   └── types/          ← Tipos TS
│   ├── web/                ← App web principal
│   │   ├── src/
│   │   ├── docs/
│   │   └── package.json
│   ├── mobile/             ← App móvil
│   │   ├── lib/
│   │   ├── docs/
│   │   └── pubspec.yaml
│   └── api/                ← API shareada
│       ├── src/
│       ├── docs/
│       └── package.json
├── tools/                  ← Scripts y tooling
├── docs/
│   ├── PRD.md
│   ├── RFC.md
│   └── shared/
├── openspec/
├── package.json            ← Root workspace
└── turbo.json              ← Turborepo config (si aplica)
```

## Cuándo Usar Monorepo

| Caso | Respuesta |
|------|-----------|
| Múltiples apps (web + móvil) | ✅ Sí |
| Paquetes reutilizables | ✅ Sí |
| Código compartido entre proyectos | ✅ Sí |
| Equipos trabajando en diferentes apps | ✅ Sí |
| Proyecto simple (1 app) | ❌ No usar |

## Pros y Contras

| Pros | Contras |
|------|----------|
| Código compartido | Complejidad de build |
| Una fuente de truth | Learning curve |
| Difusión de cambios fácil | Puede generar acoplamiento |

## Tools Comunes

- Turborepo
- Nx
- Lerna
- Yarn workspaces
- NPM workspaces
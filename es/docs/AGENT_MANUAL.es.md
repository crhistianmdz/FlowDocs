# Manual del Agente — FlowDocs

> Cuando dudés con la documentación, empezá por acá.

---

## Regla de oro

**¿No sabés qué hacer? → Preguntá al developer. Sin adivinar. Sin asumir.**

---

## Arquitectura Overview

FlowDoc usa una **arquitectura de especialistas** donde un orquestador coordina skills especializados:

```
flowdoc-assist (ORQUESTADOR)
├── flowdoc-discover   (investigación)
├── flowdoc-prd       (documentos PRD)
├── flowdoc-rfc       (documentos RFC)
├── flowdoc-adr       (documentos ADR)
├── flowdoc-api       (documentación de API)
├── flowdoc-db        (documentación de schema DB)
├── flowdoc-hu        (user stories + post-dev)
└── flowdoc-review    (validación)
```

**Orquestador** (`flowdoc-assist`): Coordina especialistas, mantiene registro de sesión en `docs/.flowdoc/sessions/`

**Especialistas**: Cada uno maneja un tipo de documento. Pueden invocarse directamente o a través del orquestador.

---

## Árbol de decisiones

```
¿Necesitás documentar algo?
│
├── Usar el orquestador flowdoc-assist
│   └── "adopt flowdocs" o "help me document"
│
├── Documento específico?
│   ├── PRD → flowdoc-prd
│   ├── RFC → flowdoc-rfc
│   ├── ADR → flowdoc-adr
│   ├── Docs de API → flowdoc-api
│   ├── Schema de DB → flowdoc-db
│   └── User story / HU → flowdoc-hu
│
├── ¿Validar docs existentes?
│   └── flowdoc-review
│
└── ¿No sabés qué necesitás?
    └── flowdoc-discover (investiga proyecto, recomienda especialistas)
```

---

## Quick Reference

| Situación | Acción | Especialistas |
|-----------|--------|---------------|
| Empezar documentación desde cero | Ejecutar `flowdoc-assist` | orquestador |
| Investigar proyecto existente | `flowdoc-discover` | discover |
| Requerimientos de producto | Crear/actualizar PRD | `flowdoc-prd` |
| Propuesta técnica (bajo discusión) | Crear RFC | `flowdoc-rfc` |
| Decisión técnica (aprobada) | Crear ADR | `flowdoc-adr` |
| Endpoints de API | Documentar desde código | `flowdoc-api` |
| Schema de base de datos | Documentar desde código | `flowdoc-db` |
| User story / feature | Crear/actualizar HU | `flowdoc-hu` |
| HU completada, documentar lo hecho | Post-dev update | `flowdoc-hu` |
| Validar toda la documentación | Ejecutar validación | `flowdoc-review` |

---

## Invocación de Especialistas

### Via Orquestador (recomendado)
```
Usuario: "adopt flowdocs"
     → flowdoc-assist orquesta todo
     → Especialistas corren en secuencia
     → flowdoc-review valida
```

### Especialista directo
```
Usuario: "creame un ADR para auth"
     → flowdoc-adr invocado directamente
     → Puede invocar flowdoc-discover si necesita
```

### Especialista + Review
```
Usuario: "creame ADR + review"
     → flowdoc-adr invocado
     → flowdoc-review valida
```

---

## Estados de documentos

### ADR / RFC
```
Draft → In Review → Accepted
                      ↓
                 Deprecated (si se reemplaza)
```

### Reglas
- **ADR en Draft > 1 mes**: Preguntá al dev — decisión trabada
- **RFC en Review > 2 semanas**: Preguntá al dev — no hay consenso
- **¿No sabés el estado?**: Preguntá al dev

---

## Registro de Sesión

Cada sesión genera un registro en `docs/.flowdoc/sessions/`:

```
docs/.flowdoc/sessions/
├── 2026-08-05_1430_register.json
└── ...
```

Este directorio está **en .gitignore**. Registra:
- Especialistas invocados
- Documentos creados/actualizados
- Issues encontrados
- Actualizaciones pendientes

---

## Convenciones de nombre

```
NNN-nombre-descriptivo.md
```

| Tipo | Ejemplo |
|------|---------|
| ADR | `001-auth-jwt.md` |
| RFC | `001-auth-jwt-proposal.md` |
| HU | `HU-001-login.md` |

- NNN = número correlativo (ver último en la carpeta)
- Nombre = kebab-case, descriptivo
- Sin espacios, sin tildes

---

## Formato mínimo obligatorio

### ADR
```markdown
# ADR-NNN: Título

- **Fecha**: YYYY-MM-DD
- **Estado**: Accepted | Deprecated
- **Contexto**: Por qué se tomó esta decisión
- **Decisión**: Qué se decidió
- **Consecuencias**: Pros y contras
```

### RFC
```markdown
# RFC-NNN: Título

- **Autor**: Tu nombre
- **Estado**: Draft | In Review
- **Problema**: Qué problema resuelve
- **Solución Propuesta**: Tu propuesta
- **Preguntas Abiertas**: Qué falta definir
```

---

## No hagas esto

- ❌ Modificar `docs/` sin approval del dev
- ❌ Crear ADR sin RFC previo (a menos que el dev lo pida)
- ❌ Borrar documentación existente
- ❌ Actualizar ADR deprecated (creá uno nuevo)
- ❌ Inventar convenciones que no existen
- ❌ El especialista de API tocar el PRD (reporta al orquestador en cambio)

---

## Cuando actualizás documentación

**Regla**: Los docs se actualizan en el MISMO PR que cambia el código.

```
Si hacés un cambio en el código → Actualizá los docs en ese mismo PR
```

No hagas PR separado para docs.

---

## Checklist antes de commit

- [ ] ¿Usaste el especialista correcto?
- [ ] ¿El documento sigue el formato del template?
- [ ] ¿El registro de sesión está actualizado?
- [ ] ¿Se ejecutó flowdoc-review?
- [ ] ¿Hay algo para preguntarle al dev?

---

## Cuando todo falla

1. Leé `docs/anti-patrones.md` — puede estar descripto ahí
2. Leé `docs/troubleshooting.md` — problemas comunes y soluciones
3. **Preguntá al developer** — no adivines

---

## Referencia de Skills

| Skill | Propósito | Invoca a |
|-------|-----------|----------|
| `flowdoc-assist` | Orquestador | Todos los especialistas |
| `flowdoc-discover` | Investigación | — |
| `flowdoc-prd` | Documentos PRD | discover |
| `flowdoc-rfc` | Documentos RFC | discover |
| `flowdoc-adr` | Documentos ADR | discover |
| `flowdoc-api` | Docs de API | discover |
| `flowdoc-db` | Schema de DB | discover |
| `flowdoc-hu` | User stories | adr (si hay nueva decisión) |
| `flowdoc-review` | Validación | — |

---

## Ver también

- `docs/architecture/rfc/005-specialist-architecture.md` — Arquitectura completa de especialistas
- `docs/architecture/adr/013-specialist-orchestrator-architecture.md` — ADR del orquestador
- `docs/architecture/adr/014-session-register-location.md` — ADR del registro
- `docs/anti-patrones.md` — Señales de que algo está mal
- `docs/troubleshooting.md` — Problemas y soluciones
- `docs/templates/` — Templates para cada tipo de documento

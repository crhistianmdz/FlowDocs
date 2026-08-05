# RFC 005: Arquitectura de Especialistas de FlowDoc

- **Estado**: Borrador
- **Autor**: Kaito
- **Fecha**: 2026-08-05

---

## 1. Resumen

Propuesta para dividir `flowdoc-assist` en un orquestador que coordine skills especializadas, cada una experta en su dominio documental. El orquestador mantiene el diálogo, detecta qué necesita el proyecto y delega al especialista correspondiente.

## 2. Contexto

El skill `flowdoc-assist` actual es monolítico — maneja descubrimiento, propuesta, ejecución y validación en un solo skill. Si bien funciona, esto genera problemas:

- Difícil probar fases individuales de forma independiente
- No es posible la ejecución en paralelo
- El usuario no puede invocar un solo especialista directamente
- Difícil de mantener y extender

El objetivo es descomponer en skills especializadas y componibles que puedan trabajar juntas bajo un orquestador o de forma independiente.

## 3. Arquitectura de Componentes

```
┌─────────────────────────────────────────────────────────────┐
│  flowdoc-assist (ORQUESTADOR)                               │
│  - Mantiene el diálogo con el usuario                       │
│  - Detecta las necesidades del proyecto                     │
│  - Decide qué especialistas invocar                          │
│  - Coordena ejecución secuencial y paralela                 │
│  - Hace checkpoint antes de lanzar en paralelo              │
│  - Mantiene el registro de sesión en docs/.flowdoc/sessions/ │
│  - Puede trabajar solo o con especialistas                   │
└─────────────────────────────────────────────────────────────┘
          │
          ├──► flowdoc-discover   (investigación profunda)
          ├──► flowdoc-prd       (PRD: crea y actualiza)
          ├──► flowdoc-rfc       (RFC: crea, actualiza, cierra)
          ├──► flowdoc-adr       (ADR: crea, actualiza, deprecia)
          ├──► flowdoc-api       (API: solo documenta)
          ├──► flowdoc-db        (DB: solo documenta esquema)
          ├──► flowdoc-hu        (HU + documentación post-desarrollo)
          └──► flowdoc-review    (validación después de especialistas)
```

## 4. Responsabilidades de los Especialistas

| Especialista | Crea | Actualiza | Elimina | Alcance |
|-------------|------|-----------|---------|---------|
| `flowdoc-prd` | ✅ | ✅ | ❌ | Inicial y existente |
| `flowdoc-rfc` | ✅ | ✅ | Cierra | Inicial y existente |
| `flowdoc-adr` | ✅ | ✅ | Deprecia | Inicial y existente |
| `flowdoc-api` | ✅ | ✅ | ❌ | Solo documenta desde código |
| `flowdoc-db` | ✅ | ✅ | ❌ | Solo documenta desde código |
| `flowdoc-hu` | ✅ | ✅ | ❌ | Basado en HU + cambios realizados |
| `flowdoc-review` | ❌ | Sugiere correcciones | ❌ | Valida formato y templates |

## 5. Registro de Sesión

Cada sesión genera un archivo de registro:

```
docs/.flowdoc/sessions/
├── 2026-08-05_1430_register.json
├── 2026-08-05_1600_register.json
└── ...
```

**Ubicación**: `docs/.flowdoc/` (debe estar en `.gitignore`)

**Esquema del registro**:
```json
{
  "session": {
    "id": "2026-08-05_1430",
    "startedAt": "2026-08-05T14:30:00Z",
    "endedAt": "2026-08-05T15:45:00Z",
    "duration": "1h 15m",
    "trigger": "adopt-flowdocs | HU-001 | flowdoc-adr | manual"
  },
  "context": {
    "projectPath": "/path/to/project",
    "language": "es | en",
    "architecture": "monolith | microservices | monorepo | serverless",
    "scope": "adoption | new-hu | update-hu | maintenance"
  },
  "invokedSpecialists": [
    {
      "name": "flowdoc-discover",
      "status": "completed | failed | skipped",
      "contextGathered": {
        "stack": ["Node.js", "PostgreSQL"],
        "decisionsFound": ["auth", "database"],
        "existingDocs": ["docs/PRD.md"]
      },
      "duration": "2m"
    }
  ],
  "documents": {
    "created": [
      {
        "path": "docs/PRD.md",
        "specialist": "flowdoc-prd",
        "template": "docs/templates/PRD/PRD_template.md"
      }
    ],
    "updated": [
      {
        "path": "docs/tasks/HU-001-login.md",
        "specialist": "flowdoc-hu",
        "previousCommit": "abc123",
        "template": "docs/templates/user-stories/template-user-story.md",
        "scope": "after-dev",
        "reference": "docs/tasks/HU-001-login.md (original)"
      }
    ],
    "closed": [
      {
        "path": "docs/architecture/rfc/001-auth-strategy.md",
        "specialist": "flowdoc-rfc",
        "action": "accepted | rejected | obsolete",
        "resultingAdr": "docs/architecture/adr/003-auth-jwt.md"
      }
    ]
  },
  "pendingUpdates": [
    {
      "from": "flowdoc-api",
      "reason": "API change affects PRD section 3.2",
      "requiresUpdate": ["docs/PRD.md"],
      "status": "pending | resolved | dropped"
    }
  ],
  "issues": [
    {
      "type": "format | template | ortography | context | consistency",
      "specialist": "flowdoc-review",
      "document": "docs/PRD.md",
      "description": "Missing constraints section",
      "severity": "error | warning",
      "status": "open | fixed | ignored"
    }
  ],
  "adrImpactAnalysis": [
    {
      "hu": "docs/tasks/HU-001-login.md",
      "decisionsTaken": ["JWT auth", "refresh token rotation"],
      "adrsAffected": ["docs/architecture/adr/003-auth-jwt.md"],
      "newAdrRequired": true,
      "newAdrPath": "docs/architecture/adr/005-refresh-token-rotation.md"
    }
  ],
  "summary": {
    "specialistsRun": 4,
    "documentsCreated": 3,
    "documentsUpdated": 2,
    "documentsClosed": 1,
    "issuesFound": 1,
    "issuesFixed": 1,
    "parallelExecution": false
  }
}
```

## 6. Protocolo de Comunicación

### 6.1 Orquestador → Especialista
- **Contexto base**: rutas a buscar, qué existe, referencias a templates
- **Prompt**: Contexto mínimo necesario para comenzar
- **Entrada de registro**: Qué documentación debe actualizarse después

### 6.2 Especialista → Orquestador
- **Resultado**: Documento creado/actualizado en `docs/`
- **Actualización de registro**: Notifica qué docs se actualizaron
- **Actualizaciones pendientes**: Si detecta que otro documento necesita cambios, reporta al orquestador

### 6.3 Especialista → Especialista
- **NO hay comunicación directa**
- **Si es necesario**: invoca `flowdoc-discover` para investigar
- **Si detecta impacto**: reporta al orquestador

## 7. Reglas de Ejecución en Paralelo

### Secuencial (por defecto)
Todos los especialistas se ejecutan secuencialmente para evitar conflictos.

### Paralelo permitido
Solo el especialista ADR puede paralelizar cuando:
- Todas las decisiones técnicas ya están identificadas por PRD/RFC
- Los ADR no dependen entre sí
- El orquestador hizo checkpoint antes de lanzar

### Resolución de conflictos
- El orquestador mantiene un registro de qué doc actualizó qué
- Si ADR contradice RFC → checkpoint + revisión manual
- El especialista de API NUNCA toca el PRD

## 8. Modos de Invocación

### Modo A: Orquestación completa
```
Usuario: "adopt flowdocs"
     → flowdoc-assist orquesta todos los especialistas
     → flowdoc-review valida
     → Registro actualizado
```

### Modo B: Especialista directo
```
Usuario: "creame un ADR para auth"
     → flowdoc-adr invocado directamente
     → Puede invocar flowdoc-discover si es necesario
     → Reporta al orquestador (si existe sesión)
```

### Modo C: Especialista + revisión
```
Usuario: "creame un ADR para auth + review"
     → flowdoc-adr invocado
     → flowdoc-review valida
```

## 9. Ciclo de Vida de la Documentación de HU

```
┌──────────────────────────────────────────────────────────────┐
│  HU Original                                                 │
│  (ej: HU-001-login.md)                                      │
└──────────────────────────────────────────────────────────────┘
          │
          ▼
┌──────────────────────────────────────────────────────────────┐
│  flowdoc-hu (pre-desarrollo)                                │
│  - Genera/actualiza documentación basada en HU              │
│  - PRD, RFC, ADR creados según sea necesario                │
└──────────────────────────────────────────────────────────────┘
          │
          ▼
┌──────────────────────────────────────────────────────────────┐
│  Desarrollo                                                  │
└──────────────────────────────────────────────────────────────┘
          │
          ▼
┌──────────────────────────────────────────────────────────────┐
│  flowdoc-hu (post-desarrollo)                               │
│  - Actualiza docs basándose en lo realizado                  │
│  - Referencia HU original como fuente                        │
│  - Si hay nuevas decisiones técnicas → especialista ADR      │
└──────────────────────────────────────────────────────────────┘
          │
          ▼
┌──────────────────────────────────────────────────────────────┐
│  flowdoc-review                                             │
│  - Valida todos los documentos generados                    │
│  - Formato, templates, ortografía, contexto                 │
└──────────────────────────────────────────────────────────────┘
```

## 10. Lista de Validación de Revisión

`flowdoc-review` valida:

- [ ] El formato coincide con el template de `docs/templates/`
- [ ] Secciones requeridas presentes
- [ ] Ortografía y gramática
- [ ] Contexto entendible (el agente puede continuar sin más input)
- [ ] Referencias cruzadas válidas
- [ ] Estado válido (Borrador/En Revisión/Aceptado/Depreciado)
- [ ] Nomenclatura correcta (NNN-nombre.md)
- [ ] Índice de ADR actualizado (si se creó nuevo ADR)

## 11. Referencias de Templates

Los templates viven en `docs/templates/` (fuente de verdad). Los especialistas referencian, no duplican:

| Documento | Template |
|-----------|----------|
| PRD | `docs/templates/PRD/PRD_template.md` |
| RFC | `docs/templates/architecture/RFC_template.md` |
| ADR | `docs/templates/architecture/ADR_template.md` |
| HU | `docs/templates/user-stories/template-user-story.md` |
| API | `docs/templates/api/endpoints.md` |
| DB | `docs/templates/database/schema.md` |

## 12. Dependencia de Discovery

```
┌─────────────────────────────────────────────────────────────┐
│  Especialista necesita más contexto                         │
│                                                             │
│  ¿Puede investigar solo?                                     │
│  ├── NO → Invoca flowdoc-discover                           │
│  └── SÍ → Continúa con el contexto base del orquestador    │
└─────────────────────────────────────────────────────────────┘
```

## 13. Principios de Diseño

1. **Independiente de herramientas**: FlowDoc es independiente de cualquier stack de IA (SDD, engram, etc.)
2. **Persistencia opcional**: Los documentos viven en `docs/`, el registro vive en `docs/.flowdoc/`
3. **Independencia de especialistas**: Cada skill es autocontenido e invocable directamente
4. **Sin comunicación directa entre especialistas**: Toda coordinación a través del orquestador
5. **Secuencial por defecto**: Paralelismo solo cuando es seguro (caso especialista ADR)
6. **Registro para auditoría**: Cada sesión documentada, sobrevive a reinicios de herramientas

## 14. Preguntas Abiertas

| # | Pregunta | Decisión |
|---|----------|----------|
| 1 | Mecanismo de rollback | Usar `git` para ver estado anterior |
| 2 | Política de retención del registro | Mantener todos (bajo volumen) |
| 3 | ¿Especialista puede ser invocado sin orquestador? | Sí, con contexto reducido |

---

## 15. Estado de Aprobación

| Rol | Persona | Estado | Fecha |
|------|---------|--------|-------|
| Autor | Kaito | Borrador | 2026-08-05 |
| Decisión | - | Pendiente | - |

---

## 16. Historial de Cambios

| Fecha | Cambio | Autor |
|-------|--------|-------|
| 2026-08-05 | Versión inicial | Kaito |

(Final del archivo — total 331 líneas)

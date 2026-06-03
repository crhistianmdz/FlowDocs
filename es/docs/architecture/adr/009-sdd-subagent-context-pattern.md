# ADR-009: SDD Sub-agent Context Pattern

**Fecha**: 2026-06-03
**Autor**: @author
**RFC relacionado**: Ninguno (decisión inicial)
**Estado**: Aceptado

---

## Contexto

Los sub-agents lanzados mediante el flujo SDD (`sdd-explore`, `sdd-propose`, `sdd-spec`, `sdd-design`, `sdd-tasks`, `sdd-apply`, `sdd-verify`, `sdd-archive`) arrancan **sin contexto** sobre el proyecto en el que están trabajando. No conocen el stack, las convenciones, el change activo ni las decisiones previas.

La sintaxis `@` en rutas de archivos **no** auto-carga contenido en el contexto del agent — es un mecanismo de navegación, no un mecanismo de inyección de contexto. Esto se descubrió empíricamente en la sesión `SESSION-FLOWDOC-ADOPTION-2026-06-01`.

Sin contexto, los sub-agents producen specs **genéricas** que no matchean las convenciones del proyecto, el naming, la estructura ni las decisiones previas. El orchestrator termina reescribiendo los artifacts, lo que derrota el propósito de la delegación.

Necesitamos un patrón que:

1. **Dé contexto** a los sub-agents de forma estructurada y predecible
2. Sea **portable** más allá de cualquier herramienta específica (OpenCode, ClaudeCode, Antigravity, etc.)
3. **Optimice el uso de tokens** (los sub-agents se pagan por token)
4. Permita **propagación de conocimiento** entre HUs relacionadas (decisiones tomadas en HU-A informan HU-B)

### Alternativas Consideradas

| Alternativa | Descripción | Veredicto |
|-------------|-------------|-----------|
| **Solo AGENTS.md** | Poner todo el contexto en `AGENTS.md` y que los sub-agents lo lean | Rechazado — demasiado grande, no es específico de fase, estático, infla el contexto de cada agent |
| **Inline en prompts** | Pasar todo inline en el prompt del sub-agent cada vez | Rechazado — alto costo de tokens en cada llamada, sin persistencia, sin reusabilidad |
| **Contexto dinámico generado** | Generar un archivo `sdd-context.md` por change en `/sdd-new` | **Seleccionado** — balancea tamaño, frescura, portabilidad y reusabilidad |
| **Config específica de la herramienta** | Usar el mecanismo nativo de contexto de la herramienta (ej., OpenCode agents config) | Rechazado — no es portable entre herramientas, ata el framework a un ecosistema |

---

## Decisión

El patrón seleccionado: **SDD Sub-agent Context Pattern**

### 1. Generación del Archivo

- Se genera **una vez** en `/sdd-new` (cuando arranca un nuevo change / HU)
- El archivo vive en: `openspec/changes/{change-name}/sdd-context.md`
- **Restricción dura**: 20-50 líneas como máximo
- Se genera a partir de **3 fuentes**:
  1. **AGENTS.md** (extracción selectiva de secciones: Stack, Key Paths, Conventions)
  2. **Estado del Change Activo** (provisto por el orchestrator: nombre, fase, artifacts completados)
  3. **Punteros a Engram** (top 3-5 topic keys relevantes vía `mem_search`)
- **Sin** dependencia de skill-registry (debe funcionar sin la infraestructura de OpenCode)
- **Sin** escaneo del repo (AGENTS.md ya declara las paths core)
- Costo estimado de generación: ~1200 tokens; costo típico de ciclo: ~4-5K tokens

### 2. Estructura del Archivo

```markdown
# SDD Context — {change-name}

## Project Snapshot
[Extracted from AGENTS.md — name, type, stack, languages]

## Key Paths
[Extracted from AGENTS.md — paths to docs/, architecture/, tasks/, etc. with source note]

## Conventions
[Extracted from AGENTS.md — bilingual, conventional commits, etc.]

## Active Change
- Name: {change-name}
- Phase: {current_phase}
- Artifacts: [list of Engram topic keys for completed phases]
- Last updated: {ISO 8601 timestamp}

## Engram Pointers
[Top 3-5 topic keys from mem_search, formatted as references]

## Update Permissions
[Which agents can update — sdd-explore, sdd-design, sdd-apply — hardcoded in orchestrator logic]

## Discovery Schema
[Format for discoveries returned by authorized agents]
<!-- Format: ### [timestamp] [agent] [category] -->
<!-- Content goes here -->
```

### 3. Cómo los Sub-agents Reciben el Contexto

- **Opción C**: Contenido completo + path inyectado en el prompt del sub-agent por el orchestrator
- El sub-agent **no** escribe directo al archivo
- El sub-agent retorna los descubrimientos en su respuesta mediante un bloque estructurado:

```markdown
=== DISCOVERIES ===
### Discovery 1
- timestamp: <ISO 8601>
- agent: <sdd-explore|sdd-design|sdd-apply>
- category: <adr-applicable|convention|pattern|workaround|reference>
- summary: <max 200 chars>
- details_ref: <inline|engram:topic_key>
- details: <optional short text>
=== END DISCOVERIES ===
```

- **Formato**: Markdown (consistente con el framework; YAML/JSON rechazados por ser menos amigables para humanos)
- **Manejo de errores**: Si el bloque de descubrimientos está mal formado, el orchestrator loguea un warning y continúa (log+continue, nunca bloquear)

### 4. Lógica de Persistencia del Orchestrator

- El orchestrator parsea el bloque `DISCOVERIES` de la respuesta del sub-agent
- Para cada discovery, aplica la **regla del switch de 45 líneas**:
  - Si agregar el contenido inline entra en el cap de 20-50 líneas → agregar a `sdd-context.md`
  - Si lo excede → guardar en Engram como un topic key, agregar un puntero en `sdd-context.md`
- El orchestrator decide la ubicación (inline vs Engram) — **no** el sub-agent

### 5. R2: Propagación de Conocimiento entre HUs

Cuando una nueva HU referencia una HU archivada (vía `Related HU: HU-XXX` en el archivo de la HU), el orchestrator:

1. Busca el `sdd-context.md` archivado de la HU referenciada
2. Hereda los descubrimientos relevantes en el `sdd-context.md` de la nueva HU
3. Los sub-agents de la nueva HU heredan el conocimiento **sin redescubrirlo**

Esto crea **propagación de conocimiento entre HUs relacionadas** — la "joya" del patrón.

### 6. Lifecycle: Archivar vs Borrar

- **Opción B (conservar con el change)**: El archivo persiste con el change en `openspec/changes/{change-name}/`
- El archivo archivado se puede consultar si una nueva HU referencia al archivado
- **Sin límite de tiempo** — a criterio del equipo
- **Git commit** del archivo archivado — a criterio del equipo
- **Upload a Engram** del contexto archivado — **solo** si el proyecto usa Engram como artifact store (opt-in por proyecto)

### 7. Sistema de Configuración (`.context/`)

Sistema de archivos de configuración de dos niveles para preferencias del usuario:

**Archivos**:
- `.context/flowDocs.config.json` (project-level, commiteado a git)
- `.context/flowDocs.config.local.json` (dev-level, gitignored manualmente)

**Precedencia**: Local (dev) gana sobre project-level.

**Estructura de la config** (JSON, estricto):

```json
{
  "version": "1.0",
  "last_updated": "2026-06-03T14:30:00Z",
  "dismissed": {
    "section_key": {
      "scope": "project|session",
      "dismissed_at": "2026-06-03T14:30:00Z",
      "reason": "user_choice"
    }
  },
  "preferences": {
    "engram_upload_on_archive": true,
    "archive_time_limit_days": null,
    "commit_archived_to_git": false
  },
  "force_show": {
    "section_key": true
  }
}
```

- **Sin template automático de `.gitignore`** — documentado en la guía de implementación, recordado en el install check, ofrecido en el install script
- La entrada de `.gitignore` para agregar manualmente: `.context/*.local.json`

### 8. Manejo de Fallos

- Todas las sugerencias son **opt-in, nunca bloqueantes** (solo un fallo de escritura de archivo es un hard fail)
- **Degradación elegante**: las secciones faltantes se omiten con un warning logueado
- Para fuentes faltantes:
  - **AGENTS.md no encontrado** → fail hard con instrucción de crearlo
  - **Engram no disponible** → omitir la sección Engram Pointers, loguear un warning
  - **Engram vacío (sin resultados relevantes)** → omitir la sección silenciosamente (no es un error)
- Las sugerencias se descartan por sesión por defecto, opt-in por proyecto
- El campo `force_show` en la config sobrescribe los descartes a nivel proyecto para un dev individual

---

## Consecuencias

### ✅ Positivo

- Los sub-agents tienen contexto consistente y curado sin improvisar
- El costo de tokens está controlado (archivo de 20-50 líneas, generado una vez por change)
- El conocimiento descubierto durante una HU se propaga a HUs relacionadas (R2)
- Portable entre herramientas (OpenCode, ClaudeCode, Antigravity, etc.) — sin config específica de herramienta
- La config de dos niveles respeta tanto las preferencias del proyecto como las del dev individual
- Las sugerencias nunca bloquean el flujo del usuario — todo es opt-in

### ❌ Negativo

- Archivo adicional a mantener en la implementación del orchestrator
- El discovery schema requiere que los sub-agents formateen la salida correctamente (algo de entrenamiento necesario)
- Los archivos de config suman algo de complejidad (directorio `.context/`)
- La propagación de conocimiento R2 requiere que el orchestrator trackee las relaciones entre HUs

### 🔄 Neutral

- La restricción de 20-50 líneas requiere disciplina — si el contexto crece, hay que podarlo
- La config es JSON (no markdown) — diferente del resto del framework, pero apropiado para consumo por máquinas

---

## Configuración

### `.context/flowDocs.config.json`

Este archivo (y su contraparte `.local`) controla el descarte de sugerencias y las preferencias del usuario.

**Creación**: El orchestrator lo crea **de forma perezosa** — solo cuando el usuario descarta una sugerencia o setea una preferencia.

**Scopes**:
- `session`: Solo en memoria, se pierde cuando termina la sesión
- `project`: Persistido en `.context/flowDocs.config.json`, commiteado a git
- `local`: Persistido en `.context/flowDocs.config.local.json`, gitignored manualmente

**Precedencia**: `local` > `project` > `defaults`

**`force_show`**: Un dev puede sobrescribir un descarte a nivel proyecto seteando `force_show.section_key = true` en su config local.

---

## Decisiones Relacionadas

| ADR | Título | Relación |
|-----|--------|----------|
| ADR-001 | Persistencia Engram | Define el artifact store (Engram / openspec / hybrid) que `sdd-context.md` extiende |
| ADR-008 | Nombre FlowDoc | Establece el naming de FlowDoc que `sdd-context.md` usa |

---

## Documentos Relacionados

- `docs/observaciones/SESSION-FLOWDOC-ADOPTION-2026-06-01.md` — Justificación empírica (el hallazgo de la sintaxis `@`)
- `.atl/skill-registry.md` — Skills de SDD que usan este patrón de contexto
- `architectures/monolitico/.agent-context.md` — Descripción informal del patrón orchestrator / sub-agent
- `architectures/microservicios/.agent-context.md` — Lo mismo para la arquitectura de microservicios

---

## Checklist de Implementación

- [ ] El orchestrator genera `sdd-context.md` en `/sdd-new`
- [ ] El orchestrator inyecta el contenido + path en los prompts de los sub-agents
- [ ] El orchestrator parsea el bloque `DISCOVERIES` de las respuestas de los sub-agents
- [ ] El orchestrator implementa la regla del switch de 45 líneas
- [ ] El orchestrator busca el `sdd-context.md` archivado cuando una HU referencia una HU archivada
- [ ] El orchestrator crea `.context/flowDocs.config.json` de forma perezosa en el primer descarte
- [ ] El orchestrator lee tanto la config de proyecto como la local; gana la local
- [ ] El orchestrator ofrece opciones de descarte: `session` / `project` / `continue without`
- [ ] Documentación actualizada (este ADR, `AGENTS.md`, `skill-registry.md`, etc.)
- [ ] Install script actualizado para ofrecer agregar `.context/*.local.json` a `.gitignore`

---

**Última actualización**: 2026-06-03

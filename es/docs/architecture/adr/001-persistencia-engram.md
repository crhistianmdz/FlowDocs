# ADR-001: Persistencia con Engram para SDD Artifacts

**Fecha**: 2026-05-29  
**Autor**: @Crhistian  
**RFC relacionado**: Ninguno (decisión inicial)  
**Estado**: Aceptado

---

## Contexto

El framework SDD requiere guardar artifacts de cada fase (proposal, spec, design, tasks, verify, archive). Necesitamos un lugar persistente donde:

1. Los artifacts sobrevivan entre sesiones
2. Los agents puedan leer contexto de proyectos anteriores
3. Sea accesible independientemente de la herramienta (OpenCode o Antigravity)
4. No se pierda estado durante compactaciones de contexto

Evaluamos tres opciones:

| Opción | Ventajas | Desventajas |
|--------|----------|-------------|
| **engram** | Persistencia cross-session, búsqueda semántica, upserts | Solo local, no compartible con equipo |
| **openspec** | Archivos en git, compartible, audit trail completo | Sin búsqueda semántica, verboso |
| **hybrid** | Ambos mundos | Más complejo de configurar |

---

## Decisión

**Usamos Engram como artifact store por defecto.**

Para equipos que necesitan compartir artifacts (git-based workflow), usar `openspec` o `hybrid`.

**Rationale**:
- El caso de uso primary es **trabajo individual** con SDD
- La búsqueda semántica de Engram permite recuperar contexto de ciclos anteriores
- Los upserts permiten actualizar decisions sin duplicar
- La persistencia cross-session es crítica para no perder trabajo durante compactaciones

---

## Consecuencias

### ✅ Positivo

- Artifacts persisten entre sesiones automáticamente
- Búsqueda semántica para encontrar decisiones pasadas
- Upserts evitan duplicación de observaciones
- No requiere configuración adicional (OpenCode tiene Engram built-in)

### ❌ Negativo

- **No compartible**: otros miembros del equipo no ven los artifacts de Engram
- **Local**: cada dev tiene su propia base de Engram
- **Iteración sobreescribe**: re-ejecutar una fase sobreescribe la anterior (solo la última sobrevive)

### 🔄 Neutral

- Para equipos pequeños (1-3 personas) esto es ideal
- Para equipos grandes, la limitación es real → usar `hybrid` o `openspec`

---

## Configuración

### Modo engram (default)

```yaml
# Engram modo - solo local
artifact_store: engram
```

### Modo openspec (equipos)

```yaml
# Openspec modo - git-tracked, compartible
artifact_store: openspec
```

### Modo hybrid (mejor de ambos mundos)

```yaml
# Hybrid modo - archivos + engram recovery
artifact_store: hybrid
```

---

## Cómo Migrar entre Modos

### De engram a openspec

1. Exportar artifacts de Engram a archivos
2. Crear estructura `openspec/changes/{change-name}/`
3. Commitear a git
4. Cambiar `artifact_store: openspec`

### De openspec a engram

1. Importar artifacts de archivos a Engram (futuro: script de migración)
2. Cambiar `artifact_store: engram`
3. Los artifacts原有的 siguen disponibles en Engram

---

## Decisiones Relacionadas

| Decisión | Ubicación |
|----------|-----------|
| Estructura de artifacts SDD | `openspec/changes/{change-name}/` |
| Topic keys para Engram | `sdd/{change-name}/{phase}` |
| Artifact store mode | `openspec/config.yaml` o equivalente |
| ADR-009 | SDD Sub-agent Context Pattern | Extiende el modelo de artifact store con archivos de contexto por cambio para sub-agents |

---

## Notas

- Engram funciona tanto en OpenCode como en Antigravity (configurable)
- Para audit trail completo, usar `openspec` mode
- Engram es la **persistencia**; el **workflow** SDD es idéntico en todos los modes
# ADR-008: Nombre del Framework: FlowDoc

**Fecha**: 2026-05-29
**RFC relacionado**: Ninguno (decisión de naming)
**Estado**: Aceptado

---

## Contexto

El framework necesita un nombre oficial que lo identifique. Hasta ahora se referenciaba como "Framework SDD para equipos distribuidos" o simplemente "el framework".

Durante la sesión de documentación, surgieron dos nombres para proyectos complementarios:
- **FlowForge**: Herramienta para minimizar overhead de SDD y optimizar tiempo/recursos
- **FlowDoc**: Documentación que fluye con el trabajo

Estos dos nombres forman un ecosistema coherente.

---

## Decisión

**El framework se llama `FlowDoc`**.

```
FlowForge ──→ Minimiza overhead SDD (tool)
FlowDoc ────→ Documentación que fluye (framework)
```

### Por qué FlowDoc

| Criterio | Evaluación |
|----------|------------|
| **Descriptivo** | "Doc" = documentación, "Flow" = que fluye con el trabajo |
| **Memorable** | Corto, fácil de pronunciar, único |
| **Ecosistema** | Se complementa con FlowForge |
| **Agnóstico** | No dice "SDD" en el nombre (el framework es más que SDD) |
| **Async-first** | "Flow" sugiere ritmo sin fricción |

### Por qué NO otros nombres

| Nombre | Razón de descarte |
|--------|-------------------|
| `SDD Framework` | Demasiado técnico, excluye a no-initiados |
| `SpecOps` | Sonido a operaciones militares, poco amigable |
| `Async-First Framework` | Accurate pero muy largo |
| `SDD Async Framework` | Mezcla de términos |

---

## Relación con FlowForge

```
FlowForge + FlowDoc = Ecosistema completo

FlowForge:
- Minimiza overhead SDD
- Automatizaciones
- Optimización de tiempo/recursos

FlowDoc:
- Documentación first-class
- Workflow SDD
- Adopción gradual
- Agnóstico de tools
```

**FlowForge usa FlowDoc como su capa de documentación.** FlowForge genera/actualiza la documentación según el workflow de FlowDoc.

---

## Consecuencias

### ✅ Positivo

- Nombre memorable y descriptivo
- Ecosistema claro con FlowForge
- No excluye por ser muy técnico
- Fácil de buscar en internet ("FlowDoc framework")

### ❌ Negativo

- "Flow" es término común en tech ( Flow, Vue Flow, etc.)
- Puede haber colisión de nombres con otras herramientas

### 🔄 Neutral

- El nombre no cambia la funcionalidad
- Los archivos `docs/` siguen siendo el source of truth
- El repositorio puede renombrarse a `flowdoc` en el futuro

---

## Cambio de nombre en documentación

El repositorio se llama `newPropuestaFrameworkTrabajo` pero el framework es **FlowDoc**.

| Documento | Actualización necesaria |
|-----------|------------------------|
| `README.md` | Título cambia a "FlowDoc" |
| `docs/CHANGELOG.md` | Nota de versión con nuevo nombre |
| `AGENTS.md` | Referencia al nombre FlowDoc |

---

## Checklist de Implementación

- [x] ADR-008 creado con la decisión
- [ ] `README.md` actualizado con título "FlowDoc"
- [ ] `docs/CHANGELOG.md` registrado
- [ ] `AGENTS.md` actualizado
- [ ] Repository rename a `flowdoc` (opcional, futura decisión)

---

## Documentos Relacionados

| Documento | Ubicación |
|-----------|-----------|
| Propuesta unificada equipo | [RFC-004 (deprecated)](rfc/004-propuesta-unificada-equipo-deprecada.md) | Historial — ver AGENTS.md |
| Adoption guide | `docs/adoption-guide.md` |
| FAQ | `docs/FAQ.md` |

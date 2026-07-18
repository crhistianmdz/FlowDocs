# Guía de Inicio Rápido

**Configurá la documentación FlowDocs en tu proyecto en 5 minutos.**

---

## Paso 1: Copiá la Estructura

```bash
# Copiar a tu proyecto
cp -r /path/to/flowdocs/docs/ /tu/proyecto/
```

---

## Paso 2: Creá el PRD

Editá `docs/PRD.md`:

```markdown
# PRD: Nombre de Tu Proyecto

**Versión**: 1.0
**Última actualización**: YYYY-MM-DD

## 1. Resumen
[Qué hace este proyecto]

## 2. Tech Stack
[Tecnologías usadas]

## 3. Equipo
[Tamaño del equipo, husos horarios]
```

---

## Paso 3: Documentá Tu Primera Decisión

Creá tu primer ADR en `docs/architecture/adr/001-estado-inicial.md`:

```markdown
# ADR-001: Estado Inicial del Proyecto

**Fecha**: YYYY-MM-DD
**Estado**: Aceptado

## Contexto

[Qué existe al inicio del proyecto]

## Decisión

[Elecciones técnicas iniciales]

## Consecuencias

### Positivas
- [Beneficio 1]

### Negativas
- [Tradeoff 1]
```

---

## Paso 4: Configurá los Templates

Copiá los templates que necesites de `docs/templates/`:

| Template | Uso para |
|----------|----------|
| `architecture/ADR_template.md` | Registrar decisiones |
| `architecture/RFC_template.md` | Proponer discusiones |
| `PRD/PRD_template.md` | Requerimientos de producto |

---

## Paso 5: Creá el AGENTS.md

Creá `AGENTS.md` en la raíz de tu proyecto:

```markdown
# AGENTS.md

**Proyecto**: Tu Proyecto
**Stack**: [tecnologías]

## Estructura

- `docs/` — Toda la documentación
- `docs/architecture/adr/` — Decisiones de arquitectura
- `docs/api/` — Contratos de API

## Convenciones

[Convenciones del equipo]

## Recursos

- PRD: docs/PRD.md
- Templates: docs/templates/
```

---

## ¿Qué Sigue?

| Meta | Acción |
|------|--------|
| Registrar una decisión | Crear ADR en `docs/architecture/adr/` |
| Proponer algo | Crear RFC en `docs/architecture/rfc/` |
| Documentar API | Actualizar `docs/templates/api/endpoints.md` |
| Documentar DB | Actualizar `docs/templates/database/schema.md` |

---

## Reglas de Oro

1. **Si no hay ADR, la decisión no existe**
2. **Actualizá los docs en el mismo PR que el código**
3. **Copiá de `docs/templates/` para consistencia**

---

## Problemas Comunes

| Problema | Solución |
|----------|----------|
| No sabés qué template usar | Ver `docs/templates/TEMPLATE_GUIDE.md` |
| ADR está obsoleto | Marcar con estado "Deprecated" + link al reemplazo |
| Docs desactualizados | Actualizar en el mismo PR que cambia el código |

---

## Recursos

| Recurso | Link |
|---------|------|
| Guía de Documentación | `docs/README.md` |
| PRD | `docs/PRD.md` |
| Templates | `docs/templates/` |
| FAQ | `docs/FAQ.md` |
| Guía de Adopción | `docs/adoption-guide.md` |

---

**¿Preguntas?** Ver `docs/FAQ.md` o abrir un issue.

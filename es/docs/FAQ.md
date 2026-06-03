# FAQ — Preguntas Frecuentes

> Las dudas más comunes cuando adoptas este framework.

---

## Empezar

### ¿Por dónde empiezo?

**Crea una HU en `docs/tasks/HU-001-tu-feature.md`.** Así de simple. No necesitas nada más para empezar.

### ¿Por qué la HU es obligatoria?

**Sin HU = Sin desarrollo.** La HU es la unidad de planificación — te dice qué construir, qué está en scope, y cuándo está hecho. Sin ella:
- No hay nada que planificar
- El agent no sabe en qué trabajar
- No hay forma de verificar el completado

Igual que en Scrum no podés iniciar un Sprint sin backlog items, en FlowDoc no podés iniciar desarrollo sin una HU.

### ¿Puedo adoptarlo sin usar el ciclo SDD completo?

Sí. Podés tener documentación valiosa sin seguir el ciclo SDD. El mínimo viable es: una HU documentada que un humano o agent pueda leer.

### ¿Cuánto tiempo toma documentar una HU?

| Nivel | Tiempo |
|-------|--------|
| HU simple (no SDD) | 10-15 min |
| HU SDD-Ready (con Given/When/Then) | 30-45 min |
| HU completa con spec + design | 1-2 horas |

No tiene que ser perfecto. Una HU básica ya tiene valor.

---

## Herramientas y Agentes

### ¿Necesito OpenCode o Antigravity?

No. Cualquier agent de IA que pueda leer archivos markdown funciona con este framework:
- OpenCode + SDD
- Antigravity + SDD
- ClaudeCode + SDD
- Cualquier otro agent

El workflow SDD es independiente de la herramienta. `docs/` es el source of truth.

### ¿Qué conocimiento mínimo necesito?

Como mínimo:
- Saber qué es un agent de IA
- Entender que el agent lee archivos y puede escribir archivos
- Conocer el ciclo básico: Proposal → Spec → Design → Tasks → Apply → Verify

No necesitas ser expertos en prompting ni en SDD para empezar.

### ¿Puedo usar esto con GitHub Copilot?

GitHub Copilot no es un agent autónomo (no puede leer y escribir archivos por sí mismo). Pero sí podés usarlo mientras escribís código siguiendo las specs de tus HUs.

### ¿Cómo reciben contexto los sub-agents de SDD?

Los sub-agents reciben contexto vía un archivo `sdd-context.md` generado al ejecutar `/sdd-new`. Este archivo contiene las convenciones del proyecto, paths clave, estado del cambio activo, y pointers a Engram. El orchestrator lo inyecta en el prompt del sub-agent y parsea los discoveries que el sub-agent devuelve.

Ver [ADR-009: SDD Sub-agent Context Pattern](./architecture/adr/009-sdd-subagent-context-pattern.md) para la especificación completa.

---

## El Ciclo de 15 Días

### ¿Son obligatorios los 15 días?

No. El ciclo de 15 días es una **referencia**, no una obligación. Podés adaptarlo:
- Semanal (5 días)
- Quincenal (10 días)
- Mensual (20 días)
- Lo que funcione para tu equipo

Lo importante es tener un ritmo de planificación, trabajo y revisión.

### ¿Qué pasa si mi equipo es de 2 personas?

Podés usar el framework en Nivel 2 (SDD básico) o Nivel 3 (ciclo adaptado sin todas las ceremonias). No necesitás los 15 días completos.

### ¿Y si estoy en distintas zonas horarias?

El ciclo de 15 días fue diseñado para eso:
- Async updates de 5 min
- Weekly sync de 30 min
- Documentación en lugar de reuniones

Si tu equipo está spread por zonas horarias, priorizá la comunicación escrita.

### ¿De dónde viene el ciclo de 15 días?

El framework está basado en **Scrum adaptado** para equipos distribuidos y trabajo async:

| Concepto Scrum | Cómo lo usamos |
|----------------|---------------|
| Sprint | Ciclo de 15 días útiles |
| Daily standup | Async update de 5 min |
| Sprint planning | Días 1-2 |
| Integration review | Días 12-14 |
| Retrospective | Día 15 |

Si tu equipo usa Kanban u otra metodología, adaptá los conceptos. Lo importante no es el nombre sino tener un **ritmo de trabajo**: planificación → ejecución → revisión.

---

## Proyectos

### ¿Funciona para proyectos existentes (legacy)?

Sí. Ver [legacy-migration.md](legacy-migration.md) para guía paso a paso.

La regla es: **no reescribir todo, solo documentar lo que toques.**

### ¿Qué pasa si mi proyecto no es exactamente monolítico ni microservicios?

El framework es adaptable. Podés usar una estructura híbrida:
- Monolítico con módulos claros
- Monorepo con packages separados
- Mix de monolítico y serverless

Ver [ADR-006: Cuatro Arquitecturas](architecture/adr/006-cuatro-arquitecturas.md) para más detalles.

### ¿Puedo usar esto para un proyecto personal?

Sí, y es ideal para eso. Empezá en Nivel 1 (solo documentación) y subí de nivel cuando lo necesites.

---

## Plantillas y Templates

### ¿Qué template uso?

| Situación | Template |
|-----------|----------|
| Feature pequeña (< 2h) | Simple (`template-user-story.md`) |
| Feature normal | SDD-Ready (`template-user-story-sdd.md`) |
| Bug fix | SDD-Ready (`template-bug-fix-sdd.md`) |
| Refactor | `template-refactor.md` |
| Decisión técnica nueva | RFC primero, luego ADR |
| Decisión ya tomada | ADR directo |

Si no estás seguro, usá SDD-Ready. El overhead extra vale la pena.

### ¿Por qué hay templates "simple" y "SDD-Ready"?

**Simple**: Para tareas triviales o cuando estás aprendiendo.
**SDD-Ready**: Para features reales donde necesitás trazabilidad completa.

No uses SDD-Ready por inercia. Si la tarea es trivial, usá el template simple.

---

## Equipo

### ¿Cómo convenzo a mi equipo?

**No impongas, inspirá.** Empezá vos solo documentando tus HUs. Cuando tu equipo vea que:
- La documentación tiene valor
- Las decisiones están claras
- El onboarding de nuevos miembros es más fácil

...van a querer adoptar más. Mostrá el valor antes de pedir cambio.

### ¿Qué pasa si alguien no quiere cambiar su forma de trabajar?

Respetá su ritmo. Cada persona adoptiona a su velocidad. Mientras vos mantenés la documentación, el resto del equipo puede observar y adoptar cuando esté listo.

### ¿Puedo ser team de 1?

Sí. El framework funciona para 1 persona. De hecho, empezar solo es lo más común.

---

## Métricas y Medición

### ¿Cómo sé si el framework está funcionando?

En el Nivel 4 podés medir:
- Tiempo promedio de HU (objetivo: predecible)
- % de HUs completadas vs planificadas
- Deuda técnica acumulada

En niveles menores, la métrica es simpler: "¿la documentación me está ahorrando tiempo?"

### ¿Hay KPIs definidos?

No hay KPIs obligatorios. El framework es adaptativo. Medí lo que tenga sentido para tu equipo.

---

## Recursos

| Recurso | Qué es |
|---------|--------|
| [adoption-guide.md](adoption-guide.md) | Guía de niveles para adoptar |
| [TEMPLATE_GUIDE.md](templates/TEMPLATE_GUIDE.md) | Cuándo usar cada template |
| [legacy-migration.md](legacy-migration.md) | Cómo adaptar proyecto existente |
| [troubleshooting.md](troubleshooting.md) | Errores comunes |
| [Ciclo de trabajo](../flowdoc-ciclo.md) | Ciclo de trabajo completo |

---

## Integración con Herramientas

### ¿Cómo integro con GitHub Projects, Jira, Linear, etc.?

**No es responsabilidad del framework.** La integración con tu tool de project management es decisión tuya, de tu equipo, o de tu empresa.

El framework te provee:
- `docs/` con toda la documentación
- `openspec/` con los artifacts SDD
- Scripts en `scripts/` para crear issues desde HUs

Cómo vinculás eso a GitHub Projects, Jira, Linear, Trello, o cualquier otra tool es:
- **Individual**: Lo que prefieras
- **Equipo**: Lo que el equipo acuerde
- **Empresa**: Lo que la empresa decida

El framework es agnóstico. No te dice cómo gestionar tus proyectos.

---

## HUs que FALLAN

### ¿Qué pasa si una HU no se puede completar?

Una HU no es un contrato hard. Es un documento vivo. Se puede cerrar sin completar.

| Escenario | Qué hacer |
|-----------|-----------|
| **Se subestimó, es muy grande** | Dividirla en 2-3 HUs más pequeñas |
| **Bloqueos que no se resuelven** | Archivar con nota: "bloqueada por X" |
| **El scope cambió, ya no tiene sentido** | Archivar con nota: "scope cambió, obsoleta" |
| **El owner se fue** | Re-asignar o archivar |
| **El feature no funciona** | Crear Bug Fix HU para resolver |

### ¿Cómo archivo una HU sin completar?

```markdown
# HU-042: Login de usuario

**Status**: ❌ Archived

**Razón**: Scope cambió. El login social ahora es prioritario.

**Ver**: [HU-043](HU-043-login-social.md)
```

Lo importante: **no dejar HUs zombies** en el backlog sin estado definido.

---

## ¿Tu pregunta no está respondida?

Abre un issue en el repo o preguntá en Discord. Este FAQ se actualiza con las preguntas más frecuentes.

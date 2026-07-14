# Guía de Adopción — Cómo Adoptar el Framework según tu Contexto

> No tienes que adoptarlo todo de golpe. Elige el nivel que mejor se adapte a tu situación y crezca desde ahí.

---

## Niveles de Adopción

```
┌─────────────────────────────────────────────────────────────┐
│  Nivel 4: Equipo Completo                                   │
│  Ciclo de 15 días + Métricas + Proceso completo              │
├─────────────────────────────────────────────────────────────┤
│  Nivel 3: Equipo Coordinado                                  │
│  Ciclo adaptado + Planning + Integración                     │
├─────────────────────────────────────────────────────────────┤
│  Nivel 2: SDD Básico                                         │
│  Proposal → Spec → Design → Tasks → Apply → Verify         │
├─────────────────────────────────────────────────────────────┤
│  Nivel 1: Solo Documentación                                │
│  HUs en docs/tasks/, sin ceremonia SDD                       │
└─────────────────────────────────────────────────────────────┘
```

---

## Nivel 1: Solo Documentación ✅

**Ideal para**: Equipos de 1 persona, proyectos pequeños, comenzar a documentar sin overhead.

### Qué hacer

1. Crear `docs/tasks/HU-001-tu-feature.md`
2. Usar template de `docs/templates/user-stories/template-user-story.md`
3. Documentar: qué hace, criterios de aceptación

### La HU es el punto de partida

**Sin HU = Sin desarrollo.** La HU te dice qué construir. Empezá por ahí.

### Valor obtenido

- La feature queda documentada
- Cualquier agent puede leerla después
- No hay proceso que seguir, solo archivos

### Cuándo pasar al Nivel 2

Cuando sientas que necesitás más estructura para trackear qué falta hacer.

---

## Nivel 2: SDD Básico ✅

**Ideal para**: 1-2 personas que quieren estructura sin ciclo de equipo.

### Qué agregar

1. Seguir el ciclo SDD completo:
   ```
   Proposal → Spec → Design → Tasks → Apply → Verify → Archive
   ```

2. Usar templates SDD-Ready:
   - `docs/templates/user-stories/template-user-story-detailed.md`
   - `docs/templates/bug-fixes/template-bug-fix-detailed.md`

3. Guardar artifacts en `openspec/` o Engram

### Valor obtenido

- Cada decisión queda documentada
- Los scenarios Given/When/Then sirven como especificación verificable
- Los 🧪 Ref permiten trackear qué tests existen

### Cuándo pasar al Nivel 3

Cuando necesitás coordinar con otros o tienes bloqueos entre features.

---

## Nivel 3: Ciclo Adaptado ✅

**Ideal para**: Equipos de 2-5 personas que quieren sincronización sin reuniones excesivas.

### Qué agregar

1. **Planning adaptado** (no 15 días obligatorios)
   - Puede ser semanal, quincenal, mensual
   - Lo importante es tener un momento de revisión

2. **Contract claro**
   - Owner de cada HU
   - Dependencies explícitas
   - Definition of Done acordada

3. **Feature flags**
   - Para trabajo paralelo sin bloqueos

### Valor obtenido

- El equipo sabe quién hace qué
- Las dependencias se hacen explícitas
- El trabajo en paralelo es seguro con flags

### Cuándo pasar al Nivel 4

Cuando quieras medir si el proceso está funcionando.

---

## Nivel 4: Equipo Completo ✅

**Ideal para**: Equipos de 4+ personas en distintas zonas horarias.

### Qué agregar

1. **Ciclo de 15 días** (o adaptado a tu contexto)
   - Planning (días 1-2)
   - Execution (días 3-11)
   - Integration (días 12-14)
   - Retrospective (día 15)

2. **Métricas**
   - Tiempo promedio de HU
   - % de HUs completadas vs planificadas
   - Deuda técnica acumulada

3. **Proceso completo**
   - RFC para decisiones técnicas
   - ADR como registro permanente
   - Onboarding para nuevos miembros

### Valor obtenido

- Visibilidad completa del trabajo
- Decisiones documentadas para referencia futura
- Onboarding rápido de nuevos miembros

---

## ¿Cómo sé si el Framework Está Funcionando?

El framework funciona cuando:

| Indicador | Qué buscar |
|-----------|------------|
| **Documentación accesible** | ¿Cuando alguien tiene una duda, va a `docs/` y encuentra respuesta? |
| **HUs no zombies** | ¿Todas las HUs tienen estado claro (active, done, archived)? |
| **Specs actualizadas** | ¿Cuando cambia algo, se actualiza la doc? |
| **Onboarding más rápido** | ¿Un nuevo miembro puede empezar a contribuir sin preguntarte todo? |
| **Menos "de qué habla esta feature?"** | ¿Las decisiones y el contexto están documentados? |

### Indicadores por Nivel

| Nivel | Está funcionando cuando... |
|-------|---------------------------|
| **N1** | Las HUs que creás tienen información útil para vos mismo mañana |
| **N2** | El ciclo SDD te ayuda a pensar antes de codear |
| **N3** | El equipo sabe quién hace qué sin necesidad de preguntar |
| **N4** | Las métricas muestran predecibilidad en el trabajo |

### No te preocupes por

- DORA metrics avanzados
- Cobertura de tests específica
- Cumplimiento del ciclo al 100%
- Que todos los archivos estén perfectos

**Lo único que importa**: ¿te está ahorrando tiempo o no?

---

## FAQ: Preguntas Frecuentes

### ¿Puedo saltar niveles?

Sí. Si ya tenés experiencia con SDD, podés empezar en Nivel 2 o 3. La idea es no repetir ceremonia innecesaria.

### ¿Qué pasa si mi equipo no quiere cambiar su forma de trabajar?

Empezá vos solo (Nivel 1). Cuando vean valor en la documentación, van a querer adoptar más. No impongas, inspirá.

### ¿Puedo mezclar niveles?

Sí. Por ejemplo:
- Proyecto principal en Nivel 3
- Un módulo nuevo en Nivel 1
- Un refactor en Nivel 2

### ¿Cuánto tiempo toma el Nivel 1?

10-15 minutos por HU. No más.

### ¿Cuánto tiempo gana el Nivel 3 sobre no tener proceso?

Según equipos que lo usan:
- Menos tiempo en coordinación (reuniones de status)
- Menos bugs por falta de specs
- Onboarding de nuevos miembros en días, no semanas

---

## Empezar

1. **Hoy**: Crear `docs/tasks/HU-001-tu-proxima-feature.md`
2. **Esta semana**: Probar el ciclo SDD en una HU
3. **Este mes**: Evaluar si necesitás más estructura

El objetivo es que la documentación sea útil, no perfecta. Iterá según tu contexto.

---

## Ver también

- [ADR-002: docs/ como source of truth](architecture/adr/002-docs-source-of-truth.md)
- [ADR-007: docs/templates/ como source of truth](architecture/adr/007-estructura-templates.md)
- [TEMPLATE_GUIDE.md](templates/TEMPLATE_GUIDE.md)
- [Guías de Arquitectura](../reference/) — Monolítico, Microservicios, Monorepo, Serverless

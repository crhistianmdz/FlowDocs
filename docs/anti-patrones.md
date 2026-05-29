# Anti-Patrones — Señales de que el Framework No Está Funcionando

> Este documento enumera señales de que algo no está funcionando en cómo usás el framework.
> No son errores obligatorios, pero si ves estas señales, algo necesita atención.

---

## ¿Por qué anti-patrones?

El framework funciona cuando se usa bien. Estos son los síntomas de que no se está usando bien.

La idea no es castigar sino **identificar temprano** para poder corregir.

---

## Anti-Patrones de Documentación

### docs/ se vuelve cementerio

**Señal**: Archivos en `docs/` que no se actualizaron en meses.

**Qué mirar**:
- `docs/api/endpoints.md` - ¿refleja los endpoints actuales?
- `docs/database/schema.md` - ¿refleja el schema actual?
- `docs/architecture/adr/` - ¿hay ADRs en "Borrador" de hace más de 1 mes?

**Qué hacer**:
- Regla: "docs se actualizan en el mismo PR que el código"
- Agregar label `docs-stale` cuando detectás desactualización
- Priorizar en el próximo planning

---

### HUs sin owner

**Señal**: Hay HUs en `docs/tasks/` sin campo `**Owner**:` o con owner que no existe.

**Qué mirar**:
```bash
grep -r "Owner" docs/tasks/HU-*.md | grep -v "@"
```

**Qué hacer**:
- Asignar owner a cada HU en el planning
- Si el owner ya no está en el equipo, re-asignar

---

### ADRs sin estado

**Señal**: ADRs que llevan más de 1 mes en "Borrador" o "En Revisión".

**Qué mirar**:
```bash
grep -r "Estado.*Borrador\|Estado.*En Revisión" docs/architecture/adr/
```

**Qué hacer**:
- Forzar decisión: o se aprueba o se descarta
- Si la decisión ya se tomó, actualizar el estado
- Si no se tomó, cerrar el RFC sin crear ADR

---

### RFCs colgados

**Señal**: RFCs en "En Revisión" hace más de 1 ciclo (15 días).

**Qué mirar**:
```bash
grep -r "Estado.*En Revisión" docs/architecture/rfc/
```

**Qué hacer**:
- Preguntar en Discord: "¿Ya tenemos decisión?"
- Si no hay consenso, agendar reunión sincrónica
- Si no hay respuesta en 48h, forzar decisión

---

## Anti-Patrones de Proceso

### Planning toma más de 2 horas

**Señal**: El planning del día 1 se extiende a 4+ horas.

**Qué hacer**:
- Preparar agenda ANTES del planning
- Que cada developer venga con sus HUs ya escritas
- Limitar a 2 horas máximo, si sobra se讨论 en otro momento

**Por qué pasa**:
- No hubo preparación previa
- El equipo no sabe qué quiere
- Se discuten cosas que no son del planning

---

### Daily es una reunión de status

**Señal**: Reuniones de 30 min todos los días para "actualizar".

**Qué hacer**:
- Reemplazar por async update de 5 min en Discord
- La reunión solo si hay blocker que necesita discusión

**Por qué pasa**:
- No hay confianza en la comunicación escrita
- El equipo no está acostumbrado a async

---

### Reuniones sin agenda

**Señal**: "Nos juntamos a plenum" sin documento previo.

**Qué hacer**:
- Toda reunión necesita agenda publicada ANTES
- Sin agenda, no hay reunión
- Los resultados se documentan post-reunión

---

## Anti-Patrones de SDD

### HUs gigantes

**Señal**: Una HU con más de 5 escenarios Given/When/Then.

**Qué mirar**:
```bash
grep -c "GIVEN" docs/tasks/HU-*.md
```

**Qué hacer**:
- Dividir la HU en 2 o más HUs
- Regla: si necesitás scroll para ver todos los escenarios, probablemente es muy grande

---

### HUs estancadas

**Señal**: HUs en "📋 Backlog" por más de 2 ciclos.

**Qué hacer**:
- Re-evaluar prioridad en el próximo planning
- Si no es importante, cerrarla con nota
- Si es importante pero bloqueada, resolver el bloqueo

---

### Feature flags acumulando

**Señal**: Más de 3 feature flags activos de ciclos anteriores.

**Qué mirar**:
```bash
grep -r "Feature Flag" docs/tasks/HU-*.md
```

**Qué hacer**:
- Agregar a `docs/tech-debt.md`
- En el próximo ciclo, remover los flags obsolete
- Regla: un flag no puede estar activo más de 2 ciclos

---

### Self-merge

**Señal**: El mismo developer que abrió el PR lo mergeó.

**Qué hacer**:
- Inmediatamente: establecer regla de "otro debe approve"
- Tech Lead revisa que no haya self-merges
- Si pasó, Documentar como incidente menor

**Por qué pasa**:
- Apuro
- "Es un fix menor"
- Falta de costumbre

---

## Anti-Patrones de Equipo

### Onboarding lento

**Señal**: Nuevo miembro no puede trabajar Productivamente después de 4 días.

**Qué mirar**:
- ¿`ONBOARDING.md` está actualizado?
- ¿Hay acceso a todos los sistemas?
- ¿Sabe dónde está la documentación?

**Qué hacer**:
- Revisar y actualizar `ONBOARDING.md`
- Asignar buddy/mentor al newcomer
- Checklist día por día

---

### Decisiones sin ADR

**Señal**: "Creo que así lo acordamos" pero no hay ADR.

**Qué hacer**:
- Regla: **si no hay ADR, la decisión no existe**
- Crear ADR retroactivo si la decisión ya se tomó
- Para nuevas decisiones, crear RFC primero

---

### Deuda técnica ignorada

**Señal**: `docs/tech-debt.md` existe pero nadie lo mira.

**Qué hacer**:
- Revisar tech-debt en cada planning
- Asignar tiempo a pagar deuda (regla: 20% del sprint)
- Si no se paga, al menos documentar por qué

---

## Checklist de Salud del Equipo

Usá esto para evaluar cómo está funcionando el framework:

- [ ] Los docs se actualizan cuando el código cambia
- [ ] Cada HU tiene owner asignado
- [ ] Los ADRs tienen estado (no quedan en "Borrador")
- [ ] El planning dura menos de 2 horas
- [ ] Los daily son async, no reuniones
- [ ] Las HUs tienen menos de 5 escenarios
- [ ] No hay HUs estancadas por más de 2 ciclos
- [ ] Los feature flags se remueven post-release
- [ ] Nadie hace self-merge
- [ ] El newcomer puede trabajar en 4 días

---

## Resumen

| Anti-Patrón | Señal | Urgencia |
|-------------|-------|----------|
| docs como cementerio | Archivos sin update en meses | Alta |
| HUs sin owner | Campo Owner vacío | Media |
| ADRs sin estado | >1 mes en borrador | Alta |
| RFCs colgados | >1 ciclo en revisión | Media |
| Planning largo | >2 horas | Media |
| Daily como reunión | 30 min diarios | Baja |
| Reuniones sin agenda | Sin documento previo | Media |
| HUs gigantes | >5 escenarios | Alta |
| HUs estancadas | >2 ciclos en backlog | Media |
| Flags acumulando | >3 flags old | Alta |
| Self-merge | Owner mergea su PR | Crítica |
| Onboarding lento | >4 días para productivo | Media |
| Decisiones sin ADR | "Creo que acordamos" | Alta |
| Deuda ignorada | tech-debt.md sin ver | Baja |

---

## Ver también

- [adoption-guide.md](adoption-guide.md) - Cómo adoptar el framework
- [troubleshooting.md](troubleshooting.md) - Errores técnicos comunes
- [framework-coordinacion.md](../framework-coordinacion.md) - Ciclo de trabajo
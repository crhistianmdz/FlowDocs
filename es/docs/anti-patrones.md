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

**Señal**: Archivos en `docs/` que no se actualizaron en meses y ya no reflejan la realidad.

**Qué mirar**:
- `docs/api/endpoints.md` - ¿refleja los endpoints actuales?
- `docs/database/schema.md` - ¿refleja el schema actual?
- `docs/architecture/adr/` - ¿hay ADRs en "Borrador" de hace más de 1 mes?

**Qué hacer**:
- Regla: "docs se actualizan en el mismo PR que el código"
- Agregar label `docs-stale` cuando detectás desactualización
- Crear un issue para corregirlo

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
grep -r "Estado.*Borrador\|Estado.*En Revisión\|Status.*Draft\|Status.*In Review" docs/architecture/adr/
```

**Qué hacer**:
- Forzar decisión: o se aprueba o se descarta
- Si la decisión ya se tomó, actualizar el estado
- Si no se tomó, cerrar el RFC sin crear ADR
- **Regla**: si no hay ADR, la decisión no existe

---

### RFCs colgados

**Señal**: RFCs en "En Revisión" hace más de 2 semanas sin decisión.

**Qué mirar**:
```bash
grep -r "Estado.*En Revisión\|Status.*In Review" docs/architecture/rfc/
```

**Qué hacer**:
- Preguntar en Discord: "¿Ya tenemos decisión?"
- Si no hay consenso en 48h: agendar reunión sincrónica para decidir
- Después de 2 semanas sin decisión: cerrar el RFC sin crear ADR

---

### API contract drift

**Señal**: `docs/api/endpoints.md` no coincide con la API real.

**Qué hacer**:
- Los docs de API deben actualizarse en el mismo PR que cambia los endpoints
- Si detectás drift, crear un issue para corregirlo
- No dejar que los docs de API se desactualicen — rompen integraciones

---

### DB schema drift

**Señal**: `docs/database/schema.md` no coincide con la base de datos real.

**Qué hacer**:
- Los docs de schema se actualizan en el mismo PR que cambia la DB
- Si detectás drift, crear un issue para corregirlo

---

## Anti-Patrones de Equipo

### Onboarding lento

**Señal**: Nuevo miembro no puede trabajar productivamente después de 4 días.

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
- **Regla**: si no hay ADR, la decisión no existe
- Crear ADR retroactivo si la decisión ya se tomó
- Para nuevas decisiones, crear RFC primero

**Por qué importa**: Sin ADR, los futuros desarrolladores no saben por qué se hizo algo. Podrían deshacer una decisión que no entienden.

---

### Deuda técnica ignorada

**Señal**: `docs/tech-debt.md` existe pero nadie lo mira.

**Qué hacer**:
- Revisar tech-debt en cada planning
- Asignar tiempo a pagar deuda (regla: 20% del sprint)
- Si no se paga, al menos documentar por qué

---

## Checklist de Salud de Documentación

Usá esto para evaluar cómo está funcionando el framework:

- [ ] Los docs se actualizan cuando el código cambia
- [ ] Cada HU tiene owner asignado
- [ ] Los ADRs tienen estado (no quedan en "Borrador")
- [ ] Los RFCs reachan decisión en 2 semanas o se cierran
- [ ] Toda decisión significativa tiene un ADR
- [ ] Los docs de API coinciden con los endpoints reales
- [ ] Los docs de DB schema coinciden con la base de datos real
- [ ] El newcomer puede trabajar en 4 días

---

## Resumen

| Anti-Patrón | Señal | Urgencia |
|-------------|-------|----------|
| docs como cementerio | Archivos sin update en meses | Alta |
| HUs sin owner | Campo Owner vacío | Media |
| ADRs sin estado | >1 mes en borrador | Alta |
| RFCs colgados | >2 semanas en revisión | Media |
| API contract drift | Docs no coinciden con la API | Alta |
| DB schema drift | Docs no coinciden con el schema | Alta |
| Onboarding lento | >4 días para productivo | Media |
| Decisiones sin ADR | "Creo que acordamos" | Alta |
| Deuda ignorada | tech-debt.md sin ver | Baja |

---

## Ver también

- [adoption-guide.md](adoption-guide.md) - Cómo adoptar el framework
- [troubleshooting.md](troubleshooting.md) - Errores técnicos comunes
- [FAQ.md](FAQ.md) - Preguntas frecuentes
- [Ciclo de Trabajo](./flowdoc-ciclo.md) - Ciclo de trabajo

**Versión**: v2.0 — Alignado con FlowDocs EN (sin anti-patrones de proceso/SDD)

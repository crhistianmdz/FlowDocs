# RFC-002: Ciclo de Trabajo de 15 Días

- **Estado**: Aprobado
- **Autor(es)**: @kaito
- **Fecha**: 2026-05-29
- **Proyecto**: Framework de Trabajo para Equipos Distribuidos

---

## 1. Resumen

Establecer ciclos de trabajo de **15 días úteis** que incluyen Planning (días 1-2), Execution (días 3-11), Integration (días 12-14) y Retrospective (día 15). El objetivo es dar estructura suficiente para equipos distributed sin ser tan rígido como sprints de 2 semanas tradicionales.

---

## 2. Contexto

- **Problema técnico**: Equipos en distintas zonas horarias necesitan estructura para coordinarse sin reuniones constantes. Sprints de 1-2 semanas son muy cortos para resultados significativos, y milestones de 1 mes son demasiado largos sin feedback.
- **Por qué es necesario decidir esto ahora**: El framework será usado por equipos en distintos países. Sin un ciclo definido, cada equipo improvisa.
- **Alternativas consideradas**:
  1. **Sprints de 1 semana**: Muy corto, poco tiempo para features significativas, mucho overhead de planning
  2. **Sprints de 2 semanas (tradicional)**: Funciona bien para equipos syncrónicos, menos efectivo para async
  3. **Milestones de 1 mes**: Feedback muy lento, difícil ajustar curso
  4. **15 días úteis (elegido)**: Equivalente a 3 semanas calendario, balance entre estructura y flexibilidad

---

## 3. Decisión Técnica

### 3.1 Estructura del Ciclo

```
Días 1-2:   Planning & Contract
            - Feature list collaboration
            - Task contract (owner, deadline, dependencies)
            - Definition of Done acordada
            - Feature flags definidos

Días 3-11:  Execution
            - Async updates diarios (5 min)
            - Weekly sync (día 7, 30 min)
            - Si estás bloqueado, AVISAR INMEDIATAMENTE

Días 12-14: Integration & Verify
            - Integration review completo
            - Testing conjunto
            - Verificar contra specs
            - Release candidate a staging

Día 15:     Retrospective
            - ¿Qué funcionó bien?
            - ¿Qué no funcionó?
            - ¿Qué aprendimos?
```

### 3.2 Async Updates Diarios

Formato en Discord (o herramienta async del equipo):

```
Feature X: [en progreso/bloqueado/completado]
Bloqueado: [sí/no] - Si sí, por quién y por qué
Tests: [escritos / pendientes]
```

**Regla**: Si estás bloqueado más de 24h y no avisaste, es problema. Si avisaste y no se resolvió, es problema de coordination, no tuyo.

### 3.3 Weekly Sync (Día 7)

Sesión de 30 min (máximo):
1. ¿Qué se completó? (5 min)
2. ¿Qué está bloqueado? (10 min — resolver ahí mismo)
3. ¿Qué ajustar? (10 min)
4. Próximo paso (5 min)

**Si no necesita interacción en tiempo real, no es reunión** — es un mensaje async o un issue.

---

## 4. Consideraciones de Feature Flags

Todo feature nuevo se desarrolla detrás de un flag:

```
HU-001          → flag: HU-001 (default: false)
HU-003-v2       → flag: HU-003-v2 (para migraciones graduales)
HU-005-exp      → flag: HU-005-exp (para A/B testing)
```

**Reglas del flag**:
- El flag se define en Planning junto con la HU
- Código mergea a `dev` con flag en `false` — no rompe nada
- Flag se activa en staging para integration review
- Flag se activa en production después de release validado
- Flags de ciclos anteriores se REMUEVEN — no acumular deuda de flags

**Beneficio**: Permite merge continuo a `dev` sin miedo a romper features de otros.

---

## 5. Cadencia de Reuniones

| Tipo | Frecuencia | Duración | Quién |
|------|-----------|----------|-------|
| **Planning** | Inicio de ciclo (Día 1) | 2h | Todo el equipo |
| **Weekly Sync** | Día 7 | 30 min | Todo el equipo |
| **Integration Review** | Día 12 | 1h | Todo el equipo |
| **Retrospectiva** | Día 15 | 1h | Todo el equipo |
| **Decisión técnica** | Solo si no hay consenso async | Máx 2h | Involucrados + moderador |
| **1:1 / Onboarding** | Según necesidad | Variable | Owner + nuevo |

**Timezone rotation**: Si el equipo está en más de 2 zonas horarias, rotar horarios de reuniones para no perjudicar siempre al mismo grupo.

---

## 6. Costos y Recursos

- **Tiempo de planning**: ~2h por ciclo (por persona)
- **Tiempo de retrospective**: ~1h por ciclo
- **Async updates**: ~5 min por día
- **Weekly sync**: ~30 min por ciclo

**Total overhead por ciclo**: ~4-5 horas de coordinación (~15% del tiempo en ciclos de 15 días)

---

## 7. Riesgos

| Riesgo | Impacto | Mitigación |
|--------|---------|------------|
| Equipo saltea planning | Alto | Sin planning = sin dirección clara. Tech Lead insiste |
| Sync semanal se extiende | Medio | Moderador con cronómetro, agenda clara |
| Feature flags acumulan deuda | Medio | Regla: flags se remueven en el ciclo siguiente |
| Retrospectiva se vuelve crítica | Bajo | Enfoque en proceso, no en personas |

---

## 8. Estados de Aprobación

| Rol | Persona | Estado | Fecha |
|-----|---------|--------|-------|
| Tech Lead | @kaito | Aprobado | 2026-05-29 |

---

## 9. Historial de Cambios

| Fecha | Cambio | Autor |
|-------|--------|-------|
| 2026-05-29 | Versión inicial | @kaito |

---

## 10. Documentos Relacionados

- **RFC-001**: Estructura de documentación docs/
- **RFC-003**: Feature Flags obligatorios
- **ONBOARDING.md**: Checklist para nuevos miembros
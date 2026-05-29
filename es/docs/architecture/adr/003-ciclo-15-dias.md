# ADR-003: Ciclo de Trabajo de 15 Días

**Fecha**: 2026-05-29  
**RFC relacionado**: [RFC-002: Ciclo de Trabajo de 15 Días](./rfc/002-ciclo-15-dias.md)  
**Estado**: Aceptado

---

## Contexto

Equipos en distintas zonas horarias necesitan estructura para coordinarse sin reuniones constantes. Sprints de 1-2 semanas son muy cortos para resultados significativos, y milestones de 1 mes son demasiado largos sin feedback. Necesitábamos un ciclo quebalancee estructura con flexibilidad para trabajo async.

---

## Decisión

Adoptamos ciclos de **15 días útiles** con 4 fases claramente definidas:

```
Días 1-2:   Planning & Contract
Días 3-11:  Execution (async, con sync semanal día 7)
Días 12-14: Integration & Verify
Día 15:     Retrospective
```

Cada ciclo incluye:
- Feature flags para trabajo paralelo seguro
- Async updates diarios de 5 min
- Definition of Done acordada en Planning
- Release checklist antes de producción

---

## Consecuencias

### ✅ Positivo

- Estructura clara sin ser rígida (15 días vs 2 semanas exactas)
- Feedback en 2 semanas (vs 4 semanas de milestones mensuales)
- Weekly sync previene bloqueos prolongados
- Feature flags permiten deploy continuo sin romper trabajo de otros

### ❌ Negativo

- Planning de 2h puede sentirse largo para equipos pequeños
- Overhead de coordinación (~15% del tiempo en ciclos)
- Retrospectiva requiere disciplina para no volverse sesión de quejas

### 🔄 Neutral

- Equipos syncrónicos pueden sentir que el ciclo es innecesariamente largo
- Equipos async lo valoran como救命稻草 (salvavidas)

---

## Decisiones Relacionadas

| Decisión | Ubicación |
|----------|-----------|
| docs/ como source of truth | ADR-002 |
| Feature flags obligatorios | ADR-004 |
| Documentación en ONBOARDING | ONBOARDING.md |
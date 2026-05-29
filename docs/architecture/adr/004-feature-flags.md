# ADR-004: Feature Flags Obligatorios

**Fecha**: 2026-05-29  
**RFC relacionado**: [RFC-003: Feature Flags Obligatorios](./rfc/003-feature-flags.md)  
**Estado**: Aceptado

---

## Contexto

En equipos distribuidos trabajando en paralelo, un developer puede mergear código que rompe la funcionalidad de otro. Sin mecanismo de isolation, el trabajo paralelo es arriesgado y requiere branches largos que causan integration hell. Necesitábamos permitir que múltiples personas trabajen simultáneamente en `dev` sin pisarse.

---

## Decisión

Toda feature nueva (que no sea hotfix) se desarrolla detrás de un feature flag:

**Nomenclatura**: `{HU-ID}[-opcional-subfeature]`
- `HU-001` — flag para la feature completa
- `HU-003-v2` — versión 2 de la feature (migración gradual)
- `HU-005-exp` — experimental (A/B testing)

**Ciclo del flag**:
1. Development: flag en `false` → código existe pero no está activo
2. Staging (días 12-14): flag en `true` → integration review
3. Production: flag en `true` post-release validado
4. Post-release: **REMOVE** — max 2 ciclos (30 días) por flag

---

## Consecuencias

### ✅ Positivo

- Trabajo paralelo seguro en `dev` sin bloqueos
- Rollback instantáneo sin deploy (desactivar flag = instantáneo)
- Integration review continua, no al final del ciclo
- Staging usable todo el ciclo, no solo los últimos 3 días

### ❌ Negativo

- Código dual (if/else) mientras el flag exista
- Deuda técnica si flags se acumulan sin remover
- Overhead de configuración inicial por feature (~15 min)

### 🔄 Neutral

- Requiere disciplina para remover flags post-release
- Equipos pequeños pueden ver overhead; equipos grandes lo valoran

---

## Decisiones Relacionadas

| Decisión | Ubicación |
|----------|-----------|
| Ciclo de 15 días | ADR-003 |
| docs/ como source of truth | ADR-002 |
| Release checklist | docs/flowdoc-ciclo.md Sección 1.6 |
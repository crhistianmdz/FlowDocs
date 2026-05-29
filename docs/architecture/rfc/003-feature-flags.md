# RFC-003: Feature Flags Obligatorios para Features Nuevos

- **Estado**: Aprobado
- **Autor(es)**: @Crhistian
- **Fecha**: 2026-05-29
- **Proyecto**: Framework de Trabajo para Equipos Distribuidos

---

## 1. Resumen

Toda feature nueva que no sea un hotfix se desarrolla detrás de un feature flag. El flag debe estar en `false` hasta que el release sea validado en staging y production. El objetivo es permitir trabajo paralelo seguro sin romper el codebase compartido.

---

## 2. Contexto

- **Problema técnico**: En equipos distribuidos trabajando en paralelo, un developer puede mergear código que rompe la funcionalidad de otro. Los feature flags permiten que cada developer trabaje en Isolation sin afectar a los demás hasta que la feature esté lista.
- **Por qué es necesario decidir esto ahora**: Sin feature flags, el trabajo paralelo es arriesgado. Necesitamos un mecanismo para que múltiples personas trabajen simultáneamente en `dev` sin pisarse.
- **Alternativas consideradas**:
  1. **Branches largos por feature**: Cada developer en su branch hasta terminar. Problema: integration hell al final, merge conflicts enormes.
  2. **Feature flags opcionales (recomendación)**: Cada equipo decide si usar o no. Problema: inconsistencias, algunos equipos los usan y otros no.
  3. **Feature flags obligatorios (elegido)**: Todo feature nuevo requiere flag. Consistency across equipos.

---

## 3. Decisión Técnica

### 3.1 Nomenclatura de Flags

```
{HU-ID}[-opcional-subfeature]

Ejemplos:
HU-001              → Flag: HU-001 (feature completa)
HU-003-v2           → Flag: HU-003-v2 (versión 2 de la feature)
HU-005-experimental → Flag: HU-005-exp (A/B testing)
```

### 3.2 Reglas del Flag

| Fase | Estado del Flag | Qué significa |
|------|----------------|---------------|
| Development (días 3-11) | `false` | Feature existe en código pero no está activa |
| Staging (días 12-14) | `true` | Feature activa para integration review |
| Production | `true` (release validado) | Feature viva para usuarios |
| Post-release | **REMOVE** | Flag y código viejo se eliminan |

**Regla de oro**: Un flag no puede estar activo más de **2 ciclos** (30 días). Si sigue activo, es deuda técnica.

### 3.3 Implementación

**Ejemplo conceptual** (pseudocódigo):

```typescript
// Ejemplo: Angular component
@Component({...})
export class OrderListComponent {
  // Flag check en el componente
  isNewOrderFlowEnabled = featureFlags['HU-001'];

  // Template condicional
  // @if (isNewOrderFlowEnabled) {
  //   <new-order-flow />
  // } @else {
  //   <legacy-order-flow />
  // }
}

// Ejemplo: Backend endpoint
app.post('/api/orders', async (req, res) => {
  if (featureFlags['HU-001']) {
    return newOrderFlow(req, res);
  }
  return legacyOrderFlow(req, res);
});
```

### 3.4 Feature Flag Provider

| Maturity | Herramienta | Cuándo usar |
|----------|--------------|-------------|
| **L1: Variables de entorno** | `.env` | Inicio, equipos pequeños |
| **L2: Config en runtime** | JSON/YAML en servidor | Varios entornos, testing manual |
| **L3: Servicio dedicado** | LaunchDarkly, Flagsmith, Unleash | Equipos grandes, múltiples features simultáneas |

---

## 4. Workflow con Feature Flags

### Desarrollo (días 3-11)

1. Crear feature branch: `feature/kaito-HU-001`
2. Implementar feature con flag en `false`
3. Merge a `dev` (flag sigue en `false`)
4. Otros developers trabajan normalmente, no se ven afectados

### Integration (días 12-14)

1. Activar flag en staging
2. Integration review con feature activa
3. Si pasa → preparar release
4. Si no pasa → desactivar flag, continue desarrollo

### Release (día 14+)

1. Tech Lead approves release
2. Activar flag en production
3. Monitorear métricas
4. Remover flag en próximo ciclo (no dejar deuda)

---

## 5. Rollback Rápido

**Beneficio clave**: Desactivar un flag es instantáneo, no requiere deploy.

```
Problema en production con HU-001:
  1. Desactivar flag HU-001 → Config: false
  2. Feature vieja vuelve automáticamente
  3. Sin deploy, sin rollback de código
```

vs

```
Rollback tradicional:
  1. git revert v1.x.x
  2. Re-deploy
  3. 5-15 min de downtime
```

---

## 6. Costos y Recursos

- **Setup inicial**: ~15 min (configurar flag, implement condicional)
- **Mantenimiento**: Eliminar flag post-release (~15 min)
- **Herramienta dedicada**: $0 (L1-L2) o ~$100-500/mes (L3)

---

## 7. Riesgos

| Riesgo | Impacto | Mitigación |
|--------|---------|------------|
| Flags acumulativos (deuda técnica) | Medio | Regla: max 2 ciclos por flag, tracked en tech-debt.md |
| Código dual (if/else) se vuelve complejo | Medio | Refactor post-flag-removal |
| Flag mal nombrado/confundido | Bajo | Usar nomenclatura consistente: HU-NNN |
| Olvidar activar/desactivar flag | Medio | Checklist en DoD, automate where possible |

---

## 8. Estados de Aprobación

| Rol | Persona | Estado | Fecha |
|-----|---------|--------|-------|
| Tech Lead | @Crhistian | Aprobado | 2026-05-29 |

---

## 9. Historial de Cambios

| Fecha | Cambio | Autor |
|-------|--------|-------|
| 2026-05-29 | Versión inicial | @Crhistian |

---

## 10. Documentos Relacionados

- **RFC-001**: Estructura de documentación docs/
- **RFC-002**: Ciclo de trabajo de 15 días
- **framework-coordinacion.md**: Sección 1.1.5 Feature Flag Strategy
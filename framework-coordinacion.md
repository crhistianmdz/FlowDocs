# Ciclo de Trabajo: 15 Días Útiles

```
Días 1-2:   Planning & Contract
Días 3-11:  Execution (con sync semanal)
Días 12-14: Integration & Verify
Días 15:    Retrospective
```

---

## Phase 1: Planning & Contract (Días 1-2)

**Duración máxima**: 4 horas totales

### 1.1 Feature List Collab (2 horas, todos juntos)

- Reunión virtual de 2 horas
- Escribir todas las features en un documento compartido
- Priorizar con matriz: impacto vs esfuerzo
- Seleccionar máximo 5-6 features para los 15 días
- Regla: si una feature no cabe en 3-4 días, dividirla

### 1.2 Task Contract (1 hora)

Por cada feature:
```
FEATURE: [nombre]
OWNER: @usuario (solo uno)
DEPENDENCIAS: [qué necesita de otros]
DEADLINE: Día [X]
DONE WHEN: [qué significa "entregado"]
```

### 1.3 Dependency Map (30 min)

Documentar explícitamente las dependencias:
- "Pedro: no podés empezar X hasta que María defina Y"

### 1.4 Estrategia de Branching

```
main                 ← Producción. Solo desde staging vía release.
staging             ← Pre-producción. Integration review + smoke tests.
dev                 ← Integración diaria. PRs desde feature branches.
feature-{usuario}-{HU}  ← trabajo individual de cada HU.
```

**Flujo**:
1. Cada desarrollador crea `feature-{su-nombre}-{HU}` desde `dev`
2. Termina la HU → abre PR a `dev` (mínimo 1 aprobación, tests pasando)
3. Día 12: `dev` → `staging` (release candidate, integration review)
4. Integration review pasa → `staging` → `main` (producción)
5. **Hotfix**: `hotfix-{nombre}-{desc}` desde `main` → PR a `main` y a `dev`

**Reglas**:
- Nadie mergea su propio PR
- `staging` y `main` solo los mergea el Tech Lead
- Si dos HUs dependen entre sí, mergear primero la que tiene la dependencia base

### 1.5 Definition of Done del Proyecto

Acordar qué significa "entregado":
- Código funcionando
- **Todos los escenarios de la HU tienen 🧪 Ref y sus tests pasan**
- Code review aprobada
- Desplegado a staging
- Un teammate que NO escribió el código lo probó

---

## Phase 2: Execution (Días 3-11)

**Regla de testing**: cada tarea de código incluye su tarea de test al lado.
No se considera "completado" hasta que el test asociado existe y pasa.

### 2.1 Async Updates (diario, 5 min)

Formato:
```
Feature X: [en progreso/bloqueado/completado]
Bloqueado: [sí/no] - Si sí, por quién
Tests: [cantidad escritos / cantidad pendientes según HU]
```

Regla: Si estás bloqueado, AVISAR INMEDIATAMENTE. No esperar al weekly.

### 2.2 Weekly Sync (Día 7, 30 min)

Agenda:
1. ¿Qué se completó? (5 min)
2. ¿Qué está bloqueado? (10 min - resolver ahí)
3. ¿Qué ajustar? (10 min)
4. Próximo paso (5 min)

---

## Phase 3: Integration & Verify (Días 12-14)

**Regla**: NO HAY CODE REVIEW INDIVIDUAL. Se necesita Integration Review: "¿funciona todo junto?"

Checklist:
- [ ] **Todos los 🧪 Ref de las HUs apuntan a tests existentes y pasan**
- [ ] Tests de integración pasaron
- [ ] API documentada
- [ ] Los consumidores (web + móvil) funcionando con los mismos endpoints
- [ ] Desplegado a staging
- [ ] Un teammate que NO escribió el código lo probó

Limpiar pendientes: documentar qué no se terminó y por qué.

---

## Phase 4: Retrospective (Día 15, 1 hora)

Formato:
1. ¿Qué funcionó bien? (seguir haciendo)
2. ¿Qué no funcionó? (STOP doing)
3. ¿Qué aprendimos? (para el próximo proyecto)

Documentar en máximo una página.
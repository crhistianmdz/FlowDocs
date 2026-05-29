# Ciclo de Trabajo: 15 Días Útiles

> **Basado en Scrum** adaptado para equipos distribuidos y trabajo async. Si conocés Scrum, vas a reconocer los conceptos. Si no, los adaptás a tu metodología.

```
Días 1-2:   Planning & Contract
Días 3-11:  Execution (con sync semanal)
Días 12-14: Integration & Verify
Días 15:    Retrospective
```

| Concepto Scrum | Adaptación |
|----------------|------------|
| Sprint | Ciclo de 15 días |
| Daily standup | Async update de 5 min |
| Sprint planning | Días 1-2 |
| Integration review | Días 12-14 |
| Retrospective | Día 15 |

---

## Async Communication Charter

| Canal | Para | SLA |
|-------|------|-----|
| Discord | Preguntas rápidas, blockers, updates diarios | 4h hábiles |
| GitHub Issues | Bugs, features, tareas trackeables | 24h |
| Llamada rápida | Decisiones que requieren ida y vuelta | Cuando haga falta |

### Decisiones técnicas
- La discusión es por Discord o llamada (sin proceso, como siempre).
- **Una vez decidido**: crear ADR en `docs/architecture/adr/`. 2 minutos.
- Regla de oro: **si no hay ADR, la decisión no existe**.

### Proceso de resolución de conflictos

1. **Propuesta**: Se comenta en Discord y se escribe el RFC correspondiente
2. **Discusión**: Se debate asíncronamente en Discord
3. **Si no hay consenso**: Reunión sincrónica (máx. 2 horas) — se debate y se decide ahí mismo
4. **Decisión registrada**: Se crea el ADR en `docs/architecture/adr/`
5. **ADR obsoleto**: Se marca como `DEPRECATED` con link al nuevo ADR que lo reemplaza

### Gobernanza de Agents de IA

**Principios:**
- Los agents son herramientas de asistencia, no responsables. El dev siempre es responsable del código que entrega.
- Los agents **NO hacen commits**. El dev revisa, commitea y abre el PR.
- Los agents NO modifican `AGENTS.md`, `docs/`, ni `openspec/` sin aprobación humana.
- Los agents NO mergean a `main` ni `staging`. Solo pueden generar código en feature branches.

**Reglas de uso:**
- Cada HU tiene un owner que decide qué agent usar y cuándo.
- No se lanzan agents simultáneos sobre la misma tarea.
- El agent trabaja siempre con `--from-docs` — no genera nada desde cero.
- El humano revisa SIEMPRE el output del agent antes de commitear.

**Configuración:**
- El `AGENTS.md` de cada proyecto lo crea y mantiene el Tech Lead.
- Se actualiza cuando cambian las reglas del proyecto o el stack.
- Si un developer necesita cambiar algo en `AGENTS.md`, abre un RFC primero.

### Cadencia de Reuniones

| Tipo | Frecuencia | Duración | Quién |
|------|-----------|----------|-------|
| **Planning** | Inicio de ciclo (Día 1) | 2h | Todo el equipo |
| **Weekly Sync** | Día 7 de cada ciclo | 30 min | Todo el equipo |
| **Integration Review** | Día 12 | 1h | Todo el equipo |
| **Retrospectiva** | Día 15 | 1h | Todo el equipo |
| **Decisión técnica** | Solo si no hay consenso async | Máx 2h | Involucrados + moderador |
| **1:1 / Onboarding** | Según necesidad | Variable | Owner + nuevo miembro |

**Regla**: Si no necesita interacción en tiempo real, no es reunión — es Discord o Issue.
**Timezone rotation**: Si el equipo está en más de 2 zonas horarias, rotar los horarios de reuniones sincrónicas para que no siempre perjudique al mismo equipo.

### Documentación Viva

Los docs son tan importantes como el código. Si no se actualizan, pierden todo valor.

**Reglas:**
- **Docs se actualizan en el PR**: Si un PR cambia un endpoint, se actualiza API docs en el MISMO PR. Si no, el PR no pasa.
- **Review de docs en Retrospectiva**: Día 15, scan rápido — ¿hay docs desactualizados? ¿ADRs obsoletos?
- **Label `docs-stale`**: Si alguien detecta doc desactualizada, crea issue con label `docs-stale`. Se prioriza en el próximo ciclo.

**Owner de docs**: El Tech Lead es responsable de que los docs estén al día. Pero cada developer es responsable de los docs que toca.

### Reglas
- Si necesitás +2 párrafos para explicar, no es Discord — es un Issue o documento.
- No @everyone. Usá @persona o @channel solo si es blocker.
- Respetá los SLA según el huso horario de cada uno.
- Async updates diarios (Phase 2): máx 5 min.

---

## Phase 1: Planning & Contract (Días 1-2)

**Duración máxima**: 4 horas totales

### 1.1 Feature List Collab (2 horas, todos juntos)

- Reunión virtual de 2 horas
- Escribir todas las features en un documento compartido
- Priorizar con matriz: impacto vs esfuerzo
- Seleccionar máximo 5-6 features para los 15 días
- Regla: si una feature no cabe en 3-4 días, dividirla

### 1.1.5 Feature Flag Strategy

Toda feature nueva que no sea un hotfix se desarrolla detrás de un feature flag.

**Nomenclatura**: `{HU-ID}[-opcional-subfeature]`
- `HU-001` — flag único para la feature completa
- `HU-003-v2` — migración gradual
- `HU-005-experimental` — A/B testing

**Reglas:**
- El flag se define en Planning junto con la HU. Sin flag definido, no se empieza.
- El código mergea a `dev` con el flag en `false`. Feature dormida, no rompe nada.
- El flag se activa en `staging` para la integration review (día 12).
- El flag se activa en `production` después del release validado (día 14).
- El flag y el código viejo que reemplaza se **REMUEVEN** en el próximo ciclo. Un flag vivo más de 2 ciclos es deuda técnica.

**Por qué:**
- Permite mergear a `dev` desde el día 3 sin miedo a romper nada.
- Hace que `staging` sea usable todo el ciclo, no solo los últimos 3 días.
- Rollback inmediato: desactivar un flag es instantáneo, no requiere deploy.
- Cada dev trabaja independiente sin bloquear a los demás.

**Herramientas sugeridas:**
- Variables de entorno (fase inicial)
- LaunchDarkly, Flagsmith o Unleash (cuando el equipo crezca)

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

Acordar qué significa "entregado". Esta misma lista se verifica en Phase 3.

- [ ] **Tests unitarios**: todos los escenarios de las HUs tienen 🧪 Ref y pasan
- [ ] **Feature flag definido y mergeado en `false`**: la feature no está viva hasta que el release lo active
- [ ] **Tests de integración**: pasan
- [ ] **Smoke tests en staging**: la feature funciona después del deploy
- [ ] **Documentación actualizada**: API docs, ADR si corresponde
- [ ] **Code review aprobada** (por alguien que NO escribió el código)
- [ ] **Desplegado a staging**
- [ ] **Deuda técnica consciente**: si se dejó algo pendiente, está documentado con issue

### 1.6 Release Checklist (staging → main)

Se verifica antes de cualquier deploy a producción:

- [ ] Todos los items de la DoD están cumplidos
- [ ] Integration review pasada en staging
- [ ] Smoke tests en staging pasan
- [ ] Tech Lead aprueba el release
- [ ] Changelog actualizado (features nuevas, bugs fixeados)
- [ ] Tag de versión creado (semver: v1.x.x)
- [ ] **Feature flags del release activados en producción**: solo los flags de este ciclo
- [ ] **Flags del ciclo anterior removidos**: sin flags huérfanos acumulando deuda técnica

### 1.7 Proceso de Hotfix

Para fixes urgentes en producción:

1. Crear branch `hotfix-{nombre}-{desc}` desde `main`
2. Resolver el problema (fix rápido, no la causa raíz)
3. Abrir PR → 1 review mínimo → merge a `main` Y a `dev`
4. Mergea el Tech Lead
5. Documentar en changelog

---

## Phase 2: Execution (Días 3-11)

**Regla de testing**: cada tarea de código incluye su tarea de test al lado.
No se considera "completado" hasta que el test asociado existe y pasa.

**Regla SDD**: si se trabaja desde una HU pre-escrita, usar `/sdd-new <nombre> --from-docs`.
Sin `--from-docs` el agente NO lee la HU y genera todo desde cero.

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

Checklist (contra la DoD acordada en Planning 1.5):
- [ ] **Todos los items de la DoD están cumplidos**
- [ ] **Integration review**: los consumidores (web + móvil) funcionan con los mismos endpoints
- [ ] **Pendientes documentados**: qué no se terminó y por qué

No duplicar la DoD aquí — la DoD vive en Planning y se verifica acá.

---

## Phase 3.5: Release (Día 14)

Una vez que Integration Review pasa y la DoD está cumplida:

1. Tech Lead revisa el Release Checklist (ver 1.6)
2. Si todo está OK: `staging` → `main`
3. Crear tag de versión: `git tag -a v1.x.x -m "Release 1.x.x"`
4. Push del tag: `git push origin v1.x.x`
5. Comunicar al equipo en Discord: "✅ Release v1.x.x en producción"

---

## Phase 4: Retrospective (Día 15, 1 hora)

Formato:
1. ¿Qué funcionó bien? (seguir haciendo)
2. ¿Qué no funcionó? (STOP doing)
3. ¿Qué aprendimos? (para el próximo proyecto)

Documentar en máximo una página.

---

## Proceso de Incidentes

### Cuando se rompe producción

1. **Detectar**: Alguien avisa en Discord con `@channel - INCIDENTE: [descripción breve]`
2. **Hotfix**: Seguir el proceso de 1.7
3. **Postmortem** (dentro de 48h): Documento con:
   ```
   ## Incidente: [nombre]
   **Fecha**: [YYYY-MM-DD]
   **Impacto**: [qué usuarios afectados, por cuánto tiempo]
   **Causa raíz**: [qué lo provocó]
   **Fix aplicado**: [qué se hizo para resolverlo]
   **Prevención**: [qué se hace para que no vuelva a pasar]
   **ADRs creados/actualizados**: [si aplica]
   ```

### Reglas
- El postmortem es **obligatorio** para incidentes que afectaron a usuarios
- No es para buscar culpables — es para mejorar el sistema
- Se guarda en `docs/incidents/YYYY-MM-DD-nombre.md`

---

## Rollback Strategy

Cuando un release a producción causa problemas graves:

**Criterios de rollback:**
- Error que afecta a >50% de los usuarios
- Pérdida o corrupción de datos
- Tiempo de respuesta > 5x el normal
- Feature crítica rota (login, pagos, etc.)

**Procedimiento:**
1. **Detectar**: Alguien avisa en Discord con `@channel - ROLLBACK: [versión afectada]`
2. **Revertir tag**: `git tag -d v1.x.x && git push --delete origin v1.x.x`
3. **Revertir código**: `git revert v1.x.x` (o `git reset --hard v1.x-1.x` si es necesario)
4. **Deploy inmediato**: Re-desplegar la versión anterior estable
5. **Comunicar**: Informar al equipo en Discord: "⚠️ Rollback de v1.x.x realizado. Versión estable: v1.x-1.x"
6. **Postmortem**: Dentro de 48h, documentar qué falló y cómo evitarlo

**Regla**: El rollback no es fracaso — es una herramienta de seguridad. Se documenta, se aprende, se mejora.

---

## Apéndice: Onboarding

Para personas nuevas en el equipo, existe `ONBOARDING.md` en la raíz del proyecto con un checklist día por día.
Incluye: acceso, entorno local, contexto del proyecto y primera contribución supervisada.
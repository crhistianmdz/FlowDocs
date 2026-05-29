# Troubleshooting — Errores Comunes y Soluciones

> Guía de problemas frecuentes cuando usas SDD con este framework.

---

## SDD Commands

### `/sdd-init` no funciona

**Síntoma**: El comando no responde o da error.

**Causas posibles**:
1. No estás en un proyecto git
2. El directorio no tiene permisos de escritura
3. La tool de SDD no está configurada

**Solución**:
```bash
# Verificar que estás en un repo git
git status

# Verificar permisos
ls -la

# Si el proyecto está vacío, inicializar git primero
git init
git add .
git commit -m "chore: initial structure"

# Luego volver a intentar
/sdd-init
```

---

### `/sdd-new` no lee las HUs de `docs/tasks/`

**Síntoma**: El agent genera todo desde cero en lugar de usar tu HU pre-escrita.

**Causa**: Falta el flag `--from-docs`

**Solución**:
```bash
# ❌ Wrong - genera todo desde cero
/sdd-new mi-feature

# ✅ Correct - lee de docs/tasks/HU-XXX.md
/sdd-new mi-feature --from-docs
```

---

### Engram no guarda contexto entre sesiones

**Síntoma**: Después de cerrar y abrir OpenCode, el agent no recuerda nada del proyecto.

**Causa**: No se corrió `/sdd-init` al inicio de la sesión.

**Solución**:
```bash
# Al inicio de cada sesión
/sdd-init

# Luego puedes continuar con tu trabajo
/sdd-new mi-feature --from-docs
```

---

### Artifact store mode incorrecto

**Síntoma**: Los artifacts se guardan en un lugar que no esperabas.

**Modos disponibles**:

| Mode | Dónde guarda | Cuándo usarlo |
|------|--------------|---------------|
| `engram` | Base de datos local Engram | Trabajo individual |
| `openspec` | Archivos en `openspec/` | Equipos (git-tracked) |
| `hybrid` | Ambos | Recovery + compartir |

**Cambiar modo**:
```bash
# En OpenCode, usar el comando de configuración
# o editar la configuración del proyecto

# Ver modo actual
/sdd-init

# Para equipos, usar openspec mode desde el inicio
```

---

## Git & Branching

### Conflictos en `docs/` cuando hago pull

**Síntoma**: `git pull` da conflictos en archivos de documentación.

**Causa**: Dos personas editaron la misma documentación.

**Solución**:
```bash
# Opción 1: Pull con rebase (si sabes que tus cambios van primero)
git pull --rebase origin main

# Opción 2: Resolver conflictos manualmente
git pull origin main
# Editar los archivos en conflicto
git add .
git commit -m "chore: resolve conflicts in docs"
git push

# Opción 3: Hablar con el otro dev ANTES de editar docs compartidos
```

**Prevención**: Comunicar en Discord cuando vas a editar docs compartidos.

---

### No puedo hacer push a `main` o `staging`

**Síntoma**: Git rechaza el push.

**Causa**: Rama protegida, solo Tech Lead puede mergea a estas ramas.

**Solución**:
```bash
# Crear feature branch desde dev
git checkout dev
git checkout -b feature/mi-nombre-HU-XXX

# Trabajar en la feature branch
# Abrir PR a dev (no a main/staging)
# Esperar approval
# Tech Lead mergea a staging/main
```

---

### Self-merge (mergeo mi propio PR)

**Síntoma**: El repo tiene un merge de tu branch a ti mismo.

**Causa**: Violación de regla del equipo.

**Regla**: Nadie mergea su propio PR. Siempre otro miembro revisa y approve.

**Solución**:
```bash
# No hacer esto:
git checkout main
git merge feature/mi-branch  # ❌ Wrong

# Hacer esto:
# 1. Abrir PR desde GitHub UI
# 2. Solicitar review a otro miembro
# 3. Esperar approval
# 4. Alguien más mergea
```

---

## Documentación

### No sé qué plantilla usar

| Situación | Template |
|-----------|----------|
| Nueva feature | `templates/template-user-story-sdd.md` |
| Bug fix | `templates/template-bug-fix-sdd.md` |
| Refactor (sin cambio de comportamiento) | `templates/template-refactor.md` |
| Decisión técnica nueva | `templates/RFC_template.md` |
| Decisión técnica aprobada | `templates/ADR_template.md` |
| Documento de producto | `templates/PRD_template.md` |

---

### ADR obsoleto pero不知道 cómo marcarlo

**Solución**:
```markdown
# ADR-NNN: Título de la decisión

- **Fecha**: YYYY-MM-DD
- **Estado**: Deprecado
- **Reemplazado por**: ADR-MMM - Nuevo título
```

El ADR queda como histórico. No se borra.

---

### La documentación está desactualizada

**Síntoma**: `docs/` no refleja el código actual.

**Regla**: Docs se actualizan en el MISMO PR que cambia el código.

**Solución**:
1. Si encontrás docs desactualizadas, crear issue con label `docs-stale`
2. En el próximo planning, priorizarlas
3. O fixearlas inmediatamente si es rápido

---

## Feature Flags

### Feature flag no funciona

**Síntoma**: La feature no aparece aunque el flag debería estar activo.

**Causas posibles**:

1. **Flag en código no coincide con nombre en config**
   ```typescript
   // ❌ Wrong
   if (featureFlags.HU_001) { }  // con underscore

   // ✅ Correct
   if (featureFlags['HU-001']) { }  // con guion, como se definió
   ```

2. **Flag no activado en el entorno**
   ```bash
   # En .env
   FLAG_HU001=false  # ❌ development
   # vs
   FLAG_HU001=true   # ✅ production
   ```

3. **Feature flag no mergeado a la rama correcta**
   ```bash
   # El flag debe estar en la misma rama que el feature
   git log --oneline | grep HU-001
   ```

---

## Legacy Projects

### El proyecto es muy grande, por dónde empiezo?

**Regla**: No intentar documentar todo. Solo lo que se toca.

**Estrategia**:
1. Crear `docs/architecture/adr/000-legacy-state.md` (inventory de lo que hay)
2. Elegir UNA cosa que se va a cambiar en el próximo sprint
3. Crear HU para esa cosa
4. SDD completo para esa HU
5. Repetir

Más detalles en: `docs/legacy-migration.md`

---

### El código no tiene tests, qué hago?

**Opciones**:

1. **Si es código legacy estable**: No escribir tests (aún no se rompe, no tocarlo)
2. **Si es código que se va a cambiar**: Escribir tests ANTES del cambio (TDD)
3. **Si es código nuevo**: Tests obligatorios desde el primer día

**Cobertura mínima**: >80% para código nuevo.

---

## Comunicación

### No me responden en Discord hace 24h

**SLA según timezone**:
- Discord: respuesta en 4h hábiles
- GitHub Issues: respuesta en 24h

**Si no hay respuesta después del SLA**:
1. Reenviar mensaje mencionando a la persona
2. Si es blocker, mencionar `@channel`
3. Si después de 48h sigue sin respuesta, escalar al Tech Lead

---

### Hay dos personas trabajando en la misma HU

**Causa**: Falta de comunicación async.

**Solución**:
1. Avisar inmediatamente en Discord: "Estoy trabajando en HU-XXX"
2. Dividir la HU si es muy grande
3. Crear subtareas si son independientes

---

## Referencias Rápidas

| Problema | Archivo de referencia |
|----------|----------------------|
| Cómo estructurar docs | `README.md` → sección Estructura |
| Cómo escribir HU | `templates/template-user-story-sdd.md` |
| Ciclo de trabajo | `docs/flowdoc-ciclo.md` |
| Migración legacy | `docs/legacy-migration.md` |
| Branching strategy | `docs/flowdoc-ciclo.md` → sección branching |
| Onboarding nuevo miembro | `ONBOARDING.md` |

---

**¿Problema no listado?** Abrir issue en el repo o preguntar en Discord.
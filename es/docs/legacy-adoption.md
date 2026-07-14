# Guía de Adopción Legacy

> Cómo adoptar FlowDocs en proyectos existentes con código.

---

## Cuándo Usar Esto

Usá `--legacy` cuando:
- Tenés un proyecto existente con código
- Querés documentarlo con FlowDocs
- El codebase no tiene documentación formal aún

```bash
init-flowdoc.sh --legacy
```

---

## Qué Hace

1. **Explora** tu codebase (entry points, APIs, DB, docs existentes)
2. **Crea** `docs/flowDocs/` con:
   - `flowdoc-migration-progress.md` — trackea qué está hecho
   - `flowdoc-migration-prompt.md` — prompt para agente de IA
   - `migrations/` con 4 templates de HU
3. **Genera** `docs/PRD.md` desde los datos de exploración

---

## Inicio Rápido

### 1. Ejecutá el script

```bash
# Básico (con exploración)
bash scripts/init-flowdoc.sh --legacy

# Saltar exploración (más rápido)
bash scripts/init-flowdoc.sh --legacy --no-explore

# Preview sin crear archivos
bash scripts/init-flowdoc.sh --legacy --dry-run
```

### 2. Leé el prompt

```bash
cat docs/flowDocs/flowdoc-migration-prompt.md
```

### 3. Pasá al agente de IA

Dás al agente el contenido del prompt y dejalo generar la documentación.

### 4. Revisá los resultados

El agente crea:
- `migrations/HU-001-prd.md` — Overview del proyecto
- `migrations/HU-002-rfc-legacy.md` — Decisiones técnicas encontradas
- `migrations/HU-003-apis.md` — Endpoints de API
- `migrations/HU-004-db-schema.md` — Schema de base de datos

**Importante**: Revisá el schema de DB cuidadosamente. El agente infiere desde el código — verificá contra la base de datos real.

### 5. Trackeá el progreso

El `flowdoc-migration-progress.md` trackea qué está hecho:

```markdown
| HU | Área | Estado |
|----|------|--------|
| HU-001 | PRD | ✅ Hecho |
| HU-002 | RFC Legacy | 🟡 En Progreso |
| HU-003 | APIs | 🔲 Pendiente |
| HU-004 | DB Schema | 🔲 Pendiente |
```

---

## Estructura Generada

```
docs/
└── flowDocs/
    ├── flowdoc-migration-progress.md  ← Trackea progreso
    ├── flowdoc-migration-prompt.md    ← Prompt para agente
    └── migrations/
        ├── HU-001-prd.md
        ├── HU-002-rfc-legacy.md
        ├── HU-003-apis.md
        └── HU-004-db-schema.md
```

---

## Flags

| Flag | Propósito |
|------|----------|
| `--legacy` | Habilita modo legacy |
| `--no-explore` | Salta exploración del codebase |
| `--overwrite` | Sobrescribe PRD existente |
| `--dry-run` | Preview sin crear archivos |

---

## Para Proyectos Grandes

Si el proyecto es grande, trabajá en sesiones:

1. Ejecutá `--legacy` una vez para generar la estructura
2. Dejá que el agente complete una HU a la vez
3. Actualizá `flowdoc-migration-progress.md` después de cada sesión
4. Cuando todas las HUs estén listas, movelas a las ubicaciones finales en `docs/`

---

## Ejemplo de Sesión

```bash
# 1. Generar estructura
bash scripts/init-flowdoc.sh --legacy

# 2. El agente llena las HUs
# (Pasá al agente docs/flowDocs/flowdoc-migration-prompt.md)

# 3. Revisá cada HU
# Especialmente validar: HU-004-db-schema.md

# 4. Mover HUs a ubicación final
mv docs/flowDocs/migrations/* docs/tasks/

# 5. Commitear
git add .
git commit -m "docs: complete FlowDoc adoption"
```

---

## Ver También

- [Guía de Adopción](adoption-guide.md) — Cómo adoptar FlowDocs
- [init-flowdoc.sh --help](scripts/init-flowdoc.sh) — Referencia completa del script

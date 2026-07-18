# FlowDoc Legacy Migration Checklist

> Use this checklist after running `scripts/flowdoc-migration.sh` to complete the migration from a legacy project to FlowDoc.

---

## 🎯 Which Scenario Applies?

Run this to identify your situation:

```bash
# Check for existing documentation
find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" | head -20

# Check for existing SDD structure
ls -la docs/ 2>/dev/null || echo "No docs/ directory"
ls -la openspec/ 2>/dev/null || echo "No openspec/ directory"
ls -la AGENTS.md 2>/dev/null || echo "No AGENTS.md"
```

| Scenario | What you have | Use |
|----------|---------------|-----|
| **A. Con SDD existente** | HUs, ADRs, RFCs, docs/ structure | → Go to Step 1 |
| **B. Sin SDD (legacy)** | Código existente pero sin docs/ formal | → Go to Scenario B |
| **C. Proyecto nuevo** | Sin código, proyecto desde cero | → Go to Scenario C |

---

## Scenario A: Proyecto Legacy CON SDD Existente

> You have existing HUs, ADRs, RFCs — follow the full checklist.

---

## ⚠️ Before Starting

1. Run `scripts/flowdoc-migration.sh` (creates structure + templates)
2. Confirm you have a backup or are in a git repo

---

## Step 1: Inventory (Identify What Exists)

Run these commands to understand what you have:

```bash
# What documentation exists?
find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" | head -50

# What HUs exist?
find . -name "HU-*.md" -o -name "hu-*.md" -o -name "*user-story*.md" 2>/dev/null

# What ADRs exist?
find . -name "ADR-*.md" -o -name "adr-*.md" 2>/dev/null

# What RFCs exist?
find . -name "RFC-*.md" -o -name "rfc-*.md" 2>/dev/null

# Any existing AGENTS.md?
cat AGENTS.md 2>/dev/null || echo "No AGENTS.md found"

# Any openspec/ artifacts?
ls -la openspec/ 2>/dev/null || echo "No openspec/ found"
```

### Questions to Answer

| Question | Your Answer |
|----------|-------------|
| Where are the HUs? | |
| Where are the ADRs/RFCs? | |
| Is there an existing AGENTS.md? | |
| Are there existing templates? | |
| What's the current structure? | |

---

## Step 2: Map Existing HUs to FlowDoc Structure

For each HU you found:

```
OLD LOCATION                    → NEW LOCATION
----------------------------------------------------------------
docs/tasks/*.md                → docs/tasks/HU-001-HU-099/HU-XXX-*.md
docs/HU-*.md                   → docs/tasks/HU-001-HU-099/HU-XXX-*.md
hu-*.md                        → docs/tasks/HU-001-HU-099/HU-XXX-*.md
templates/user-stories/*.md     → docs/templates/user-stories/ (replace with FlowDoc templates)
```

### Actions

1. **Move HUs to correct location:**
   ```bash
   # Example - adapt to your actual paths
   mv docs/tasks/HU-001.md docs/tasks/HU-001-HU-099/
   mv docs/tasks/HU-002.md docs/tasks/HU-001-HU-099/
   ```

2. **Use FlowDoc templates** for new HUs (script already created them)
   - Don't rewrite existing HUs unless needed
   - New HUs use FlowDoc templates

### ⚠️ Important

- **HUs with active work**: Keep current status, just move file
- **HUs with done status**: Keep as done, just move file
- **HUs with no status**: Add status before moving
- **HU numbering**: FlowDoc uses HU-XXX format. If your existing HUs have different names, you may renumber or keep existing names (not a problem)

---

## Step 3: Move ADRs and RFCs to docs/architecture/

```
OLD LOCATION                    → NEW LOCATION
----------------------------------------------------------------
docs/architecture/adr/*.md     → docs/architecture/adr/
docs/adr/*.md                  → docs/architecture/adr/
architecture/*.md              → docs/architecture/
ADRs/*.md                      → docs/architecture/adr/
RFCs/*.md                      → docs/architecture/rfc/
```

### Actions

```bash
# Example - adapt to your actual paths
mv docs/adr/*.md docs/architecture/adr/
mv docs/rfc/*.md docs/architecture/rfc/
```

### Update References

If an ADR references another ADR or external file, update the links:

```markdown
# Before
[ADR-001](./../../adr/ADR-001.md)

# After
[ADR-001](./ADR-001.md)
```

---

## Step 4: Adapt AGENTS.md to Your Project

The script created a base `AGENTS.md`. You need to customize it:

### Required Changes

1. **Project name and description**
   ```markdown
   # Before (FlowDoc default)
   **Framework**: FlowDoc — Documentación que fluye con el trabajo
   **Ecosistema**: FlowForge (tool) + FlowDoc (framework)

   # After (your project)
   **Framework**: FlowDoc — Documentación que fluye con el trabajo
   **Project**: [Tu Proyecto] — [Descripción]
   ```

2. **Team information** (add or update)
   ```markdown
   ### Herramientas de Equipo
   - **Control de versiones**: Git + GitHub
   - **Comunicación**: Discord (async-first)
   - **Issues**: GitHub Issues
   ```

3. **Tech Stack** (update with your actual stack)
   ```markdown
   ### Stack del Proyecto
   - **Frontend**: React + TypeScript
   - **Backend**: Node.js + Express
   - **Database**: PostgreSQL
   ```

### Optional Changes

- Add project-specific conventions
- Add environment setup instructions
- Add team-specific rules

---

## Step 5: Integrate Existing openspec/ (if exists)

If you have `openspec/` with SDD artifacts:

```
openspec/
├── config.yaml
├── specs/
│   └── {domain}/
│       └── spec.md        → docs/{domain}/spec.md (consider consolidating)
└── changes/
    └── {change-name}/
        ├── proposal.md    → docs/tasks/HU-XXX-proposal.md (consider converting)
        ├── specs/
        ├── design.md
        └── tasks.md
```

### Decision: Keep openspec/ or Consolidate?

| Option | When to Use | Pros | Cons |
|--------|-------------|------|------|
| **Keep openspec/** | Active SDD work, team familiar with it | No change | Dual structure |
| **Consolidate to docs/** | Simplify, single source of truth | Unified docs | Migration effort |

### If Consolidating

```bash
# Move openspec artifacts to docs/
mv openspec/changes/*/proposal.md docs/tasks/HU-XXX-proposal.md 2>/dev/null || true
mv openspec/changes/*/design.md docs/tasks/HU-XXX-design.md 2>/dev/null || true
mv openspec/changes/*/tasks.md docs/tasks/HU-XXX-tasks.md 2>/dev/null || true
```

---

## Step 6: Clean Up Legacy Files

### Files to Remove (if safe)

```bash
# Only if you're sure they're not needed and have backups

# Deprecated templates
rm -rf templates/                    # Use docs/templates/ instead

# Duplicate docs (if consolidated)
# rm docs/old-structure.md           # Only after confirming new structure works

# Temporary files
rm -f *~ *.backup *.tmp
```

### ⚠️ Safety First

```bash
# Always git status before deleting
git status

# Only delete files you've confirmed are safe
git rm templates/  # Instead of rm -rf
```

---

## Step 7: Validate the Migration

### Checklist

- [ ] All HUs moved to `docs/tasks/HU-001-HU-099/`
- [ ] All ADRs moved to `docs/architecture/adr/`
- [ ] All RFCs moved to `docs/architecture/rfc/`
- [ ] `docs/templates/` has all FlowDoc templates
- [ ] `AGENTS.md` customized to project
- [ ] `docs/flowdoc-ciclo.md` readable
- [ ] No broken internal links (run: `rg "\.\./" docs/`)

### Verify Structure

```bash
# Should show:
docs/
├── templates/
│   ├── user-stories/
│   ├── bug-fixes/
│   ├── refactors/
│   ├── architecture/
│   ├── database/
│   ├── api/
│   └── PRD/
├── architecture/
│   ├── adr/
│   └── rfc/
├── tasks/
│   └── HU-001-HU-099/
├── flowdoc-ciclo.md
├── adoption-guide.md
├── FAQ.md
└── troubleshooting.md

AGENTS.md
CHANGELOG.md
ONBOARDING.md
.gitignore
```

---

## Step 8: First Commit

```bash
git add .
git status

# Review what will be committed
git diff --staged --name-only

# Commit
git commit -m "feat: adopt FlowDoc framework

- Migrate existing docs to FlowDoc structure
- Add templates, AGENTS.md, onboarding
- Document team conventions in AGENTS.md

See docs/flowdoc-ciclo.md for work cycle reference."
```

---

## Common Issues

### "I have HUs with different naming"

FlowDoc recommends `HU-XXX-name.md` but doesn't require it. As long as they're in `docs/tasks/`, the agent will find them. Consider renaming over time.

### "My ADRs have different format"

ADRs in FlowDoc use `docs/architecture/adr/ADR-XXX-title.md`. Convert over time when ADRs are updated, not all at once.

### "I have existing openspec/ but also docs/"

Choose one as source of truth. See Step 5 for options. Most teams consolidate to `docs/` for simplicity.

### "The agent doesn't understand my project context"

Update `AGENTS.md` with:
- Project description
- Tech stack
- Team conventions
- Any project-specific rules

---

## Scenario B: Proyecto Legacy SIN SDD (Solo Código)

> You have an existing project with code but no formal documentation. The agent will help document what exists.

---

### Step B-1: El Agente Explora el Códigobase

Prompt para el agent:

```
"El proyecto no tiene documentación formal. Por favor:
1. Explora la estructura del proyecto
2. Identifica los módulos principales
3. Identifica los endpoints API (si hay)
4. Identifica la base de datos (si hay)
5. Describe brevemente qué hace cada módulo

Guarda los hallazgos en docs/exploration.md"
```

### Step B-2: Crear HU Inicial de Documentación

El agent crea la primera HU para documentar el proyecto:

```bash
# Crear HU inicial
cat > docs/tasks/HU-001-HU-099/HU-001-documentacion-proyecto.md << 'EOF'
# HU-001: Documentación del Proyecto

**Status**: 🟡 In Progress
**Owner**: @tu-usuario
**Created**: YYYY-MM-DD
**Priority**: Must

---

## 🎯 Intent

Documentar la estructura y componentes actuales del proyecto para tener un baseline.

---

## 📋 Scope

### In Scope
- Estructura general del proyecto
- Módulos principales y responsabilidades
- API endpoints (si aplica)
- Modelo de datos (si aplica)
- Dependencias externas

### Out of Scope
- Documentación detallada de cada función
- Tests (eso viene después)

---

## ✅ Requirements

### MUST
- [ ] Estructura de carpetas documentada
- [ ] Cada módulo tiene descripción de responsabilidad
- [ ] Endpoints API documentados (si hay)
- [ ] Modelo de datos documentado (si hay)

---

## 🧪 Verification

🧪 Ref: El Tech Lead revisa y aprueba la documentación

---

## 📦 Affected Areas

- `docs/exploration.md` — salida del agent
- `docs/PRD.md` — documento de requerimientos
- `docs/templates/api/endpoints.md` — contratos API
- `docs/templates/database/schema.md` — esquema de BD
EOF
```

### Step B-3: El Agent Completa la HU

El agent ejecuta la HU siguiendo el ciclo SDD:
- Proposal → Spec → Design → Tasks → Apply → Verify → Archive

### Step B-4: Resultados Esperados

Al terminar Scenario B, tendrás:

```
docs/
├── exploration.md          ← Lo que el agent descubrió
├── PRD.md                 ← Documento de requerimientos
├── api/
│   └── endpoints.md       ← Endpoints documentados
├── database/
│   └── schema.md          ← Esquema documentado
└── tasks/
    └── HU-001-HU-099/
        └── HU-001-documentacion-proyecto.md  ← HU completada
```

---

## Scenario C: Proyecto Nuevo (Desde Cero)

> No tienes código aún. El agent te guía a documentar antes de escribir código.

---

### Step C-1: Crear PRD

El agent te ayuda a crear el Product Requirements Document:

```bash
# Copiar template
cp docs/templates/PRD/PRD.md docs/PRD.md

# El agent te hace preguntas para llenarlo:
# - ¿Qué problema resuelve el proyecto?
# - ¿Quiénes son los usuarios?
# - ¿Qué funcionalidades son core?
# - ¿Hay constraints técnicos?
```

### Step C-2: Crear Primera HU

```bash
cat > docs/tasks/HU-001-HU-099/HU-002-setup-proyecto.md << 'EOF'
# HU-002: Setup Inicial del Proyecto

**Status**: 🟡 In Progress
**Owner**: @tu-usuario
**Created**: YYYY-MM-DD
**Priority**: Must

---

## 🎯 Intent

Crear la estructura base del proyecto con tooling inicial.

---

## 📋 Scope

### In Scope
- Repositorio con .gitignore
- Estructura de carpetas inicial
- Package.json / requirements.txt (según stack)
- Linting y formatting configurado
- CI/CD básico (si aplica)

### Out of Scope
- Código de negocio
- Documentación de features

---

## ✅ Requirements

### MUST
- [ ] Repo creado con .gitignore
- [ ] Estructura de carpetas según arquitectura
- [ ] Dependencias base instaladas
- [ ] Linting configurado
- [ ] README inicial

---

## 🧪 Verification

🧪 Ref: `npm test` / `pytest` corre sin errores después del setup
EOF
```

### Step C-3: Flujo Recomendado

Para proyectos nuevos, el flujo es:

```
1. PRD → ¿Qué vamos a construir?
2. Primera HU → Setup del proyecto
3. Siguientes HUs → Features reales

El agente documenta ANTES de codear.
```

### Nota sobre "El Usuario No Quiere Llenar Info"

Si el usuario no quiere o no puede responder las preguntas del agent:

| Situación | Qué hace el agent |
|-----------|-------------------|
| Usuario no sabe qué hacer | El agent pregunta una cosa a la vez, no todo junto |
| Usuario quiere decidir rápido | El agent pone placeholder `[TBD]` y sigue |
| Usuario no quiere participar | El agent documenta lo que puede del código y marca "Pendiente: decisión de usuario" |

**Regla**: Mejor documentación incompleta que ninguna. El agent marca lo que falta con `⚠️ PENDIENTE: [decisión del usuario]`.

---

## After Migration

Once migration is complete:

1. **Test the agent**: Ask "What HUs do we have?" and verify it finds them
2. **Create a new HU**: Use `docs/templates/` and verify the format
3. **Update team**: Share the new structure and conventions
4. **Iterate**: Adjust based on what works for your team

---

## Resources

| Resource | Purpose |
|----------|---------|
| [FlowDoc Adoption Guide](docs/adoption-guide.md) | How to adopt at your pace |
| [FlowDoc FAQ](docs/FAQ.md) | Common questions |
| [FlowDoc Anti-Patrones](docs/anti-patrones.md) | What to avoid |
| [FlowDoc Troubleshooting](docs/troubleshooting.md) | Common errors |
| [FlowDoc Cycle](docs/flowdoc-ciclo.md) | The 15-day work cycle |

---

**Last updated**: 2026-05-29
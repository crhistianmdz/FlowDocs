# ADR-005: Organización de HUs por Rangos de 100

**Fecha**: 2026-05-29  
**RFC relacionado**: Ninguno (decisión de organización)  
**Estado**: Aceptado

---

## Contexto

En proyectos grandes con muchas historias de usuario, los sistemas de archivos empiezan a degradar cuando hay demasiados archivos en una sola carpeta (típicamente >1,000 archivos, pero el rendimiento puede verse afectado desde >100). Además, encontrar una HU especificada hace tiempo se vuelve difícil en una carpeta plana con cientos de archivos.

Los equipos necesitan:
- Navegación rápida entre HUs
- Contexto histórico de en qué "época" se trabajó
- Performance aceptable del filesystem

---

## Decisión

Adoptamos la siguiente estructura para `docs/tasks/`:

```
docs/tasks/
├── HU-001-HU-099/
│   ├── HU-001-primera-feature.md
│   └── ...
├── HU-100-HU-199/
│   └── ...
├── HU-200-HU-299/
│   └── ...
└── HU-900-HU-999/
    └── ...
```

**Regla**: Las carpetas se crean cuando la HU编号 alcanzan el límite del rango. No se crean carpetas vacías por anticipado.

| Fase | Rango | Cuando crear |
|------|-------|--------------|
| Fase 1 | HU-001 a HU-099 | Al inicio (primera HU) |
| Fase 2 | HU-100 a HU-199 | Cuando HU-099 existe |
| Fase 3 | HU-200 a HU-299 | Cuando HU-199 existe |
| ... | ... | Y así sucesivamente |

---

## Criterios de Aplicación

| Tamaño del proyecto | Aplicación |
|---------------------|------------|
| < 50 HUs | Opcional — carpeta plana aceptable |
| 50-100 HUs | Recomendado — crear siguiente carpeta |
| > 100 HUs | Obligatorio — carpeta por rango |

---

## Implementación

### Scripts

El script `scripts/hu-to-issues.sh` debe detectar automáticamente en qué carpeta está la HU:

```bash
# Pseudocódigo
function get_hu_folder(hunumber) {
 hunum=$(echo $hunumber | sed 's/HU-//' | sed 's/-.*//')
  folder=$((hunum / 100 * 100 + 1))"-"$(((hunum / 100 + 1) * 100))
  echo "HU-${folder}"
}
```

### Git

El path completo de la HU incluye la carpeta:
```
docs/tasks/HU-001-HU-099/HU-042-login.md
```

En commits:
```
feat: HU-042 - add login page
```

---

## Consecuencias

### ✅ Positivo

- Performance del filesystem estable
- Navegación más fácil (100 archivos por carpeta es manejable)
- Contexto histórico implícito (carpeta = época del proyecto)
- Escalable a cualquier cantidad de HUs

### ❌ Negativo

- Cuando una HU pasa de rango (ej: 099 → 100), hay que mover archivos
- Scripts existentes pueden necesitar actualización
- Un poco más de trabajo al reorganizar

### 🔄 Neutral

- Requiere disciplina para crear la carpeta en el momento correcto
- Para proyectos pequeños es overhead innecesario

---

## Cómo Migrar un Proyecto Existente

Si tenés un proyecto con HUs planas y ya tiene > 100:

```bash
# 1. Crear carpeta del rango siguiente
mkdir -p docs/tasks/HU-100-HU-199

# 2. Mover las HUs del rango
mv docs/tasks/HU-100*.md docs/tasks/HU-100-HU-199/
mv docs/tasks/HU-101*.md docs/tasks/HU-100-HU-199/
# ... etc

# 3. Commitear
git add .
git commit -m "chore: reorganize HUs into HU-100-HU-199 folder"
```

---

## Documentos Relacionados

| Documento | Ubicación |
|-----------|-----------|
| Guía de templates | `templates/TEMPLATE_GUIDE.md` |
| HU de ejemplo | `docs/tasks/HU-001-onboarding-docs.md` |

---

## Checklist de Implementación

- [ ] Scripts `hu-to-issues.*` actualizados para detectar carpeta
- [ ] `TEMPLATE_GUIDE.md` actualizado con esta regla
- [ ] Primera carpeta HU-001-HU-099 creada
- [ ] HU de ejemplo movida a la carpeta correcta (post-100)
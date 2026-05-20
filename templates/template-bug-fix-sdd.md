# Template: Bug Fix (SDD-Ready)

> Copiar este template cuando se necesite solventar un bug o error.
> Compatible con SDD: spec → design → tasks.

**Título**: [Título corto del bug]

---

## Descripción del Bug

**Comportamiento actual**:
[Qué está pasando actualmente - describe el bug]

**Comportamiento esperado**:
[Qué debería pasar - describe el comportamiento correcto]

---

## Pasos para Reproducir

1. [Paso 1]
2. [Paso 2]
3. [Paso 3]

---

## Escenarios de Prueba (SDD Spec)

### Happy Path (después del fix)
- [ ] [Comportamiento correcto verificado]

### Edge Cases
- [ ] [Caso borde 1]
- [ ] [Caso borde 2]

### Error Cases (manejo de errores)
- [ ] [Qué pasa con input inválido]
- [ ] [Logging del error]

---

## Criterios de Aceptación

- [ ] Bug ya no ocurre
- [ ] [Comportamiento específico verificado 1]
- [ ] [Comportamiento específico verificado 2]

---

## Tasks (Fix)

- [ ] [Fix específico 1]
- [ ] [Fix específico 2]
- [ ] [Test que verifica el fix]

---

## Notas (Opcional)

- [Logs de error si hay]
- [Referencias a código relevante]
- [Causa raíz si se conoce]

---

## Contract (para Coordination Layer)

- **Owner**: @usuario
- **Deadline**: Día [X]

---

## Para SDD (input al workflow)

- **Change name**: [nombre en kebab-case, ej: fix-login-error]
- **Tipo**: bug-fix
- **Descripción**: [una línea que describa el bug]
- **Dominio affected**: [qué parte del sistema está afectada]

---

## Ejemplo de uso

```bash
# Copiar el template
cp docs/tasks/template-bug-fix-sdd.md docs/tasks/fix-login-error.md

# Editar con el contenido del bug
# Luego ejecutar sdd-new
/sdd-new fix-login-error
```
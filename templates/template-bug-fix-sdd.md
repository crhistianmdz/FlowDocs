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

Cada escenario describe un comportamiento verificable. Usar formato Given/When/Then.
**🧪 Ref**: link al archivo de test que verifica este escenario (se completa durante implementación).

### Happy Path (después del fix)

- [ ] **Bug corregido**
  **GIVEN** [condición donde ocurría el bug]
  **WHEN** [misma acción que antes]
  **THEN** [comportamiento correcto ahora]
  **🧪 Ref**: `tests/...` → "[nombre del test]"

### Edge Cases

- [ ] **[Nombre del caso borde]**
  **GIVEN** [precondición]
  **WHEN** [acción]
  **THEN** [resultado esperado]
  **🧪 Ref**: `tests/...` → "[nombre del test]"

### Error Cases (manejo de errores)

- [ ] **[Nombre del error]**
  **GIVEN** [precondición]
  **WHEN** [acción]
  **THEN** [resultado esperado]
  **🧪 Ref**: `tests/...` → "[nombre del test]"

---

## Criterios de Aceptación

- [ ] Bug ya no ocurre
- [ ] [Comportamiento específico verificado 1]
- [ ] [Comportamiento específico verificado 2]
- [ ] Cada escenario tiene su 🧪 Ref y su test pasa
- [ ] Documentación actualizada (API docs y/o ADR si corresponde)

---

## Tasks (Fix + Test)

Cada fix incluye su test al lado.

- [ ] **Fix**: [fix específico 1]
- [ ] **Test**: [test que verifica el fix 1]
- [ ] **Fix**: [fix específico 2]
- [ ] **Test**: [test que verifica el fix 2]

---

## Notas (Opcional)

- [Logs de error si hay]
- [Referencias a código relevante]
- [Causa raíz si se conoce]

## Deuda Técnica (si aplica)

- [Qué se dejó pendiente, por qué, y cómo se resuelve después]

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
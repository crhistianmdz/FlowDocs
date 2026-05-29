# Template: User Story (SDD-Ready)

> Copiar este template cuando se necesite implementar un nuevo feature o funcionalidad.
> Compatible con SDD: proposal → spec → design → tasks.

**Título**: [Nombre corto del feature]

---

## Como usuario...

**Como**: [tipo de usuario]
**Quiero**: [acción que quiero hacer]
**Para**: [beneficio / razón]

---

## Criterios de Aceptación

- [ ] [Criterio 1 - comportamiento esperado]
- [ ] [Criterio 2 - comportamiento esperado]
- [ ] [Criterio 3 - comportamiento esperado]
- [ ] Documentación actualizada (API docs y/o ADR si corresponde)

---

## Escenarios (SDD Spec)

Cada escenario describe un comportamiento verificable. Usar formato Given/When/Then.
**🧪 Ref**: link al archivo de test que verifica este escenario (se completa durante implementación).

### Happy Path

- [ ] **Escenario principal**
  **GIVEN** [precondición]
  **WHEN** [acción]
  **THEN** [resultado esperado]
  **🧪 Ref**: `tests/...` → "[nombre del test]"

### Edge Cases

- [ ] **[Nombre del caso borde]**
  **GIVEN** [precondición]
  **WHEN** [acción]
  **THEN** [resultado esperado]
  **🧪 Ref**: `tests/...` → "[nombre del test]"

### Error Cases

- [ ] **[Nombre del error]**
  **GIVEN** [precondición]
  **WHEN** [acción]
  **THEN** [resultado esperado]
  **🧪 Ref**: `tests/...` → "[nombre del test]"

---

## Tasks (Implementation + Tests)

Cada tarea de código incluye su tarea de test al lado.

- [ ] **Código**: [tarea técnica 1]
- [ ] **Test**: [test que verifica la tarea 1]
- [ ] **Código**: [tarea técnica 2]
- [ ] **Test**: [test que verifica la tarea 2]

---

## Notas (Opcional)

- [Información adicional]
- [Dependencias]
- [Referencias a código existente]

## Deuda Técnica (si aplica)

- [Qué se dejó pendiente, por qué, y cómo se resuelve después]

---

## Contract (para Coordination Layer)

- **Owner**: @usuario
- **Deadline**: Día [X]
- **Dependencies**: [qué necesita de otros]

---

## Para SDD (input al workflow)

- **Change name**: [nombre en kebab-case, ej: add-user-auth]
- **Tipo**: feature
- **Descripción**: [una línea que describa qué hace]
- **Dominio affected**: [si sabes qué parte del sistema afecta]

---

## Ejemplo de uso

```bash
# Copiar el template
cp docs/tasks/template-user-story-sdd.md docs/tasks/mi-nuevo-feature.md

# Editar con el contenido del feature
# Luego ejecutar sdd-new
/sdd-new mi-nuevo-feature
```
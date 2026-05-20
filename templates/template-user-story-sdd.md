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

---

## Escenarios (SDD Spec)

### Happy Path
- [ ] [Escenario principal funcionando]

### Edge Cases
- [ ] [Caso borde 1]
- [ ] [Caso borde 2]

### Error Cases
- [ ] [Error 1 - qué muestra al usuario]
- [ ] [Error 2 - logging]

---

## Tasks (Implementation)

- [ ] [Tarea técnica 1]
- [ ] [Tarea técnica 2]
- [ ] [Tarea técnica 3]

---

## Notas (Opcional)

- [Información adicional]
- [Dependencias]
- [Referencias a código existente]

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
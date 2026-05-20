# Template: Refactor

> Copiar este template cuando se necesite refactorizar código existente.
> Usar solo cuando el cambio no modifique comportamiento, solo estructura.

**Título**: [Nombre corto del refactor]

---

## Objetivo

**Por qué se necesita refactorizar**:
[Explicar la razón: código duplicado, difícil de mantener, performance, etc.]

---

## Código Actual

**Archivos afectados**:
- `[path/to/file1.ext]`
- `[path/to/file2.ext]`

**Problemas identificados**:
1. [Problema 1]
2. [Problema 2]

---

## Diseño Propuesto

**Patrón a usar**: [nombre del patrón si aplica]

**Nuevos archivos** (si aplica):
- `[path/to/new-file.ext]`

**Archivos modificados**:
- `[path/to/file.ext]` - [qué cambia]

---

## Criterios de Aceptación

- [ ] Funcionalidad existente sigue funcionando igual
- [ ] Tests existentes pasan antes y después del refactor
- [ ] [Criterio específico 1]
- [ ] [Criterio específico 2]

---

## Tasks (Refactor + Verificación)

Cada refactor incluye verificación de tests.

- [ ] **Refactor**: [tarea 1]
- [ ] **Verificar**: tests existentes siguen pasando
- [ ] **Refactor**: [tarea 2]
- [ ] **Verificar**: tests existentes siguen pasando
- [ ] **Test**: [nuevo test si el refactor cambia interfaces o expone nuevos casos]

---

## Notas (Opcional)

- [Consideraciones de performance]
- [Dependencias]

---

## Ejemplo de uso

```bash
# Copiar el template
cp docs/tasks/template-refactor.md docs/tasks/refactor-auth-service.md

# Editar con el contenido del refactor
# Luego ejecutar sdd-new
/sdd-new refactor-auth-service
```

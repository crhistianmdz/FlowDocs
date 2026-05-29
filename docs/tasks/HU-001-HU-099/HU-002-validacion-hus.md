# HU-002: Agregar validación de HUs en pre-commit

## Información General

- **ID**: HU-002
- **Prioridad**: P2
- **Módulo**: DevOps / Scripts
- **Estimado**: 4 horas

---

## User Story

**Como** developer  
**Quiero** que el script de pre-commit valide que las HUs en `docs/tasks/` tengan el formato correcto  
**Para** evitar提交 invalid HU files que rompan los scripts de `hu-to-issues`

---

## Criterios de Aceptación

### Funcionales

- [ ] El hook pre-commit rechaza HUs sin campo `**Título**:` con contenido válido
- [ ] El hook pre-commit rechaza HUs sin campo `**Owner**:` en la sección Contract
- [ ] El hook pre-commit rechaza HUs sin campo `**Status**:` al final del archivo
- [ ] El hook acepta HUs válidas sin blocker

### No Funcionales

- [ ] El hook es rápido (< 1 segundo por archivo)
- [ ] Mensaje de error claro indicando qué falta
- [ ] Tests covering validación de casos válidos e inválidos

---

## Escenarios (SDD Spec)

### Happy Path

- [ ] **HU válida pasa validación**
  **GIVEN** Una HU con todos los campos requeridos (`**Título**:`, `**Owner**:`, `**Status**:`)
  **WHEN** El developer hace `git commit` con esa HU
  **THEN** El commit proceede sin errores
  **🧪 Ref**: `scripts/validate-hu.test.sh` → "accepts valid HU"

- [ ] **HU con escenarios Given/When/Then pasa validación**
  **GIVEN** Una HU con secciones `### Happy Path`, `### Edge Cases` y `### Error Cases`
  **WHEN** Cada escenario tiene formato correcto (GIVEN/WHEN/THEN)
  **THEN** El commit proceede
  **🧪 Ref**: `scripts/validate-hu.test.sh` → "accepts HU with all scenario types"

### Edge Cases

- [ ] **HU sin título**
  **GIVEN** Una HU donde falta `**Título**:` o está vacío
  **WHEN** El developer intenta commitear
  **THEN** El hook rechaza con mensaje: "HU must have a non-empty **Título** field"
  **🧪 Ref**: `scripts/validate-hu.test.sh` → "rejects HU without title"

- [ ] **HU sin owner en Contract**
  **GIVEN** Una HU sin la sección Contract o sin campo `**Owner**:`
  **WHEN** El developer intenta commitear
  **THEN** El hook rechaza con mensaje: "HU must have **Owner** in Contract section"
  **🧪 Ref**: `scripts/validate-hu.test.sh` → "rejects HU without owner"

- [ ] **HU sin status**
  **GIVEN** Una HU sin `**Status**:` al final del archivo
  **WHEN** El developer intenta commitear
  **THEN** El hook rechaza con mensaje: "HU must have a **Status** field"
  **🧪 Ref**: `scripts/validate-hu.test.sh` → "rejects HU without status"

- [ ] **HU con título placeholder**
  **GIVEN** Una HU con `**Título**: [Nombre corto del feature]` (sin cambiar)
  **WHEN** El developer intenta commitear
  **THEN** El hook rechaza con mensaje: "HU **Título** is still the placeholder value"
  **🧪 Ref**: `scripts/validate-hu.test.sh` → "rejects HU with placeholder title"

- [ ] **Multiple HUs, solo una inválida**
  **GIVEN** Un commit que incluye `HU-001-valid.md` y `HU-002-invalid.md`
  **WHEN** El developer intenta commitear
  **THEN** El hook rechaza y muestra cuál HU es inválida
  **🧪 Ref**: `scripts/validate-hu.test.sh` → "rejects when any HU in commit is invalid"

### Error Cases

- [ ] **HU con caracteres inválidos en título**
  **GIVEN** Una HU con caracteres especiales en el título (ej: `<>:"|?*`)
  **WHEN** El developer intenta commitear
  **THEN** El hook rechaza con mensaje indicando caracteres inválidos
  **🧪 Ref**: `scripts/validate-hu.test.sh` → "rejects HU with invalid filename characters"

---

## API Endpoints Required

N/A — es un script local, no hay API.

---

## DB Changes

N/A — no requiere base de datos.

---

## UI Components

N/A — es un hook de CLI, no tiene interfaz.

---

## Dependencies

| Dependencia | Por qué |
|-------------|---------|
| Git pre-commit hook | Plataforma de ejecución |
| Shell script (`validate-hu.sh`) | Lógica de validación |
| Test script (`validate-hu.test.sh`) | Verificación de la validación |

---

## Testing Checklist

- [ ] Unit test: validación de HU válida
- [ ] Unit test: validación de HU sin título
- [ ] Unit test: validación de HU sin owner
- [ ] Unit test: validación de HU sin status
- [ ] Unit test: validación de HU con placeholder
- [ ] Unit test: validación de caracteres inválidos
- [ ] Integration test: hook rechaza commit con HU inválida
- [ ] Integration test: hook acepta commit con HU válida
- [ ] Manual test: verificar que el hook está instalado correctamente

---

## Contract (para Coordination Layer)

- **Owner**: @Crhistian
- **Deadline**: Día 8 del ciclo actual
- **Dependencies**: Ninguna
- **Blocking**: No bloquea otras HUs

---

## Feature Flag

- **Nombre**: HU-002-validation
- **Estado inicial**: `false` (solo validación local, no bloquea commits de otros)
- **Activación**: Cuando esté testeado y aprobado

---

## Notes

- El script debe funcionar en Linux, macOS y Windows (Git Bash/WSL)
- Los tests deben ser cross-platform usando shell portable
- El hook solo valida archivos en `docs/tasks/` con patrón `HU-*.md`

---

## Definition of Done

- [ ] Script `validate-hu.sh` creado y funcionando
- [ ] Tests `validate-hu.test.sh` pasando (>80% coverage)
- [ ] Pre-commit hook instalado en `.git/hooks/`
- [ ] Documentación actualizada (`docs/troubleshooting.md` o nuevo section)
- [ ] Code review aprobado
- [ ] PR mergeado a main

---

**Created**: 2026-05-29  
**Author**: @Crhistian  
**Status**: 📋 Backlog
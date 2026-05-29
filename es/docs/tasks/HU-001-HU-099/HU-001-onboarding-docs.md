# HU-001: Mejorar onboarding de nuevos miembros al framework

## Información General

- **ID**: HU-001
- **Prioridad**: P1
- **Módulo**: Documentación / Proceso
- **Estimado**: 5 horas

---

## User Story

**Como** nuevo miembro del equipo  
**Quiero** poder entender la estructura del framework y cómo trabajar con SDD en máximo 4 días  
**Para** poder hacer mi primera contribución supervised sin bloquear a nadie

---

## Criterios de Aceptación

### Funcionales

- [ ] El checklist de onboarding está en `ONBOARDING.md` y tiene día por día
- [ ] Existe un ejemplo real de PR desde el framework hasta que se mergea
- [ ] Los templates de docs tienen ejemplos reales, no solo placeholders
- [ ] El `AGENTS.md-ejemplo.md` es funcional para cualquier agent (no solo el Restaurant App)

### Docs Existentes

- [ ] `docs/PRD.md` creado con ejemplo real del framework
- [ ] `docs/architecture/adr/001-persistencia-engram.md` creado
- [ ] `docs/tasks/HU-001-onboarding-docs.md` (esta HU)

### Estructura

- [ ] La estructura de `docs/` está completa según README.md
- [ ] `AGENTS.md-ejemplo.md` está renombrado a `AGENTS.md` en la raíz

---

## Escenarios (SDD Spec)

### Happy Path

- [ ] **Nuevo miembro completa onboarding en 4 días**
  **GIVEN** Un developer se une al equipo con zero contexto del framework
  **WHEN** Sigue el checklist de `ONBOARDING.md` día por día
  **THEN** Puede hacer su primera contribución el día 4 con supervisión
  **🧪 Ref**: Test de integración con newcomer simulado

- [ ] **Agent puede trabajar con framework desde cero**
  **GIVEN** Un agent nuevo (OpenCode o Antigravity) accede al repo
  **WHEN** Lee `AGENTS.md` en la raíz
  **THEN** Entiende: stack, estructura, workflow, команды
  **🧪 Ref**: Manual por Tech Lead

### Edge Cases

- [ ] **Nuevo miembro sin experiencia previa en SDD**
  **GIVEN** Developer joins sin experiencia en Spec-Driven Development
  **WHEN** Lee `AGENTS.md` y `docs/flowdoc-ciclo.md`
  **THEN** Entiende el flujo completo y puede empezar
  **🧪 Ref**: Feedback del nuevo miembro

- [ ] **Agent sin acceso a internet busca docs**
  **GIVEN** Agent offline con acceso solo al repo
  **WHEN** Lee `docs/`
  **THEN** Tiene toda la información necesaria para SDD
  **🧪 Ref**: Offline test

---

## API Endpoints Required

N/A — esta HU es puramente documentación.

---

## DB Changes

N/A — no aplica.

---

## UI Components (si es frontend)

N/A — no aplica.

---

## Dependencies

Ninguna — es contenido nuevo.

---

## Testing Checklist

- [ ] Revisión de `ONBOARDING.md` por miembro existente
- [ ] Test de "onboarding simulado" con alguien nuevo
- [ ] Validar que agent puede leer todos los docs sin errores

---

## Contract (para Coordination Layer)

- **Owner**: @Crhistian
- **Deadline**: Día 8 (fin del ciclo actual)
- **Dependencies**: Ninguna
- **Blocking**: No bloquea otras HUs

---

## Notes

- Esta HU es meta-work: documentar el propio framework que se usa
- El ejemplo del "Restaurant App" en `AGENTS.md-ejemplo.md` sirve como referencia pero NO es el framework mismo
- La meta es que cualquier equipo pueda copiar esta estructura a su proyecto

---

## Definition of Done

- [ ] `docs/PRD.md` existe con contenido real
- [ ] `docs/architecture/adr/001-persistencia-engram.md` existe
- [ ] `docs/tasks/HU-001-onboarding-docs.md` existe (esta HU)
- [ ] `ONBOARDING.md` tiene ejemplos concretos, no genéricos
- [ ] Code review aprobada por otro miembro del equipo
- [ ] PR mergeado a main

---

**Created**: 2026-05-29  
**Author**: @Crhistian  
**Status**: 📋 Backlog

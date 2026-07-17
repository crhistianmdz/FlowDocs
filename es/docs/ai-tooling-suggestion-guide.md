# Guía de Sugerencias de Herramientas AI

> Recomendaciones para configurar herramientas de codificación AI para trabajar mejor con FlowDoc.
> Estas son **sugerencias, no obligaciones**. Mejoran la experiencia pero no son requeridas para que FlowDoc funcione.

---

## OpenCode

### Cargar AGENTS.md del proyecto por defecto

**Problema**: OpenCode lee automáticamente el `AGENTS.md` global (`~/.config/opencode/AGENTS.md`) pero NO el `AGENTS.md` del proyecto (`./AGENTS.md`). Esto significa que el agent comienza cada sesión sin el contexto específico del proyecto.

**Solución**: Agregá lo siguiente al `opencode.json` de tu proyecto:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": ["./AGENTS.md"]
}
```

Esto carga el `AGENTS.md` del proyecto automáticamente al inicio de cada sesión, dándole al agent contexto inmediato sobre tu proyecto sin que tengas que mencionarlo manualmente.

**¿Es obligatorio?**: No. Sin esto, OpenCode igual funciona. Con esto, el agent tiene mejor contexto desde el inicio.

**Por qué importa para FlowDoc**: FlowDoc depende de que el agent entienda la estructura del proyecto, convenciones y workflow. Sin esta configuración, el agent puede no tener ese contexto hasta que lo menciones explícitamente.

---

## Claude Code

### Cargar AGENTS.md del proyecto por defecto

**Problema**: Claude Code automáticamente lee `CLAUDE.md` (o `~/.claude/CLAUDE.md` para contexto global), pero no lee `AGENTS.md`. Esto significa que el agent comienza cada sesión sin el contexto específico del proyecto si usás `AGENTS.md` como archivo del proyecto.

**Solución**: Creá un archivo `CLAUDE.md` en la raíz del proyecto que importe `AGENTS.md`:

```markdown
@AGENTS.md
```

Esto carga el contenido del `AGENTS.md` del proyecto automáticamente al inicio de cada sesión, dándole al agent contexto inmediato sobre tu proyecto.

**¿Es obligatorio?**: No. Sin esto, Claude Code igual funciona. Con esto, el agent tiene mejor contexto desde el inicio.

**Por qué importa para FlowDoc**: FlowDoc depende de que el agent entienda la estructura del proyecto, convenciones y workflow. Sin esto, el agent puede no tener ese contexto hasta que lo menciones explícitamente.

---

## GitHub Copilot (VS Code)

### Cargar AGENTS.md del proyecto por defecto

**No se requiere acción**. GitHub Copilot en VS Code detecta automáticamente un archivo `AGENTS.md` en la raíz de tu workspace y aplica sus instrucciones a todas las solicitudes de chat.

Esto significa que el `AGENTS.md` de FlowDoc ya es reconocido sin configuración adicional.

**¿Es obligatorio?**: No. Ya está configurado por defecto.

**Por qué importa para FlowDoc**: FlowDoc depende de que el agent entienda la estructura del proyecto, convenciones y workflow. Con `AGENTS.md` en la raíz del proyecto, Copilot automáticamente tendrá ese contexto.

---

## Antigravity

### Cargar AGENTS.md del proyecto por defecto

**No se requiere acción**. Antigravity detecta automáticamente un archivo `AGENTS.md` en la raíz de tu proyecto (o raíz del workspace) y aplica sus instrucciones a todas las sesiones de agent.

Antigravity busca `AGENTS.md` comenzando desde el directorio actual y subiendo por el árbol hasta encontrarlo. Ponerlo en la raíz del proyecto asegura que cualquier comando ejecutado desde cualquier subcarpeta lo reconozca.

Esto significa que el `AGENTS.md` de FlowDoc ya es reconocido sin configuración adicional.

**¿Es obligatorio?**: No. Ya está configurado por defecto.

**Por qué importa para FlowDoc**: FlowDoc depende de que el agent entienda la estructura del proyecto, convenciones y workflow. Con `AGENTS.md` en la raíz del proyecto, Antigravity automáticamente tendrá ese contexto.

---

## Cursor

### Cargar AGENTS.md del proyecto por defecto

**No se requiere acción**. Cursor detecta automáticamente un archivo `AGENTS.md` en la raíz de tu proyecto (y subdirectorios) y aplica sus instrucciones a todas las sesiones de agent.

Cursor soporta `AGENTS.md` en la raíz del proyecto y subdirectorios anidados. Las instrucciones de `AGENTS.md` anidados se combinan con las del directorio padre, con las instrucciones más específicas teniendo precedencia.

Esto significa que el `AGENTS.md` de FlowDoc ya es reconocido sin configuración adicional.

**¿Es obligatorio?**: No. Ya está configurado por defecto.

**Por qué importa para FlowDoc**: FlowDoc depende de que el agent entienda la estructura del proyecto, convenciones y workflow. Con `AGENTS.md` en la raíz del proyecto, Cursor automáticamente tendrá ese contexto.

---

## Más Herramientas (Próximamente)

Esta guía se expandirá a medida que probemos y validemos configuraciones para otras herramientas de codificación AI.

---

**Nota**: Si experimentás problemas donde el agent parece no "conocer" tu proyecto, esta configuración es probablemente lo primero que hay que revisar.

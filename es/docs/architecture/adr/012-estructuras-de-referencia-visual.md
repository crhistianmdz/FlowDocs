# ADR-012: Estructuras de Referencia Visual para Arquitecturas

- **Fecha**: 2026-07-18
- **RFC relacionado**: Ninguno
- **Estado**: Accepted

---

## Contexto

FlowDocs soporta cuatro arquitecturas (monolítico, microservicios, monorepo, serverless), cada una con sus convenciones sobre cómo se organiza el árbol de `docs/`. Hasta ahora, esas convenciones se describían en prosa — texto que explicaba cómo deberían disponerse las carpetas — pero el lector tenía que reconstruir mentalmente la estructura a partir de la descripción.

Esto generaba fricción:

- Un lector no podía, de un vistazo, **ver** el layout de carpetas esperado para una arquitectura.
- Al incorporar un nuevo proyecto, los adoptantes tenían que adivinar qué archivos concretos deberían vivir dónde.
- Comparar arquitecturas requería leer varias descripciones en prosa en paralelo.

La necesidad: una forma de que alguien **mire** una arquitectura y entienda inmediatamente la organización de carpetas sin tener que interpretar prosa.

---

## Decisión

### Introducir carpetas `reference/` con estructuras visuales completas para cada arquitectura

FlowDocs ahora incluye una carpeta `reference/` en la raíz del proyecto, con una subcarpeta por cada arquitectura:

```
reference/
├── monolitico/
├── microservicios/
├── monorepo/
└── serverless/
```

Cada carpeta `reference/<arquitectura>/` contiene **estructuras de carpetas completas con archivos de ejemplo realistas para docs, src, scripts y configuración** — no diagramas ni descripciones en prosa, sino archivos reales que muestran un proyecto representativo que sigue las convenciones de FlowDocs para esa arquitectura.

Qué contiene cada carpeta de referencia, cualitativamente:

- Un árbol de `docs/` representativo (PRD, ADRs, RFCs, documentación por servicio o por paquete, historias de usuario, docs de API/base de datos, etc. — lo que aplique a la arquitectura).
- Un layout de `src/` de ejemplo que se ajuste a la arquitectura (una sola app para monolítico; carpetas por servicio para microservicios; paquetes para monorepo; funciones para serverless).
- Scripts y archivos de configuración de ejemplo apropiados a la arquitectura.
- Un `estructura.md` que describe la estructura, y un `.agent-context.md` para que los agents de IA se orienten.

La intención es mostrar la **forma** del proyecto — qué carpetas existen, qué tipos de archivos viven en ellas y cómo los docs de FlowDocs se mapean a cada arquitectura — en lugar de servir como un scaffold para copiar y pegar. Los adoptantes usan las referencias para comparar arquitecturas visualmente y luego aplican las convenciones relevantes a su propio proyecto.

### Las carpetas de referencia son artifacts de ejemplo, no templates

Las referencias **no** se copian en un proyecto durante la adopción — `docs/templates/` sigue siendo el source of truth para los templates escritos por humanos. Las referencias son ejemplos de solo lectura cuyo único trabajo es hacer concreto y visible el layout de carpetas.

---

## Consecuencias

### ✅ Positivas

- Los lectores ahora pueden **ver** la organización de carpetas para cada arquitectura de un vistazo, sin reconstruirla desde prosa.
- Comparar las cuatro arquitecturas es visual y rápido — abrí dos archivos `estructura.md` lado a lado.
- Los nuevos adoptantes tienen un modelo mental concreto de cómo debería verse su proyecto antes de generar ningún archivo.
- Los agents de IA que aterrizan en una carpeta de referencia pueden leer el `.agent-context.md` y entender inmediatamente el layout esperado para esa arquitectura.

### ❌ Negativas

- Las carpetas de referencia deben mantenerse junto con el framework — si las convenciones de FlowDocs evolucionan, los archivos de ejemplo corren riesgo de desfasarse de los templates canónicos.
- Cuatro carpetas de referencia aumentan la superficie del repo; los contribuyentes deben entender que son ejemplos, no templates para copiar.
- Los nombres de archivo de ejemplo son ilustrativos — los adoptantes que los copien literalmente terminarán con nombres genéricos (ej., `HU-001-login.md`) que no reflejan su proyecto.

### 🔄 Neutrales

- `docs/templates/` mantiene su rol como source of truth para templates; las referencias heredan esas convenciones pero no definen nuevas.
- El naming es en español (`monolitico`, `microservicios`, `monorepo`, `serverless`), consistente con el naming del ADR-006.

### Deuda técnica aceptada

- Aún no hay ningún check automatizado que garantice que los archivos de ejemplo en `reference/` se mantengan consistentes con `docs/templates/`. El desfasaje es posible y se deja a revisión manual o a una futura extensión del skill `flowdoc-audit`.

---

## Documentos Relacionados

| Documento | Ubicación |
|-----------|-----------|
| Cuatro Arquitecturas Soportadas | ADR-006 |
| Estructura de templates (docs/templates/) | ADR-007 |
| docs/ como source of truth | ADR-002 |
| Carpetas de referencia | `reference/{monolitico,microservicios,monorepo,serverless}/` |
| Guía de Templates (menciona referencias) | `docs/templates/TEMPLATE_GUIDE.md` |

---

> **Recordatorio**: Después de crear este ADR, agregalo a [`docs/architecture/adr/INDEX.md`](./INDEX.md) (o al README mirror en `es/docs/architecture/adr/README.md`).
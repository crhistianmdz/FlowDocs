# ¿FlowDoc es para vos?

## TL;DR (60 segundos)

| ✅ Sí, FlowDoc te sirve si... | ❌ No, buscá otra cosa si... |
|------------------------------|----------------------------|
| Tu equipo tiene entre 2 y 6 personas (sweet spot), está distribuido y los docs escritos son tu handoff principal | Sos 1 persona o un par co-localizado — hablar es más rápido |
| Querés que agents de IA (OpenCode, Antigravity, ClaudeCode) lean y escriban tus specs | Necesitás un editor WYSIWYG o edición colaborativa en tiempo real |
| Ya usás Git como source of truth y querés docs que vivan en el mismo repo que el código | Tu equipo no usa Git para documentación — sin Git, no hay FlowDoc |
| | Solo necesitás un wiki compartido — Notion o Outline te queda mejor |

**FlowDoc es un framework de documentación para equipos que ya usan Git y quieren docs que evolucionen con el código — no un reemplazo de wiki.**

## ¿Quién usa FlowDoc?

**El equipo distribuido (2-6 personas)**

Trabajan en 2 o 3 husos horarios. Una reunión es un rompecabezas cuando la mitad arranca mientras la otra mitad termina. Los specs y ADRs se vuelven el handoff — escritos una vez, leídos por todos.

**El equipo aumentado con IA**

Usan agents de IA a diario. Sus agents necesitan markdown estructurado para leer contexto y escribir specs — el mismo PRD que escribe el PM se vuelve el brief del agent. Los templates de FlowDoc están pensados para esta interfaz humano-IA.

**El maintainer de OSS**

Los PRs llegan a las 3am de contribuyentes en 4 husos horarios. Las decisiones de Discord ya se olvidaron. Los ADRs en `docs/architecture/adr/` hacen cada decisión visible y buscable. Los contribuyentes async se auto-sirven contexto.

**El equipo que mezcla devs, PMs y diseñadores**

No todo el mundo escribe código, pero todo el mundo lee specs. Markdown es el lenguaje común — sin training de Jira, sin permisos de Notion. El PM escribe el PRD, el diseñador lo referencia, el dev implementa. Si usás agents de IA, ese mismo PRD es el contexto que leen.

**El equipo agent-driven**

Son 2-6 personas usando agents de IA en su workflow diario. Quieren agents que entiendan el contexto del proyecto — PRD, RFCs, ADRs, specs — sin copy-pastear. La estructura markdown en Git de FlowDoc significa que los agents leen los mismos archivos que los humanos.

## Cuándo usar FlowDoc

**Distribuido en varios husos horarios**: tu equipo abarca 3 husos. La sincronización en tiempo real es impráctica. Los docs escritos transfieren trabajo entre husos. FlowDoc los pone en el repo, al lado del código.

**Los specs se desincronizan del código**: tus PRDs viven en Notion, tu código en GitHub, y dos sprints después divergen. FlowDoc mantiene ambos en el repo. Un PR cambia código Y su spec juntos.

**Cultura async-first**: tu equipo escribe antes de agendar una reunión. Las decisiones se registran en ADRs, no se recuerdan de una call. El ciclo de 15 días da ritmo sin daily standups.

**Ya usás Git como source of truth**: querés docs que brancheen, mergeen y se reviewen como código. FlowDoc son archivos markdown en tu repo — sin herramienta nueva.

**Adoptando agents de IA**: querés agents que lean tus specs y escriban código contra ellos. El markdown estructurado con Given/When/Then y ADRs les da contexto claro.

**Equipo creciendo, deuda de docs creciendo**: hoy son 2 personas, en 6 meses van a ser 6-8. Las páginas del wiki están stale. Los READMEs están dispersos. El onboarding lleva semanas. Las convenciones de FlowDoc escalan antes de que tus docs se vuelvan un pasivo.

**Probaste SAFe o Scrum-of-scrums y es demasiado pesado**: querés proceso que entre en archivos markdown, no una herramienta que configurar y una certificación que ganar.

## Cuándo NO usar FlowDoc

**Sos 1 persona o un par co-localizado**: para equipos chicos y co-localizados, la conversación supera a los docs. Si estás siempre en la misma sala, una página de Notion o un README alcanza.

**Solo necesitás un wiki**: querés drag-and-drop, rich text y edición en tiempo real. Notion, Outline o Confluence se ajustan mejor.

**Git no es tu source of truth**: tu equipo trata los docs como artefactos secundarios. FlowDoc asume docs-in-repo como registro autoritativo. Si tus docs viven en Google Drive y eso funciona, FlowDoc no agrega valor.

**Querés cero overhead de proceso**: incluso L1 requiere crear un archivo de user story por feature. Si "crear un markdown" te parece burocracia, FlowDoc no es para vos. Estructura es overhead.

**Tu equipo odia markdown**: FlowDoc es markdown-only. Sin editor WYSIWYG, sin cursores de colaboración. Si escribir markdown es una frustración diaria, este framework lo va a empeorar.

**Necesitás edición colaborativa en tiempo real**: Notion y Google Docs permiten edición simultánea. FlowDoc está basado en Git — los cambios pasan por branches, commits y PRs.

**Tu organización exige una plataforma específica**: si tu empresa requiere Confluence, SharePoint o Google Docs por compliance, FlowDoc puede complementar pero no reemplazar tu sistema obligatorio.

**Tenés más de 30 personas**: FlowDoc está diseñado para equipos chicos (2-6 es el sweet spot). Puede escalar con cuidado, pero si necesitás coordinación cross-team enterprise, FlowDoc puede necesitar complementarse.

## Los 4 niveles de adopción

FlowDoc se adapta a tu equipo — vos no te adaptás a FlowDoc. Elegí un nivel y crecé desde ahí.

| Nivel | Tiempo para adoptar | Qué incluye | Problema que resuelve |
|-------|-------------------|------------|----------------------|
| 🟢 **L1: Solo Documentación** | 15 minutos | PRD en `docs/PRD.md`, RFCs en `docs/architecture/rfc/`, ADRs en `docs/architecture/adr/`, HUs en `docs/tasks/`. Source of truth para humanos y agents de IA. Sin ciclo SDD, sin ceremonia. | "Necesito docs al lado de mi código — PRD, RFCs, decisiones y user stories." |
| 🟡 **L2: SDD Básico** | 1-2 días | Ciclo SDD completo (proposal → spec → design → tasks → apply → verify). Workflow individual. Specs parseables por agents: Given/When/Then, ADRs, checklists. | "Quiero pensamiento estructurado antes de codear, no solo una lista de TODO." |
| 🟠 **L3: Equipo AI-Context** | 1-2 semanas | Agents de IA leen el PRD, los RFCs, los ADRs y las HUs para entender contexto, historia y estado del proyecto. Ciclo de planning, dependencias explícitas, convenciones de equipo. Acá la agent-friendliness de FlowDoc rinde frutos — tus docs son infraestructura. | "Mis agents necesitan contexto estructurado. Mi equipo necesita coordinación sin 3 standups por día." |
| 🔴 **L4: Equipo Completo** | 2-4 semanas | Ciclo de 15 días, métricas, RFCs, ADRs, onboarding, automatización de issues. Agents contribuyen a decisiones y mantienen memoria institucional. | "Predictibilidad, memoria institucional y un proceso que escale." |

**No tenés que arrancar por L1.** Equipos que ya hacen SDD pueden empezar en L2 o L3. Los devs solos pueden quedarse en L1 para siempre. Un equipo de 2 puede llegar a L4 en días — el overhead está en hábitos, no en buy-in. Ver [adoption-guide.md](adoption-guide.md).

## Comparación con alternativas

### FlowDoc vs Notion/Confluence vs Solo README

| Qué obtenés | FlowDoc | Notion/Confluence | Solo README |
|------------|---------|-------------------|-------------|
| Basado en Git (PRs, history, blame) | ✅ | ❌ | ✅ |
| Agents de IA leen de Git | ✅ (markdown en repo) | ❌ (API-dependiente) | ⚠️ (manual, no estructurado) |
| PRD, RFCs, ADRs, HUs legibles por agents | ✅ (markdown en repo) | ❌ (API-dependiente, desestructurado) | ⚠️ (PRD a lo sumo) |
| Vendor lock-in | ❌ (archivos markdown) | ✅ (formato propietario) | ❌ |
| Gratis para siempre | ✅ | ❌ (tiers limitados) | ✅ |
| Async-first (docs como handoff) | ✅ | ⚠️ (sesgo a tiempo real) | ❌ (sin estructura) |
| Decision records (ADRs) | ✅ | ⚠️ (manual) | ❌ |
| Captura propuestas y razonamiento (RFCs) | ✅ (estructurado en `docs/architecture/rfc/`) | ⚠️ (páginas ad-hoc) | ❌ |
| Templates para specs y tasks | ✅ | ❌ | ❌ |
| Editor WYSIWYG | ❌ (solo markdown) | ✅ | ❌ |
| Colaboración en tiempo real | ❌ (basado en Git, PRs) | ✅ | ❌ |
| Búsqueda integrada | ❌ (usá grep o GitHub) | ✅ | ❌ |

**Postura honesta**: Notion tiene mejor editor y colaboración en tiempo real. Si markdown o workflow basado en Git es un dealbreaker, FlowDoc no va a funcionar — y está bien. Pero si ya vivís en Git y querés docs async que los agents de IA lean y escriban, los tradeoffs de FlowDoc valen la pena. Solo README se rompe cuando tenés múltiples features en vuelo y ningún historial de decisiones.

### FlowDoc vs metodologías estilo SAFe

SAFe define roles, ceremonias y artefactos a escala enterprise. FlowDoc define dónde viven los docs y cómo evolucionan. Resuelven problemas distintos.

Si tu organización exige SAFe: FlowDoc puede complementarlo. Guardá PI objectives, feature docs y backlogs en `docs/`. El ciclo SDD mapea al loop inspect-and-adapt de SAFe. Los ADRs reemplazan decisiones de pasillo con registros fechados.

Compararlos es comparar manzanas con naranjas — estructura organizacional vs higiene de documentación. Podés usar ambos, ninguno, o uno sin el otro.

## FAQ

### Q: ¿Necesito usar GitHub?

No. FlowDoc funciona con cualquier host de Git — GitLab, Bitbucket, Gitea o self-hosted. El único requisito es que tus docs vivan en un repositorio Git.

### Q: ¿Cuánto tiempo lleva adoptarlo?

Level 1 lleva 15 minutos — creá un archivo de user story. Level 2 lleva uno o dos días para tu primer ciclo SDD. Level 3 y 4 llevan semanas por coordinación de equipo y cambios de hábito.

### Q: ¿FlowDoc es gratis?

Sí. FlowDoc es un conjunto de templates y convenciones markdown — no hay producto pago, ni licencia, ni suscripción. FlowForge puede tener tiers pagos en el futuro, pero el framework es gratis para siempre.

### Q: ¿Somos solo 2 personas. Nos sirve?

Sí — 2-6 personas es el sweet spot. L1 o L2 funciona perfecto: tenés docs estructurados que sobreviven cuando alguien se va. L3 y L4 agregan coordinación que un par quizás no necesita.

### Q: ¿Puedo migrar desde Notion?

Sí, pero es manual. Exportá tus páginas a markdown, reorganizalas en la estructura de FlowDoc (`docs/tasks/`, `docs/architecture/adr/`) y commiteá.

### Q: ¿Qué herramientas de IA funcionan con FlowDoc?

Cualquier agent de IA que lea markdown: OpenCode, Antigravity, ClaudeCode y otros. El formato estructurado de FlowDoc da a los agents contexto predecible. Ver [Tool Compatibility](../README.md#compatibilidad-con-herramientas).

### Q: ¿Y si mi equipo odia escribir docs?

FlowDoc no va a arreglar una cultura que se resiste a la documentación. Arrancá por Level 1 — 15 minutos por feature. Si eso todavía te parece overhead, FlowDoc no es para tu equipo. Y es una conclusión válida.

### Q: ¿Por qué FlowDoc es bueno para agents de IA?

Los agents de IA leen markdown — no navegan wikis rich-text. FlowDoc pone tu PRD, RFCs, ADRs, specs y task breakdowns en una estructura Git predecible con formato consistente. Incluso en L1, los cuatro artefactos son contexto legible — los agents entienden no solo QUÉ se decidió sino POR QUÉ (los RFCs capturan el razonamiento que los ADRs referencian). Ver [Tool Compatibility](../README.md#compatibilidad-con-herramientas).

### Q: ¿Cuál es la diferencia entre RFCs y ADRs?

Los RFCs son propuestas en discusión — capturan alternativas y el proceso de razonamiento. Los ADRs son registros inmutables de las decisiones tomadas. FlowDoc soporta ambos: RFCs para el "por qué consideramos X" y ADRs para el "elegimos Y porque Z". Juntos le dan a agents y nuevos miembros del equipo el panorama completo, no solo el resultado.

### Q: ¿Esto reemplaza a Jira o Linear?

No. FlowDoc maneja documentación — specs, diseños, decisiones. Jira y Linear manejan tracking de tareas. Se complementan: escribí specs en `docs/`, trackeá el progreso en tu issue tracker. El script `hu-to-issues` conecta ambos.

## Próximos pasos

- **Arrancá ahora**: [QUICKSTART.md](../../QUICKSTART.md) — tu primer user story en 5 minutos
- **Profundizá**: [adoption-guide.md](adoption-guide.md) — guía completa por nivel
- **Unite al equipo**: [ONBOARDING.md](../../ONBOARDING.md) — checklist para nuevos miembros

---

**Última actualización**: 2026-06-05

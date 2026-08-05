---
name: flowdoc-api
description: >
  Documents API endpoints from existing code. Scans route/controller files and
  writes docs following the endpoints.md template format. ONLY documents what
  exists in code — never gives design opinions. Invokes flowdoc-discover if
  deeper investigation is needed. NEVER touches the PRD.
  Trigger: "document api", "documentar api", "documentar endpoints",
  "scan api routes", "update api docs"
license: Apache-2.0
metadata:
  author: FlowDoc
  version: "1.0"
  based_on: RFC-005
---

## When to Use

Use this skill when you need to document API endpoints **from existing code**:

- **Orchestrator invoke**: `flowdoc-assist` detected routes/controllers and delegates API documentation
- **Direct user invoke**: User wants their existing API documented in `docs/api/endpoints.md`
- **Post-development invoke**: After implementing new endpoints, document them in the same flow

**This skill is NOT for:**

- Designing APIs or giving opinions on API design — that's the human's job
- Creating new endpoints — it documents what exists, never what should exist
- Touching the PRD — if an API change affects the PRD, it reports to the orchestrator
- Investigating the full stack — use `flowdoc-discover` for that

---

## Core Principle: Document, Don't Design

This skill is a **recorder**, not an architect. It reads code evidence and writes documentation matching the `endpoints.md` template. It NEVER:

- Suggests a different endpoint path
- Recommends HTTP methods
- Proposes response structures
- Opines on REST vs GraphQL

If the code is wrong, the documentation reflects what the code does. The human fixes the code.

---

## What This Skill Returns

```
apiDocsResult:
├── status: completed | partial | failed
├── language (user's language detected)
├── documents
│   ├── created: [{ path, endpointsDocumented }]
│   └── updated: [{ path, endpointsAdded, endpointsModified }]
├── endpointsFound: number
├── endpointsDocumented: number
├── pendingUpdates: []   # if PRD impact detected
│   └── { reason, requiresUpdate: ["docs/PRD.md"], status: "pending" }
└── needsDiscovery: boolean   # true if scan was insufficient
```

---

## Documentation Protocol

### Step 1: Load Context from Orchestrator

The orchestrator provides the base context to start. If invoked directly, gather the minimum needed:

**From orchestrator (when orchestrated):**
- `projectPath` — where to scan
- `existingDocs` — what API docs exist (e.g., `docs/api/endpoints.md`)
- `templateReference` — `docs/templates/api/endpoints.md`
- `routesToScan` — paths/patterns where routes live (from `flowdoc-discover`)

**If invoked directly (no orchestrator):**
1. Detect the user's language preference
2. Read `AGENTS.md` (if exists) for project conventions
3. Locate route files passively (see Step 2)
4. Locate the template at `docs/templates/api/endpoints.md`

**If context is insufficient to start scanning** (e.g., unclear where routes live), invoke `flowdoc-discover` for deeper investigation — do NOT guess.

### Step 2: Scan Code for API Routes/Endpoints

Read code evidence to locate every endpoint. Common patterns:

| Pattern | Framework | Evidence |
|---------|-----------|----------|
| `app.get/post/patch/delete(path, handler)` | Express | `routes/*.js`, `app.js` |
| `@Controller(...)`, `@Get(...)`, `@Post(...)` | NestJS | `*.controller.ts` |
| `@RestController`, `@RequestMapping` | Spring | `*Controller.java` |
| `router.GET/POST(path, handler)` | Gin, Echo (Go) | `main.go`, `*/router.go` |
| `@app.route(path, methods=[...])` | FastAPI | `*.py` |
| `urlpatterns`, `path(...)` | Django | `urls.py` |
| `router.get/post(path, handler)` | Fastify, Koa | `routes/*.ts` |
| `func Handler(w, r)` with `mux.HandleFunc` | net/http (Go) | `main.go` |

For each endpoint found, capture:
- HTTP method (GET, POST, PUT, PATCH, DELETE)
- Path (including path params like `{id}` or `:id` — normalize to `{id}` in docs)
- Handler function/identifier (for traceability, not for the doc)
- Request body shape (from DTO/type/validation schema if present)
- Response body shape (from return types, serializer, or actual response objects)
- Query parameters (from validation or route definitions)
- Headers required (e.g., `Authorization: Bearer <token>`)
- Error responses thrown/returned by the handler

**Important**: Document what the code DOES — including any middleware-imposed behavior (auth required, admin only). Infer these from middleware decorators or route configuration, not assumptions.

### Step 3: Document Each Endpoint Following the Template

Use `docs/templates/api/endpoints.md` as the canonical format. For each endpoint, write a section structured EXACTLY like the template:

```
### {METHOD} {/api/path}

**Description**: {one line describing what the endpoint does — derived from handler behavior, not invented}

**Headers**: {if applicable, e.g., `Authorization: Bearer <accessToken>`}

**Query Params** (if any):
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| ...   | ...  | ...     | ...         |

**Request Body** (if applicable):
```json
{ ... shape derived from code ... }
```

**Response ({status code})**:
```json
{ ... shape derived from code/return types ... }
```

**Error Responses** (if any):
| Code | Body | Description |
|------|------|-------------|
| ...  | ...  | ...         |

---
```

**Formatting rules (match the template):**

- **Method groupings**: Group endpoints by resource/domain (`## Authentication`, `## Users`, `## Products`, etc.) using H2 headings
- **Path params**: normalize `:id` and `{id}` to `{id}` for consistency with template
- **Status codes**: use the most specific success code from the handler (200 OK, 201 Created, 204 No Content)
- **JSON examples**: realistic example values — UUIDs for IDs, ISO timestamps for dates (e.g., `2026-01-15T10:30:00Z`)
- **Error responses**: include a table when the handler has distinct error paths

**Global error codes**: If the project has middleware that produces standard errors (401, 403, 429, 500), include the `## Global Error Codes` table at the bottom of the document, matching the template.

### Step 4: Handle PRD Impact (Critical Boundary)

The API specialist NEVER touches the PRD. This is a hard boundary from RFC-005 §6 and §7.

When documenting endpoints, check if any of these signal PRD impact:

| Signal | Likely PRD impact |
|--------|-------------------|
| Endpoint exposes a core product capability not in PRD scope | PRD may be missing a feature |
| Endpoint returns data that contradicts PRD requirements | PRD out of sync with implementation |
| Endpoint implies a new user-facing feature | PRD should reference it |
| Endpoint deprecates a documented feature | PRD needs update |

**If PRD impact detected:**

1. DO NOT modify `docs/PRD.md`
2. Collect the impact finding as a `pendingUpdate` entry
3. Report to the orchestrator (or user if direct invocation):

```
## ⚠️ PRD Impact Detected

While documenting API endpoints, I detected changes that may affect the PRD:

| Endpoint | Signal | Likely PRD section |
|----------|--------|---------------------|
| POST /api/feature-flags | New core capability not in PRD scope | §3 Features |
| DELETE /api/legacy-export | Deprecates a documented feature | §3.2 Export |

**Action**: I did NOT modify the PRD. Please have `flowdoc-prd` review these findings.

[pendingUpdate added to session register]
```

### Step 5: Report Results to Orchestrator

Return a structured result so the orchestrator can update the session register and decide next steps:

```
## API Documentation Complete

**Status**: completed | partial | failed
**Language**: {es | en}
**Scan scope**: {paths scanned}

### Documents
- **Created**: docs/api/endpoints.md ({N} endpoints documented)
- **Updated**: docs/api/endpoints.md ({N} added, {M} modified)

### Endpoints
- Found: {N}
- Documented: {N}
- Skipped (already documented, no change): {N}
- Failed to document (ambiguous handler): {N} — reason

### Pending Updates
[If any]
- Reason: API change affects PRD section X
- Requires: flowdoc-prd to review docs/PRD.md
- Status: pending

### Needs Discovery
{true | false}

If true, recommends invoking `flowdoc-discover` for deeper investigation of:
- {specific unresolved question}
```

---

## Edge Cases

### No routes found in scanned paths

Report honestly:

```
## No API Endpoints Found

I scanned {paths} and did not detect any route/controller definitions.

Possible reasons:
- Routes are in non-standard locations
- The project doesn't expose HTTP endpoints (e.g., CLI, library, worker)
- The route files were not committed yet

Options:
1. Tell me where your routes live (path or pattern)
2. Invoke `flowdoc-discover` for a deeper scan
3. End — this project has no API to document
```

### Ambiguous handler (cannot determine request/response shape)

If a handler's request/response shape cannot be inferred from the code (no types, no validation, dynamic responses):

```
## Ambiguous Endpoint: POST /api/some-path

I found this endpoint but cannot determine its request/response shape from code:
- No DTO/type annotations on the handler
- No validation schema
- Response is dynamically constructed

Options:
1. Document with placeholder shape (mark with `<!-- TODO: confirm shape -->`) and move on
2. Skip this endpoint — report it in the summary
3. Invoke `flowdoc-discover` to analyze the handler's callers/consumers
```

### Existing `docs/api/endpoints.md` already documents some endpoints

When updating (not creating), preserve existing structure and only:

1. Add newly-found endpoints not yet documented
2. Update endpoints whose code has changed (verify against current handler)
3. Mark deprecated/removed endpoints — DO NOT delete their docs silently; flag for orchestrator review

```
## Updating Existing docs/api/endpoints.md

- 12 endpoints already documented — preserved
- 3 new endpoints detected — adding
- 1 endpoint changed — updating section
- 1 endpoint in docs but NOT in code — flagging as possibly deprecated

Proceed? (default: yes, write changes)
```

### Template missing (`docs/templates/api/endpoints.md` not found)

If the canonical template does not exist, fall back to a default structure mirroring the template format documented in this skill's Step 3, and note that the template should be added:

```
### Note: Template Missing

`docs/templates/api/endpoints.md` was not found. I documented endpoints using the
canonical template format from this skill (Step 3). Recommend invoking
`flowdoc-assist` to add the template to docs/templates/ for consistency.
```

---

## Rules

- **DOCUMENT, DON'T DESIGN** — record what code does, never suggest how APIs should be
- **NEVER touch the PRD** — if PRD impact is detected, report to orchestrator only (`pendingUpdate`)
- **Only documents** — this skill cannot delete or deprecate endpoints; it can only flag them
- **Evidence-based** — every endpoint documented must trace to code evidence found during scan
- **No direct specialist communication** — if you need deeper context, invoke `flowdoc-discover`; never talk to `flowdoc-prd`, `flowdoc-adr`, etc. directly (RFC-005 §6.3)
- **Template first** — always follow the `docs/templates/api/endpoints.md` format; fall back to the format defined in Step 3 only if the template is absent
- **Normalize path params** — `:id` and `{id}` both become `{id}` in documentation
- **Realistic examples** — use UUIDs for IDs, ISO timestamps for dates; never `string`, `123`, or `example` placeholders in JSON examples
- **Preserve existing docs** — when updating, never silently delete documented endpoints; flag and report
- **Write results to `docs/`** — specifically `docs/api/endpoints.md` (or the project's configured API docs location)
- **Report to orchestrator** — return the structured result from Step 5; do not take further actions on your own

---

## Usage Examples

### As Orchestrator (automatic)

```
User: "adopt flowdocs"
     → flowdoc-assist runs flowdoc-discover
     → flowdoc-discover reports: REST API detected in routes/*.ts
     → flowdoc-assist invokes flowdoc-api with base context
     → flowdoc-api scans, documents, returns result
     → If PRD impact pendingUpdate → orchestrator invokes flowdoc-prd
```

### Direct Invocation

```
User: "documentar los endpoints de mi API"
     → flowdoc-api detects Spanish, scans project
     → Finds routes in src/routes/*.ts
     → Documents 14 endpoints into docs/api/endpoints.md
     → Reports summary in Spanish
```

### Post-Development Invocation

```
Orchestrator: "documentar the new order endpoints added in HU-003"
     → flowdoc-api scans routes/orders.ts
     → Adds POST /api/orders and PATCH /api/orders/{id}/status
     → Updates docs/api/endpoints.md (preserves existing 12 endpoints)
     → Reports: 2 added, 0 modified
```

---

## See Also

- [RFC-005 — Specialist Architecture](../../docs/architecture/rfc/005-specialist-architecture.md) — the design this skill follows
- [flowdoc-assist](../flowdoc-assist/SKILL.md) — the orchestrator that coordinates specialists
- [flowdoc-discover](../flowdoc-discover/SKILL.md) — invoke for deeper codebase investigation
- [docs/templates/api/endpoints.md](../../docs/templates/api/endpoints.md) — the canonical API template
- [AGENTS.md](../../AGENTS.md) — project entry point and conventions
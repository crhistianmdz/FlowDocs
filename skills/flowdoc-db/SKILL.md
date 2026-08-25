---
name: flowdoc-db
description: >
  Documents database schema from existing code. Scans for tables, columns, types,
  constraints, indexes, relationships, and enums — then writes documentation
  following the schema.md template. Does NOT give design opinions.
  Invoked by flowdoc-assist orchestrator or directly by users.
  Trigger: "document database", "documentar base de datos", "schema docs",
  "db schema", "documentar schema"
license: Apache-2.0
metadata:
  author: FlowDoc
  version: "1.1"
---

## When to Use

Use this skill when you need to document a database from existing code:

- **Orchestrator invoke**: `flowdoc-assist` launches this skill after discovery detects a database
- **Direct user invoke**: User wants to generate or update `docs/database/schema.md` from their code
- **Maintenance**: Existing database changed and documentation needs to reflect the new state

**This skill is NOT for:**

- Designing new schemas — use an RFC for that (`flowdoc-rfc`)
- Expressing opinions on schema design — this is a REPORTER, not an ADVISOR
- Creating or modifying the database itself — only documents what exists
- Investigating the project — invoke `flowdoc-discover` for deep investigation

---

## What This Skill Returns

After executing, this skill reports to the caller (orchestrator or user):

```
result:
├── status: completed | failed | partial
├── documents:
│   ├── created: [docs/database/schema.md]
│   └── updated: [existing docs that changed]
├── tablesFound: [{ table name, source file }]
├── enumsFound: [{ enum name, values, source file }]
├── relationshipsFound: [{ from, to, type }]  (if detectable)
├── pendingUpdates: [{ other docs that reference this schema }]
└── issues: [{ things that couldn't be documented from code alone }]
```

---

## Protocol

### Step 1: Load Context from Orchestrator

Receive base context from the caller. If the orchestrator (`flowdoc-assist`) invoked this skill, the context includes:

```
orchestratorContext:
├── projectPath        — absolute path to the project
├── pathsToScan        — directories where schema definitions live
│                        (e.g., prisma/, models/, entities/, migrations/, db/)
├── existing           — what documentation already exists in docs/
├── stack              — technologies found by flowdoc-discover
├── database           — database engine detected (PostgreSQL, MySQL, MongoDB, etc.)
├── orm                — ORM detected (Prisma, TypeORM, Sequelize, SQLAlchemy, EF Core, etc.)
└── templateReference  — docs/templates/database/schema.md (canonical format)
```

If invoked directly by the user (no orchestrator session), gather context yourself:

1. Read `AGENTS.md` — check if FlowDoc is adopted
2. Scan for schema definition files (see Step 2)
3. Read the template at `docs/templates/database/schema.md` to know the target format

If no `docs/templates/database/schema.md` exists, use the pattern documented in this skill.

### Step 2: Scan Code for Database Schemas/Models/Entities

Locate the source of truth for the database schema. Scan the project for schema definitions:

| File Pattern | ORM / Database | Location to inspect |
|---|---|---|
| `prisma/schema.prisma` | Prisma | `model` blocks |
| `models/*.py`, `db/models/*.py` | SQLAlchemy | class-based definitions |
| `entities/*.ts`,ORM decorators | TypeORM | `@Entity` classes |
| `models/*.js` with `define()` | Sequelize | `sequelize.define()` calls |
| `DbContext*.cs`, `*.cs` with `[Table]` | Entity Framework Core | entity classes |
| `db/schema.rb`, `db/migrate/*.rb` | Rails ActiveRecord | schema file + migrations |
| `entities/*.go` | GORM / ent | struct tags |
| `supabase/migrations/*.sql`, `*.sql` | Raw SQL | `CREATE TABLE` statements |
| `migrations/*.sql` | Raw SQL (any engine) | `CREATE TABLE` statements |
| `graphql` schema with `type` + `@table` directives | EdgeDB / custom | type definitions |

For each schema source found, extract:

- **Table names** — the entity/table being defined
- **Column names** — each field in the entity
- **Column types** — mapped to canonical SQL types
- **Constraints** — PRIMARY KEY, NOT NULL, UNIQUE, DEFAULT, CHECK, FK
- **Indexes** — if declared in schema or migrations
- **Relationships** — FK references, 1:1, 1:N, N:M (join tables)
- **Enums** — if the ORM defines them or the schema uses custom types

If no schema source is found:

```
## No Database Schema Found

I scanned the following locations and didn't find schema definitions:
- {list of paths checked}

Possible reasons:
- Your schema isn't in a standard location
- You use a different ORM/tool not listed above
- Your schema lives in a separate database repo

Please tell me where your schema definitions live, or invoke flowdoc-discover
for a broader investigation.
```

Then STOP and wait for user direction. Do not guess.

### Step 3: Document Tables, Columns, Types, Constraints

Generate `docs/database/schema.md` following the template format. The canonical template lives at `docs/templates/database/schema.md`.

For EACH table found, document:

```
### {table_name}

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | {infer from name/context} |
| email | VARCHAR(255) | UNIQUE, NOT NULL | {infer from name/context} |
| ... | ... | ... | ... |

**Indexes**:
- `{index_name}` ON `{column}` ({unique if applicable})
- ...

**Relationships**:
- {from} → {to}({field}) — {1:1 | 1:N | N:M}
```

**Type mapping** — normalize ORM types to a generic SQL format:

| If ORM declares | Document as |
|-----------------|-------------|
| `String` (Prisma) | `VARCHAR(255)` |
| `Int` / `Int32` | `INTEGER` |
| `BigInt` | `BIGINT` |
| `Boolean` | `BOOLEAN` |
| `DateTime` / `timestamp` | `TIMESTAMP` |
| `Json` / `JSONB` | `JSONB` |
| `Decimal` / `Money` | `DECIMAL(10,2)` |
| `UUID` / `String @id @default(uuid())` | `UUID` |
| `enum` type | `{enum_name}` (reference to Enums section) |
| `Any` / `{}` | Document as-is, note uncertainty |

**Description column** — default to "—" if the schema has no comment/annotation. Do NOT make up descriptions. If a column name is self-evident (`created_at`, `updated_at`), use that as the description:

- `created_at` → "Creation date"
- `updated_at` → "Last modification"
- `is_active` / `active` → "Whether active"
- `name` → "Name"
- `email` → "Email address"

For non-evident column names, leave as "—" and flag it in the issues report.

**Constraints mapping**:

| Code declares | Document as |
|---------------|-------------|
| `@PrimaryColumn`, `@PrimaryGeneratedColumn`, `@id` | `PRIMARY KEY` |
| `NOT NULL`, required field without `?` | `NOT NULL` |
| `@Unique`, `unique: true`, `@@unique` (Prisma) | `UNIQUE` |
| `default()` | `DEFAULT {value}` |
| FK reference | `FK → {table}({column})` |
| Check constraint (Prisma rarely), CHECK in SQL | `CHECK {condition}` |

### Step 4: Document Relationships and Indexes

After documenting each table, generate the aggregate views:

#### 4a. Relationships (ER Diagram)

Build an ASCII ER diagram showing how tables connect. The diagram uses box-drawing characters. Reuse the style from the template:

```
┌─────────────┐       ┌─────────────┐
│   tenants   │───────│    users    │
└─────────────┘  1:N  └─────────────┘
       │                │
       │ 1:N            │ 1:N
       ▼                ▼
┌─────────────┐  ┌─────────────┐
│  categories │  │   orders   │
└─────────────┘  └─────────────┘
```

Relationship types to detect:

- **1:1** — FK with UNIQUE constraint on both sides
- **1:N** — FK on the "many" side referencing the "one" side (most common)
- **N:M** — a join/junction table with two FKs each referencing one of the related tables
- **Self-referential** — FK pointing to the same table (`parent_id → categories(id)`)

If the ORM declares relationships explicitly (`@ManyToOne`, `@OneToMany`, `@OneToOne`, `@ManyToMany`, Prisma `relation` field), use those declarations to build the diagram.

If only FK columns are present (no explicit relation declared), infer from the column name and FK reference: a column named `{table_singular}_id` referencing `{table}(id)` is a 1:N.

If relationships cannot be determined from code, document what you can and add to issues:

```
## Issues

- Could not determine relationship cardinality for `{table}.{column}` —
  no explicit ORM relation declaration found. FK points to `{target_table}`.
  Assumed 1:N (FK on the "many" side).
```

#### 4b. Indexes

Collect all indexes from:

- ORM declarations (`@Index`, Prisma `@@index`, Sequelize `indexes: []`)
- Migration files (`CREATE INDEX` statements)
- UNiques (documented as indexes with `(unique)` marker)

List them per table in the same block:

```
**Indexes**:
- `idx_{table}_{column}` ON `{column}` (unique)
- `idx_{table}_{other_column}` ON `{other_column}`
```

If indexes are not declared in the schema and no migration files exist, document this:

```
> No indexes found in the schema. Indexes may exist in the database
> but were not detectable from the schema definition.
```

### Step 5: Document Enums (If Applicable)

If the schema defines enums (Prisma `enum`, Postgres `CREATE TYPE`, SQLAlchemy `Enum`, TypeORM `enum:`), document them in a dedicated **Enums** section:

```
## Enums

### {enum_name}

```sql
CREATE TYPE {enum_name} AS ENUM ({values});
```

| Value | Description |
|-------|-------------|
| {value} | {inferred or "—"} |
| ... | ... |
```

Enum value descriptions follow the same rule as columns: only describe if evident, otherwise "—".

### Step 6: Report Results to Orchestrator

Produce a structured result report to return to the caller (orchestrator or direct user).

#### For orchestrator sessions

Return this structure so the orchestrator can update the session register:

```
## flowdoc-db — Report

### Status
completed | partial | failed

### Documents created
- docs/database/schema.md (created | updated)

### Tables documented
| Table | Source file | Notes |
|-------|------------|-------|

### Enums documented
| Enum | Values |
|------|---------|

### Relationships documented
| From | To | Type |
|------|----|------|

### Pending updates
These other documents may need updates as a result of schema changes:
- docs/PRD.md — if business entities changed
- docs/templates/api/endpoints.md — if schema affects API contracts
- {others detected}

### Issues
- {anything that couldn't be documented from code alone}
- {columns without descriptions}
- {relationships that were guessed}
```

#### For direct invocations (no orchestrator)

Show the user a concise summary:

```
## Database Schema Documentation Complete

Generated: docs/database/schema.md
Tables documented: {N}
Enums documented: {N}
Relationships documented: {N}
Issues found: {N} (see below)

Files affected:
- {list}

Issues:
- {list — can be empty}
```

---

## Determining Existing Documentation

Before writing, check if `docs/database/schema.md` already exists:

| Scenario | Action |
|----------|--------|
| File exists, contains schema already | **Update** — merge new tables/changes, preserve existing content where not overridden |
| File exists, contains `These are generic examples` placeholder | **Replace** — this is the starter template content, replace it with actual schema |
| File exists, completely empty | **Write** — document the full schema |
| File does not exist | **Create** — write the schema starting from the template structure |

**Update rule**: When updating existing schema documentation:

1. Read the current `docs/database/schema.md`
2. Match existing tables by name with newly-scanned tables
3. For tables still present → update columns/constraints/indexes
4. For tables no longer in the code → mark as "⚠️ Possibly removed — verify" (DO NOT delete without user confirmation)
5. For new tables → add to the document
6. Preserve any hand-written notes or multi-tenant sections that are NOT auto-generated

---

## Decision Gates

| Situación | Acción | Tipo |
|-----------|--------|------|
| Schema no encontrado | Ask user | error |
| Múltiples databases | Secciones separadas | info |
| Template faltante | Usar patrón embebido | warning |

---

## Edge Cases

These situations are covered by the Decision Gates table above. Additional context:

### Schema lives in a separate database repository

If the project uses a database but no schema files exist in this repo, document what you can from:

- Configuration files (`config/database.js`, `knexfile.js`, `ormconfig.json`)
- Migration files
- SQL files in `db/` or `sql/`

Then note in the output that the schema is not defined in this project directly.

### Schema uses raw SQL instead of an ORM

Document directly from the `CREATE TABLE` statements. Skip type mapping — use the SQL types as declared.

### GraphQL-defined schema with persistence directives

If the project uses a GraphQL-first approach with directives like `@table` / `@column`, parse those directives to extract table definitions.

---

## Rules

- **DOCUMENT ONLY FROM CODE** — never invent tables, columns, or relationships not present in the code
- **NO DESIGN OPINIONS** — do not suggest "you should add an index here" or "this should be normalized"
- **NO PRESCRIPTIONS** — this is a documentation skill, not an advisory
- **Descriptions from evidence only** — don't make up the purpose of a column; use the column name or schema comment/annotation if present, otherwise leave "—"
- **Type canonicalization is allowed** — mapping ORM types to SQL types (transforms for readability) is NOT a design opinion
- **Never modify schema files** — this skill only reads code, it only writes documentation under `docs/`
- **If uncertain, ask** — if a relationship is ambiguous, report it as an issue rather than guessing silently
- **Report pending updates** — if documenting the DB implies another doc needs to change (API endpoints, PRD), add it to `pendingUpdates`
- **No direct specialist communication** — to investigate deeper, invoke `flowdoc-discover`; to coordinate changes, report to orchestrator
- **Template fidelity** — the output section structure MUST match `docs/templates/database/schema.md`
- **Handle language directly** — if invoked in Spanish, write the section headers and summaries in Spanish; if in English, in English

---

## Example Sessions

### Example A: Orchestrator-invoked, Prisma project

```
[Orchestrator launches flowdoc-db with context:]

orchestratorContext:
  projectPath: /home/user/my-shop
  pathsToScan: [prisma/]
  stack: [Node.js, TypeScript, PostgreSQL]
  database: PostgreSQL
  orm: Prisma
  existing: [docs/PRD.md, docs/templates/]
  templateReference: docs/templates/database/schema.md

[Skill reads prisma/schema.prisma, scans models:]

User model declared → document `users` table
Product model declared → document `products` table
Category model declared → document `categories` table
Order model declared → document `orders` table
...

[Skill writes docs/database/schema.md]:

Created: docs/database/schema.md
- Tables: 6 (users, categories, products, orders, order_items, tenants)
- Enums: 3 (user_role, order_status, subscription_plan)
- Relationships: 1:N (tenants→users, tenants→categories, categories→products [self-ref], users→orders, orders→order_items, products→order_items)

Issues:
- column {schema_url} on `tenants` table has no clear description — inferred from column name
```

### Example B: Direct user invocation, raw SQL

```
User: documentame la base de datos

[Skill scans project, doesn't find FlowDoc adoption (no AGENTS.md)]

Agent: No encontre FlowDoc en este proyecto. Documentare en docs/database/schema.md
siguiendo la plantilla de docs/templates/database/schema.md.

[If docs/templates/database/schema.md doesn't exist, use the embedded pattern.]

[Skill finds migrations/*.sql with CREATE TABLE statements]

Generated: docs/database/schema.md
Tables documentadas: 4
...
```

### Example C: Existing schema.md needs update

```
[Skill invoked by orchestrator after schema changes]

[Reads existing docs/database/schema.md]
[Scans prisma/schema.prisma]
[Compares]

Updated: docs/database/schema.md
- users table: 2 new columns (avatar_url, last_login_at)
- orders table: status column type changed from VARCHAR to ENUM
- {removed_table} marked with "⚠️ Possibly removed — verify"

Pending updates:
- docs/templates/api/endpoints.md — Orders endpoint may reflect new status values
```

### Example D: No schema found

```
[Skill scans project, finds no schema definitions]

Agent:
## No Database Schema Found

I scanned the following locations and didn't find schema definitions:
- prisma/
- models/
- entities/
- db/
- migrations/

Possible reasons:
- Your schema isn't in a standard location
- You use a different ORM/tool not listed above
- Your schema lives in a separate database repo

Please tell me where your schema definitions live, or invoke flowdoc-discover
for a broader investigation.
```

---

# Database Schema — Ejemplos Genéricos

> Estos son ejemplos genéricos para referencia. Copiar y adaptar según tu proyecto.

---

## Overview

- **Database**: PostgreSQL 15+
- **ORM**: Entity Framework Core / Prisma / SQLAlchemy (adaptar según tu stack)
- **Multi-tenant**: Sí (campo `tenant_id` en todas las tablas)

---

## Tablas

### users

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Identificador único |
| email | VARCHAR(255) | UNIQUE, NOT NULL | Email único |
| password_hash | VARCHAR(255) | NOT NULL | Hash bcrypt |
| name | VARCHAR(255) | NOT NULL | Nombre completo |
| role | user_role | NOT NULL, DEFAULT 'user' | Rol del usuario |
| avatar_url | TEXT | NULL | URL de avatar |
| tenant_id | UUID | NOT NULL, FK | Tenant (multi-tenant) |
| is_active | BOOLEAN | DEFAULT true | Si está activo |
| created_at | TIMESTAMP | DEFAULT NOW() | Fecha creación |
| updated_at | TIMESTAMP | DEFAULT NOW() | Última modificación |

**Indexes**:
- `idx_users_email` ON `email` (unique)
- `idx_users_tenant_id` ON `tenant_id`

---

### categories

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Identificador único |
| name | VARCHAR(255) | NOT NULL | Nombre de categoría |
| description | TEXT | NULL | Descripción |
| parent_id | UUID | FK → categories(id), NULL | Categoría padre |
| tenant_id | UUID | NOT NULL, FK | Tenant (multi-tenant) |
| is_active | BOOLEAN | DEFAULT true | Si está activa |
| created_at | TIMESTAMP | DEFAULT NOW() | Fecha creación |
| updated_at | TIMESTAMP | DEFAULT NOW() | Última modificación |

**Indexes**:
- `idx_categories_tenant_id` ON `tenant_id`
- `idx_categories_parent_id` ON `parent_id`

**Relaciones**:
- Self-referential: `parent_id` → `categories(id)` (categorías anidadas)

---

### products

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Identificador único |
| name | VARCHAR(255) | NOT NULL | Nombre del producto |
| description | TEXT | NULL | Descripción larga |
| price | DECIMAL(10,2) | NOT NULL | Precio unitario |
| stock | INTEGER | DEFAULT 0 | Stock actual |
| min_stock | INTEGER | DEFAULT 10 | Umbral mínimo |
| category_id | UUID | FK → categories(id), NULL | Categoría |
| image_url | TEXT | NULL | URL de imagen |
| tenant_id | UUID | NOT NULL, FK | Tenant (multi-tenant) |
| is_active | BOOLEAN | DEFAULT true | Si está disponible |
| created_at | TIMESTAMP | DEFAULT NOW() | Fecha creación |
| updated_at | TIMESTAMP | DEFAULT NOW() | Última modificación |

**Indexes**:
- `idx_products_tenant_id` ON `tenant_id`
- `idx_products_category_id` ON `category_id`
- `idx_products_name` ON `name`

---

### orders

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Identificador único |
| order_number | VARCHAR(50) | UNIQUE, NOT NULL | Número legible |
| customer_id | UUID | NOT NULL, FK → users(id) | Cliente |
| status | order_status | NOT NULL, DEFAULT 'pending' | Estado |
| subtotal | DECIMAL(10,2) | NOT NULL | Subtotal |
| tax | DECIMAL(10,2) | NOT NULL | Impuesto |
| total | DECIMAL(10,2) | NOT NULL | Total |
| shipping_address | JSONB | NOT NULL | Dirección de envío |
| notes | TEXT | NULL | Notas adicionales |
| tracking_number | VARCHAR(100) | NULL | Número de seguimiento |
| tenant_id | UUID | NOT NULL, FK | Tenant (multi-tenant) |
| created_at | TIMESTAMP | DEFAULT NOW() | Fecha del pedido |
| updated_at | TIMESTAMP | DEFAULT NOW() | Última modificación |

**Indexes**:
- `idx_orders_order_number` ON `order_number` (unique)
- `idx_orders_customer_id` ON `customer_id`
- `idx_orders_status` ON `status`
- `idx_orders_tenant_id` ON `tenant_id`
- `idx_orders_created_at` ON `created_at`

---

### order_items

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Identificador único |
| order_id | UUID | NOT NULL, FK → orders(id) | Orden padre |
| product_id | UUID | NOT NULL, FK → products(id) | Producto |
| quantity | INTEGER | NOT NULL, CHECK > 0 | Cantidad |
| unit_price | DECIMAL(10,2) | NOT NULL | Precio al momento |
| subtotal | DECIMAL(10,2) | NOT NULL | quantity × unit_price |

**Indexes**:
- `idx_order_items_order_id` ON `order_id`
- `idx_order_items_product_id` ON `product_id`

---

### tenants

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Identificador único |
| name | VARCHAR(255) | NOT NULL | Nombre de la empresa |
| slug | VARCHAR(100) | UNIQUE, NOT NULL | Slug URL |
| plan | subscription_plan | DEFAULT 'free' | Plan de suscripción |
| is_active | BOOLEAN | DEFAULT true | Si está activo |
| created_at | TIMESTAMP | DEFAULT NOW() | Fecha creación |
| updated_at | TIMESTAMP | DEFAULT NOW() | Última modificación |

**Indexes**:
- `idx_tenants_slug` ON `slug` (unique)

---

## Enums

### user_role

```sql
CREATE TYPE user_role AS ENUM ('admin', 'user', 'guest');
```

| Value | Description |
|-------|-------------|
| admin | Administrador con acceso total |
| user | Usuario estándar |
| guest | Invitado (solo lectura) |

---

### order_status

```sql
CREATE TYPE order_status AS ENUM (
  'pending',
  'confirmed',
  'preparing',
  'ready',
  'shipped',
  'delivered',
  'cancelled'
);
```

| Value | Description |
|-------|-------------|
| pending | Creada, esperando pago |
| confirmed | Pago confirmado |
| preparing | En preparación |
| ready | Lista para envío |
| shipped | Enviada |
| delivered | Entregada |
| cancelled | Cancelada |

---

### subscription_plan

```sql
CREATE TYPE subscription_plan AS ENUM ('free', 'starter', 'pro', 'enterprise');
```

| Value | Description |
|-------|-------------|
| free | Hasta 100 productos, 1 usuario |
| starter | Hasta 1000 productos, 3 usuarios |
| pro | Productos ilimitados, 10 usuarios |
| enterprise | Todo ilimitado, usuarios ilimitados |

---

## Relaciones (ER Diagram)

```
┌─────────────┐       ┌─────────────┐
│   tenants   │───────│    users    │
└─────────────┘  1:N  └─────────────┘
       │                │
       │ 1:N            │ 1:N
       ▼                ▼
┌─────────────┐  ┌─────────────┐
│  products   │  │   orders   │
└─────────────┘  └─────────────┘
       │                │
       │                │
       │ 1:N            │ 1:N
       ▼                ▼
┌─────────────┐  ┌─────────────┐
│  categories │  │ order_items│
└─────────────┘  └─────────────┘
       │
       │ self-ref
       ▼
┌─────────────┐
│  categories │ (parent_id → id)
└─────────────┘
```

---

## Multi-Tenant Isolation

**Regla**: TODAS las queries deben incluir `tenant_id`.

```sql
-- ✅ Correcto
SELECT * FROM products WHERE tenant_id = '550e8400-e29b-41d4-a716-446655440000';

-- ❌ Incorrecto (data leak)
SELECT * FROM products;
```

**En aplicación**:
1. Extraer `tenant_id` del JWT o sesión
2. Agregar a TODAS las queries
3. Validar en middleware

---

## Migraciones

```bash
# Crear migración
dotnet ef migrations add InitialCreate

# Aplicar
dotnet ef database update

# Ver historial
dotnet ef migrations list
```

**Ver historial completo**: `migrations.md`

---

## Cómo Usar Estos Ejemplos

1. **Copiar** las tablas que necesites
2. **Adaptar** tipos y constraints
3. **Agregar** campos específicos de tu negocio
4. **Mantener** el campo `tenant_id` para multi-tenant

Para API endpoints relacionados, ver `endpoints.md`.

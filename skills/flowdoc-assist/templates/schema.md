# Database Schema — Generic Examples

> These are generic examples for reference. Copy and adapt to your project.

---

## Overview

- **Database**: PostgreSQL 15+
- **ORM**: Entity Framework Core / Prisma / SQLAlchemy (adapt to your stack)
- **Multi-tenant**: Yes (`tenant_id` field on all tables)

---

## Tables

### users

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Unique identifier |
| email | VARCHAR(255) | UNIQUE, NOT NULL | Unique email |
| password_hash | VARCHAR(255) | NOT NULL | Bcrypt hash |
| name | VARCHAR(255) | NOT NULL | Full name |
| role | user_role | NOT NULL, DEFAULT 'user' | User role |
| avatar_url | TEXT | NULL | Avatar URL |
| tenant_id | UUID | NOT NULL, FK | Tenant (multi-tenant) |
| is_active | BOOLEAN | DEFAULT true | Whether active |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last modification |

**Indexes**:
- `idx_users_email` ON `email` (unique)
- `idx_users_tenant_id` ON `tenant_id`

---

### categories

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Unique identifier |
| name | VARCHAR(255) | NOT NULL | Category name |
| description | TEXT | NULL | Description |
| parent_id | UUID | FK → categories(id), NULL | Parent category |
| tenant_id | UUID | NOT NULL, FK | Tenant (multi-tenant) |
| is_active | BOOLEAN | DEFAULT true | Whether active |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last modification |

**Indexes**:
- `idx_categories_tenant_id` ON `tenant_id`
- `idx_categories_parent_id` ON `parent_id`

**Relationships**:
- Self-referential: `parent_id` → `categories(id)` (nested categories)

---

### products

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Unique identifier |
| name | VARCHAR(255) | NOT NULL | Product name |
| description | TEXT | NULL | Long description |
| price | DECIMAL(10,2) | NOT NULL | Unit price |
| stock | INTEGER | DEFAULT 0 | Current stock |
| min_stock | INTEGER | DEFAULT 10 | Minimum threshold |
| category_id | UUID | FK → categories(id), NULL | Category |
| image_url | TEXT | NULL | Image URL |
| tenant_id | UUID | NOT NULL, FK | Tenant (multi-tenant) |
| is_active | BOOLEAN | DEFAULT true | Whether available |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last modification |

**Indexes**:
- `idx_products_tenant_id` ON `tenant_id`
- `idx_products_category_id` ON `category_id`
- `idx_products_name` ON `name`

---

### orders

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Unique identifier |
| order_number | VARCHAR(50) | UNIQUE, NOT NULL | Human-readable number |
| customer_id | UUID | NOT NULL, FK → users(id) | Customer |
| status | order_status | NOT NULL, DEFAULT 'pending' | Status |
| subtotal | DECIMAL(10,2) | NOT NULL | Subtotal |
| tax | DECIMAL(10,2) | NOT NULL | Tax |
| total | DECIMAL(10,2) | NOT NULL | Total |
| shipping_address | JSONB | NOT NULL | Shipping address |
| notes | TEXT | NULL | Additional notes |
| tracking_number | VARCHAR(100) | NULL | Tracking number |
| tenant_id | UUID | NOT NULL, FK | Tenant (multi-tenant) |
| created_at | TIMESTAMP | DEFAULT NOW() | Order date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last modification |

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
| id | UUID | PRIMARY KEY | Unique identifier |
| order_id | UUID | NOT NULL, FK → orders(id) | Parent order |
| product_id | UUID | NOT NULL, FK → products(id) | Product |
| quantity | INTEGER | NOT NULL, CHECK > 0 | Quantity |
| unit_price | DECIMAL(10,2) | NOT NULL | Price at time of purchase |
| subtotal | DECIMAL(10,2) | NOT NULL | quantity × unit_price |

**Indexes**:
- `idx_order_items_order_id` ON `order_id`
- `idx_order_items_product_id` ON `product_id`

---

### tenants

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Unique identifier |
| name | VARCHAR(255) | NOT NULL | Company name |
| slug | VARCHAR(100) | UNIQUE, NOT NULL | URL slug |
| plan | subscription_plan | DEFAULT 'free' | Subscription plan |
| is_active | BOOLEAN | DEFAULT true | Whether active |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last modification |

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
| admin | Administrator with full access |
| user | Standard user |
| guest | Guest (read-only) |

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
| pending | Created, awaiting payment |
| confirmed | Payment confirmed |
| preparing | Being prepared |
| ready | Ready for shipment |
| shipped | Shipped |
| delivered | Delivered |
| cancelled | Cancelled |

---

### subscription_plan

```sql
CREATE TYPE subscription_plan AS ENUM ('free', 'starter', 'pro', 'enterprise');
```

| Value | Description |
|-------|-------------|
| free | Up to 100 products, 1 user |
| starter | Up to 1000 products, 3 users |
| pro | Unlimited products, 10 users |
| enterprise | Everything unlimited, unlimited users |

---

## Relationships (ER Diagram)

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

**Rule**: ALL queries must include `tenant_id`.

```sql
-- ✅ Correct
SELECT * FROM products WHERE tenant_id = '550e8400-e29b-41d4-a716-446655440000';

-- ❌ Incorrect (data leak)
SELECT * FROM products;
```

**In application**:
1. Extract `tenant_id` from JWT or session
2. Add to ALL queries
3. Validate in middleware

---

## Migrations

```bash
# Create migration
dotnet ef migrations add InitialCreate

# Apply
dotnet ef database update

# View history
dotnet ef migrations list
```

**View complete history**: `migrations.md`

---

## How to Use These Examples

1. **Copy** the tables you need
2. **Adapt** types and constraints
3. **Add** business-specific fields
4. **Keep** the `tenant_id` field for multi-tenant

For related API endpoints, see `endpoints.md`.
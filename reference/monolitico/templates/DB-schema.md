# Database Schema

## Overview

- **Database**: PostgreSQL / MySQL / MongoDB
- **Version**: X.X
- **Multi-tenant**: Yes (`id_empresa` in all tables)

---

## Tables

### users

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | User ID |
| email | VARCHAR(255) | UNIQUE, NOT NULL | Email address |
| password_hash | VARCHAR(255) | NOT NULL | Hashed password |
| role | ENUM | NOT NULL | 'admin', 'user', 'etc.' |
| id_empresa | INTEGER | NOT NULL, FK → companies(id) | Multi-tenant key |
| is_active | BOOLEAN | DEFAULT true | Account status |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | ON UPDATE NOW() | Last update |

**Indexes**:
- `users.email` (unique)
- `users.id_empresa` (foreign key)
- `users.role` (query optimization)

---

### companies

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INTEGER | PRIMARY KEY, AUTO INCREMENT | Company ID |
| name | VARCHAR(255) | NOT NULL | Company name |
| nit | VARCHAR(50) | UNIQUE | Tax ID |
| address | TEXT | - | Physical address |
| phone | VARCHAR(20) | - | Contact phone |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |

**Indexes**:
- `companies.nit` (unique)

---

### products

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Product ID |
| name | VARCHAR(255) | NOT NULL | Product name |
| description | TEXT | - | Product description |
| price | DECIMAL(10,2) | NOT NULL | Unit price |
| stock | INTEGER | DEFAULT 0 | Current stock |
| min_stock | INTEGER | DEFAULT 10 | Low stock threshold |
| category_id | UUID | FK → categories(id) | Category |
| id_empresa | INTEGER | NOT NULL, FK → companies(id) | Multi-tenant key |
| is_active | BOOLEAN | DEFAULT true | Product status |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | ON UPDATE NOW() | Last update |

**Indexes**:
- `products.id_empresa` (foreign key)
- `products.category_id` (foreign key)
- `products.name` (search optimization)

---

### categories

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Category ID |
| name | VARCHAR(255) | NOT NULL | Category name |
| parent_id | UUID | FK → categories(id) | Parent category (nullable) |
| id_empresa | INTEGER | NOT NULL, FK → companies(id) | Multi-tenant key |

**Indexes**:
- `categories.id_empresa` (foreign key)
- `categories.parent_id` (hierarchical queries)

---

### orders

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Order ID |
| order_number | VARCHAR(50) | UNIQUE, NOT NULL | Human-readable number |
| customer_id | UUID | FK → customers(id) | Customer |
| status | ENUM | NOT NULL | 'pending', 'confirmed', 'shipped', 'delivered', 'cancelled' |
| subtotal | DECIMAL(10,2) | NOT NULL | Subtotal before tax |
| tax | DECIMAL(10,2) | NOT NULL | Tax amount |
| total | DECIMAL(10,2) | NOT NULL | Total amount |
| id_empresa | INTEGER | NOT NULL, FK → companies(id) | Multi-tenant key |
| created_at | TIMESTAMP | DEFAULT NOW() | Order date |
| updated_at | TIMESTAMP | ON UPDATE NOW() | Last update |

**Indexes**:
- `orders.order_number` (unique)
- `orders.customer_id` (foreign key)
- `orders.status` (filter optimization)
- `orders.id_empresa` (foreign key)

---

### order_items

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Order Item ID |
| order_id | UUID | NOT NULL, FK → orders(id) | Order |
| product_id | UUID | NOT NULL, FK → products(id) | Product |
| quantity | INTEGER | NOT NULL | Quantity ordered |
| unit_price | DECIMAL(10,2) | NOT NULL | Price at time of order |
| subtotal | DECIMAL(10,2) | NOT NULL | quantity × unit_price |

**Indexes**:
- `order_items.order_id` (foreign key)
- `order_items.product_id` (foreign key)

---

## Relationships

```
companies (1) ──────< (N) users
companies (1) ──────< (N) products
companies (1) ──────< (N) categories
companies (1) ──────< (N) orders

categories (1) ──────< (N) products
categories (parent) ──< (N) categories (children) [self-referential]

orders (1) ──────< (N) order_items
products (1) ──────< (N) order_items

customers (1) ──────< (N) orders
```

---

## Enums

### user_role
- `admin`
- `user`
- `mesero`
- `cocina`
- `repartidor`

### order_status
- `pending`
- `confirmed`
- `preparing`
- `ready`
- `in_transit`
- `delivered`
- `cancelled`

---

## Migrations

**Latest Migration**: `001_initial_schema.sql`

```sql
-- Example migration
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role user_role NOT NULL,
  id_empresa INTEGER NOT NULL REFERENCES companies(id),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

**Ver historial completo**: `docs/DB/migrations.md`

---

## Multi-Tenant Isolation

**All queries MUST include `id_empresa`**:

```sql
-- ✅ Correct
SELECT * FROM products WHERE id_empresa = 1;

-- ❌ Wrong (data leak risk)
SELECT * FROM products;
```

**Application-level enforcement**:
- Add `id_empresa` to JWT claims
- Axios interceptor adds `X-Empresa-Id` header
- Backend validates against user's company

---

**Last Updated**: YYYY-MM-DD  
**Maintained By**: @db-lead

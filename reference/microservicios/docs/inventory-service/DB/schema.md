# inventory-service DB Schema

- **Database**: `inventory_db` (PostgreSQL 15, isolated)
- **Multi-tenant**: by `restaurant_id`

---

## products

| Column        | Type          | Constraints              |
|---------------|---------------|--------------------------|
| id            | UUID          | PRIMARY KEY              |
| name          | VARCHAR(255)  | NOT NULL                 |
| description   | TEXT          | —                        |
| price         | DECIMAL(10,2) | NOT NULL                 |
| category_id   | UUID          | FK → categories(id)      |
| restaurant_id| INTEGER       | NOT NULL                 |
| is_active     | BOOLEAN       | DEFAULT true             |
| created_at    | TIMESTAMP     | DEFAULT NOW()            |
| updated_at    | TIMESTAMP     | DEFAULT NOW()            |
| version       | INTEGER       | NOT NULL DEFAULT 0       |

**Indexes**: `products.restaurant_id`, `products.category_id`, `products.name`.

---

## stock

| Column        | Type    | Constraints                       |
|---------------|---------|-----------------------------------|
| product_id    | UUID    | PK, FK → products(id) CASCADE     |
| restaurant_id | INTEGER | PK                                |
| available     | INTEGER | NOT NULL DEFAULT 0                |
| reserved      | INTEGER | NOT NULL DEFAULT 0                |

---

## reservations

| Column          | Type      | Constraints                       |
|-----------------|-----------|-----------------------------------|
| id              | UUID      | PRIMARY KEY                       |
| order_id        | UUID      | NOT NULL                          |
| product_id      | UUID      | FK → products(id)                 |
| restaurant_id   | INTEGER   | NOT NULL                          |
| quantity        | INTEGER   | NOT NULL                          |
| status          | ENUM      | 'pending','confirmed','released'  |
| expires_at      | TIMESTAMP | NOT NULL                          |
| created_at      | TIMESTAMP | DEFAULT NOW()                     |

**Indexes**: `reservations.order_id`, `reservations.status`, `reservations.expires_at`.

Sweeper job releases expired `pending` reservations every 60s.

---

## Relationships

```
products (1) ──< (N) stock          (per restaurant)
products (1) ──< (N) reservations
orders (external) ── referenced by reservations.order_id (no FK cross-DB)
```

---

**Last Updated**: 2026-07-18
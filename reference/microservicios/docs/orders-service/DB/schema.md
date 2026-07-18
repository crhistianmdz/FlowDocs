# orders-service DB Schema

- **Database**: `orders_db` (PostgreSQL 15, isolated)
- **Multi-tenant**: by `restaurant_id`

---

## orders

| Column         | Type          | Constraints                                  |
|----------------|---------------|----------------------------------------------|
| id             | UUID          | PRIMARY KEY                                  |
| order_number   | VARCHAR(50)   | UNIQUE, NOT NULL                             |
| customer_id    | UUID          | NOT NULL (no FK — crosses auth-service)      |
| restaurant_id  | INTEGER       | NOT NULL                                     |
| status         | ENUM          | NOT NULL ('pending','confirmed','shipped','delivered','cancelled') |
| subtotal       | DECIMAL(10,2) | NOT NULL                                     |
| tax            | DECIMAL(10,2) | NOT NULL                                     |
| total          | DECIMAL(10,2) | NOT NULL                                     |
| reservation_id | UUID          | NULLABLE (set after inventory reserve)       |
| notes          | TEXT          | —                                            |
| created_at     | TIMESTAMP     | DEFAULT NOW()                                |
| updated_at     | TIMESTAMP     | DEFAULT NOW()                                |

**Indexes**: `orders.order_number` (unique), `orders.customer_id`, `orders.status`, `orders.restaurant_id`.

---

## order_items

| Column      | Type          | Constraints                       |
|-------------|---------------|-----------------------------------|
| id          | UUID          | PRIMARY KEY                        |
| order_id    | UUID          | FK → orders(id) CASCADE            |
| product_id  | UUID          | NOT NULL (no FK — inventory svc)   |
| quantity    | INTEGER       | NOT NULL                           |
| unit_price  | DECIMAL(10,2) | NOT NULL (snapshot at order time)  |
| subtotal    | DECIMAL(10,2) | NOT NULL                           |

**Indexes**: `order_items.order_id`, `order_items.product_id`.

---

## Relationships

```
orders (1) ──< (N) order_items
```

Cross-service references (NO foreign keys across DBs):
- `orders.customer_id` → auth-service `users.id`
- `order_items.product_id` → inventory-service `products.id`
- `orders.reservation_id` → inventory-service `reservations.id`

Integrity maintained by contract + eventual reconciliation job.

---

**Last Updated**: 2026-07-18
# auth-service DB Schema

- **Database**: `auth_db` (PostgreSQL 15, isolated)
- **Version**: 1.0
- **Multi-tenant**: Yes (`id_empresa`)

---

## users

| Column        | Type           | Constraints                  |
|---------------|----------------|------------------------------|
| id            | UUID           | PRIMARY KEY                  |
| email         | VARCHAR(255)   | UNIQUE, NOT NULL             |
| password_hash | VARCHAR(255)   | NOT NULL                     |
| role          | ENUM           | NOT NULL ('admin','customer')|
| id_empresa    | INTEGER        | NOT NULL                     |
| is_active     | BOOLEAN        | DEFAULT true                 |
| created_at    | TIMESTAMP      | DEFAULT NOW()                |
| updated_at    | TIMESTAMP      | DEFAULT NOW()                |

**Indexes**: `users.email` (unique), `users.id_empresa`.

---

## refresh_tokens

| Column       | Type         | Constraints                    |
|--------------|--------------|--------------------------------|
| id           | UUID         | PRIMARY KEY                    |
| user_id      | UUID         | FK → users(id) ON DELETE CASCADE |
| token_hash   | VARCHAR(255) | NOT NULL UNIQUE                |
| family_id    | UUID         | NOT NULL                       |
| expires_at   | TIMESTAMP    | NOT NULL                       |
| revoked      | BOOLEAN      | DEFAULT false                  |
| created_at   | TIMESTAMP    | DEFAULT NOW()                  |

**Indexes**: `refresh_tokens.user_id`, `refresh_tokens.family_id`, `refresh_tokens.token_hash`.

Reuse policy: if a token in a `family_id` is reused after rotation → revoke entire family.

---

## Relationships

```
users (1) ──< (N) refresh_tokens
```

---

**Last Updated**: 2026-07-18
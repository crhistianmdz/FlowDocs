# API Models — TaskManager

> Tipos compartidos por endpoints y contratos. Ver `endpoints.md` para uso.

---

## User

```typescript
interface User {
  id: string;        // UUID
  email: string;
  role: 'admin' | 'user';
  companyId: number;
  createdAt: string; // ISO8601
}

interface UserWithPermissions extends User {
  permissions: string[];
}
```

---

## Auth

```typescript
interface LoginRequest {
  email: string;
  password: string; // min 8
}

interface AuthResponse {
  accessToken: string; // JWT, 15min
  user: User;
  // refreshToken en cookie httpOnly (no en body)
}

interface RefreshResponse {
  accessToken: string;
}
```

---

## Board

```typescript
type BoardVisibility = 'private' | 'company' | 'public';

interface Board {
  id: string;
  name: string;
  visibility: BoardVisibility;
  companyId: number;
  ownerId: string;
  createdAt: string;
  updatedAt: string;
}

interface Column {
  id: string;
  boardId: string;
  name: string;
  order: number; // 0-indexed
  color?: string;
}

interface Card {
  id: string;
  columnId: string;
  title: string;
  description?: string;
  order: number;
  assigneeIds: string[];
  dueDate?: string;        // ISO8601
  labels: string[];       // label ids
  metadata?: Record<string, unknown>; // JSONB flexible
  createdAt: string;
  updatedAt: string;
}
```

---

## Pagination Envelope

```typescript
interface Paginated<T> {
  data: T[];
  meta: {
    total: number;
    page: number;
    limit: number;
    totalPages: number;
  };
}
```

---

## Error Envelope

```typescript
interface ApiError {
  success: false;
  error: {
    code: 'VALIDATION_ERROR' | 'UNAUTHORIZED' | 'FORBIDDEN' | 'NOT_FOUND' | 'CONFLICT' | 'INTERNAL_ERROR';
    message: string;
    details?: unknown;
  };
}
```

---

**Last Updated**: 2026-07-18
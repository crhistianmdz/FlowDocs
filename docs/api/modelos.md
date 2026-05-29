# Modelos — Ejemplos Genéricos

> Estos son ejemplos genéricos para referencia. Copiar y adaptar según tu proyecto.

---

## User (Modelo de Dominio)

### Estructura

| Campo | Tipo | Requerido | Descripción |
|-------|------|-----------|-------------|
| id | UUID | Sí | Identificador único |
| email | string | Sí | Email único |
| name | string | Sí | Nombre completo |
| role | enum | Sí | admin, user, guest |
| avatarUrl | string | No | URL de imagen de perfil |
| createdAt | timestamp | Sí | Fecha de creación |
| updatedAt | timestamp | Sí | Última modificación |
| isActive | boolean | Sí | Si la cuenta está activa |

### Ejemplo JSON

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "usuario@ejemplo.com",
  "name": "Juan Pérez",
  "role": "user",
  "avatarUrl": "https://cdn.ejemplo.com/avatars/550e8400.jpg",
  "createdAt": "2026-01-15T10:30:00Z",
  "updatedAt": "2026-05-20T14:22:00Z",
  "isActive": true
}
```

---

## Product

### Estructura

| Campo | Tipo | Requerido | Descripción |
|-------|------|-----------|-------------|
| id | UUID | Sí | Identificador único |
| name | string | Sí | Nombre del producto |
| description | string | No | Descripción larga |
| price | decimal | Sí | Precio unitario |
| stock | integer | Sí | Cantidad en inventario |
| minStock | integer | No | Umbral de stock mínimo |
| categoryId | UUID | No | FK a Category |
| imageUrl | string | No | URL de imagen |
| isActive | boolean | Sí | Si está disponible |
| createdAt | timestamp | Sí | Fecha de creación |
| updatedAt | timestamp | Sí | Última modificación |

### Ejemplo JSON

```json
{
  "id": "660e8400-e29b-41d4-a716-446655440001",
  "name": "Camisa azul manga larga",
  "description": "Camisa de algodón 100%, talla M",
  "price": 29.99,
  "stock": 150,
  "minStock": 20,
  "categoryId": "770e8400-e29b-41d4-a716-446655440002",
  "imageUrl": "https://cdn.ejemplo.com/products/660e8400.jpg",
  "isActive": true,
  "createdAt": "2026-02-10T08:00:00Z",
  "updatedAt": "2026-05-25T09:15:00Z"
}
```

---

## Order

### Estructura

| Campo | Tipo | Requerido | Descripción |
|-------|------|-----------|-------------|
| id | UUID | Sí | Identificador único |
| orderNumber | string | Sí | Número legible (ej: ORD-2026-001) |
| customerId | UUID | Sí | FK a User (cliente) |
| status | enum | Sí | pending, confirmed, shipped, delivered, cancelled |
| subtotal | decimal | Sí | Subtotal sin impuestos |
| tax | decimal | Sí | Monto de impuesto |
| total | decimal | Sí | Total con impuestos |
| shippingAddress | Address | Sí | Dirección de envío |
| notes | string | No | Notas adicionales |
| createdAt | timestamp | Sí | Fecha del pedido |
| updatedAt | timestamp | Sí | Última modificación |

### Ejemplo JSON

```json
{
  "id": "880e8400-e29b-41d4-a716-446655440003",
  "orderNumber": "ORD-2026-042",
  "customerId": "550e8400-e29b-41d4-a716-446655440000",
  "status": "shipped",
  "subtotal": 89.97,
  "tax": 14.40,
  "total": 104.37,
  "shippingAddress": {
    "street": "Av. Principal 123",
    "city": "Buenos Aires",
    "state": "CABA",
    "postalCode": "C1001",
    "country": "AR"
  },
  "notes": "Dejar en portería",
  "createdAt": "2026-05-28T16:45:00Z",
  "updatedAt": "2026-05-29T08:20:00Z"
}
```

---

## Address (Value Object)

### Estructura

| Campo | Tipo | Requerido | Descripción |
|-------|------|-----------|-------------|
| street | string | Sí | Calle y número |
| city | string | Sí | Ciudad |
| state | string | No | Estado/Provincia |
| postalCode | string | Sí | Código postal |
| country | string | Sí | Código ISO de país |

### Ejemplo JSON

```json
{
  "street": "Av. Principal 123",
  "city": "Buenos Aires",
  "state": "CABA",
  "postalCode": "C1001",
  "country": "AR"
}
```

---

## Enums Comunes

### UserRole

```
admin   — Administrador con acceso total
user    — Usuario estándar
guest   — Usuario invitado (solo lectura)
```

### OrderStatus

```
pending    — Pedido creado, esperando confirmación
confirmed  — Confirmado, en preparación
shipped    — Enviado al cliente
delivered  — Entregado
cancelled  — Cancelado
```

### PaymentStatus

```
pending    — Pendiente de pago
paid       — Pagado
failed     — Falló el pago
refunded   — Reembolsado
```

---

## Cómo Usar Estos Ejemplos

1. **Copiar** el modelo que se parezca a tu caso
2. **Adaptar** campos, tipos y enumeraciones
3. **Agregar** campos específicos de tu negocio
4. **Mantener** consistencia con los enums ya definidos

Para más detalles sobre API contracts, ver `endpoints.md`.
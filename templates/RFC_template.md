# Plantilla de RFC: Request for Comments

> Copiar este template cuando se necesite tomar una decisión técnica importante.
> Las decisiones de producto van en PRD.md, no en RFC.

---

## [Número del RFC]: [Título de la decisión técnica]

- **Estado:** [Borrador | En Revisión | Aprobado | Obsoleto]
- **Autor(es):** [Nombre(s)]
- **Fecha:** [YYYY-MM-DD]
- **Proyecto:** [Nombre del proyecto]

---

## 1. Resumen

Breve descripción de la decisión técnica y por qué se necesita.

---

## 2. Contexto

- ¿Qué problema técnico resuelve?
- ¿Por qué es necesario decidir esto ahora?
- ¿Qué alternativas se consideraron?

---

## 3. Decisión Técnica

### 3.1 Tecnología Elegida
| Item | Selección | Justificación |
|------|-----------|---------------|
| Lenguaje/Framework | [ej: .NET 8] | [razón] |
| Base de Datos | [ej: PostgreSQL] | [razón] |
| API Style | [REST/GraphQL/gRPC] | [razón] |
| Auth | [JWT/OAuth/etc] | [razón] |

---

## 4. Infraestructura

### 4.1 Contenedores (Docker)

| Servicio | Imagen | Puerto | Descripción |
|----------|--------|--------|-------------|
| API | [imagen:tag] | 5000 | Backend |
| Frontend | [imagen:tag] | 4200 | Web app |
| Database | [imagen:tag] | 5432 | PostgreSQL |
| Cache | [imagen:tag] | 6379 | Redis |
| [Otro] | [imagen:tag] | [puerto] | [descripción] |

### 4.2 Archivos Docker

- `Dockerfile` - Imagen de la API
- `Dockerfile.web` - Imagen del frontend
- `docker-compose.yml` - Desarrollo local
- `.dockerignore` - Exclusiones
- `Dockerfile.tests` - Tests (opcional)

### 4.3 Entornos

| Entorno | Descripción | URL |
|---------|-------------|-----|
| Development | docker-compose local | localhost |
| Staging | [Docker swarm/K8s] | staging.example.com |
| Production | [K8s/Cloud] | example.com |

---

## 5. Consideraciones de Seguridad

- Variables de entorno sensibles
- Puertos expuestos
- Redes containerizadas
- Secrets management

---

## 6. Costos y Recursos

- Recursos de hardware necesarios
- Estimación de costos mensuales
- Licencias necesarias

---

## 7. Riesgos

| Riesgo | Impacto | Mitigación |
|--------|---------|-------------|
| [Riesgo 1] | [Alto/Medio/Bajo] | [Cómo evitarlo] |
| [Riesgo 2] | [Alto/Medio/Bajo] | [Cómo evitarlo] |

---

## 8. Estado de Aprobación

| Rol | Persona | Estado | Fecha |
|-----|---------|--------|-------|
| Tech Lead | [Nombre] | [Aprobado/Rechazado/Pendiente] | [Fecha] |
| Equipo | - | [Revisado] | [Fecha] |

---

## 9. Historial de Cambios

| Fecha | Cambio | Autor |
|-------|--------|-------|
| YYYY-MM-DD | Versión inicial | [Autor] |

---

## Ejemplo de uso

```bash
# Copiar el template
cp docs/templates/RFC_template.md docs/RFC/001-mi-decision.md

# Editar con la decisión técnica
# Luego crear task en docs/tasks/ para implementar
```
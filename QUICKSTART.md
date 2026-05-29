# Quick Start Guide

**Cómo usar este framework en 5 minutos**

---

## 🎯 Elegir Arquitectura

### ¿Monolítico o Microservicios?

| Tu Caso | Usar |
|---------|------|
| **Frontend-only** (React, Angular, Vue) | `monolitico/` |
| **Backend único** (Node, Go, Python) | `monolitico/` |
| **Fullstack pequeño** (< 5 personas) | `monolitico/` |
| **Múltiples servicios** independientes | `microservicios/` |
| **Equipos por módulo** | `microservicios/` |
| **Cada módulo con su propia DB** | `microservicios/` |

---

## 🚀 Opción 1: Monolítico

### Paso 1: Inicializar
```bash
cd ~/Documentos/proyectosJunior

# Opción A: Usar script automático (recomendado)
~/Documentos/newPropuestaFrameworkTrabajo/monolitico/scripts/init-monolith.sh mi-proyecto

# Opción B: Copiar manualmente
# 1. Copiar contexto del agent
cp ~/Documentos/newPropuestaFrameworkTrabajo/monolitico/.agent-context.md mi-proyecto/.agent/context.md

# 2. Copiar templates desde docs/templates/ (source of truth)
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/user-stories/* mi-proyecto/docs/templates/user-stories/
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/bug-fixes/* mi-proyecto/docs/templates/bug-fixes/
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/refactors/* mi-proyecto/docs/templates/refactors/
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/PRD/* mi-proyecto/docs/templates/PRD/
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/architecture/* mi-proyecto/docs/templates/architecture/
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/database/* mi-proyecto/docs/templates/database/
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/api/* mi-proyecto/docs/templates/api/
```

### Paso 2: Personalizar
```bash
cd mi-proyecto

# Editar context.md con info de tu proyecto
nano .agent/context.md

# Editar primera HU
nano docs/tasks/HU-001-first-feature.md
```

### Paso 3: Empezar a trabajar
```bash
# Inicializar SDD
/sdd-init

# Trabajar en primera HU
/sdd-new HU-001-first-feature --from-docs
```

---

## 🚀 Opción 2: Microservicios

### Paso 1: Inicializar
```bash
cd ~/Documentos/proyectosJunior

# Opción A: Usar script automático (recomendado)
~/Documentos/newPropuestaFrameworkTrabajo/microservicios/scripts/init-microservices.sh mi-proyecto auth-service inventory-service orders-service

# Opción B: Copiar manualmente
# 1. Copiar contexto del agent
cp ~/Documentos/newPropuestaFrameworkTrabajo/microservicios/.agent-context.md mi-proyecto/.agent/context.md

# 2. Copiar templates desde docs/templates/ (source of truth)
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/user-stories/* mi-proyecto/docs/templates/user-stories/
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/bug-fixes/* mi-proyecto/docs/templates/bug-fixes/
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/refactors/* mi-proyecto/docs/templates/refactors/
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/PRD/* mi-proyecto/docs/templates/PRD/
cp ~/Documentos/newPropuestaFrameworkTrabajo/docs/templates/architecture/* mi-proyecto/docs/templates/architecture/
```

### Paso 2: Personalizar
```bash
cd mi-proyecto

# Editar context.md con lista de servicios
nano .agent/context.md

# Editar README de cada servicio
nano docs/auth-service/README.md
nano docs/inventory-service/README.md

# Editar primera HU de un servicio
nano docs/auth-service/tasks/HU-001-login.md
```

### Paso 3: Empezar a trabajar
```bash
# Inicializar SDD
/sdd-init

# Trabajar en HU de un servicio específico
/sdd-new HU-001-login --from-docs --module=auth-service
```

---

## 📁 Estructura Resultante

### Monolítico
```
mi-proyecto/
├── .agent/
│   └── context.md
├── docs/
│   ├── PRODUCTO/
│   │   └── PRD.md
│   ├── TECNICO/
│   │   └── RFC.md
│   ├── API/
│   │   └── endpoints.md
│   ├── DB/
│   │   └── schema.md
│   └── tasks/
│       ├── TEMPLATE.md
│       └── HU-001-first-feature.md
├── openspec/changes/
└── src/
```

### Microservicios
```
mi-proyecto/
├── .agent/
│   └── context.md
├── docs/
│   ├── SHARED/
│   │   ├── PRD.md
│   │   ├── RFC.md
│   │   ├── contratos.md
│   │   └── deployments.md
│   ├── auth-service/
│   │   ├── README.md
│   │   ├── API/
│   │   ├── DB/
│   │   └── tasks/
│   └── inventory-service/
│       └── ...
├── openspec/changes/
├── src/
│   ├── auth-service/
│   └── inventory-service/
└── docker-compose.yml
```

---

## 📋 Flujo Diario de Trabajo

### 1. Sincronizar
```bash
git pull origin main
```

### 2. Inicializar sesión SDD
```bash
/sdd-init
```

### 3. Trabajar en HU
```bash
# Monolítico
/sdd-new HU-XXX-nombre --from-docs

# Microservicios (con módulo)
/sdd-new HU-XXX-nombre --from-docs --module=nombre-servicio
```

### 4. Commit y push
```bash
git add .
git commit -m "feat: HU-XXX - descripción"
git push origin main
```

---

## 📚 Documentación Clave

| Archivo | Qué es | Cuándo editar |
|---------|--------|---------------|
| `.agent/context.md` | Contexto para SDD | Al inicio del proyecto, actualizar cuando hay cambios grandes |
| `docs/tasks/HU-XXX.md` | Historia de usuario | Antes de empezar cada feature |
| `docs/API/endpoints.md` | Documentación de API | Cuando se agregan/modify endpoints |
| `docs/DB/schema.md` | Esquema de DB | Cuando se agregan/modify tablas |
| `docs/SHARED/contratos.md` | Contratos entre servicios | Solo microservicios, cuando cambia comunicación |

---

## ⚠️ Errores Comunes

| Error | Solución |
|-------|----------|
| **SDD no lee las HUs** | Verificar que `--from-docs` está en el comando |
| **Engram no guarda contexto** | Correr `/sdd-init` al inicio de cada sesión |
| **Conflicto de merges en docs/** | Comunicar cambios en el equipo antes de editar docs compartidos |
| **HU muy grande** | Dividir en HUs más pequeñas (1-3 días máximo por HU) |

---

## 🎓 Próximos Pasos

1. **Leer** `README.md` del framework
2. **Elegir** arquitectura (monolitico vs microservicios)
3. **Inicializar** proyecto con script
4. **Personalizar** `.agent/context.md`
5. **Crear** primera HU
6. **Empezar** a trabajar con `/sdd-new`

---

**¿Preguntas?** Ver `README.md` para documentación completa.

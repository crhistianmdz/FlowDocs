#!/bin/bash

# SDD Microservices Project Initialization Script
# Usage: ./init-microservices.sh <project-name> <service1> <service2> ...

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if project name is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Project name required${NC}"
    echo "Usage: $0 <project-name> [service1] [service2] ..."
    exit 1
fi

PROJECT_NAME=$1
shift
SERVICES=("$@")

FRAMEWORK_PATH="$HOME/Documentos/propuestaFrameworkTrabajo"
TARGET_PATH="./$PROJECT_NAME"

echo -e "${GREEN}🚀 Initializing SDD Microservices Project: $PROJECT_NAME${NC}"
echo -e "${BLUE}Services: ${SERVICES[@]:-frontend}${NC}"
echo ""

# Create directory structure
echo -e "${YELLOW}📁 Creating directory structure...${NC}"
mkdir -p "$TARGET_PATH/.agent"
mkdir -p "$TARGET_PATH/docs/SHARED/{PRODUCTO,TECNICO,tasks}"
mkdir -p "$TARGET_PATH/openspec/changes"

# If no services provided, create default structure
if [ ${#SERVICES[@]} -eq 0 ]; then
    SERVICES=("frontend")
fi

# Create structure for each service
for SERVICE in "${SERVICES[@]}"; do
    echo -e "${YELLOW}📦 Creating module: $SERVICE${NC}"
    mkdir -p "$TARGET_PATH/docs/$SERVICE/{API,DB,tasks}"
    mkdir -p "$TARGET_PATH/src/$SERVICE"
    
    # Copy module templates
    cp "$FRAMEWORK_PATH/microservicios/templates/modulo-README.md" "$TARGET_PATH/docs/$SERVICE/README.md"
    cp "$FRAMEWORK_PATH/microservicios/templates/HU-TEMPLATE.md" "$TARGET_PATH/docs/$SERVICE/tasks/TEMPLATE.md"
    
    # Update README with service name
    sed -i "s/<SERVICE_NAME>/$SERVICE/g" "$TARGET_PATH/docs/$SERVICE/README.md"
    
    # Create first HU placeholder
    echo "# HU-001: [First User Story for $SERVICE]" > "$TARGET_PATH/docs/$SERVICE/tasks/HU-001-first-feature.md"
    echo "" >> "$TARGET_PATH/docs/$SERVICE/tasks/HU-001-first-feature.md"
    echo "See TEMPLATE.md for structure." >> "$TARGET_PATH/docs/$SERVICE/tasks/HU-001-first-feature.md"
done

# Copy shared templates
echo -e "${YELLOW}📄 Copying shared templates...${NC}"
cp "$FRAMEWORK_PATH/microservicios/.agent-context.md" "$TARGET_PATH/.agent/context.md"
cp "$FRAMEWORK_PATH/shared/PRD-template.md" "$TARGET_PATH/docs/SHARED/PRD.md"
cp "$FRAMEWORK_PATH/shared/RFC-template.md" "$TARGET_PATH/docs/SHARED/RFC.md"
cp "$FRAMEWORK_PATH/microservicios/templates/contratos.md" "$TARGET_PATH/docs/SHARED/contratos.md"

# Create additional shared files
touch "$TARGET_PATH/docs/SHARED/arquitectura.md"
echo "# System Architecture" > "$TARGET_PATH/docs/SHARED/arquitectura.md"
echo "" >> "$TARGET_PATH/docs/SHARED/arquitectura.md"
echo "## Overview" >> "$TARGET_PATH/docs/SHARED/arquitectura.md"
echo "" >> "$TARGET_PATH/docs/SHARED/arquitectura.md"
echo "Add system architecture diagram here." >> "$TARGET_PATH/docs/SHARED/arquitectura.md"

touch "$TARGET_PATH/docs/SHARED/convenciones.md"
echo "# Coding Conventions" > "$TARGET_PATH/docs/SHARED/convenciones.md"
echo "" >> "$TARGET_PATH/docs/SHARED/convenciones.md"
echo "Shared coding conventions for all modules." >> "$TARGET_PATH/docs/SHARED/convenciones.md"

touch "$TARGET_PATH/docs/SHARED/deployments.md"
echo "# Deployment Guide" > "$TARGET_PATH/docs/SHARED/deployments.md"
echo "" >> "$TARGET_PATH/docs/SHARED/deployments.md"
echo "## Environments" >> "$TARGET_PATH/docs/SHARED/deployments.md"
echo "" >> "$TARGET_PATH/docs/SHARED/deployments.md"
echo "| Environment | URL | Branch |" >> "$TARGET_PATH/docs/SHARED/deployments.md"
echo "|-------------|-----|--------|" >> "$TARGET_PATH/docs/SHARED/deployments.md"
echo "| Development | localhost | any |" >> "$TARGET_PATH/docs/SHARED/deployments.md"
echo "| Staging | TBD | develop |" >> "$TARGET_PATH/docs/SHARED/deployments.md"
echo "| Production | TBD | main |" >> "$TARGET_PATH/docs/SHARED/deployments.md"

# Update context.md with project name and services
sed -i "s/<PROJECT_NAME>/$PROJECT_NAME/g" "$TARGET_PATH/.agent/context.md"

# Update services table in context.md
SERVICES_TABLE=""
for SERVICE in "${SERVICES[@]}"; do
    SERVICES_TABLE+="| **$SERVICE** | src/$SERVICE/ | @person | N/A | ⏳ Pending |\n"
done
sed -i "s/| \*\*auth-service\*\*.*/$SERVICES_TABLE/" "$TARGET_PATH/.agent/context.md"

# Create docker-compose.yml
echo -e "${YELLOW}🐳 Creating docker-compose.yml...${NC}"
cat > "$TARGET_PATH/docker-compose.yml" << EOF
version: '3.8'

services:
EOF

for SERVICE in "${SERVICES[@]}"; do
    cat >> "$TARGET_PATH/docker-compose.yml" << EOF
  $SERVICE:
    build: ./src/$SERVICE
    ports:
      - "${RANDOM_PORT:-3000}:3000"
    environment:
      - NODE_ENV=development
    volumes:
      - ./src/$SERVICE:/app
    networks:
      - app-network

EOF
done

cat >> "$TARGET_PATH/docker-compose.yml" << EOF
networks:
  app-network:
    driver: bridge
EOF

# Create root README
cat > "$TARGET_PATH/README.md" << EOF
# $PROJECT_NAME

**Architecture**: Microservices  
**Created**: $(date +%Y-%m-%d)  
**Services**: ${SERVICES[*]}

## Quick Start

1. Initialize SDD:
   \`\`\`bash
   /sdd-init
   \`\`\`

2. Work on a HU (specific module):
   \`\`\`bash
   /sdd-new HU-001-feature --from-docs --module=<service-name>
   \`\`\`

3. Run all services:
   \`\`\`bash
   docker-compose up
   \`\`\`

## Documentation

- **PRD**: docs/SHARED/PRD.md
- **RFC**: docs/SHARED/RFC.md
- **Architecture**: docs/SHARED/arquitectura.md
- **Contracts**: docs/SHARED/contratos.md
- **Deployments**: docs/SHARED/deployments.md

### Per-Service Documentation
EOF

for SERVICE in "${SERVICES[@]}"; do
    echo "- **$SERVICE**: docs/$SERVICE/README.md" >> "$TARGET_PATH/README.md"
done

cat >> "$TARGET_PATH/README.md" << EOF

## Team Workflow

\`\`\`bash
# Daily workflow
git pull origin main
/sdd-init
/sdd-new HU-XXX-name --from-docs --module=<service-name>
git add . && git commit -m "feat(<service>): HU-XXX" && git push
\`\`\`

## Structure

\`\`\`
$PROJECT_NAME/
├── .agent/              # SDD context
├── docs/
│   ├── SHARED/         # Shared documentation (all modules)
│   │   ├── PRD.md
│   │   ├── RFC.md
│   │   ├── arquitectura.md
│   │   ├── contratos.md
│   │   └── deployments.md
│   └── <service>/      # Per-service documentation
│       ├── README.md
│       ├── API/
│       ├── DB/
│       └── tasks/
├── openspec/changes/   # SDD artifacts
├── src/
│   └── <service>/      # Service source code
└── docker-compose.yml
\`\`\`

## Services

| Service | Port | Owner | Status |
|---------|------|-------|--------|
EOF

for SERVICE in "${SERVICES[@]}"; do
    echo "| $SERVICE | TBD | @person | ⏳ Pending |" >> "$TARGET_PATH/README.md"
done

echo "" >> "$TARGET_PATH/README.md"
echo "---" >> "$TARGET_PATH/README.md"
echo "**Last Updated**: $(date +%Y-%m-%d)" >> "$TARGET_PATH/README.md"

# Create .gitignore (if doesn't exist)
if [ ! -f "$TARGET_PATH/.gitignore" ]; then
    cat > "$TARGET_PATH/.gitignore" << EOF
# Dependencies
node_modules/
vendor/
__pycache__/
*.pyc
go.mod
go.sum

# Build outputs
dist/
build/
*.egg-info/
target/

# Environment
.env
.env.local
.env.*.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*

# Testing
coverage/
.coverage

# SDD (keep openspec, ignore personal Engram cache if any)
.engram/

# Docker
*.log
EOF
fi

echo ""
echo -e "${GREEN}✅ Project initialized successfully!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. cd $PROJECT_NAME"
echo "2. Edit .agent/context.md with your project details"
echo "3. Edit docs/SHARED/PRD.md with product requirements"
echo "4. Edit docs/<service>/tasks/HU-001-first-feature.md with your first HU"
echo "5. Run: /sdd-init"
echo "6. Run: /sdd-new HU-001-first-feature --from-docs --module=<service-name>"
echo ""
echo -e "${GREEN}Happy coding! 🎉${NC}"

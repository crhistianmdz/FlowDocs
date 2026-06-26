#!/bin/bash

# SDD Monolith Project Initialization Script
# Usage: ./init-monolith.sh <project-name>

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if project name is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Project name required${NC}"
    echo "Usage: $0 <project-name>"
    exit 1
fi

PROJECT_NAME=$1
FRAMEWORK_PATH="$HOME/Documentos/propuestaFrameworkTrabajo"
TARGET_PATH="./$PROJECT_NAME"

echo -e "${GREEN}🚀 Initializing SDD Monolith Project: $PROJECT_NAME${NC}"

# Create directory structure
echo -e "${YELLOW}📁 Creating directory structure...${NC}"
mkdir -p "$TARGET_PATH/.agent"
mkdir -p "$TARGET_PATH/docs/{PRODUCTO,TECNICO,API,DB,tasks}"
mkdir -p "$TARGET_PATH/openspec/changes"
mkdir -p "$TARGET_PATH/src/{components,pages,services,hooks,contexts,utils}"

# Copy templates
echo -e "${YELLOW}📄 Copying templates...${NC}"
cp "$FRAMEWORK_PATH/monolitico/.agent-context.md" "$TARGET_PATH/.agent/context.md"
cp "$FRAMEWORK_PATH/monolitico/templates/HU-TEMPLATE.md" "$TARGET_PATH/docs/tasks/TEMPLATE.md"
cp "$FRAMEWORK_PATH/monolitico/templates/API-endpoints.md" "$TARGET_PATH/docs/API/endpoints.md"
cp "$FRAMEWORK_PATH/monolitico/templates/DB-schema.md" "$TARGET_PATH/docs/DB/schema.md"

# Copy shared templates
cp "$FRAMEWORK_PATH/shared/PRD-template.md" "$TARGET_PATH/docs/PRODUCTO/PRD.md"
cp "$FRAMEWORK_PATH/shared/RFC-template.md" "$TARGET_PATH/docs/TECNICO/RFC.md"

# Create migrations file
touch "$TARGET_PATH/docs/DB/migrations.md"
echo "# Database Migrations" > "$TARGET_PATH/docs/DB/migrations.md"
echo "" >> "$TARGET_PATH/docs/DB/migrations.md"
echo "## Migration History" >> "$TARGET_PATH/docs/DB/migrations.md"
echo "" >> "$TARGET_PATH/docs/DB/migrations.md"
echo "### 001_initial_schema.sql" >> "$TARGET_PATH/docs/DB/migrations.md"
echo "- **Date**: $(date +%Y-%m-%d)" >> "$TARGET_PATH/docs/DB/migrations.md"
echo "- **Description**: Initial database schema" >> "$TARGET_PATH/docs/DB/migrations.md"
echo "- **Status**: Pending" >> "$TARGET_PATH/docs/DB/migrations.md"

# Create first HU placeholder
echo "# HU-001: [First User Story]" > "$TARGET_PATH/docs/tasks/HU-001-first-feature.md"
echo "" >> "$TARGET_PATH/docs/tasks/HU-001-first-feature.md"
echo "See TEMPLATE.md for structure." >> "$TARGET_PATH/docs/tasks/HU-001-first-feature.md"

# Update context.md with project name
sed -i "s/<PROJECT_NAME>/$PROJECT_NAME/g" "$TARGET_PATH/.agent/context.md"

# Create README
cat > "$TARGET_PATH/README.md" << EOF
# $PROJECT_NAME

**Type**: Monolith (Frontend/Backend/Fullstack)  
**Created**: $(date +%Y-%m-%d)  

## Quick Start

1. Initialize SDD:
   \`\`\`bash
   /sdd-init
   \`\`\`

2. Work on a HU:
   \`\`\`bash
   /sdd-new HU-001-first-feature --from-docs
   \`\`\`

## Documentation

- **PRD**: docs/PRODUCTO/PRD.md
- **RFC**: docs/TECNICO/RFC.md
- **API**: docs/API/endpoints.md
- **DB**: docs/DB/schema.md
- **Tasks**: docs/tasks/

## Team Workflow

\`\`\`bash
# Daily workflow
git pull origin main
/sdd-init
/sdd-new HU-XXX-name --from-docs
git add . && git commit -m "feat: HU-XXX" && git push
\`\`\`

## Structure

\`\`\`
$PROJECT_NAME/
├── .agent/              # SDD context
├── docs/                # Documentation
│   ├── PRODUCTO/       # PRD, roadmap
│   ├── TECNICO/        # RFC, architecture
│   ├── API/            # Endpoints, contracts
│   ├── DB/             # Schema, migrations
│   └── tasks/          # User stories
├── openspec/changes/   # SDD artifacts
└── src/                # Source code
\`\`\`
EOF

# Create .gitignore (if doesn't exist)
if [ ! -f "$TARGET_PATH/.gitignore" ]; then
    cat > "$TARGET_PATH/.gitignore" << EOF
# Dependencies
node_modules/
vendor/

# Build outputs
dist/
build/
*.egg-info/

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

# SDD (keep openspec, ignore personal Engram cache if any)
.engram/
EOF
fi

echo -e "${GREEN}✅ Project initialized successfully!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. cd $PROJECT_NAME"
echo "2. Edit .agent/context.md with your project details"
echo "3. Edit docs/tasks/HU-001-first-feature.md with your first HU"
echo "4. Run: /sdd-init"
echo "5. Run: /sdd-new HU-001-first-feature --from-docs"
echo ""
echo -e "${GREEN}Happy coding! 🎉${NC}"

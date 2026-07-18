#!/bin/bash

# SDD Monorepo Project Initialization Script
# Usage: ./init-monorepo.sh <project-name>

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Resolve script location so it works from anywhere (relative paths)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REFERENCE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Check if project name is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Project name required${NC}"
    echo "Usage: $0 <project-name>"
    exit 1
fi

PROJECT_NAME=$1
TARGET_PATH="./$PROJECT_NAME"

echo -e "${GREEN}🚀 Initializing SDD Monorepo Project: $PROJECT_NAME${NC}"

# Create directory structure
echo -e "${YELLOW}📁 Creating directory structure...${NC}"
mkdir -p "$TARGET_PATH/.agent"
mkdir -p "$TARGET_PATH/packages/shared/{ui,utils,types}"
mkdir -p "$TARGET_PATH/packages/web/src"
mkdir -p "$TARGET_PATH/packages/web/docs/tasks"
mkdir -p "$TARGET_PATH/packages/mobile/lib"
mkdir -p "$TARGET_PATH/packages/mobile/docs/tasks"
mkdir -p "$TARGET_PATH/packages/api/src"
mkdir -p "$TARGET_PATH/packages/api/docs/API"
mkdir -p "$TARGET_PATH/packages/api/docs/DB"
mkdir -p "$TARGET_PATH/packages/api/docs/tasks"
mkdir -p "$TARGET_PATH/tools"
mkdir -p "$TARGET_PATH/docs/shared/tasks"
mkdir -p "$TARGET_PATH/openspec/changes"
mkdir -p "$TARGET_PATH/scripts"

# Copy templates (if reference copies exist)
echo -e "${YELLOW}📄 Copying templates...${NC}"
if [ -f "$REFERENCE_DIR/.agent-context.md" ]; then
    cp "$REFERENCE_DIR/.agent-context.md" "$TARGET_PATH/.agent/context.md"
    sed -i "s/<PROJECT_NAME>/$PROJECT_NAME/g" "$TARGET_PATH/.agent/context.md"
fi

# Create placeholder HU template files in each package
for pkg in web mobile api; do
    cat > "$TARGET_PATH/packages/$pkg/docs/tasks/TEMPLATE.md" << EOF
# HU-XXX: [User Story Title]

See docs/tasks/TEMPLATE.md (root) for full template structure.
EOF
done

# Create placeholder top-level docs
cat > "$TARGET_PATH/docs/PRD.md" << EOF
# PRD - $PROJECT_NAME

(Draft) Add product requirements here.
EOF

cat > "$TARGET_PATH/docs/RFC.md" << EOF
# RFC - $PROJECT_NAME

(Draft) Architectural decisions and proposals under discussion.
EOF

cat > "$TARGET_PATH/docs/arquitectura.md" << EOF
# Arquitectura - $PROJECT_NAME

(Draft) Diagrama general del sistema con dependencias entre paquetes.
EOF

# Create README
cat > "$TARGET_PATH/README.md" << EOF
# $PROJECT_NAME

**Type**: Monorepo (web + mobile + api + shared)
**Created**: $(date +%Y-%m-%d)

## Quick Start

1. Initialize SDD:
   \`\`\`bash
   /sdd-init
   \`\`\`

2. Work on a HU (per package):
   \`\`\`bash
   /sdd-new web/HU-001-name --from-docs
   \`\`\`

## Documentation

- **PRD**: docs/PRD.md
- **RFC**: docs/RFC.md
- **Arquitectura**: docs/arquitectura.md
- **Per package**: packages/{web,mobile,api}/docs/

## Structure

\`\`\`
$PROJECT_NAME/
├── .agent/
├── packages/
│   ├── shared/    # UI, utils, types
│   ├── web/       # Web app
│   ├── mobile/    # Mobile app
│   └── api/       # API
├── docs/          # Cross-cutting docs
├── openspec/      # SDD artifacts
└── scripts/
\`\`\`
EOF

# Create .gitignore
if [ ! -f "$TARGET_PATH/.gitignore" ]; then
    cat > "$TARGET_PATH/.gitignore" << EOF
# Dependencies
node_modules/

# Build outputs
dist/
build/
.next/
.expo/

# Environment
.env
.env.local

# IDE
.vscode/
.idea/
*.swp

# OS
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*

# Testing
coverage/

# SDD
.engram/
EOF
fi

# Create root package.json (npm workspaces)
cat > "$TARGET_PATH/package.json" << EOF
{
  "name": "$PROJECT_NAME",
  "private": true,
  "workspaces": [
    "packages/*",
    "packages/shared/*"
  ],
  "scripts": {
    "dev:web": "npm -w packages/web run dev",
    "dev:api": "npm -w packages/api run dev"
  }
}
EOF

echo -e "${GREEN}✅ Project initialized successfully!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. cd $PROJECT_NAME"
echo "2. Edit .agent/context.md with your project details"
echo "3. Add HUs in packages/{web,mobile,api}/docs/tasks/"
echo "4. Run: /sdd-init"
echo "5. Run: /sdd-new web/HU-001-name --from-docs"
echo ""
echo -e "${GREEN}Happy coding! 🎉${NC}"
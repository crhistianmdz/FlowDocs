#!/bin/bash

# SDD Serverless Project Initialization Script
# Usage: ./init-serverless.sh <project-name> [function1 function2 ...]

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
    echo "Usage: $0 <project-name> [function1 function2 ...]"
    exit 1
fi

PROJECT_NAME=$1
shift
FUNCTIONS=("$@")

# Default functions if none provided
if [ ${#FUNCTIONS[@]} -eq 0 ]; then
    FUNCTIONS=("upload" "resize" "thumbnail")
fi

TARGET_PATH="./$PROJECT_NAME"

echo -e "${GREEN}🚀 Initializing SDD Serverless Project: $PROJECT_NAME${NC}"

# Create directory structure
echo -e "${YELLOW}📁 Creating directory structure...${NC}"
mkdir -p "$TARGET_PATH/.agent"
mkdir -p "$TARGET_PATH/infrastructure/terraform"
mkdir -p "$TARGET_PATH/infrastructure/docker/local-dev"
mkdir -p "$TARGET_PATH/shared/types"
mkdir -p "$TARGET_PATH/shared/utils"
mkdir -p "$TARGET_PATH/docs/functions"
mkdir -p "$TARGET_PATH/openspec/changes"
mkdir -p "$TARGET_PATH/scripts"

# Create per-function structure
for fn in "${FUNCTIONS[@]}"; do
    mkdir -p "$TARGET_PATH/functions/$fn/docs"

    cat > "$TARGET_PATH/functions/$fn/index.ts" << EOF
// $fn - Serverless function handler
export const handler = async (event: unknown): Promise<void> => {
  // TODO: implement $fn handler
  console.log('$fn received event:', JSON.stringify(event, null, 2));
};
EOF

    cat > "$TARGET_PATH/functions/$fn/package.json" << EOF
{
  "name": "@$PROJECT_NAME/$fn",
  "version": "1.0.0",
  "private": true,
  "main": "index.ts"
}
EOF

    cat > "$TARGET_PATH/functions/$fn/docs/README.md" << EOF
# $fn

**Trigger**: TBD
**Runtime**: Node.js (TBD version)
**Timeout**: TBD
**Memory**: TBD

## Purpose

TODO: describe what $fn does.

## Environment Variables

| Var | Description |
|-----|-------------|
| TBD | TBD |

## Dependencies

- TBD
EOF
done

# Copy reference context
echo -e "${YELLOW}📄 Copying templates...${NC}"
if [ -f "$REFERENCE_DIR/.agent-context.md" ]; then
    cp "$REFERENCE_DIR/.agent-context.md" "$TARGET_PATH/.agent/context.md"
    sed -i "s/<PROJECT_NAME>/$PROJECT_NAME/g" "$TARGET_PATH/.agent/context.md"
fi

# Create top-level docs
cat > "$TARGET_PATH/docs/PRD.md" << EOF
# PRD - $PROJECT_NAME

(Draft) Add product requirements here.
EOF

cat > "$TARGET_PATH/docs/RFC.md" << EOF
# RFC - $PROJECT_NAME

(Draft) Architectural decisions (e.g. Lambda vs Fargate, provider choice).
EOF

cat > "$TARGET_PATH/docs/arquitectura.md" << EOF
# Arquitectura - $PROJECT_NAME

(Draft) Diagrama event-driven: triggers, colas, dependencias entre funciones.
EOF

cat > "$TARGET_PATH/docs/functions/overview.md" << EOF
# Functions Overview

| Function | Trigger | Runtime | Purpose |
|----------|---------|---------|---------|
EOF
for fn in "${FUNCTIONS[@]}"; do
    echo "| $fn | TBD | Node.js | TODO |" >> "$TARGET_PATH/docs/functions/overview.md"
done

cat > "$TARGET_PATH/docs/functions/events-flow.md" << EOF
# Events Flow

(Draft) Describe how events chain across functions.

\`\`\`
[TBD trigger] -> [function] -> [TBD queue/topic] -> [function] -> ...
\`\`\`
EOF

# Create placeholder Terraform files
cat > "$TARGET_PATH/infrastructure/terraform/main.tf" << EOF
# Main Terraform configuration for $PROJECT_NAME
# TODO: define resources (S3 buckets, SQS, Lambda permissions, etc.)
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
EOF

cat > "$TARGET_PATH/infrastructure/terraform/variables.tf" << EOF
# Input variables for $PROJECT_NAME
variable "aws_region" {
  type    = string
  default = "us-east-1"
}
EOF

cat > "$TARGET_PATH/infrastructure/terraform/outputs.tf" << EOF
# Outputs for $PROJECT_NAME
# output "bucket_arn" {
#   value = aws_s3_bucket.input.arn
# }
EOF

# Create serverless.yml placeholder
cat > "$TARGET_PATH/serverless.yml" << EOF
# Serverless Framework config for $PROJECT_NAME
service: $PROJECT_NAME

frameworkVersion: "3"

provider:
  name: aws
  runtime: nodejs20.x
  region: \${env:AWS_REGION, "us-east-1"}

functions:
EOF
for fn in "${FUNCTIONS[@]}"; do
    cat >> "$TARGET_PATH/serverless.yml" << EOF
  $fn:
    handler: functions/$fn/index.handler
EOF
done

# Create README
cat > "$TARGET_PATH/README.md" << EOF
# $PROJECT_NAME

**Type**: Serverless (event-driven)
**Created**: $(date +%Y-%m-%d)

## Quick Start

1. Initialize SDD:
   \`\`\`bash
   /sdd-init
   \`\`\`

2. Work on a HU per function:
   \`\`\`bash
   /sdd-new upload/HU-001-name --from-docs
   \`\`\`

## Functions

EOF
for fn in "${FUNCTIONS[@]}"; do
    echo "- **$fn** — See \`functions/$fn/docs/README.md\`" >> "$TARGET_PATH/README.md"
done

cat >> "$TARGET_PATH/README.md" << EOF

## Structure

\`\`\`
$PROJECT_NAME/
├── functions/        # Each function is autocontenida
├── infrastructure/   # Terraform (IaC)
├── shared/           # Types & utils comunes
├── docs/             # Cross-cutting docs
├── openspec/         # SDD artifacts
└── serverless.yml
\`\`\`
EOF

# Create .gitignore
if [ ! -f "$TARGET_PATH/.gitignore" ]; then
    cat > "$TARGET_PATH/.gitignore" << EOF
# Dependencies
node_modules/

# Build outputs
dist/
.webpack/

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

# Terraform
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl

# SDD
.engram/
EOF
fi

echo -e "${GREEN}✅ Project initialized successfully!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. cd $PROJECT_NAME"
echo "2. Edit .agent/context.md with project details (triggers, runtime, provider)"
echo "3. Fill in functions/*/docs/README.md for each function"
echo "4. Run: /sdd-init"
echo "5. Run: /sdd-new <function>/HU-001-name --from-docs"
echo ""
echo -e "${GREEN}Happy coding! 🎉${NC}"
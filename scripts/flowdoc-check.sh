#!/bin/bash
# ============================================================================
# FlowDoc Check Script
# Quick post-migration smoke test — verifies required directories and files
# exist. Returns exit 0 on success, exit 1 on failure.
#
# Usage:
#   bash flowdoc-check.sh
#
# Requirements: Bash 4+, runs on macOS and Linux.
# ============================================================================

set -euo pipefail

# ------------------------------------------------------------------
# Colors
# ------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'

# ------------------------------------------------------------------
# Required directories (14)
# Satisfies R3.1
# ------------------------------------------------------------------
REQUIRED_DIRS=(
  "docs"
  "docs/templates/user-stories"
  "docs/templates/bug-fixes"
  "docs/templates/refactors"
  "docs/templates/architecture"
  "docs/templates/database"
  "docs/templates/api"
  "docs/templates/PRD"
  "docs/architecture/adr"
  "docs/architecture/rfc"
  "docs/tasks/HU-001-HU-099"
  "docs/api"
  "docs/database"
  "scripts"
)

# ------------------------------------------------------------------
# Required files (5) — minimal subset for smoke test
# Satisfies R3.2, R3.3
# ------------------------------------------------------------------
REQUIRED_FILES=(
  "AGENTS.md"
  "docs/flowdoc-ciclo.md"
  "docs/adoption-guide.md"
  "docs/FAQ.md"
  "scripts/flowdoc-migration.sh"
)

# ------------------------------------------------------------------
# State
# ------------------------------------------------------------------
FAILURES=()
PASSES=()

# ------------------------------------------------------------------
# Check directories
# ------------------------------------------------------------------
check_dirs() {
  echo ""
  echo -e "${BOLD}Checking directories...${NC}"

  for d in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$d" ]; then
      echo -e "  ${GREEN}✅${NC} $d/"
      PASSES+=("dir:$d")
    else
      echo -e "  ${RED}❌${NC} $d/ — MISSING"
      FAILURES+=("dir:$d")
    fi
  done
}

# ------------------------------------------------------------------
# Check files
# ------------------------------------------------------------------
check_files() {
  echo ""
  echo -e "${BOLD}Checking files...${NC}"

  for f in "${REQUIRED_FILES[@]}"; do
    if [ -f "$f" ]; then
      echo -e "  ${GREEN}✅${NC} $f"
      PASSES+=("file:$f")
    else
      echo -e "  ${RED}❌${NC} $f — MISSING"
      FAILURES+=("file:$f")
    fi
  done
}

# ------------------------------------------------------------------
# Print result
# Satisfies R3.4, R3.5
# ------------------------------------------------------------------
print_result() {
  echo ""
  echo -e "${BOLD}========================================${NC}"
  echo -e "${BOLD}=== Result ===${NC}"
  echo -e "${BOLD}========================================${NC}"
  echo ""

  local passed=${#PASSES[@]}
  local failed=${#FAILURES[@]}
  local total=$((passed + failed))

  echo "  Checked: $total items"
  echo -e "  ${GREEN}Passed: $passed${NC}"
  echo -e "  ${RED}Failed: $failed${NC}"

  if [ "$failed" -gt 0 ]; then
    echo ""
    echo -e "${RED}❌ Issues found: $failed missing${NC}"
    for f in "${FAILURES[@]}"; do
      echo "     - $f"
    done
    echo ""
    exit 1
  else
    echo ""
    echo -e "${GREEN}✅ Framework ready${NC}"
    echo ""
    exit 0
  fi
}

# ==================================================================
# Main
# ==================================================================
main() {
  echo ""
  echo -e "${BOLD}=== FlowDoc Check ===${NC}"

  check_dirs
  check_files
  print_result
}

# Entry point
main

#!/bin/bash
# ============================================================================
# FlowDoc Migration Script — DEPRECATED
#
# ⚠️  DEPRECATION NOTICE:
# This script is deprecated.
# Use 'scripts/init-flowdoc.sh --legacy' instead.
#
# This wrapper exists for backwards compatibility with existing documentation.
# ============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${YELLOW}⚠️  DEPRECATION WARNING${NC}"
echo -e "${BOLD}=====================${NC}"
echo ""
echo -e "This script (${0}) is ${RED}deprecated${NC}."
echo ""
echo -e "Use instead:"
echo -e "  ${BOLD}bash scripts/init-flowdoc.sh --legacy${NC}"
echo ""
echo -e "This wrapper will now delegate to init-flowdoc.sh --legacy..."
echo ""

# Get the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Delegate to init-flowdoc.sh --legacy with all arguments
exec bash "${SCRIPT_DIR}/init-flowdoc.sh" --legacy "$@"

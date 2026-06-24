#!/bin/bash
# ============================================================================
# FlowDoc Audit Script
# Verifies FlowDoc structure integrity: missing files, orphans, broken links,
# naming consistency, and EN/ES parity.
#
# Usage:
#   bash flowdoc-audit.sh
#
# Requirements: Bash 4+, runs on macOS and Linux.
# ============================================================================

set -euo pipefail

# ------------------------------------------------------------------
# Colors
# ------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

# ------------------------------------------------------------------
# Global counters
# ------------------------------------------------------------------
PASS_COUNT=0
FAIL_COUNT=0
TOTAL_CHECKS=0
ISSUES=()

# ------------------------------------------------------------------
# PROMISED_FILES: Every file the migration script creates (41 files)
# Must stay in sync with scripts/flowdoc-migration.sh.
# Satisfies R2.1.
# ------------------------------------------------------------------
PROMISED_FILES=(
  # Templates (12)
  "docs/templates/user-stories/template-user-story-sdd.md"
  "docs/templates/user-stories/template-user-story.md"
  "docs/templates/bug-fixes/template-bug-fix-sdd.md"
  "docs/templates/bug-fixes/template-bug-fix.md"
  "docs/templates/refactors/template-refactor.md"
  "docs/templates/architecture/RFC_template.md"
  "docs/templates/architecture/ADR_template.md"
  "docs/templates/database/schema.md"
  "docs/templates/api/endpoints.md"
  "docs/templates/PRD/PRD.md"
  "docs/templates/PRD/PRD_template.md"
  "docs/templates/TEMPLATE_GUIDE.md"

  # Base docs (11)
  "docs/flowdoc-ciclo.md"
  "docs/adoption-guide.md"
  "docs/FAQ.md"
  "docs/anti-patrones.md"
  "docs/troubleshooting.md"
  "docs/legacy-migration.md"
  "docs/architecture-diagram.md"
  "docs/walkthrough-hu-login.md"
  "docs/tech-debt.md"
  "docs/PRD.md"
  "docs/is-it-for-me.md"

  # ADR stubs (8)
  "docs/architecture/adr/001-persistencia-engram.md"
  "docs/architecture/adr/002-docs-source-of-truth.md"
  "docs/architecture/adr/003-ciclo-15-dias.md"
  "docs/architecture/adr/004-feature-flags.md"
  "docs/architecture/adr/005-organizacion-hu.md"
  "docs/architecture/adr/006-cuatro-arquitecturas.md"
  "docs/architecture/adr/007-estructura-templates.md"
  "docs/architecture/adr/008-nombre-flowdoc.md"

  # RFC stubs (4)
  "docs/architecture/rfc/001-estructura-docs.md"
  "docs/architecture/rfc/002-ciclo-15-dias.md"
  "docs/architecture/rfc/003-feature-flags.md"
  "docs/architecture/rfc/004-propuesta-unificada-equipo-deprecada.md"

  # HU examples (2)
  "docs/tasks/HU-001-HU-099/HU-001-onboarding-docs.md"
  "docs/tasks/HU-001-HU-099/HU-002-validacion-hus.md"

  # Root files (4)
  "AGENTS.md"
  "ONBOARDING.md"
  "QUICKSTART.md"
  "CHANGELOG.md"
)

# Directories the migration script creates (for context, not directly audited as files)
PROMISED_DIRS=(
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
  "docs/observaciones"
  "scripts"
)

# ==================================================================
# Utility: record a PASS or FAIL
# ==================================================================
record_pass() {
  local msg="$1"
  echo -e "  ${GREEN}✅ PASS${NC} — $msg"
  ((PASS_COUNT++)) || true
}

record_fail() {
  local msg="$1"
  echo -e "  ${RED}❌ FAIL${NC} — $msg"
  ISSUES+=("$msg")
  ((FAIL_COUNT++)) || true
}

check_start() {
  local category="$1"
  echo ""
  echo -e "${BOLD}── ${category} ──${NC}"
}

# ==================================================================
# Check 1: Missing files (R2.1)
# ==================================================================
check_missing() {
  check_start "Check: Missing Files"
  ((TOTAL_CHECKS++)) || true

  local category_ok=true
  for f in "${PROMISED_FILES[@]}"; do
    if [ -f "$f" ]; then
      record_pass "$f"
    else
      record_fail "Missing: $f"
      category_ok=false
    fi
  done

  if $category_ok; then
    echo -e "  ${GREEN}✓ All ${#PROMISED_FILES[@]} promised files present${NC}"
  fi
}

# ==================================================================
# Check 2: Orphaned files (R2.2)
# ==================================================================
check_orphaned() {
  check_start "Check: Orphaned Files"
  ((TOTAL_CHECKS++)) || true

  # Build an associative lookup of promised files for fast checking
  declare -A KNOWN
  for f in "${PROMISED_FILES[@]}"; do
    KNOWN["$f"]=1
  done

  local orphans_found=0

  # Walk docs/ only (skip scripts/ — tools, not documentation structure)
  if [ -d "docs" ]; then
    while IFS= read -r -d '' file; do
      [ -f "$file" ] || continue
      if [ -z "${KNOWN[$file]:-}" ]; then
        record_fail "Orphaned: $file (not in promised list)"
        ((orphans_found++)) || true
      fi
    done < <(find docs -type f -print0 2>/dev/null)
  fi

  # Also check root-level markdown files we didn't promise
  for rf in AGENTS.md ONBOARDING.md QUICKSTART.md CHANGELOG.md; do
    # Already in PROMISED_FILES
    :
  done

  if [ "$orphans_found" -eq 0 ]; then
    echo -e "  ${GREEN}✓ No orphaned files detected${NC}"
  fi
}

# ==================================================================
# Check 3: Broken links (R2.3)
# Uses portable sed-based markdown link extraction (no grep -P).
# ==================================================================
check_links() {
  check_start "Check: Broken Internal Links"
  ((TOTAL_CHECKS++)) || true

  local broken=0
  local total_links=0

  # Walk all markdown files in docs/ and root
  while IFS= read -r -d '' md_file; do
    # Extract markdown links: [text](path)
    # Portable sed: capture everything inside parentheses after a ](
    while IFS= read -r link_target; do
      [ -z "$link_target" ] && continue
      ((total_links++)) || true

      # Skip external URLs (http://, https://, mailto:)
      if [[ "$link_target" =~ ^https?:// ]] || [[ "$link_target" =~ ^mailto: ]] || [[ "$link_target" =~ ^# ]]; then
        continue
      fi

      # Resolve relative path from the markdown file's directory
      local md_dir
      md_dir="$(dirname "$md_file")"
      local resolved
      if [[ "$link_target" == /* ]]; then
        resolved="${link_target#/}"
      else
        resolved="$md_dir/$link_target"
      fi
      # Simple path resolution: remove ./ and normalize //
      resolved="$(echo "$resolved" | sed 's|/\./|/|g')"
      resolved="$(echo "$resolved" | sed 's|///*|/|g')"
      # Handle parent directory references: use realpath if available, else skip
      if [[ "$resolved" == *".."* ]]; then
        if command -v realpath > /dev/null 2>&1; then
          resolved="$(realpath -m --relative-to=. "$resolved" 2>/dev/null || echo "$resolved")"
        fi
      fi

      # Skip anchor-only links within same file
      if [[ "$link_target" == "#"* ]]; then
        continue
      fi

      # Check if the target file exists
      if [ ! -f "$resolved" ] && [ ! -d "$resolved" ]; then
        record_fail "Broken link in $md_file → $link_target (resolved: $resolved)"
        ((broken++)) || true
      fi
    done < <(sed -n 's/.*\[[^]]*\](\([^)]*\)).*/\1/p' "$md_file" 2>/dev/null)
  done < <(find docs -name "*.md" -type f -print0 2>/dev/null)

  # Also check root md files
  for rf in AGENTS.md ONBOARDING.md QUICKSTART.md CHANGELOG.md README.md; do
    [ -f "$rf" ] || continue
    while IFS= read -r link_target; do
      [ -z "$link_target" ] && continue
      ((total_links++)) || true
      if [[ "$link_target" =~ ^https?:// ]] || [[ "$link_target" =~ ^mailto: ]] || [[ "$link_target" =~ ^# ]]; then
        continue
      fi
      if [ ! -f "$link_target" ] && [ ! -d "$link_target" ]; then
        record_fail "Broken link in $rf → $link_target"
        ((broken++)) || true
      fi
    done < <(sed -n 's/.*\[[^]]*\](\([^)]*\)).*/\1/p' "$rf" 2>/dev/null)
  done

  if [ "$broken" -eq 0 ]; then
    echo -e "  ${GREEN}✓ All ${total_links} internal links resolve${NC}"
  fi
}

# ==================================================================
# Check 4: Naming consistency (R2.4)
# Detects mixed patterns: HU-001.md vs hu-001.md vs HU-001-HU-099/HU-001.md
# ==================================================================
check_naming() {
  check_start "Check: Naming Consistency"
  ((TOTAL_CHECKS++)) || true

  local issues=0

  # Check HU files in docs/tasks/ for consistent naming
  while IFS= read -r -d '' hu_file; do
    local basename
    basename="$(basename "$hu_file")"
    
    # Expected pattern: HU-NNN-description.md (uppercase HU)
    if [[ "$basename" =~ ^hu-[0-9]+ ]]; then
      record_fail "Lowercase HU prefix: $hu_file (should be uppercase HU-)"
      ((issues++)) || true
    fi
    
    # Check for files placed incorrectly (should be in HU- range dirs)
    local parent_dir
    parent_dir="$(dirname "$hu_file")"
    if [[ "$parent_dir" == "docs/tasks" ]] && [[ "$basename" =~ ^HU-[0-9]+ ]]; then
      record_fail "HU file outside range directory: $hu_file (should be in HU-XXX-HU-YYY/)"
      ((issues++)) || true
    fi
  done < <(find docs/tasks -name "HU-*" -type f -print0 2>/dev/null)

  # Check range directory naming
  while IFS= read -r -d '' range_dir; do
    local dirname
    dirname="$(basename "$range_dir")"
    if [[ ! "$dirname" =~ ^HU-[0-9]+-HU-[0-9]+$ ]]; then
      record_fail "Invalid range directory name: $range_dir (expected HU-NNN-HU-MMM)"
      ((issues++)) || true
    fi
  done < <(find docs/tasks -type d -name "HU-*" -print0 2>/dev/null)

  if [ "$issues" -eq 0 ]; then
    echo -e "  ${GREEN}✓ All naming conventions consistent${NC}"
  fi
}

# ==================================================================
# Check 5: EN/ES parity (R2.5)
# For every EN file in PROMISED_FILES, es/ mirror must exist.
# Also checks for orphaned ES files with no EN counterpart.
# ==================================================================
check_en_es_parity() {
  check_start "Check: EN/ES Parity"
  ((TOTAL_CHECKS++)) || true

  local issues=0

  # EN → ES: for each promised file, check es/ mirror
  for f in "${PROMISED_FILES[@]}"; do
    if [ -f "$f" ] && [ ! -f "es/$f" ]; then
      record_fail "Missing ES mirror: es/$f"
      ((issues++)) || true
    fi
  done

  # ES → EN (reverse): find orphaned ES files
  if [ -d "es" ]; then
    while IFS= read -r -d '' es_file; do
      local en_file="${es_file#es/}"
      if [ ! -f "$en_file" ]; then
        record_fail "Orphan in ES (no EN counterpart): $es_file"
        ((issues++)) || true
      fi
    done < <(find es/docs -type f -print0 2>/dev/null)
    while IFS= read -r -d '' es_file; do
      local en_file="${es_file#es/}"
      if [ -f "$en_file" ]; then
        :
      else
        # Check if it's a known root file
        case "$en_file" in
          AGENTS.md|ONBOARDING.md|QUICKSTART.md|CHANGELOG.md)
            record_fail "Orphan in ES (no EN counterpart): $es_file"
            ((issues++)) || true
            ;;
        esac
      fi
    done < <(find es -maxdepth 1 -name "*.md" -type f -print0 2>/dev/null)
  fi

  if [ "$issues" -eq 0 ]; then
    echo -e "  ${GREEN}✓ EN/ES parity is consistent${NC}"
  fi
}

# ==================================================================
# Print summary
# ==================================================================
print_summary() {
  echo ""
  echo -e "${BOLD}========================================${NC}"
  echo -e "${BOLD}=== Audit Summary ===${NC}"
  echo -e "${BOLD}========================================${NC}"
  echo ""

  local total=$((PASS_COUNT + FAIL_COUNT))
  echo -e "  Categories: ${TOTAL_CHECKS} total"
  echo -e "  Checks: ${GREEN}PASS: ${PASS_COUNT}${NC}  ${RED}FAIL: ${FAIL_COUNT}${NC}  Total: ${total}"

  if [ "${#ISSUES[@]}" -gt 0 ]; then
    echo ""
    echo -e "${RED}Issues found:${NC}"
    for issue in "${ISSUES[@]}"; do
      echo -e "  ${RED}❌${NC} $issue"
    done
  fi

  echo ""

  if [ "$FAIL_COUNT" -gt 0 ]; then
    echo -e "${RED}❌ Audit: ISSUES FOUND${NC}"
    exit 1
  else
    echo -e "${GREEN}✅ Audit: ALL CHECKS PASSED${NC}"
    exit 0
  fi
}

# ==================================================================
# Main
# ==================================================================
main() {
  echo ""
  echo -e "${BOLD}=== FlowDoc Audit ===${NC}"
  echo ""

  check_missing
  check_orphaned
  check_links
  check_naming
  check_en_es_parity

  print_summary
}

# Entry point
main

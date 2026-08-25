#!/bin/bash
# ============================================================================
# FlowDoc Skills Installer
# Instala las skills de FlowDoc en OpenCode
#
# Uso:
#   curl -fsSL https://raw.githubusercontent.com/crhistianmdz/FlowDocs/main/scripts/install-flowdoc-skills.sh | bash
#   curl -fsSL ... | bash -s -- --force
#   curl -fsSL ... | bash -s -- --update
#   curl -fsSL ... | bash -s -- --target /custom/path
# ============================================================================

set -euo pipefail

# ------------------------------------------------------------------
# Constantes
# ------------------------------------------------------------------
GITHUB_REPO="https://github.com/crhistianmdz/FlowDocs.git"
GITHUB_BRANCH="main"
SKILLS_SOURCE_DIR="skills"
SKILLS_PATTERN="flowdoc-"
INSTALLER_VERSION="1.0"

# ------------------------------------------------------------------
# Colores
# ------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ------------------------------------------------------------------
# Estado global
# ------------------------------------------------------------------
DRY_RUN=false
FORCE=false
UPDATE=false
VERBOSE=false
TARGET_DIR=""
BACKUP_DIR=""
SKILLS_INSTALLED=0
SKILLS_SKIPPED=0

# ------------------------------------------------------------------
# Uso
# ------------------------------------------------------------------
usage() {
  cat << EOF
${BOLD}FlowDoc Skills Installer v${INSTALLER_VERSION}${NC}

${BOLD}Uso:${NC}
  $0 [OPTIONS]

${BOLD}Opciones:${NC}
  --dry-run     Muestra qué haría sin ejecutar
  --force       Sobrescribe skills existentes sin preguntar
  --update      Actualiza skills ya instaladas
  --target DIR  Instala en directorio específico
  --verbose     Muestra más detalle
  --help        Muestra esta ayuda

${BOLD}Instalación:${NC}
  curl -fsSL https://raw.githubusercontent.com/crhistianmdz/FlowDocs/main/scripts/install-flowdoc-skills.sh | bash

${BOLD}Ejemplos:${NC}
  $0                      # Interactivo
  $0 --force              # Sin preguntar
  $0 --update             # Actualizar existentes
  $0 --target ~/.opencode # Dir personalizado

EOF
  exit 0
}

# ------------------------------------------------------------------
# Logging
# ------------------------------------------------------------------
log() { echo -e "${CYAN}[INFO]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }
verbose() { $VERBOSE && echo -e "       $*"; }

# ------------------------------------------------------------------
# Parsear argumentos
# ------------------------------------------------------------------
parse_args() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      --dry-run)
        DRY_RUN=true
        shift
        ;;
      --force)
        FORCE=true
        shift
        ;;
      --update)
        UPDATE=true
        shift
        ;;
      --target)
        TARGET_DIR="$2"
        shift 2
        ;;
      --verbose)
        VERBOSE=true
        shift
        ;;
      --help|-h)
        usage
        ;;
      *)
        error "Opción desconocida: $1"
        usage
        ;;
    esac
  done
}

# ------------------------------------------------------------------
# Detectar directorio de OpenCode
# ------------------------------------------------------------------
detect_opencode_dir() {
  local default_dir=""

  if [ -n "$TARGET_DIR" ]; then
    if [ -d "$TARGET_DIR" ]; then
      echo "$TARGET_DIR"
      return 0
    else
      error "Directorio no existe: $TARGET_DIR"
      return 1
    fi
  fi

  # Detectar instalación de OpenCode
  if [ -d "$HOME/.config/opencode" ]; then
    default_dir="$HOME/.config/opencode"
  elif [ -d "$HOME/.opencode" ]; then
    default_dir="$HOME/.opencode"
  else
    # Crear directorio por defecto
    default_dir="$HOME/.config/opencode"
    if [ ! -d "$HOME/.config" ]; then
      mkdir -p "$HOME/.config"
    fi
    mkdir -p "$default_dir"
    log "Creado directorio OpenCode: $default_dir"
  fi

  echo "$default_dir"
}

# ------------------------------------------------------------------
# Verificar que el directorio es válido para skills
# ------------------------------------------------------------------
validate_skills_dir() {
  local opencode_dir="$1"

  if [ ! -d "$opencode_dir" ]; then
    error "OpenCode directory no existe: $opencode_dir"
    return 1
  fi

  # El directorio de skills puede no existir aún
  if [ ! -d "$opencode_dir/skills" ]; then
    if $DRY_RUN; then
      log "Dry-run: crearía $opencode_dir/skills"
    else
      mkdir -p "$opencode_dir/skills"
    fi
    verbose "Creado directorio de skills"
  fi

  return 0
}

# ------------------------------------------------------------------
# Listar skills flowdoc-* en el repo local
# ------------------------------------------------------------------
list_local_skills() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local project_root
  project_root="$(cd "$script_dir/.." && pwd)"

  if [ -d "$project_root/$SKILLS_SOURCE_DIR" ]; then
    ls -d "$project_root/$SKILLS_SOURCE_DIR/$SKILLS_PATTERN"* 2>/dev/null || echo ""
  else
    echo ""
  fi
}

# ------------------------------------------------------------------
# Listar skills ya instaladas
# ------------------------------------------------------------------
list_installed_skills() {
  local opencode_dir="$1"
  local skills_dir="$opencode_dir/skills"

  if [ -d "$skills_dir" ]; then
    ls -d "$skills_dir/$SKILLS_PATTERN"* 2>/dev/null || echo ""
  else
    echo ""
  fi
}

# ------------------------------------------------------------------
# Hacer backup de skills existentes
# ------------------------------------------------------------------
backup_existing() {
  local opencode_dir="$1"
  local skills_dir="$opencode_dir/skills"

  if [ ! -d "$skills_dir" ] || [ -z "$(list_installed_skills "$opencode_dir")" ]; then
    verbose "No hay skills instaladas. No se requiere backup."
    return 0
  fi

  if [ "$FORCE" = false ] && [ "$UPDATE" = false ]; then
    warn "Ya existen skills instaladas:"
    for skill in $(list_installed_skills "$opencode_dir"); do
      warn "  - $(basename "$skill")"
    done
    echo ""
    read -p "¿Sobrescribir? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      log "Instalación cancelada."
      exit 0
    fi
  fi

  # Crear backup
  BACKUP_DIR="$opencode_dir/skills.backup.$(date +%Y%m%d_%H%M%S)"
  log "Backup en: $BACKUP_DIR"

  if $DRY_RUN; then
    log "Dry-run: movería $skills_dir → $BACKUP_DIR"
  else
    mv "$skills_dir" "$BACKUP_DIR"
    mkdir -p "$skills_dir"
  fi
}

# ------------------------------------------------------------------
# Descargar skills desde GitHub
# ------------------------------------------------------------------
download_skills() {
  local opencode_dir="$1"
  local temp_dir
  temp_dir=$(mktemp -d)

  log "Descargando skills desde GitHub..."

  if $DRY_RUN; then
    log "Dry-run: git clone $GITHUB_REPO → $temp_dir"
    rm -rf "$temp_dir"
    return 0
  fi

  # Clonar solo la carpeta skills (sparse checkout)
  git clone \
    --depth 1 \
    --filter=blob:none \
    --sparse \
    -b "$GITHUB_BRANCH" \
    "$GITHUB_REPO" \
    "$temp_dir" 2>/dev/null || {
      error "Falló descarga desde GitHub"
      rm -rf "$temp_dir"
      return 1
    }

  cd "$temp_dir"
  git sparse-checkout set "$SKILLS_SOURCE_DIR"

  # Copiar solo las skills flowdoc-*
  local skills_dir="$opencode_dir/skills"
  local copied=0

  for skill in "$SKILLS_SOURCE_DIR/$SKILLS_PATTERN"*; do
    if [ -d "$skill" ]; then
      local skill_name
      skill_name=$(basename "$skill")
      verbose "Instalando: $skill_name"

      if $DRY_RUN; then
        log "  [dry-run] copiaría $skill → $skills_dir/"
      else
        cp -r "$skill" "$skills_dir/"
      fi
      ((copied++)) || true
    fi
  done

  cd /
  rm -rf "$temp_dir"

  if [ "$copied" -eq 0 ]; then
    error "No se encontraron skills flowdoc-* en el repositorio"
    return 1
  fi

  SKILLS_INSTALLED=$copied
  success "Instaladas $copied skills"
}

# ------------------------------------------------------------------
# Actualizar skills existentes (git pull)
# ------------------------------------------------------------------
update_skills() {
  local opencode_dir="$1"
  local skills_dir="$opencode_dir/skills"

  if [ ! -d "$skills_dir" ] || [ -z "$(list_installed_skills "$opencode_dir")" ]; then
    warn "No hay skills instaladas para actualizar."
    log "Usa --force para instalación limpia."
    return 0
  fi

  log "Actualizando skills existentes..."

  # Para update simple, descargamos de nuevo y sobreescribimos
  local temp_dir
  temp_dir=$(mktemp -d)

  if $DRY_RUN; then
    log "Dry-run: actualizaría skills en $skills_dir"
    rm -rf "$temp_dir"
    return 0
  fi

  git clone \
    --depth 1 \
    --filter=blob:none \
    --sparse \
    -b "$GITHUB_BRANCH" \
    "$GITHUB_REPO" \
    "$temp_dir" 2>/dev/null || {
      error "Falló descarga desde GitHub"
      rm -rf "$temp_dir"
      return 1
    }

  cd "$temp_dir"
  git sparse-checkout set "$SKILLS_SOURCE_DIR"

  local updated=0
  for skill in "$SKILLS_SOURCE_DIR/$SKILLS_PATTERN"*; do
    if [ -d "$skill" ]; then
      local skill_name
      skill_name=$(basename "$skill")
      if [ -d "$skills_dir/$skill_name" ]; then
        verbose "Actualizando: $skill_name"
        rm -rf "$skills_dir/$skill_name"
        cp -r "$skill" "$skills_dir/"
        ((updated++)) || true
      fi
    fi
  done

  cd /
  rm -rf "$temp_dir"

  success "Actualizadas $updated skills"
}

# ------------------------------------------------------------------
# Generar o actualizar skill-registry
# ------------------------------------------------------------------
update_registry() {
  local opencode_dir="$1"
  local atlocal_dir="$opencode_dir/.atl"

  if [ ! -d "$atlocal_dir" ]; then
    if $DRY_RUN; then
      log "Dry-run: crearía $atlocal_dir"
    else
      mkdir -p "$atlocal_dir"
    fi
  fi

  verbose "Registry actualizado (skill-registry indexará en próximo inicio)"
}

# ------------------------------------------------------------------
# Verificar instalación
# ------------------------------------------------------------------
verify_install() {
  local opencode_dir="$1"
  local skills_dir="$opencode_dir/skills"

  echo ""
  echo -e "${BOLD}=== Verificación ===${NC}"

  local installed
  installed=$(list_installed_skills "$opencode_dir")

  if [ -z "$installed" ]; then
    error "No se encontraron skills instaladas"
    return 1
  fi

  success "Skills instaladas en: $skills_dir"
  echo ""
  echo "Skills:"
  for skill in $installed; do
    echo -e "  ${GREEN}✓${NC} $(basename "$skill")"
  done

  if [ -n "$BACKUP_DIR" ]; then
    echo ""
    echo -e "${YELLOW}Backup保留了 en: $BACKUP_DIR${NC}"
  fi

  echo ""
  echo -e "${BOLD}Próximos pasos:${NC}"
  echo "  1. Reinicia OpenCode o recarga la configuración"
  echo "  2. Verifica con: opencode --skills (o comando similar)"
  echo "  3. Para actualizar: $0 --update"

  return 0
}

# ------------------------------------------------------------------
# Main
# ------------------------------------------------------------------
main() {
  echo ""
  echo -e "${BOLD}========================================${NC}"
  echo -e "${BOLD}  FlowDoc Skills Installer v${INSTALLER_VERSION}${NC}"
  echo -e "${BOLD}========================================${NC}"
  echo ""

  # Parsear argumentos
  parse_args "$@"

  # Mostrar configuración
  if $DRY_RUN; then
    warn "MODO DRY-RUN - No se ejecutará ninguna acción"
    echo ""
  fi

  if $UPDATE; then
    log "Modo: ACTUALIZAR skills existentes"
  elif $FORCE; then
    log "Modo: INSTALAR (sobrescribir)"
  else
    log "Modo: INSTALAR (interactivo)"
  fi
  echo ""

  # Detectar directorio
  local opencode_dir
  opencode_dir=$(detect_opencode_dir)
  verbose "Directorio OpenCode: $opencode_dir"

  # Validar
  validate_skills_dir "$opencode_dir" || exit 1

  # Listar skills actuales
  local current_skills
  current_skills=$(list_installed_skills "$opencode_dir")
  if [ -n "$current_skills" ]; then
    verbose "Skills actuales:"
    for skill in $current_skills; do
      verbose "  - $(basename "$skill")"
    done
  fi

  # Backup si hay skills existentes
  if [ -n "$current_skills" ]; then
    if $UPDATE; then
      update_skills "$opencode_dir"
    else
      backup_existing "$opencode_dir"
    fi
  fi

  # Descargar e instalar
  if [ "$UPDATE" = false ]; then
    download_skills "$opencode_dir" || exit 1
  fi

  # Actualizar registry
  update_registry "$opencode_dir"

  # Verificar
  if ! $DRY_RUN; then
    verify_install "$opencode_dir"
  fi

  echo ""
  success "¡Listo!"
}

# Ejecutar
main "$@"

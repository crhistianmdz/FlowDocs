# ============================================================================
# FlowDoc Skills Installer para Windows
# Instala las skills de FlowDoc en OpenCode
#
# Uso:
#   powershell -ExecutionPolicy Bypass -File install-flowdoc-skills.ps1
#   .\install-flowdoc-skills.ps1 -DryRun
#   .\install-flowdoc-skills.ps1 -Force
#   .\install-flowdoc-skills.ps1 -Update
# ============================================================================

param(
    [switch]$DryRun,
    [switch]$Force,
    [switch]$Update,
    [string]$TargetDir = "",
    [switch]$Verbose,
    [switch]$Help
)

# ------------------------------------------------------------------
# Constantes
# ------------------------------------------------------------------
$GITHUB_REPO = "https://github.com/crhistianmdz/FlowDocs.git"
$GITHUB_BRANCH = "main"
$SKILLS_SOURCE_DIR = "skills"
$SKILLS_PATTERN = "flowdoc-"
$INSTALLER_VERSION = "1.0"

# ------------------------------------------------------------------
# Funciones de logging
# ------------------------------------------------------------------
function Write-Info { param($m) Write-Host "[INFO] $m" -ForegroundColor Cyan }
function Write-Warn { param($m) Write-Host "[WARN] $m" -ForegroundColor Yellow }
function Write-Err { param($m) Write-Host "[ERROR] $m" -ForegroundColor Red }
function Write-Success { param($m) Write-Host "[OK] $m" -ForegroundColor Green }
function Write-Verbose { param($m) if ($Verbose) { Write-Host "       $m" } }

function Show-Usage {
    Write-Host @"

FlowDoc Skills Installer v${INSTALLER_VERSION} (Windows)

Uso:
  install-flowdoc-skills.ps1 [OPTIONS]

Opciones:
  -DryRun              Muestra que hara sin ejecutar
  -Force               Sobrescribe skills existentes sin preguntar
  -Update              Actualiza skills ya instaladas
  -TargetDir <path>    Instala en directorio especifico
  -Verbose             Muestra mas detalle
  -Help                Muestra esta ayuda

Instalacion:
  irm https://raw.githubusercontent.com/crhistianmdz/FlowDocs/main/scripts/install-flowdoc-skills.ps1 | iex

Ejemplos:
  .\install-flowdoc-skills.ps1              Interactivo
  .\install-flowdoc-skills.ps1 -Force        Sin preguntar
  .\install-flowdoc-skills.ps1 -Update       Actualizar existentes
  .\install-flowdoc-skills.ps1 -TargetDir "C:\Users\.opencode"

"@
    exit 0
}

# ------------------------------------------------------------------
# Detectar directorio de OpenCode
# ------------------------------------------------------------------
function Get-OpenCodeDir {
    if ($TargetDir -ne "") {
        if (Test-Path $TargetDir) {
            return $TargetDir
        } else {
            Write-Err "Directorio no existe: $TargetDir"
            exit 1
        }
    }

    $homeDir = $env:USERPROFILE

    # Detectar instalacion de OpenCode
    $configOpencode = Join-Path $homeDir ".config\opencode"
    $opencodeDir = Join-Path $homeDir ".opencode"

    if (Test-Path $configOpencode) {
        return $configOpencode
    } elseif (Test-Path $opencodeDir) {
        return $opencodeDir
    } else {
        # Crear directorio por defecto
        $defaultDir = $configOpencode
        if (-not (Test-Path (Split-Path $defaultDir -Parent))) {
            New-Item -ItemType Directory -Path (Split-Path $defaultDir -Parent) -Force | Out-Null
        }
        New-Item -ItemType Directory -Path $defaultDir -Force | Out-Null
        Write-Info "Creado directorio OpenCode: $defaultDir"
        return $defaultDir
    }
}

# ------------------------------------------------------------------
# Validar directorio de skills
# ------------------------------------------------------------------
function Assert-SkillsDir {
    param($opencodeDir)

    if (-not (Test-Path $opencodeDir)) {
        Write-Err "OpenCode directory no existe: $opencodeDir"
        exit 1
    }

    $skillsDir = Join-Path $opencodeDir "skills"
    if (-not (Test-Path $skillsDir)) {
        if ($DryRun) {
            Write-Info "Dry-run: crearia $skillsDir"
        } else {
            New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null
        }
        Write-Verbose "Creado directorio de skills"
    }

    return $skillsDir
}

# ------------------------------------------------------------------
# Listar skills instaladas
# ------------------------------------------------------------------
function Get-InstalledSkills {
    param($opencodeDir)

    $skillsDir = Join-Path $opencodeDir "skills"
    if (Test-Path $skillsDir) {
        Get-ChildItem -Directory $skillsDir | Where-Object { $_.Name -like "$SKILLS_PATTERN*" } | ForEach-Object { $_.FullName }
    }
}

# ------------------------------------------------------------------
# Backup de skills existentes
# ------------------------------------------------------------------
function Backup-Existing {
    param($opencodeDir)

    $skillsDir = Join-Path $opencodeDir "skills"
    $currentSkills = Get-InstalledSkills -opencodeDir $opencodeDir

    if ($currentSkills.Count -eq 0) {
        Write-Verbose "No hay skills instaladas. No se requiere backup."
        return ""
    }

    if (-not $Force -and -not $Update) {
        Write-Warn "Ya existen skills instaladas:"
        foreach ($skill in $currentSkills) {
            Write-Warn "  - $(Split-Path $skill -Leaf)"
        }
        Write-Host ""
        $response = Read-Host "¿Sobrescribir? [y/N]"
        if ($response -notmatch "^[Yy]$") {
            Write-Info "Instalacion cancelada."
            exit 0
        }
    }

    # Crear backup
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupDir = Join-Path $opencodeDir "skills.backup.$timestamp"
    Write-Info "Backup en: $backupDir"

    if (-not $DryRun) {
        Move-Item -Path (Join-Path $opencodeDir "skills") -Destination $backupDir -Force
        New-Item -ItemType Directory -Path (Join-Path $opencodeDir "skills") -Force | Out-Null
    }

    return $backupDir
}

# ------------------------------------------------------------------
# Descargar skills desde GitHub
# ------------------------------------------------------------------
function Install-SkillsFromGitHub {
    param($opencodeDir)

    $skillsDir = Join-Path $opencodeDir "skills"
    $tempDir = Join-Path $env:TEMP "flowdoc-skills-install"

    Write-Info "Descargando skills desde GitHub..."

    if ($DryRun) {
        Write-Info "Dry-run: git clone $GITHUB_REPO -> $tempDir"
        return
    }

    # Limpiar temp anterior
    if (Test-Path $tempDir) {
        Remove-Item -Path $tempDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

    # Clonar solo la carpeta skills (sparse checkout)
    try {
        git clone --depth 1 --filter=blob:none --sparse -b $GITHUB_BRANCH $GITHUB_REPO $tempDir 2>&1 | Out-Null
    } catch {
        Write-Err "Falló descarga desde GitHub. Asegurate de tener git instalado."
        Remove-Item -Path $tempDir -Recurse -Force
        exit 1
    }

    Set-Location $tempDir
    git sparse-checkout set $SKILLS_SOURCE_DIR 2>&1 | Out-Null

    # Copiar solo las skills flowdoc-*
    $sourceSkillsDir = Join-Path $tempDir $SKILLS_SOURCE_DIR
    $copied = 0

    Get-ChildItem -Directory $sourceSkillsDir | Where-Object { $_.Name -like "$SKILLS_PATTERN*" } | ForEach-Object {
        $skillName = $_.Name
        Write-Verbose "Instalando: $skillName"

        Copy-Item -Path $_.FullName -Destination $skillsDir -Recurse -Force
        $copied++
    }

    Set-Location $PSScriptRoot
    Remove-Item -Path $tempDir -Recurse -Force

    if ($copied -eq 0) {
        Write-Err "No se encontraron skills flowdoc-* en el repositorio"
        exit 1
    }

    Write-Success "Instaladas $copied skills"
}

# ------------------------------------------------------------------
# Actualizar skills existentes
# ------------------------------------------------------------------
function Update-Skills {
    param($opencodeDir)

    $currentSkills = Get-InstalledSkills -opencodeDir $opencodeDir
    if ($currentSkills.Count -eq 0) {
        Write-Warn "No hay skills instaladas para actualizar."
        Write-Info "Usa -Force para instalacion limpia."
        return
    }

    Write-Info "Actualizando skills existentes..."

    $tempDir = Join-Path $env:TEMP "flowdoc-skills-update"

    if ($DryRun) {
        Write-Info "Dry-run: actualizaria skills en $opencodeDir\skills"
        return
    }

    # Limpiar temp anterior
    if (Test-Path $tempDir) {
        Remove-Item -Path $tempDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

    try {
        git clone --depth 1 --filter=blob:none --sparse -b $GITHUB_BRANCH $GITHUB_REPO $tempDir 2>&1 | Out-Null
    } catch {
        Write-Err "Falló descarga desde GitHub"
        Remove-Item -Path $tempDir -Recurse -Force
        exit 1
    }

    Set-Location $tempDir
    git sparse-checkout set $SKILLS_SOURCE_DIR 2>&1 | Out-Null

    $skillsDir = Join-Path $opencodeDir "skills"
    $updated = 0

    Get-ChildItem -Directory (Join-Path $tempDir $SKILLS_SOURCE_DIR) | Where-Object { $_.Name -like "$SKILLS_PATTERN*" } | ForEach-Object {
        $skillName = $_.Name
        $targetSkillDir = Join-Path $skillsDir $skillName
        if (Test-Path $targetSkillDir) {
            Write-Verbose "Actualizando: $skillName"
            Remove-Item -Path $targetSkillDir -Recurse -Force
            Copy-Item -Path $_.FullName -Destination $skillsDir -Recurse -Force
            $updated++
        }
    }

    Set-Location $PSScriptRoot
    Remove-Item -Path $tempDir -Recurse -Force

    Write-Success "Actualizadas $updated skills"
}

# ------------------------------------------------------------------
# Actualizar registry
# ------------------------------------------------------------------
function Update-Registry {
    param($opencodeDir)

    $atlDir = Join-Path $opencodeDir ".atl"
    if (-not (Test-Path $atlDir)) {
        if ($DryRun) {
            Write-Info "Dry-run: crearia $atlDir"
        } else {
            New-Item -ItemType Directory -Path $atlDir -Force | Out-Null
        }
    }

    Write-Verbose "Registry actualizado (skill-registry indexara en proximo inicio)"
}

# ------------------------------------------------------------------
# Verificar instalacion
# ------------------------------------------------------------------
function Verify-Install {
    param($opencodeDir)

    Write-Host ""
    Write-Host "=== Verificacion ===" -ForegroundColor Bold

    $installed = Get-InstalledSkills -opencodeDir $opencodeDir

    if ($installed.Count -eq 0) {
        Write-Err "No se encontraron skills instaladas"
        exit 1
    }

    Write-Success "Skills instaladas en: $opencodeDir\skills"
    Write-Host ""
    Write-Host "Skills:"

    foreach ($skill in $installed) {
        Write-Host "  + $(Split-Path $skill -Leaf)" -ForegroundColor Green
    }

    if ($script:backupDir -ne "") {
        Write-Host ""
        Write-Warn "Backup保留了 en: $script:backupDir"
    }

    Write-Host ""
    Write-Host "Proximos pasos:" -ForegroundColor Bold
    Write-Host "  1. Reinicia OpenCode o recarga la configuracion"
    Write-Host "  2. Verifica con: opencode --skills (o comando similar)"
    Write-Host "  3. Para actualizar: .\install-flowdoc-skills.ps1 -Update"
}

# ------------------------------------------------------------------
# Main
# ------------------------------------------------------------------
$backupDir = ""

if ($Help) {
    Show-Usage
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Bold
Write-Host "  FlowDoc Skills Installer v${INSTALLER_VERSION}" -ForegroundColor Bold
Write-Host "========================================" -ForegroundColor Bold
Write-Host ""

if ($DryRun) {
    Write-Warn "MODO DRY-RUN - No se ejecutara ninguna accion"
    Write-Host ""
}

if ($Update) {
    Write-Info "Modo: ACTUALIZAR skills existentes"
} elseif ($Force) {
    Write-Info "Modo: INSTALAR (sobrescribir)"
} else {
    Write-Info "Modo: INSTALAR (interactivo)"
}
Write-Host ""

# Detectar directorio
$opencodeDir = Get-OpenCodeDir
Write-Verbose "Directorio OpenCode: $opencodeDir"

# Validar
$skillsDir = Assert-SkillsDir -opencodeDir $opencodeDir

# Listar skills actuales
$currentSkills = Get-InstalledSkills -opencodeDir $opencodeDir
if ($currentSkills.Count -gt 0) {
    Write-Verbose "Skills actuales:"
    foreach ($skill in $currentSkills) {
        Write-Verbose "  - $(Split-Path $skill -Leaf)"
    }
}

# Backup o update si hay skills existentes
if ($currentSkills.Count -gt 0) {
    if ($Update) {
        Update-Skills -opencodeDir $opencodeDir
    } else {
        $backupDir = Backup-Existing -opencodeDir $opencodeDir
    }
}

# Descargar e instalar
if (-not $Update) {
    Install-SkillsFromGitHub -opencodeDir $opencodeDir
}

# Actualizar registry
Update-Registry -opencodeDir $opencodeDir

# Verificar
if (-not $DryRun) {
    Verify-Install -opencodeDir $opencodeDir
}

Write-Host ""
Write-Success "Listo!"

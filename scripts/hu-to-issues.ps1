# Script para pasar HU de docs/tasks a GitHub Issues
# Compatible con Windows (PowerShell)
# Evita duplicados verificando si el issue ya existe
#
# Soporta estructura con carpetas por rango (HU-001-HU-099, etc.)
# Ver: docs/architecture/adr/005-organizacion-hu.md

param(
    [string]$Repo = ""  # Si no se pasa, usa el repo actual
)

# Obtener repo actual si no se especifica
if (-not $Repo) {
    $Repo = (gh repo view --json nameWithOwner -q .nameWithOwner 2>$null)
    if (-not $Repo) {
        Write-Host "❌ Error: No se pudo detectar el repositorio. Especifica: .\hu-to-issues.ps1 owner/repo" -ForegroundColor Red
        exit 1
    }
}

$parts = $Repo -split "/"
$Owner = $parts[0]
$RepoName = $parts[1]

Write-Host "📋 Procesando HU de docs/tasks/ → GitHub Issues" -ForegroundColor Cyan
Write-Host "   Repo: $Repo"
Write-Host ""

# Buscar archivos .md en docs/tasks (incluye subcarpetas para rangos HU-XXX-HU-XXX)
$files = Get-ChildItem -Path "docs/tasks" -Filter "*.md" -Recurse -ErrorAction SilentlyContinue

if (-not $files) {
    Write-Host "⚠️  No se encontraron archivos en docs/tasks/" -ForegroundColor Yellow
    exit 0
}

foreach ($file in $files) {
    # Leer contenido del archivo
    $content = Get-Content $file.FullName -Raw
    
    # Extraer título (buscar línea **Título**: )
    if ($content -match '\*\*Título\*\*:\s*(.+)') {
        $titulo = $matches[1].Trim()
    } else {
        Write-Host "⚠️  Saltando: $($file.Name) - sin título válido" -ForegroundColor Yellow
        continue
    }
    
    # Validar que no sea el placeholder del template
    if ([string]::IsNullOrWhiteSpace($titulo) -or $titulo -match '\[Nombre') {
        Write-Host "⚠️  Saltando: $($file.Name) - template vacío" -ForegroundColor Yellow
        continue
    }
    
    # Verificar si ya existe un issue con el mismo título
    $existing = gh issue list --repo $Repo --state all --search $titulo --limit 1 2>$null
    
    if ($existing) {
        # Extraer número del issue existente
        if ($existing -match '#(\d+)') {
            $issueNum = $matches[1]
            Write-Host "⏭️  Ya existe: #$issueNum - $titulo" -ForegroundColor DarkGray
        } else {
            Write-Host "⏭️  Ya existe (conflictivo): $titulo" -ForegroundColor DarkGray
        }
    } else {
        # Crear el issue
        $body = $content
        
        try {
            $result = gh issue create `
                --repo $Repo `
                --title $titulo `
                --body $body `
                --label "user-story" 2>&1
            
            if ($result -match 'http') {
                Write-Host "✅ Creado: $result" -ForegroundColor Green
            } else {
                Write-Host "❌ Error creando '$titulo': $result" -ForegroundColor Red
            }
        } catch {
            Write-Host "❌ Error: $_" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "🏁 Finalizado" -ForegroundColor Cyan
Write-Host ""
Write-Host "📝 Nota: Los issues creados quedan en estado 'open'" -ForegroundColor Gray
Write-Host "   Moverlos al Project Board manualmente" -ForegroundColor Gray
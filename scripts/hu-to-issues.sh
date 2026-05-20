#!/bin/bash
# Script para pasar HU de docs/tasks a GitHub Issues
# Evita duplicados verificando si el issue ya existe

REPO="${1:-$(gh repo view --json nameWithOwner -q .nameWithOwner)}"
OWNER=$(echo "$REPO" | cut -d'/' -f1)
REPO_NAME=$(echo "$REPO" | cut -d'/' -f2)

echo "📋 Procesando HU de docs/tasks/ → GitHub Issues"
echo "   Repo: $REPO"
echo ""

TEMPLATE_TITLE="**Título**:"

for archivo in docs/tasks/*.md; do
  [ -e "$archivo" ] || continue
  
  # Extraer título de la HU
  titulo=$(grep -m1 "^$TEMPLATE_TITLE" "$archivo" | sed "s/^$TEMPLATE_TITLE //" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  
  if [ -z "$titulo" ] || [ "$titulo" = "[Nombre corto del feature]" ]; then
    echo "⚠️  Saltando: $(basename "$archivo") - sin título válido"
    continue
  fi
  
  # Verificar si ya existe un issue con el mismo título
  existing=$(gh issue list --repo "$REPO" --state all --search "$titulo" --limit 1 --json number,title -q '.[0]' 2>/dev/null)
  
  if [ -n "$existing" ]; then
    number=$(echo "$existing" | jq -r '.number')
    echo "⏭️  Ya existe: #$number - $titulo"
  else
    # Crear el cuerpo del issue desde el archivo
    cuerpo=$(cat "$archivo")
    
    # Crear el issue
    result=$(gh issue create \
      --repo "$REPO" \
      --title "$titulo" \
      --body "$cuerpo" \
      --label "user-story" 2>&1)
    
    if echo "$result" | grep -q "http"; then
      echo "✅ Creado: $result"
    else
      echo "❌ Error creando '$titulo': $result"
    fi
  fi
done

echo ""
echo "🏁 Finalizado"
echo ""
echo "📝 Nota: Los issues creados quedan en estado 'open'"
echo "   Moverlos al Project Board manualmente"
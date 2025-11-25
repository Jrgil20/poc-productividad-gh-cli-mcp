#!/usr/bin/env bash
# examples/02-branch-pr.sh
# Crea una rama de feature, sube y abre un PR usando gh.
set -euo pipefail

if ! gh auth status >/dev/null 2>&1; then
  echo "No autenticado con gh. Ejecuta: gh auth login" >&2
  exit 1
fi

read -r -p "Nombre de la feature branch (ej: feature/mi-cambio): " feature
if [[ -z "$feature" ]]; then
  echo "Nombre inválido." >&2
  exit 1
fi

read -r -p "Se creará la rama '$feature' desde 'main' y se realizará push. Continuar? (y/N) " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Abortado."
  exit 0
fi

git fetch origin
git checkout main
git pull origin main
git checkout -b "$feature"

# Crear un archivo de ejemplo para el commit
echo "# Cambio de prueba - $feature" > EXAMPLE.md
git add EXAMPLE.md
git commit -m "feat: inicio $feature" -q || true
git push -u origin "$feature"

echo "Rama '$feature' creada y pusheada. Creando PR (borrador)..."
gh pr create --title "feat: $feature" --body "PR creado por script de ejemplos." --base main --head "$feature" --draft

echo "PR creada como borrador. Revisa y completa en GitHub."

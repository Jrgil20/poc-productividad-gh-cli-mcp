#!/usr/bin/env bash
# examples/04-create-release.sh
# Crea una release de prueba con gh.
set -euo pipefail

if ! gh auth status >/dev/null 2>&1; then
  echo "No autenticado con gh. Ejecuta: gh auth login" >&2
  exit 1
fi

read -r -p "Tag para la release (ej: v0.1.0): " tag
if [[ -z "$tag" ]]; then
  echo "Tag inválido." >&2
  exit 1
fi

read -r -p "Crear release '$tag'? (y/N) " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Abortado."
  exit 0
fi

read -r -p "Notas de release (línea única): " notes
gh release create "$tag" --title "$tag" --notes "$notes"
echo "Release '$tag' creada."

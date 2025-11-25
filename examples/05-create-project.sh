#!/usr/bin/env bash
# examples/05-create-project.sh
# Crea un proyecto en el repo actual y muestra su id/number.
set -euo pipefail

if ! gh auth status >/dev/null 2>&1; then
  echo "No autenticado con gh. Ejecuta: gh auth login" >&2
  exit 1
fi

repo=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
read -r -p "Título del proyecto (ej: PoC Project): " title
if [[ -z "$title" ]]; then
  echo "Título inválido." >&2
  exit 1
fi
read -r -p "Descripción (opcional): " body

echo "Creando proyecto '$title' en $repo..."
gh project create --repo "$repo" --title "$title" --body "$body"

echo "Buscando número del proyecto..."
proj_num=$(gh project list --repo "$repo" --jq ".[] | select(.title==\"$title\") | .number")
if [[ -z "$proj_num" ]]; then
  echo "No se pudo obtener el número del proyecto. Lista de proyectos:";
  gh project list --repo "$repo"
  exit 1
fi

echo "Proyecto creado: número=$proj_num"
gh project view "$proj_num" --repo "$repo"

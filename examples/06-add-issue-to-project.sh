#!/usr/bin/env bash
# examples/06-add-issue-to-project.sh
# Crea un issue y lo añade a un proyecto existente en el repo.
set -euo pipefail

if ! gh auth status >/dev/null 2>&1; then
  echo "No autenticado con gh. Ejecuta: gh auth login" >&2
  exit 1
fi

repo=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
read -r -p "Título del issue: " issue_title
if [[ -z "$issue_title" ]]; then
  echo "Título inválido." >&2
  exit 1
fi
read -r -p "Cuerpo del issue (opcional): " issue_body
read -r -p "Título del proyecto (exacto): " project_title
if [[ -z "$project_title" ]]; then
  echo "Título de proyecto inválido." >&2
  exit 1
fi

echo "Creando issue en $repo..."
issue_url=$(gh issue create --title "$issue_title" --body "$issue_body" --json url --jq .url)
if [[ -z "$issue_url" ]]; then
  echo "No se pudo crear el issue." >&2
  exit 1
fi

echo "Buscando número del proyecto '$project_title'..."
proj_num=$(gh project list --repo "$repo" --jq ".[] | select(.title==\"$project_title\") | .number")
if [[ -z "$proj_num" ]]; then
  echo "No se encontró el proyecto. Lista disponible:";
  gh project list --repo "$repo"
  exit 1
fi

echo "Añadiendo issue $issue_url al proyecto #$proj_num..."
gh project item-add "$proj_num" --repo "$repo" --url "$issue_url"

echo "Hecho. Issue agregado al proyecto."

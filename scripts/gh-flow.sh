#!/usr/bin/env bash
# scripts/gh-flow.sh
# Wrapper simple para GitHub Flow: crea branch, (opcional) commit+push y crea PR draft.
set -euo pipefail

if ! gh auth status >/dev/null 2>&1; then
  echo "No autenticado con gh. Ejecuta: gh auth login" >&2
  exit 1
fi

usage(){
  cat <<EOF
Usage: $0 -n <feature-branch> [--push]
  -n, --name   Nombre de la feature branch (ej: feature/x)
  --push       Realizar commit (git add -A && git commit -m ...) y push + crear PR
EOF
}

FEATURE=""
PUSH=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--name) FEATURE="$2"; shift 2;;
    --push) PUSH=true; shift;;
    -h|--help) usage; exit 0;;
    *) echo "Argumento desconocido: $1"; usage; exit 1;;
  esac
done

if [[ -z "$FEATURE" ]]; then
  read -r -p "Nombre de la feature branch (ej: feature/mi-cambio): " FEATURE
fi
if [[ -z "$FEATURE" ]]; then
  echo "Nombre inválido." >&2
  exit 1
fi

read -r -p "Crear branch '$FEATURE' desde 'main'? (y/N) " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Abortado."
  exit 0
fi

git fetch origin
git checkout main
git pull origin main
git checkout -b "$FEATURE"

if [ "$PUSH" = true ]; then
  git add -A
  git commit -m "feat: $FEATURE" -q || true
  git push -u origin "$FEATURE"
  gh pr create --title "feat: $FEATURE" --body "PR creado por scripts/gh-flow.sh" --base main --head "$FEATURE" --draft
  echo "PR de borrador creada."
else
  echo "Branch '$FEATURE' creada localmente. Realiza tus cambios y ejecuta este script con --push para pushear y crear PR."
fi

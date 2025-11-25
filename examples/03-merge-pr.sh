#!/usr/bin/env bash
# examples/03-merge-pr.sh
# Lista PRs abiertos y permite mergear uno, con confirmación.
set -euo pipefail

if ! gh auth status >/dev/null 2>&1; then
  echo "No autenticado con gh. Ejecuta: gh auth login" >&2
  exit 1
fi

echo "PRs abiertos:"
gh pr list --state open

read -r -p "Número o URL del PR a mergear (vacío = cancelar): " pr
if [[ -z "$pr" ]]; then
  echo "Cancelado."
  exit 0
fi

read -r -p "Se mergeará el PR '$pr'. Confirmar? (y/N) " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Abortado."
  exit 0
fi

gh pr merge "$pr" --merge
echo "Merge realizado (si no hubo errores)."

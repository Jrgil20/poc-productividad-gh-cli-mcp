#!/usr/bin/env bash
# examples/01-create-issue.sh
# Crea un issue de ejemplo usando gh y lista los últimos issues.
set -euo pipefail

if ! gh auth status >/dev/null 2>&1; then
  echo "No autenticado con gh. Ejecuta: gh auth login" >&2
  exit 1
fi

read -r -p "¿Deseas crear un issue de prueba? (y/N) " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Abortando: no se creó el issue."
  exit 0
fi

title="Ejemplo: Issue creado por gh CLI"
body="Este issue fue creado como parte del PoC Productividad.\nFecha: $(date -Iseconds)"
gh issue create --title "$title" --body "$body" --label poc >/dev/null

echo "Issue creado. Últimos 5 issues:"
gh issue list --limit 5

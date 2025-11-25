# examples/03-merge-pr.ps1
# Lista PRs abiertos y permite mergear uno, con confirmación.
if (-not (gh auth status -h 2>$null)) {
    Write-Host "No autenticado con gh. Ejecuta: gh auth login" -ForegroundColor Red
    exit 1
}

Write-Host 'PRs abiertos:'
gh pr list --state open

$pr = Read-Host 'Número o URL del PR a mergear (vacío = cancelar)'
if (-not $pr) { Write-Host 'Cancelado.'; exit 0 }

$confirm = Read-Host "Se mergeará el PR '$pr'. Confirmar? (y/N)"
if ($confirm -ne 'y' -and $confirm -ne 'Y') { Write-Host 'Abortado.'; exit 0 }

gh pr merge $pr --merge
Write-Host 'Merge realizado (si no hubo errores).'

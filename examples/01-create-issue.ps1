# examples/01-create-issue.ps1
# Crea un issue de ejemplo usando gh y lista los últimos issues.
if (-not (gh auth status -h 2>$null)) {
    Write-Host "No autenticado con gh. Ejecuta: gh auth login" -ForegroundColor Red
    exit 1
}

$confirm = Read-Host '¿Deseas crear un issue de prueba? (y/N)'
if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host 'Abortando: no se creó el issue.'
    exit 0
}

$title = 'Ejemplo: Issue creado por gh CLI'
$body = "Este issue fue creado como parte del PoC Productividad.\nFecha: $(Get-Date -Format o)"
gh issue create --title "$title" --body "$body" --label "poc" | Out-Null

Write-Host 'Issue creado. Últimos 5 issues:'
gh issue list --limit 5

# scripts/gh-flow.ps1
# Wrapper simple para GitHub Flow: crea branch, push y abre PR (borrador).
if (-not (gh auth status -h 2>$null)) {
    Write-Host "No autenticado con gh. Ejecuta: gh auth login" -ForegroundColor Red
    exit 1
}

param(
    [string]$FeatureName
)

if (-not $FeatureName) {
    $FeatureName = Read-Host 'Nombre de la feature branch (ej: feature/mi-cambio)'
}

if (-not $FeatureName) { Write-Host 'Nombre inválido.'; exit 1 }

$confirm = Read-Host "Crear branch '$FeatureName' desde 'main', push y PR (draft)? (y/N)"
if ($confirm -ne 'y' -and $confirm -ne 'Y') { Write-Host 'Abortado.'; exit 0 }

git fetch origin
git checkout main
git pull origin main
git checkout -b $FeatureName

Write-Host "Branch '$FeatureName' creada localmente. Realiza tus cambios y luego ejecuta este script con --push para pushear y abrir PR."

if ($PSBoundParameters.ContainsKey('push')) {
    git add -A
    git commit -m "feat: $FeatureName" -q
    git push -u origin $FeatureName
    gh pr create --title "feat: $FeatureName" --body "PR creado por scripts/gh-flow.ps1" --base main --head $FeatureName --draft
    Write-Host 'PR de borrador creada.'
}

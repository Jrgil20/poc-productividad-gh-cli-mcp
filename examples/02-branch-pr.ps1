# examples/02-branch-pr.ps1
# Crea una rama de feature, sube y abre un PR usando gh.
if (-not (gh auth status -h 2>$null)) {
    Write-Host "No autenticado con gh. Ejecuta: gh auth login" -ForegroundColor Red
    exit 1
}

$feature = Read-Host 'Nombre de la feature branch (ej: feature/mi-cambio)'
if (-not $feature) { Write-Host 'Nombre inválido.'; exit 1 }

$confirm = Read-Host "Se creará la rama '$feature' desde 'main' y se realizará push. Continuar? (y/N)"
if ($confirm -ne 'y' -and $confirm -ne 'Y') { Write-Host 'Abortado.'; exit 0 }

git fetch origin
git checkout main
git pull origin main
git checkout -b $feature

# Crear un archivo de ejemplo para el commit
New-Item -Path README.md -ItemType File -Force | Out-Null
Add-Content -Path README.md -Value "# Cambio de prueba - $feature";
git add README.md
git commit -m "feat: inicio $feature" -q
git push -u origin $feature

Write-Host "Rama '$feature' creada y pusheada. Creando PR (se abrirá en modo interactivo si aplica)..."
gh pr create --title "feat: $feature" --body "PR creado por script de ejemplos." --base main --head $feature --draft

Write-Host 'PR creada como borrador. Revisa y completa en GitHub.'

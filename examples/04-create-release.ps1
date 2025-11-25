# examples/04-create-release.ps1
# Crea una release de prueba con gh.
if (-not (gh auth status -h 2>$null)) {
    Write-Host "No autenticado con gh. Ejecuta: gh auth login" -ForegroundColor Red
    exit 1
}

$tag = Read-Host 'Tag para la release (ej: v0.1.0)'
if (-not $tag) { Write-Host 'Tag inválido.'; exit 1 }

$confirm = Read-Host "Crear release '$tag'? (y/N)"
if ($confirm -ne 'y' -and $confirm -ne 'Y') { Write-Host 'Abortado.'; exit 0 }

$notes = Read-Host 'Notas de release (línea única)'
gh release create $tag --title "$tag" --notes "$notes"
Write-Host "Release '$tag' creada."

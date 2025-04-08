# Configuración
$backupDir = ".\backups"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupName = "backup_$timestamp.zip"
$excludeDirs = @("venv", "backups", "__pycache__", ".git")

# Crear directorio de backups si no existe
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir
}

# Crear lista de archivos a excluir
$excludePattern = ($excludeDirs | ForEach-Object { "*\$_*" }) -join "|"

# Crear el backup
Write-Host "Creando backup: $backupName"
Compress-Archive -Path * -DestinationPath "$backupDir\$backupName" -ExcludePattern $excludePattern

# Mantener solo los últimos 5 backups
$backups = Get-ChildItem $backupDir -Filter "backup_*.zip" | Sort-Object CreationTime -Descending
if ($backups.Count -gt 5) {
    $backups | Select-Object -Skip 5 | ForEach-Object {
        Write-Host "Eliminando backup antiguo: $($_.Name)"
        Remove-Item $_.FullName
    }
}

Write-Host "Backup completado: $backupName"
Write-Host "Backups disponibles:"
Get-ChildItem $backupDir -Filter "backup_*.zip" | Sort-Object CreationTime -Descending | Format-Table Name, CreationTime 
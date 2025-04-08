# Configuración
$backupDir = ".\backups"

# Verificar si existe el directorio de backups
if (-not (Test-Path $backupDir)) {
    Write-Host "No se encontró el directorio de backups"
    exit
}

# Listar backups disponibles
$backups = Get-ChildItem $backupDir -Filter "backup_*.zip" | Sort-Object CreationTime -Descending
if ($backups.Count -eq 0) {
    Write-Host "No hay backups disponibles"
    exit
}

Write-Host "Backups disponibles:"
$backups | ForEach-Object { $i = 0 } { 
    Write-Host "[$i] $($_.Name) - $($_.CreationTime)"
    $i++
}

# Solicitar selección
$selection = Read-Host "Selecciona el número del backup a restaurar (0-$($backups.Count-1))"
if ($selection -notmatch '^\d+$' -or $selection -lt 0 -or $selection -ge $backups.Count) {
    Write-Host "Selección inválida"
    exit
}

$selectedBackup = $backups[$selection]

# Confirmar restauración
$confirm = Read-Host "¿Estás seguro de restaurar el backup $($selectedBackup.Name)? (s/n)"
if ($confirm -ne 's') {
    Write-Host "Restauración cancelada"
    exit
}

# Crear backup del estado actual
Write-Host "Creando backup del estado actual..."
.\backup.ps1

# Restaurar backup seleccionado
Write-Host "Restaurando backup: $($selectedBackup.Name)"
Expand-Archive -Path $selectedBackup.FullName -DestinationPath "." -Force

Write-Host "Restauración completada" 
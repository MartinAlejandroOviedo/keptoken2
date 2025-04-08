# Script para limpiar el entorno de desarrollo
Write-Host "Limpiando entorno de desarrollo..."

# Eliminar archivos temporales y caché
if (Test-Path "__pycache__") {
    Remove-Item -Recurse -Force "__pycache__"
    Write-Host "Eliminado __pycache__"
}

if (Test-Path "*.pyc") {
    Remove-Item -Force "*.pyc"
    Write-Host "Eliminados archivos .pyc"
}

# Limpiar logs
if (Test-Path "logs") {
    Remove-Item -Recurse -Force "logs"
    Write-Host "Eliminada carpeta logs"
}

Write-Host "Limpieza completada." 
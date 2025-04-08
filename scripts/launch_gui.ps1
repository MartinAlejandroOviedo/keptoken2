# Script para iniciar la interfaz gráfica
Write-Host "Iniciando interfaz gráfica..."

# Cambiar al directorio raíz del proyecto
$rootDir = Split-Path -Parent $PSScriptRoot
Set-Location $rootDir

# Activar el entorno virtual si existe
if (Test-Path "venv") {
    & .\venv\Scripts\Activate.ps1
} else {
    Write-Host "Error: No se encontró el entorno virtual"
    Write-Host "Por favor, ejecuta primero .\scripts\start_server.ps1 para crear el entorno virtual"
    exit 1
}

# Ejecutar la interfaz gráfica
python scripts/gui_launcher.py 
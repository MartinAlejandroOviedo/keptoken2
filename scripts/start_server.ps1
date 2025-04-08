# Script para iniciar el servidor Flask
Write-Host "Iniciando servidor Keeptoken..."

# Cambiar al directorio raíz del proyecto
$rootDir = Split-Path -Parent $PSScriptRoot
Set-Location $rootDir

# Activar el entorno virtual si existe
if (Test-Path "venv") {
    Write-Host "Activando entorno virtual..."
    & .\venv\Scripts\Activate.ps1
} else {
    Write-Host "Creando nuevo entorno virtual..."
    python -m venv venv
    & .\venv\Scripts\Activate.ps1
}

# Actualizar pip
Write-Host "Actualizando pip..."
python -m pip install --upgrade pip

# Instalar dependencias
Write-Host "Instalando dependencias..."
pip install -r server/requirements.txt

# Iniciar el servidor
Write-Host "Iniciando servidor Flask..."
$env:FLASK_APP = "server.run"
$env:FLASK_ENV = "development"
$env:PYTHONPATH = "$(Get-Location)"
python -m flask run 
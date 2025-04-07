# Verificar si el entorno virtual existe
if (-not (Test-Path "venv")) {
    Write-Host "Creando entorno virtual..."
    python -m venv venv
}

# Activar el entorno virtual
Write-Host "Activando entorno virtual..."
.\venv\Scripts\Activate.ps1

# Actualizar pip
Write-Host "Actualizando pip..."
python -m pip install --upgrade pip

# Instalar dependencias
Write-Host "Instalando dependencias..."
pip install -r requirements.txt

# Verificar la instalación
Write-Host "Verificando instalación..."
pip list

Write-Host "`nInstalación completada. Para activar el entorno virtual en el futuro, ejecuta: .\venv\Scripts\Activate.ps1" 
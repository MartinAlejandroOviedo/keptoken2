# Crear el entorno virtual
python -m venv venv

# Activar el entorno virtual
.\venv\Scripts\Activate.ps1

# Instalar las dependencias
pip install -r requirements.txt

Write-Host "Entorno virtual creado y activado. Las dependencias han sido instaladas."
Write-Host "Para activar el entorno virtual en el futuro, ejecuta: .\venv\Scripts\Activate.ps1" 
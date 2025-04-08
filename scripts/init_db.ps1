# Obtener la ruta del script actual
$scriptPath = $PSScriptRoot
$projectRoot = Split-Path -Parent $scriptPath

# Crear directorios necesarios
$directories = @(
    "$projectRoot\server\db",
    "$projectRoot\server\db\backups",
    "$projectRoot\server\db\migrations",
    "$projectRoot\server\db\migrations\versions"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        Write-Host "Creando directorio: $dir"
        New-Item -ItemType Directory -Path $dir -Force
    }
}

# Crear archivo de base de datos si no existe
$dbFile = "$projectRoot\server\db\data.db"
if (-not (Test-Path $dbFile)) {
    Write-Host "Creando archivo de base de datos: $dbFile"
    New-Item -ItemType File -Path $dbFile -Force
}

# Crear archivo de configuración de Alembic si no existe
$alembicIni = "$projectRoot\server\db\migrations\alembic.ini"
if (-not (Test-Path $alembicIni)) {
    Write-Host "Creando archivo de configuración de Alembic"
    @"
[alembic]
script_location = migrations
sqlalchemy.url = sqlite:///server/db/data.db

[loggers]
keys = root,sqlalchemy,alembic

[handlers]
keys = console

[formatters]
keys = generic

[logger_root]
level = WARN
handlers = console
qualname =

[logger_sqlalchemy]
level = WARN
handlers =
qualname = sqlalchemy.engine

[logger_alembic]
level = INFO
handlers =
qualname = alembic

[handler_console]
class = StreamHandler
args = (sys.stderr,)
level = NOTSET
formatter = generic

[formatter_generic]
format = %(levelname)-5.5s [%(name)s] %(message)s
datefmt = %H:%M:%S
"@ | Out-File -FilePath $alembicIni -Encoding UTF8
}

Write-Host "`nEstructura de base de datos inicializada correctamente"
Write-Host "Ubicación de la base de datos: $dbFile"
Write-Host "Directorio de backups: $projectRoot\server\db\backups"
Write-Host "Directorio de migraciones: $projectRoot\server\db\migrations" 
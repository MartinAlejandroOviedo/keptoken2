# Configuración
$commitMessage = "Backup automatico - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$githubUser = "MartinAlejandroOviedo"
$repoName = "keptoken2"
$repoUrl = "https://github.com/$githubUser/$repoName.git"
$branchName = "main"

# Obtener la ruta base del proyecto
$projectRoot = Split-Path -Parent $PSScriptRoot

# Cambiar al directorio raíz del proyecto
Set-Location $projectRoot

# Configuración de usuario por defecto
$defaultUserName = "MartinAlejandroOviedo"
$defaultUserEmail = "quamagi@hotmail.com"

# Configurar la codificación de salida
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=== Iniciando proceso de backup a GitHub ==="

# Configurar helper de credenciales
Write-Host "Configurando helper de credenciales..."
git config --global credential.helper manager

# Deshabilitar firma GPG globalmente
Write-Host "Configurando Git sin firma GPG..."
git config --global commit.gpgsign false
git config --global tag.gpgsign false

# Verificar credenciales de Git
Write-Host "Verificando credenciales de Git..."
$gitConfig = git config --list
if (-not ($gitConfig -match "user.name") -or -not ($gitConfig -match "user.email")) {
    Write-Host "Configurando Git con credenciales por defecto..."
    git config --global user.name $defaultUserName
    git config --global user.email $defaultUserEmail
    Write-Host "Credenciales configuradas:"
    Write-Host "Nombre: $defaultUserName"
    Write-Host "Email: $defaultUserEmail"
}

# Configurar rama por defecto
Write-Host "Configurando rama por defecto..."
git config --global init.defaultBranch $branchName

# Verificar si es un repositorio git
if (-not (Test-Path ".git")) {
    Write-Host "Inicializando repositorio git..."
    git init
    git branch -M $branchName
    git add .
    git commit -m "Commit inicial"
    
    Write-Host "Configurando repositorio remoto..."
    git remote add origin $repoUrl
}

# Verificar conexión con GitHub
Write-Host "Verificando conexion con GitHub..."
try {
    $remoteStatus = git remote -v
    if (-not ($remoteStatus -match $repoUrl)) {
        Write-Host "Actualizando URL del repositorio remoto..."
        git remote set-url origin $repoUrl
    }
} catch {
    Write-Host "Error al verificar conexion con GitHub: $_"
    exit 1
}

# Configurar rama principal
Write-Host "Configurando rama principal..."
git branch -M $branchName

# Verificar estado del repositorio
Write-Host "Verificando estado del repositorio..."
$status = git status
Write-Host $status

# Verificar si hay cambios para hacer commit
$changes = git status --porcelain
if (-not $changes) {
    Write-Host "No hay cambios para hacer commit."
    exit 0
}

# Obtener información detallada de los cambios
Write-Host "`nAnalizando cambios..."
$totalSize = 0
$fileCount = 0
$modifiedFiles = @()
$addedFiles = @()
$deletedFiles = @()
$largeFiles = @()

foreach ($change in $changes) {
    $status = $change.Substring(0, 2).Trim()
    $filePath = $change.Substring(3)
    
    if (Test-Path $filePath) {
        $fileSize = (Get-Item $filePath).Length
        $totalSize += $fileSize
        $fileCount++
        
        if ($fileSize -gt 10MB) {
            $largeFiles += $filePath
        }
    }
    
    switch ($status) {
        "M" { $modifiedFiles += $filePath }
        "A" { $addedFiles += $filePath }
        "D" { $deletedFiles += $filePath }
    }
}

# Mostrar resumen de cambios
Write-Host "`nResumen de cambios:"
Write-Host "Archivos modificados: $($modifiedFiles.Count)"
Write-Host "Archivos agregados: $($addedFiles.Count)"
Write-Host "Archivos eliminados: $($deletedFiles.Count)"
Write-Host "Total de archivos: $fileCount"
Write-Host "Tamaño total: $([math]::Round($totalSize/1MB, 2)) MB"

if ($largeFiles.Count -gt 0) {
    Write-Host "`nAdvertencia: Los siguientes archivos son mayores a 10MB:"
    $largeFiles | ForEach-Object { Write-Host "- $_" }
}

# Hacer el commit
Write-Host "`nRealizando commit..."
try {
    git add .
    git commit -m $commitMessage
    Write-Host "Commit realizado exitosamente."
} catch {
    Write-Host "Error al realizar el commit: $_"
    exit 1
}

# Empujar los cambios
Write-Host "`nEmpujando cambios a GitHub..."
try {
    git push origin $branchName
    Write-Host "Cambios empujados exitosamente a GitHub."
} catch {
    Write-Host "Error al empujar los cambios: $_"
    exit 1
}

Write-Host "`n=== Proceso de backup completado ==="
exit 0 
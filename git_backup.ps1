# Configuración
$commitMessage = "Backup automatico - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$githubUser = "MartinAlejandroOviedo"
$repoName = "keptoken2"
$repoUrl = "https://github.com/$githubUser/$repoName.git"
$branchName = "main"

# Configuración de usuario por defecto
$defaultUserName = "MartinAlejandroOviedo"
$defaultUserEmail = "quamagi@hotmail.com"

# Configurar la codificación de salida
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

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
    exit
}

# Configurar rama principal
Write-Host "Configurando rama principal..."
git branch -M $branchName

# Verificar estado del repositorio
Write-Host "Verificando estado del repositorio..."
$status = git status
Write-Host $status

# Obtener información detallada de los cambios
Write-Host "`nAnalizando cambios..."
$changes = git diff --cached --name-status
$totalSize = 0
$fileCount = 0
$modifiedFiles = @()
$addedFiles = @()
$deletedFiles = @()
$largeFiles = @()

# Función para calcular el porcentaje de cambio
function Get-ChangePercentage {
    param (
        [string]$filePath
    )
    $diffOutput = git diff --cached --numstat $filePath
    if ($diffOutput) {
        $stats = $diffOutput -split '\s+'
        $added = [int]$stats[0]
        $deleted = [int]$stats[1]
        $total = $added + $deleted
        if ($total -gt 0) {
            return [math]::Round(($total / ($total + 1)) * 100, 2)
        }
    }
    return 0
}

# Función para estimar tiempo de subida
function Get-EstimatedUploadTime {
    param (
        [long]$sizeInBytes
    )
    # Asumiendo una velocidad promedio de 1MB/s
    $uploadSpeed = 1MB
    $seconds = [math]::Ceiling($sizeInBytes / $uploadSpeed)
    if ($seconds -lt 60) {
        return "$seconds segundos"
    } elseif ($seconds -lt 3600) {
        $minutes = [math]::Ceiling($seconds / 60)
        return "$minutes minutos"
    } else {
        $hours = [math]::Floor($seconds / 3600)
        $minutes = [math]::Ceiling(($seconds % 3600) / 60)
        return "$hours horas y $minutes minutos"
    }
}

foreach ($change in $changes) {
    $fileCount++
    $status = $change.Substring(0,1)
    $filePath = $change.Substring(2)
    $fileSize = (Get-Item $filePath -ErrorAction SilentlyContinue).Length
    
    if ($fileSize) {
        $totalSize += $fileSize
        # Verificar archivos grandes (>10MB)
        if ($fileSize -gt 10MB) {
            $largeFiles += @{
                'Path' = $filePath
                'Size' = [math]::Round($fileSize/1MB, 2)
            }
        }
    }
    
    $changePercentage = Get-ChangePercentage $filePath
    
    switch ($status) {
        'M' { 
            $modifiedFiles += @{
                'Path' = $filePath
                'Size' = [math]::Round($fileSize/1KB, 2)
                'Change' = $changePercentage
            }
        }
        'A' { 
            $addedFiles += @{
                'Path' = $filePath
                'Size' = [math]::Round($fileSize/1KB, 2)
            }
        }
        'D' { $deletedFiles += $filePath }
    }
}

# Mostrar resumen de cambios
Write-Host "`nResumen de cambios:"
Write-Host "Total de archivos: $fileCount"
Write-Host "Tamaño total: $([math]::Round($totalSize/1KB, 2)) KB"
Write-Host "Tiempo estimado de subida: $(Get-EstimatedUploadTime $totalSize)"

if ($largeFiles.Count -gt 0) {
    Write-Host "`nArchivos grandes detectados:"
    $largeFiles | ForEach-Object {
        Write-Host ("  - {0} ({1} MB)" -f $_.Path, $_.Size)
    }
}

if ($modifiedFiles.Count -gt 0) {
    Write-Host "`nArchivos modificados ($($modifiedFiles.Count)):"
    $modifiedFiles | ForEach-Object {
        Write-Host ("  - {0} ({1} KB) - {2}% de cambios" -f $_.Path, $_.Size, $_.Change)
    }
}

if ($addedFiles.Count -gt 0) {
    Write-Host "`nArchivos nuevos ($($addedFiles.Count)):"
    $addedFiles | ForEach-Object {
        Write-Host ("  - {0} ({1} KB)" -f $_.Path, $_.Size)
    }
}

if ($deletedFiles.Count -gt 0) {
    Write-Host "`nArchivos eliminados ($($deletedFiles.Count)):"
    $deletedFiles | ForEach-Object { Write-Host "  - $_" }
}

# Agregar cambios
Write-Host "`nAgregando cambios..."
git add .

# Hacer commit sin firma
Write-Host "Creando commit..."
git commit -m $commitMessage
$commitInfo = git log -1 --pretty=format:"%h - %an, %ar : %s"
Write-Host "Commit creado: $commitInfo"

# Realizar push
Write-Host "`nPreparando push a GitHub..."
Write-Host "Repositorio: $repoUrl"
Write-Host "Rama: $branchName"
Write-Host "`nPor favor, ingresa tus credenciales de GitHub cuando se te solicite..."
Write-Host "Usuario: $githubUser"
Write-Host "Contrasena: (tu token de acceso personal de GitHub)`n"

try {
    Write-Host "Iniciando push..."
    $pushOutput = git push -u origin $branchName 2>&1
    Write-Host $pushOutput
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`nPush exitoso!"
        Write-Host "Cambios subidos a: https://github.com/$githubUser/$repoName"
        Write-Host "Resumen del push:"
        Write-Host "- Archivos modificados: $($modifiedFiles.Count)"
        Write-Host "- Archivos nuevos: $($addedFiles.Count)"
        Write-Host "- Archivos eliminados: $($deletedFiles.Count)"
        Write-Host "- Tamaño total: $([math]::Round($totalSize/1KB, 2)) KB"
        Write-Host "- Tiempo de subida: $(Get-EstimatedUploadTime $totalSize)"
        if ($largeFiles.Count -gt 0) {
            Write-Host "- Archivos grandes: $($largeFiles.Count)"
        }
    } else {
        throw "Error en el push"
    }
} catch {
    Write-Host "`nError durante el push:"
    Write-Host "Codigo de error: $LASTEXITCODE"
    Write-Host "Mensaje: $_"
    Write-Host "`nPor favor, verifica:"
    Write-Host "1. Que el repositorio $repoName existe en GitHub"
    Write-Host "2. Que tienes permisos para escribir en el repositorio"
    Write-Host "3. Que tus credenciales son correctas"
    Write-Host "4. Que tienes conexion a internet"
    exit
}

Write-Host "`nBackup en GitHub completado" 
# Configuración
$commitMessage = "Backup automático - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$githubUser = "MartinAlejandroOviedo"
$repoName = "keptoken2"
$repoUrl = "https://github.com/$githubUser/$repoName.git"
$branchName = "main"

# Configuración de usuario por defecto
$defaultUserName = "MartinAlejandroOviedo"
$defaultUserEmail = "quamagi@hotmail.com"

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
Write-Host "Verificando conexión con GitHub..."
try {
    $remoteStatus = git remote -v
    if (-not ($remoteStatus -match $repoUrl)) {
        Write-Host "Actualizando URL del repositorio remoto..."
        git remote set-url origin $repoUrl
    }
} catch {
    Write-Host "Error al verificar conexión con GitHub: $_"
    exit
}

# Configurar rama principal
Write-Host "Configurando rama principal..."
git branch -M $branchName

# Verificar estado del repositorio
Write-Host "Verificando estado del repositorio..."
git status

# Agregar cambios
Write-Host "Agregando cambios..."
git add .

# Hacer commit sin firma
Write-Host "Creando commit..."
git commit -m $commitMessage

# Verificar si hay cambios para push
$status = git status
if ($status -match "Your branch is ahead of 'origin/$branchName'") {
    Write-Host "Subiendo cambios a GitHub..."
    try {
        git push -u origin $branchName
        Write-Host "Cambios subidos exitosamente a GitHub"
    } catch {
        Write-Host "Error al subir cambios: $_"
        Write-Host "Intentando con token de acceso personal..."
        $token = Read-Host "Ingresa tu token de acceso personal de GitHub"
        $authUrl = $repoUrl -replace "https://", "https://$token@"
        git remote set-url origin $authUrl
        git push -u origin $branchName
    }
} else {
    Write-Host "No hay cambios nuevos para subir"
}

# Limpiar credenciales temporales
if ($token) {
    git remote set-url origin $repoUrl
}

Write-Host "Backup en GitHub completado" 
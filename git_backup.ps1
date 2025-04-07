# Configuración
$commitMessage = "Backup automático - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$githubUser = "MartinAlejandroOviedo"
$repoName = "keptoken2"
$repoUrl = "https://github.com/$githubUser/$repoName.git"
$branchName = "main"
$githubToken = "ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"  # Reemplaza con tu token

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

# Configurar autenticación con token
Write-Host "Configurando autenticación con GitHub..."
$authUrl = $repoUrl -replace "https://", "https://$githubToken@"
git remote set-url origin $authUrl

# Verificar conexión con GitHub
Write-Host "Verificando conexión con GitHub..."
try {
    $remoteStatus = git remote -v
    if (-not ($remoteStatus -match $repoUrl)) {
        Write-Host "Actualizando URL del repositorio remoto..."
        git remote set-url origin $authUrl
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

# Realizar push
Write-Host "Subiendo cambios a GitHub..."
try {
    git push -u origin $branchName --force
    Write-Host "Cambios subidos exitosamente a GitHub"
} catch {
    Write-Host "Error al subir cambios: $_"
    Write-Host "Por favor, verifica:"
    Write-Host "1. Que el repositorio $repoName existe en GitHub"
    Write-Host "2. Que el token de acceso es válido"
    Write-Host "3. Que tienes permisos para escribir en el repositorio"
    exit
}

# Limpiar credenciales
Write-Host "Limpiando credenciales..."
git remote set-url origin $repoUrl

Write-Host "Backup en GitHub completado" 
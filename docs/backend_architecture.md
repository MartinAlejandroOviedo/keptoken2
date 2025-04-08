# Arquitectura del Proyecto - Keeptoken

## 1. Estructura del Proyecto

```
keptoken/
├── backend/                  # Backend de la aplicación
│   ├── api/                 # API REST
│   │   ├── routes.py        # Definición de rutas
│   │   ├── auth.py          # Rutas de autenticación
│   │   └── middleware/      # Middleware de la API
│   ├── services/            # Servicios de negocio
│   │   ├── token_service.py # Lógica de tokens
│   │   └── user_service.py  # Lógica de usuarios
│   ├── models/              # Modelos de datos
│   │   ├── token.py
│   │   └── user.py
│   └── repositories/        # Acceso a datos
│       ├── token_repo.py
│       └── user_repo.py
│
├── frontend/                # Frontend de la aplicación
│   ├── src/
│   │   ├── components/     # Componentes Vue.js
│   │   │   ├── common/     # Componentes comunes
│   │   │   ├── dashboard/  # Componentes del dashboard
│   │   │   └── admin/      # Componentes de administración
│   │   ├── pages/         # Páginas de la aplicación
│   │   │   ├── dashboard/  # Páginas del dashboard
│   │   │   │   ├── home/   # Dashboard principal
│   │   │   │   ├── tokens/ # Gestión de tokens
│   │   │   │   └── profile/# Perfil de usuario
│   │   │   └── admin/      # Páginas de administración
│   │   ├── layouts/       # Layouts principales
│   │   │   ├── MainLayout.vue    # Layout principal
│   │   │   ├── DashboardLayout.vue # Layout del dashboard
│   │   │   └── AdminLayout.vue   # Layout de administración
│   │   └── styles/        # Estilos globales
│   │       ├── tailwind.css
│   │       └── custom.css
│   └── public/            # Archivos estáticos del frontend
│       ├── index.html
│       ├── favicon.ico
│       └── assets/
│
├── server/                    # Configuración del servidor
│   ├── config/               # Archivos de configuración
│   │   ├── development.py
│   │   ├── production.py
│   │   └── testing.py
│   ├── db/                   # Base de datos y migraciones
│   │   ├── data.db          # Archivo SQLite
│   │   ├── backups/         # Copias de seguridad
│   │   └── migrations/      # Scripts de migración
│   └── utils/               # Utilidades del servidor
│       ├── security.py
│       └── helpers.py
│
├── public/                   # Archivos públicos del servidor
│   ├── assets/              # Recursos estáticos
│   │   ├── css/
│   │   ├── js/
│   │   ├── img/
│   │   └── fonts/
│   └── uploads/             # Archivos subidos por usuarios
│
└── scripts/                # Scripts de utilidad
    ├── init_db.ps1        # Inicialización de la base de datos
    ├── backup.ps1         # Copias de seguridad
    └── maintenance.ps1    # Mantenimiento del sistema
```

## 2. Flujo de Comunicación

### Frontend -> Backend -> Base de Datos
1. **Frontend (HTML/JS)**:
   - Realiza peticiones HTTP a la API
   - Maneja la interfaz de usuario
   - No tiene acceso directo a la base de datos

2. **Backend (Flask)**:
   - Procesa peticiones HTTP
   - Implementa lógica de negocio
   - Maneja autenticación y autorización
   - Valida datos antes de procesarlos

3. **Base de Datos (SQLite)**:
   - Almacena datos persistentes
   - Solo accesible a través del backend
   - Implementa relaciones y restricciones

## 3. Seguridad Implementada

### Autenticación y Autorización
- JWT para autenticación
- Tokens con expiración
- Control de acceso basado en roles
- Validación de tokens en cada petición

### Protección de Datos
- Encriptación de tokens sensibles
- Validación de entrada de datos
- Sanitización de datos
- Protección contra CSRF

### Auditoría
- Registro de operaciones
- Trazabilidad de cambios
- Monitoreo de acceso
- Logs de seguridad

## 4. API REST Endpoints

### Autenticación
- `POST /auth/login`: Inicio de sesión
- `POST /auth/refresh`: Renovación de token
- `POST /auth/logout`: Cierre de sesión

### Usuarios
- `GET /users`: Lista de usuarios (admin)
- `GET /users/<id>`: Detalles de usuario
- `POST /users`: Crear usuario
- `PUT /users/<id>`: Actualizar usuario
- `DELETE /users/<id>`: Eliminar usuario

### Tokens
- `GET /tokens`: Lista de tokens del usuario
- `POST /tokens`: Crear nuevo token
- `GET /tokens/<id>`: Obtener token específico
- `PUT /tokens/<id>`: Actualizar token
- `DELETE /tokens/<id>`: Eliminar token

## 5. Servicios Implementados

### TokenService
- Creación de tokens
- Validación de tokens
- Gestión de expiración
- Encriptación de valores

### UserService
- Gestión de usuarios
- Autenticación
- Autorización
- Perfiles de usuario

## 6. Interfaz Web y Dashboard

### Estructura del Dashboard
1. **Área de Usuario**:
   - Panel de control principal
   - Gestión de tokens
   - Perfil de usuario
   - Configuración de cuenta

2. **Área de Administración**:
   - Gestión de usuarios
   - Estadísticas del sistema
   - Configuración global
   - Logs y auditoría

### Componentes Principales
1. **Dashboard Principal**:
   - Resumen de tokens
   - Actividad reciente
   - Estadísticas de uso
   - Notificaciones

2. **Gestión de Tokens**:
   - Lista de tokens
   - Creación/edición
   - Filtros y búsqueda
   - Exportación de datos

3. **Panel de Administración**:
   - Gestión de usuarios
   - Monitoreo del sistema
   - Configuración avanzada
   - Reportes y análisis

### Tecnologías Frontend
- Vue.js para componentes
- Tailwind CSS para estilos
- Boxicons para iconos
- Chart.js para gráficos
- Axios para peticiones HTTP

## 7. Próximos Pasos

1. **Desarrollo**:
   - Implementar sistema de migraciones
   - Agregar pruebas unitarias
   - Mejorar manejo de errores
   - Optimizar consultas SQL

2. **Seguridad**:
   - Implementar 2FA
   - Agregar rate limiting
   - Mejorar encriptación
   - Auditoría detallada

3. **Frontend**:
   - Implementar interfaz responsive
   - Agregar validaciones
   - Mejorar UX/UI
   - Optimizar rendimiento

4. **Despliegue**:
   - Configurar CI/CD
   - Automatizar backups
   - Monitoreo de sistema
   - Documentación API 
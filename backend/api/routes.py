from flask import Blueprint, jsonify, request, Flask, send_from_directory, render_template_string
from functools import wraps
import jwt
from datetime import datetime, timedelta
import os

# Crear blueprint para la API
api = Blueprint('api', __name__)

# Configuración de JWT
SECRET_KEY = "tu-clave-secreta-aqui"  # Debería estar en variables de entorno
TOKEN_EXPIRATION = 3600  # 1 hora en segundos

# Decorador para verificar el token JWT
def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('Authorization')
        if not token:
            return jsonify({'message': 'Token no proporcionado'}), 401
        
        try:
            # Remover 'Bearer ' del token
            token = token.split(' ')[1]
            data = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
            current_user = data['user']
        except:
            return jsonify({'message': 'Token inválido'}), 401
        
        return f(current_user, *args, **kwargs)
    return decorated

# Rutas de autenticación
@api.route('/auth/login', methods=['POST'])
def login():
    data = request.get_json()
    # Aquí iría la lógica de autenticación
    token = jwt.encode({
        'user': data['username'],
        'exp': datetime.utcnow() + timedelta(seconds=TOKEN_EXPIRATION)
    }, SECRET_KEY)
    return jsonify({'token': token})

# Rutas de usuarios
@api.route('/users', methods=['GET'])
@token_required
def get_users(current_user):
    # Solo usuarios autorizados pueden ver la lista
    if current_user['role'] != 'admin':
        return jsonify({'message': 'No autorizado'}), 403
    # Lógica para obtener usuarios
    return jsonify({'users': []})

@api.route('/users/<int:user_id>', methods=['GET'])
@token_required
def get_user(current_user, user_id):
    # Lógica para obtener un usuario específico
    return jsonify({'user': {}})

# Rutas de tokens
@api.route('/tokens', methods=['GET'])
@token_required
def get_tokens(current_user):
    # Lógica para obtener tokens del usuario
    return jsonify({'tokens': []})

@api.route('/tokens', methods=['POST'])
@token_required
def create_token(current_user):
    data = request.get_json()
    # Lógica para crear un nuevo token
    return jsonify({'message': 'Token creado'})

@api.route('/tokens/<int:token_id>', methods=['DELETE'])
@token_required
def delete_token(current_user, token_id):
    # Lógica para eliminar un token
    return jsonify({'message': 'Token eliminado'})

# Rutas de auditoría
@api.route('/audit', methods=['GET'])
@token_required
def get_audit_logs(current_user):
    if current_user['role'] != 'admin':
        return jsonify({'message': 'No autorizado'}), 403
    # Lógica para obtener logs de auditoría
    return jsonify({'logs': []})

app = Flask(__name__)

# Configurar rutas de archivos estáticos
BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
FRONTEND_DIR = os.path.join(BASE_DIR, 'frontend', 'public')

# Plantilla HTML para el dashboard
DASHBOARD_TEMPLATE = """
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Keeptoken - Dashboard</title>
    <link rel="stylesheet" href="assets/css/tailwind.min.css">
    <link rel="stylesheet" href="assets/css/custom.css">
</head>
<body class="bg-gray-100">
    <div class="min-h-screen">
        <!-- Barra de navegación -->
        <nav class="bg-white shadow-lg">
            <div class="max-w-7xl mx-auto px-4">
                <div class="flex justify-between h-16">
                    <div class="flex">
                        <div class="flex-shrink-0 flex items-center">
                            <span class="text-xl font-bold text-gray-800">Keeptoken</span>
                        </div>
                        <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
                            <a href="/dashboard" class="border-indigo-500 text-gray-900 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                                Dashboard
                            </a>
                            <a href="/tokens" class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                                Tokens
                            </a>
                            <a href="/settings" class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                                Configuración
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Contenido principal -->
        <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
            <div class="px-4 py-6 sm:px-0">
                <div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
                    <!-- Tarjeta de estadísticas -->
                    <div class="bg-white overflow-hidden shadow rounded-lg">
                        <div class="p-5">
                            <div class="flex items-center">
                                <div class="flex-shrink-0">
                                    <svg class="h-6 w-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"></path>
                                    </svg>
                                </div>
                                <div class="ml-5 w-0 flex-1">
                                    <dl>
                                        <dt class="text-sm font-medium text-gray-500 truncate">
                                            Tokens Activos
                                        </dt>
                                        <dd class="flex items-baseline">
                                            <div class="text-2xl font-semibold text-gray-900">
                                                0
                                            </div>
                                        </dd>
                                    </dl>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Tarjeta de actividad reciente -->
                    <div class="bg-white overflow-hidden shadow rounded-lg">
                        <div class="p-5">
                            <div class="flex items-center">
                                <div class="flex-shrink-0">
                                    <svg class="h-6 w-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                    </svg>
                                </div>
                                <div class="ml-5 w-0 flex-1">
                                    <dl>
                                        <dt class="text-sm font-medium text-gray-500 truncate">
                                            Actividad Reciente
                                        </dt>
                                        <dd class="text-sm text-gray-900">
                                            No hay actividad reciente
                                        </dd>
                                    </dl>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Tarjeta de estado del sistema -->
                    <div class="bg-white overflow-hidden shadow rounded-lg">
                        <div class="p-5">
                            <div class="flex items-center">
                                <div class="flex-shrink-0">
                                    <svg class="h-6 w-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path>
                                    </svg>
                                </div>
                                <div class="ml-5 w-0 flex-1">
                                    <dl>
                                        <dt class="text-sm font-medium text-gray-500 truncate">
                                            Estado del Sistema
                                        </dt>
                                        <dd class="text-sm text-green-600">
                                            Operativo
                                        </dd>
                                    </dl>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    <script src="assets/js/app.js"></script>
</body>
</html>
"""

@app.route('/')
def index():
    return send_from_directory(FRONTEND_DIR, 'index.html')

@app.route('/dashboard')
def dashboard():
    return render_template_string(DASHBOARD_TEMPLATE)

@app.route('/<path:path>')
def serve_static(path):
    return send_from_directory(FRONTEND_DIR, path)

if __name__ == '__main__':
    app.run(debug=True) 
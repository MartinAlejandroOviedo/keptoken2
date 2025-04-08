from flask import Flask, render_template, send_from_directory
from flask_cors import CORS
from flask_restx import Api
from prometheus_client import make_wsgi_app
from werkzeug.middleware.dispatcher import DispatcherMiddleware
import os

# Crear la aplicación Flask
app = Flask(__name__)
CORS(app)

# Configurar la API REST
api = Api(app, version='1.0', title='Keeptoken API',
          description='API para el sistema Keeptoken',
          doc='/api/docs',
          prefix='/api')

# Configurar Prometheus
app.wsgi_app = DispatcherMiddleware(app.wsgi_app, {
    '/metrics': make_wsgi_app()
})

# Configurar las carpetas de templates y archivos estáticos
app.template_folder = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), 'frontend/public')
app.static_folder = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), 'frontend/public/assets')

# Ruta principal
@app.route('/')
def index():
    return render_template('index.html')

# Ruta para archivos estáticos
@app.route('/assets/<path:path>')
def serve_assets(path):
    return send_from_directory(app.static_folder, path)

# Ruta del dashboard
@app.route('/dashboard')
def dashboard():
    return render_template('dashboard.html') 
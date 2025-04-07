from flask import Flask, jsonify, request
from flask_cors import CORS
import psycopg2
from psycopg2 import sql
import os
from dotenv import load_dotenv
from flask_debugtoolbar import DebugToolbarExtension
from prometheus_client import make_wsgi_app, Counter, Histogram
from werkzeug.middleware.dispatcher import DispatcherMiddleware
from flask_restx import Api, Resource, fields
import time
import psutil

# Cargar variables de entorno
load_dotenv()

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

# Configuración de la API con Swagger
api = Api(
    app,
    version='1.0',
    title='API Dashboard',
    description='API para el dashboard de la aplicación',
    doc='/docs'
)

# Configuración de Debug Toolbar
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'dev')
app.config['DEBUG_TB_INTERCEPT_REDIRECTS'] = False
toolbar = DebugToolbarExtension(app)

# Modelos para la documentación
health_model = api.model('Health', {
    'status': fields.String(description='Estado del servicio'),
    'system_metrics': fields.Nested(api.model('SystemMetrics', {
        'cpu_percent': fields.Float(description='Porcentaje de uso de CPU'),
        'memory_percent': fields.Float(description='Porcentaje de uso de memoria'),
        'disk_percent': fields.Float(description='Porcentaje de uso de disco')
    }))
})

post_model = api.model('Post', {
    'id': fields.Integer(description='ID del post'),
    'title': fields.String(description='Título del post'),
    'content': fields.String(description='Contenido del post'),
    'created_at': fields.DateTime(description='Fecha de creación')
})

# Métricas Prometheus
REQUEST_COUNT = Counter('http_requests_total', 'Total HTTP requests')
REQUEST_LATENCY = Histogram('http_request_latency_seconds', 'HTTP request latency')

# Configuración de la base de datos
DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'postgres'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', ''),
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', '5432')
}

def get_db_connection():
    return psycopg2.connect(**DB_CONFIG)

@app.before_request
def before_request():
    request.start_time = time.time()

@app.after_request
def after_request(response):
    # Registrar métricas
    REQUEST_COUNT.inc()
    REQUEST_LATENCY.observe(time.time() - request.start_time)
    return response

@api.route('/api/health')
class Health(Resource):
    @api.doc('get_health')
    @api.marshal_with(health_model)
    def get(self):
        # Obtener métricas del sistema
        cpu_percent = psutil.cpu_percent()
        memory = psutil.virtual_memory()
        disk = psutil.disk_usage('/')
        
        return {
            "status": "ok",
            "system_metrics": {
                "cpu_percent": cpu_percent,
                "memory_percent": memory.percent,
                "disk_percent": disk.percent
            }
        }

@api.route('/api/posts')
class Posts(Resource):
    @api.doc('get_posts')
    @api.marshal_list_with(post_model)
    def get(self):
        try:
            conn = get_db_connection()
            cur = conn.cursor()
            cur.execute("SELECT * FROM meta.posts ORDER BY created_at DESC")
            posts = cur.fetchall()
            cur.close()
            conn.close()
            return posts
        except Exception as e:
            api.abort(500, str(e))

# Agregar endpoint de métricas Prometheus
app.wsgi_app = DispatcherMiddleware(app.wsgi_app, {
    '/metrics': make_wsgi_app()
})

if __name__ == '__main__':
    app.run(debug=True, port=5000) 
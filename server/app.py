from flask import Flask, jsonify, request
from flask_cors import CORS
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
    title='API Keeptoken',
    description='API para la gestión de tokens',
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

# Métricas Prometheus
REQUEST_COUNT = Counter('http_requests_total', 'Total HTTP requests')
REQUEST_LATENCY = Histogram('http_request_latency_seconds', 'HTTP request latency')

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
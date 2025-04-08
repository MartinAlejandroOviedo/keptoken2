from server.api.routes import app

if __name__ == '__main__':
    print("Iniciando servidor Keeptoken...")
    print("Servidor disponible en: http://localhost:5000")
    app.run(debug=True, host='0.0.0.0', port=5000) 
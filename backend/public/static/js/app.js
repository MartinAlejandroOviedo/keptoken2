// Esperar a que el DOM esté completamente cargado
document.addEventListener('DOMContentLoaded', function() {
    // Código para inicializar la aplicación
    console.log('Keeptoken iniciado');
    
    // Ejemplo de funcionalidad: Actualizar la hora
    function updateTime() {
        const now = new Date();
        console.log('Hora actual:', now.toLocaleTimeString());
    }
    
    // Actualizar la hora cada segundo
    setInterval(updateTime, 1000);
    
    // Manejar clics en las tarjetas
    const cards = document.querySelectorAll('.card');
    cards.forEach(card => {
        card.addEventListener('click', function() {
            const title = this.querySelector('h3').textContent;
            console.log('Card clickada:', title);
            // Aquí puedes agregar la lógica para cada tipo de card
        });
    });
}); 
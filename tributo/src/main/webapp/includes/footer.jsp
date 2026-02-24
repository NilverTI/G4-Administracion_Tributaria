<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<footer class="footer">
    <div class="footer-content">
        <div class="footer-section">
            <h3>Sobre Nosotros</h3>
            <p>Tu empresa de confianza para servicios tributarios de calidad.</p>
        </div>
        
        <div class="footer-section">
            <h3>Enlaces</h3>
            <ul>
                <li><a href="index.jsp">Inicio</a></li>
                <li><a href="servicios.jsp">Servicios</a></li>
                <li><a href="contacto.jsp">Contacto</a></li>
                <li><a href="privacidad.jsp">Privacidad</a></li>
            </ul>
        </div>
        
        <div class="footer-section">
            <h3>Contacto</h3>
            <p>Email: info@tributo.com</p>
            <p>Teléfono: +34 900 123 456</p>
        </div>
        
        <div class="footer-section">
            <h3>Síguenos</h3>
            <ul>
                <li><a href="#facebook">Facebook</a></li>
                <li><a href="#twitter">Twitter</a></li>
                <li><a href="#linkedin">LinkedIn</a></li>
            </ul>
        </div>
    </div>
    
    <div class="footer-bottom">
        <p>&copy; 2024 Tributo. Todos los derechos reservados.</p>
    </div>
</footer>

<style>
    .footer {
        background-color: #333;
        color: #fff;
        padding: 40px 20px;
        margin-top: 50px;
    }
    
    .footer-content {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 30px;
        max-width: 1200px;
        margin: 0 auto 30px;
    }
    
    .footer-section h3 {
        margin-bottom: 15px;
        color: #ffc107;
    }
    
    .footer-section ul {
        list-style: none;
        padding: 0;
    }
    
    .footer-section a {
        color: #ddd;
        text-decoration: none;
    }
    
    .footer-section a:hover {
        color: #ffc107;
    }
    
    .footer-bottom {
        text-align: center;
        border-top: 1px solid #555;
        padding-top: 20px;
        color: #999;
    }
</style>
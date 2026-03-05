<%
    String current = request.getRequestURI();
    String currentTab = request.getParameter("tab");
    boolean cuotasPath = current.contains("/funcionario/cuotas");
    boolean pagosTab = "pagos".equalsIgnoreCase(currentTab);
    boolean esAdmin = session.getAttribute("usuario") != null
            && ((com.tributaria.entity.Usuario) session.getAttribute("usuario")).getRol() != null
            && "ADMIN".equalsIgnoreCase(((com.tributaria.entity.Usuario) session.getAttribute("usuario")).getRol().getNombre());
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="fi fi-rr-chart-histogram"></i></div>
        <div class="brand-text">
            <h3>SAT Municipal</h3>
            <p>Panel Funcionario</p>
        </div>
        <button class="sidebar-toggle" type="button" title="Ocultar menu">
            <i class="fi fi-rr-angle-left"></i>
        </button>
    </div>

    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/funcionario/dashboard"
           class="nav-item <%= current.contains("/funcionario/dashboard") ? "active" : "" %>"
           title="Dashboard">
            <span class="icon"><i class="fi fi-rr-chart-pie-alt"></i></span>
            <span class="nav-label">Dashboard</span>
        </a>

        <a href="${pageContext.request.contextPath}/funcionario/contribuyente"
           class="nav-item <%= current.contains("/funcionario/contribuyente") ? "active" : "" %>"
           title="Contribuyentes">
            <span class="icon"><i class="fi fi-rr-users"></i></span>
            <span class="nav-label">Contribuyentes</span>
        </a>

        <a href="${pageContext.request.contextPath}/funcionario/inmueble"
           class="nav-item <%= current.contains("/funcionario/inmueble") ? "active" : "" %>"
           title="Inmuebles">
            <span class="icon"><i class="fi fi-rr-building"></i></span>
            <span class="nav-label">Inmuebles</span>
        </a>

        <a href="${pageContext.request.contextPath}/funcionario/vehiculo"
           class="nav-item <%= current.contains("/funcionario/vehiculo") ? "active" : "" %>"
           title="Vehiculos">
            <span class="icon"><i class="fi fi-rr-car"></i></span>
            <span class="nav-label">Vehiculos</span>
        </a>

        <a href="${pageContext.request.contextPath}/funcionario/impuesto"
           class="nav-item <%= current.contains("/funcionario/impuesto") ? "active" : "" %>"
           title="Impuestos">
            <span class="icon"><i class="fi fi-rr-receipt"></i></span>
            <span class="nav-label">Impuestos</span>
        </a>

        <a href="${pageContext.request.contextPath}/funcionario/cuotas?tab=cuotas"
           class="nav-item <%= cuotasPath && !pagosTab ? "active" : "" %>"
           title="Cuotas">
            <span class="icon"><i class="fi fi-rr-calendar"></i></span>
            <span class="nav-label">Cuotas</span>
        </a>

        <a href="${pageContext.request.contextPath}/funcionario/cuotas?tab=pagos"
           class="nav-item <%= cuotasPath && pagosTab ? "active" : "" %>"
           title="Pagos">
            <span class="icon"><i class="fi fi-rr-credit-card"></i></span>
            <span class="nav-label">Pagos</span>
        </a>

        <% if (esAdmin) { %>
        <a href="${pageContext.request.contextPath}/funcionario/configuracion"
           class="nav-item <%= current.contains("/funcionario/configuracion") ? "active" : "" %>"
           title="Configuracion">
            <span class="icon"><i class="fi fi-rr-settings"></i></span>
            <span class="nav-label">Configuracion</span>
        </a>
        <% } %>
    </nav>

    <div class="sidebar-user">
        <div class="user-avatar">${sessionScope.usuario.persona.nombres.charAt(0)}</div>
        <div class="user-info">
            <h4>${sessionScope.usuario.persona.nombres}</h4>
            <p>${sessionScope.usuario.username}</p>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Cerrar sesion">
            <i class="fi fi-rr-sign-out-alt"></i>
        </a>
    </div>
</aside>
<script src="${pageContext.request.contextPath}/js/app-shell.js?v=20260303-1"></script>

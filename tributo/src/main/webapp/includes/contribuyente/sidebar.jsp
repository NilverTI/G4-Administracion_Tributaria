<%
    String current = request.getRequestURI();
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<aside class="sidebar contribuyente-sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="fi fi-rr-file-invoice-dollar"></i></div>
        <div class="brand-text">
            <h3>SAT Municipal</h3>
            <p>Portal Contribuyente</p>
        </div>
        <button class="sidebar-toggle" type="button" title="Ocultar menu">
            <i class="fi fi-rr-angle-left"></i>
        </button>
    </div>

    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/contribuyente/dashboard"
           class="nav-item <%= current.contains("/contribuyente/dashboard") ? "active" : "" %>"
           title="Dashboard">
            <span class="icon"><i class="fi fi-rr-chart-pie-alt"></i></span>
            <span class="nav-label">Dashboard</span>
        </a>

        <a href="${pageContext.request.contextPath}/contribuyente/impuesto"
           class="nav-item <%= current.contains("/contribuyente/impuesto") ? "active" : "" %>"
           title="Mis Impuestos">
            <span class="icon"><i class="fi fi-rr-receipt"></i></span>
            <span class="nav-label">Mis Impuestos</span>
        </a>

        <a href="${pageContext.request.contextPath}/contribuyente/cuotas"
           class="nav-item <%= current.contains("/contribuyente/cuotas") ? "active" : "" %>"
           title="Mis Cuotas">
            <span class="icon"><i class="fi fi-rr-calendar"></i></span>
            <span class="nav-label">Mis Cuotas</span>
        </a>

        <a href="${pageContext.request.contextPath}/contribuyente/pagos"
           class="nav-item <%= current.contains("/contribuyente/pagos") ? "active" : "" %>"
           title="Pagos">
            <span class="icon"><i class="fi fi-rr-credit-card"></i></span>
            <span class="nav-label">Pagos</span>
        </a>

        <a href="${pageContext.request.contextPath}/contribuyente/bienes"
           class="nav-item <%= current.contains("/contribuyente/bienes") ? "active" : "" %>"
           title="Mis Bienes">
            <span class="icon"><i class="fi fi-rr-building"></i></span>
            <span class="nav-label">Mis Bienes</span>
        </a>

        <a href="${pageContext.request.contextPath}/contribuyente/perfil"
           class="nav-item <%= current.contains("/contribuyente/perfil") ? "active" : "" %>"
           title="Perfil">
            <span class="icon"><i class="fi fi-rr-user"></i></span>
            <span class="nav-label">Perfil</span>
        </a>
    </nav>

    <div class="sidebar-user">
        <div class="user-avatar">${sessionScope.usuario.persona.nombres.charAt(0)}</div>
        <div class="user-info">
            <h4>${sessionScope.usuario.persona.nombres} ${sessionScope.usuario.persona.apellidos}</h4>
            <p>${sessionScope.usuario.username}</p>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Cerrar sesion">
            <i class="fi fi-rr-sign-out-alt"></i>
        </a>
    </div>
</aside>
<script src="${pageContext.request.contextPath}/js/app-shell.js?v=20260303-1"></script>

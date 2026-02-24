<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String current = request.getRequestURI();
    String ctx = request.getContextPath();

    com.tributaria.entity.Usuario u =
            (com.tributaria.entity.Usuario) session.getAttribute("usuario");

    String nombres = (u != null && u.getPersona() != null && u.getPersona().getNombres() != null)
            ? u.getPersona().getNombres()
            : "Usuario";
%>

<aside class="sidebar" id="sidebar">
  <div class="sidebar-brand">
    <div class="brand-icon"><i class="fi fi-rr-chart-histogram"></i></div>

    <div class="brand-text">
      <h3>SAT Municipal</h3>
      <p>Panel Funcionario</p>
    </div>

    <button class="sidebar-toggle" id="sidebarToggle" type="button" aria-label="Colapsar sidebar">
      <i class="fi fi-rr-angle-left"></i>
    </button>
  </div>

  <nav class="sidebar-nav">
    <a href="<%= ctx %>/funcionario/dashboard"
       data-title="Dashboard"
       class="nav-item <%= current.contains("/funcionario/dashboard") ? "active" : "" %>">
      <span class="icon"><i class="fi fi-rr-chart-pie-alt"></i></span>
      <span class="label">Dashboard</span>
    </a>

    <a href="<%= ctx %>/funcionario/contribuyente"
       data-title="Contribuyentes"
       class="nav-item <%= current.contains("/funcionario/contribuyente") ? "active" : "" %>">
      <span class="icon"><i class="fi fi-rr-users"></i></span>
      <span class="label">Contribuyentes</span>
    </a>

    <a href="<%= ctx %>/funcionario/inmueble"
       data-title="Inmuebles"
       class="nav-item <%= current.contains("/funcionario/inmueble") ? "active" : "" %>">
      <span class="icon"><i class="fi fi-rr-building"></i></span>
      <span class="label">Inmuebles</span>
    </a>

    <a href="<%= ctx %>/funcionario/vehiculo"
       data-title="Vehículos"
       class="nav-item <%= current.contains("/funcionario/vehiculo") ? "active" : "" %>">
      <span class="icon"><i class="fi fi-rr-car"></i></span>
      <span class="label">Vehículos</span>
    </a>

    <a href="<%= ctx %>/funcionario/impuesto"
       data-title="Impuestos"
       class="nav-item <%= current.contains("/funcionario/impuesto") ? "active" : "" %>">
      <span class="icon"><i class="fi fi-rr-receipt"></i></span>
      <span class="label">Impuestos</span>
    </a>

    <a href="<%= ctx %>/funcionario/cuota"
       data-title="Cuotas"
       class="nav-item <%= current.contains("/funcionario/cuota") ? "active" : "" %>">
      <span class="icon"><i class="fi fi-rr-calendar"></i></span>
      <span class="label">Cuotas</span>
    </a>

    <a href="<%= ctx %>/funcionario/pago"
       data-title="Pagos"
       class="nav-item <%= current.contains("/funcionario/pago") ? "active" : "" %>">
      <span class="icon"><i class="fi fi-rr-credit-card"></i></span>
      <span class="label">Pagos</span>
    </a>

    <!--
    <button class="nav-item" type="button" data-title="Reportes">
      <span class="icon"><i class="fi fi-rr-stats"></i></span>
      <span class="label">Reportes</span>
    </button>
    -->

    <a href="<%= ctx %>/funcionario/configuracion"
       data-title="Configuración"
       class="nav-item <%= current.contains("/funcionario/configuracion") ? "active" : "" %>">
      <span class="icon"><i class="fi fi-rr-settings"></i></span>
      <span class="label">Configuración</span>
    </a>
  </nav>

  <div class="sidebar-user">
    <div class="user-avatar">AT</div>

    <div class="user-info">
      <h4><%= nombres %></h4>
      <p>admin@sat.gob.pe</p>
    </div>

    <a class="logout-btn" href="<%= ctx %>/logout" title="Cerrar sesión">
      <i class="fi fi-rr-sign-out-alt"></i>
    </a>
  </div>
</aside>

<script src="<%= request.getContextPath() %>/js/sidebar.js"></script>
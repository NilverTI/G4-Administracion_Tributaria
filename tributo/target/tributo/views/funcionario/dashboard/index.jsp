<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SAT Municipal - Panel Funcionario</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">

    <!-- Flaticon -->
    <link rel="stylesheet"
          href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

    <!-- Chart.js -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js"></script>

    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>

<body>

<%@ include file="/includes/sidebar.jsp" %>

<main class="main">

    <%@ include file="/includes/topbar.jsp" %>

    <div class="content">

        <div class="page-header">
        <h1>Bienvenido, ${sessionScope.usuario.persona.nombres}</h1>
        <p>Resumen general del sistema tributario</p>
      </div>

      <!-- STAT CARDS -->
      <div class="stat-grid">
        <div class="stat-card">
          <div class="stat-top">
            <span class="stat-label">Contribuyentes</span>
            <div class="stat-icon icon-blue"><i class="fi fi-rr-users"></i></div>
          </div>
          <div class="stat-value">${totalContribuyentes}</div>
          <span class="stat-badge badge-green"><i class="fi fi-rr-trending-up"></i> ${totalActivos} Activos</span>
        </div>
        <div class="stat-card">
          <div class="stat-top">
            <span class="stat-label">Inmuebles</span>
            <div class="stat-icon icon-blue"><i class="fi fi-rr-building"></i></div>
          </div>
          <div class="stat-value">${totalInmuebles}</div>
          <span class="stat-badge badge-green">${totalInmuebles} Activos</span>
        </div>
        <div class="stat-card">
          <div class="stat-top">
            <span class="stat-label">Vehículos</span>
            <div class="stat-icon icon-blue"><i class="fi fi-rr-car"></i></div>
          </div>
          <div class="stat-value">${totalVehiculos}</div>
          <span class="stat-badge badge-green">${totalVehiculos} Activos</span>
        </div>
        <div class="stat-card">
          <div class="stat-top">
            <span class="stat-label">Deuda Pendiente</span>
            <div class="stat-icon icon-amber"><i class="fi fi-rr-dollar"></i></div>
          </div>
          <div class="stat-value" style="font-size:20px;">S/ 14,675</div>
          <span class="stat-badge badge-red"><i class="fi fi-rr-triangle-warning"></i> Por cobrar</span>
        </div>
        <div class="stat-card">
          <div class="stat-top">
            <span class="stat-label">Recaudado 2025</span>
            <div class="stat-icon icon-green"><i class="fi fi-rr-chart-line-up"></i></div>
          </div>
          <div class="stat-value" style="font-size:20px;">S/ 6,300</div>
          <span class="stat-badge badge-green"><i class="fi fi-rr-trending-up"></i> +8.5%</span>
        </div>
      </div>

      <!-- BOTTOM -->
      <div class="bottom-grid">
        <div class="card">
          <div class="card-header">
            <span class="card-title">Recaudación Mensual 2025</span>
            <div class="filter-btns">
              <button class="filter-btn active">Mensual</button>
              <button class="filter-btn">Trimestral</button>
              <button class="filter-btn">Anual</button>
            </div>
          </div>
          <div class="chart-wrap">
            <canvas id="recaudacionChart"></canvas>
          </div>
          <div class="chart-legend">
            <div class="legend-item">
              <div class="legend-dot" style="background:#0f1f3d"></div>Predial
            </div>
            <div class="legend-item">
              <div class="legend-dot" style="background:#38bdf8"></div>Vehicular
            </div>
            <div class="legend-item">
              <div class="legend-dot" style="background:#10b981"></div>Alcabala
            </div>
          </div>
        </div>

        <div class="card vencidos-card">
          <div class="vencido-header">
            <span class="warn-icon"><i class="fi fi-rr-triangle-warning"></i></span>
            <h3>Impuestos Vencidos</h3>
          </div>

          <div class="vencido-item">
            <div class="vencido-top">
              <span class="vencido-name">Juan Perez Ramirez</span>
              <span class="tag-vencido">Vencido</span>
            </div>
            <div class="vencido-sub">Predial · 2025</div>
            <div class="vencido-amount">S/ 5,600.00</div>
          </div>

          <div class="vencido-item">
            <div class="vencido-top">
              <span class="vencido-name">Carmen Diaz Flores</span>
              <span class="tag-vencido">Vencido</span>
            </div>
            <div class="vencido-sub">Predial · 2025</div>
            <div class="vencido-amount">S/ 1,800.00</div>
          </div>

          <div class="vencido-item">
            <div class="vencido-top">
              <span class="vencido-name">Luis Torres Quispe</span>
              <span class="tag-pendiente">Por vencer</span>
            </div>
            <div class="vencido-sub">Vehicular · 2025</div>
            <div class="vencido-amount">S/ 920.00</div>
          </div>

          <button class="ver-todos"><i class="fi fi-rr-list"></i> Ver todos los vencidos</button>
        </div>
      </div>

    </div>

</main>

<script src="${pageContext.request.contextPath}/js/dashboard.js"></script>

</body>
</html>

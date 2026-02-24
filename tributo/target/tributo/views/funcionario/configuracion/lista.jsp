<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>SAT Municipal - Configuración</title>

  <!-- ✅ CSS GLOBAL (orden correcto) -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css">

  <!-- ✅ CSS DE ESTA PÁGINA -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/configuracion.css">

  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">

  <!-- Flaticon -->
  <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">
</head>

<body>

  <%@ include file="/includes/sidebar.jsp" %>

  <main class="main">

    <%@ include file="/includes/topbar.jsp" %>

    <section class="content">

      <!-- Header -->
      <div class="page-header">
        <div class="page-header-left">
          <h1>Configuración</h1>
          <p>Parámetros del sistema tributario</p>
        </div>
      </div>

      <!-- Tabs -->
      <div class="tabs" role="tablist" aria-label="Configuración">
        <button type="button" class="tab-btn active" data-tab="zonas" aria-selected="true">Zonas y Tasas</button>
        <button type="button" class="tab-btn" data-tab="uit" aria-selected="false">UIT por Año</button>
        <button type="button" class="tab-btn" data-tab="usuarios" aria-selected="false">Usuarios</button>
        <button type="button" class="tab-btn" data-tab="bitacora" aria-selected="false">Bitácora</button>
      </div>

      <!-- ✅ Card tabla (Zonas y Tasas) -->
      <div class="table-card" id="panel-zonas">

        <div class="table-card-header">
          <div class="table-card-title">
            <h2>Zonas y Tasas</h2>
            <p>Tasas tributarias por zona geográfica</p>
          </div>

          <button type="button" class="btn-primary" id="btnAgregar">
            <i class="fi fi-rr-plus"></i> Agregar
          </button>
        </div>

        <table class="data-table">
          <thead>
            <tr>
              <th style="width: 25%;">ID</th>
              <th>Zona</th>
              <th style="width: 20%; text-align:right;">Tasa</th>
            </tr>
          </thead>

          <tbody id="tbodyZonas">
            <!-- Render por JS o servidor -->
            <%-- Ejemplo si viene del backend:
            <c:forEach var="z" items="${zonas}">
              <tr>
                <td>${z.id}</td>
                <td>${z.nombre}</td>
                <td style="text-align:right;">${z.tasa}%</td>
              </tr>
            </c:forEach>
            --%>
          </tbody>
        </table>

        <!-- ✅ Footer integrado como tus otras páginas -->
        <div class="table-footer">
          <div class="table-info" id="tableInfo">Mostrando 0 de 0</div>
          <div id="pagination"></div>
        </div>

      </div>

      <!-- Paneles placeholder (por si luego los activas con JS) -->
      <div class="table-card" id="panel-uit" style="display:none;">
        <div class="table-card-header">
          <div class="table-card-title">
            <h2>UIT por Año</h2>
            <p>Gestión del valor UIT por año</p>
          </div>
          <button type="button" class="btn-primary" disabled>
            <i class="fi fi-rr-plus"></i> Agregar
          </button>
        </div>
        <div style="padding:18px 20px; color: var(--text-muted); font-size: 13.5px;">
          Próximamente...
        </div>
      </div>

      <div class="table-card" id="panel-usuarios" style="display:none;">
        <div class="table-card-header">
          <div class="table-card-title">
            <h2>Usuarios</h2>
            <p>Gestión de usuarios del sistema</p>
          </div>
          <button type="button" class="btn-primary" disabled>
            <i class="fi fi-rr-plus"></i> Agregar
          </button>
        </div>
        <div style="padding:18px 20px; color: var(--text-muted); font-size: 13.5px;">
          Próximamente...
        </div>
      </div>

      <div class="table-card" id="panel-bitacora" style="display:none;">
        <div class="table-card-header">
          <div class="table-card-title">
            <h2>Bitácora</h2>
            <p>Registro de acciones del sistema</p>
          </div>
        </div>
        <div style="padding:18px 20px; color: var(--text-muted); font-size: 13.5px;">
          Próximamente...
        </div>
      </div>

    </section>
  </main>

  <!-- ✅ MODAL -->
  <div class="modal-overlay" id="modalOverlay">
    <div class="modal">
      <div class="modal-header">
        <h2>Agregar zona y tasa</h2>
        <button type="button" class="modal-close" id="btnCerrar" title="Cerrar">
          <i class="fi fi-rr-cross-small"></i>
        </button>
      </div>

      <form id="formZona">
        <div class="form-grid">
          <div class="form-group">
            <label class="form-label">ID</label>
            <input class="form-input" type="text" id="zonaId" placeholder="Z005" required />
          </div>

          <div class="form-group">
            <label class="form-label">Zona</label>
            <input class="form-input" type="text" id="zonaNombre" placeholder="Zona E" required />
          </div>

          <div class="form-group full">
            <label class="form-label">Tasa (%)</label>
            <input class="form-input" type="number" step="0.1" id="zonaTasa" placeholder="1.2" required />
          </div>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn-secondary" id="btnCancelar">Cancelar</button>
          <button type="submit" class="btn-primary">
            <i class="fi fi-rr-disk"></i> Guardar
          </button>
        </div>
      </form>
    </div>
  </div>

  <!-- JS -->
  <script src="${pageContext.request.contextPath}/js/configuracion.js"></script>
  <script src="${pageContext.request.contextPath}/js/pagination.js"></script>

</body>
</html>
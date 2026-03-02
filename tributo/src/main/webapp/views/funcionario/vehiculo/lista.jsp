<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gestión de Vehículos</title>

  <!-- CSS GLOBAL -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/vehiculo.css">

  <!-- Google Fonts -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&display=swap">

  <!-- Iconos -->
  <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">
</head>

<body>

<%@ include file="/includes/sidebar.jsp" %>

<main class="main">
  <%@ include file="/includes/topbar.jsp" %>

  <div class="content">

    <!-- HEADER -->
    <div class="page-header">
      <div class="page-header-left">
        <h1>Gestión de Vehículos</h1>
        <p><c:out value="${empty cantidad ? 0 : cantidad}"/> vehículos registrados</p>
      </div>

      <button class="btn-primary" id="btnNuevo" type="button">
        <i class="fi fi-rr-plus"></i> Registrar Vehículo
      </button>
    </div>

    <!-- MENSAJES -->
    <c:if test="${not empty err}">
      <div class="alert alert-error" style="margin-bottom:14px;">
        <i class="fi fi-rr-triangle-warning"></i>
        <span><c:out value="${err}"/></span>
      </div>
    </c:if>

    <c:if test="${not empty ok}">
      <div class="alert alert-success" style="margin-bottom:14px;">
        <i class="fi fi-rr-check"></i>
        <span><c:out value="${ok}"/></span>
      </div>
    </c:if>

    <!-- FILTROS -->
    <div class="filter-bar">
      <div class="filter-search">
        <i class="fi fi-rr-search"></i>
        <input type="text" id="tableSearch" placeholder="Buscar por placa, marca o contribuyente...">
      </div>

      <div class="filter-select">
        <i class="fi fi-rr-filter"></i>
        <select id="estadoFilter">
          <option value="">Todos</option>
          <option value="ACTIVO">Activo</option>
          <option value="INACTIVO">Inactivo</option>
        </select>
      </div>
    </div>

    <!-- TABLA -->
    <div class="table-card">
      <table class="data-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Placa</th>
            <th>Contribuyente</th>
            <th>Vehículo</th>
            <th>Año</th>
            <th>Valor</th>
            <th>Estado</th>
            <th>Registro</th>
            <th>Acciones</th>
          </tr>
        </thead>

        <tbody id="tableBody">
          <c:forEach var="v" items="${lista}">
            <tr data-estado="${v[9]}">
              <td><c:out value="${v[0]}"/></td>

              <td style="font-family:'JetBrains Mono', monospace; font-weight:700;">
                <c:out value="${v[1]}"/>
              </td>

              <td><c:out value="${v[2]}"/></td>
              <td><c:out value="${v[3]}"/></td>
              <td><c:out value="${v[4]}"/></td>

              <td class="td-money">
                S/ <fmt:formatNumber value="${v[5]}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
              </td>

              <td>
                <c:choose>
                  <c:when test="${v[9] == 'ACTIVO'}">
                    <span class="badge badge-activo">Activo</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge badge-inactivo">Inactivo</span>
                  </c:otherwise>
                </c:choose>
              </td>

              <td>
                <fmt:formatDate value="${v[10]}" pattern="dd MMM yyyy"/>
              </td>

              <td>
                <c:choose>
                  <c:when test="${v[9] == 'ACTIVO'}">
                    <a class="toggle-btn activo"
                       href="${pageContext.request.contextPath}/funcionario/vehiculo?action=estado&id=${v[0]}&estado=INACTIVO"
                       title="Desactivar">
                      <i class="fi fi-rr-toggle-on"></i>
                    </a>
                  </c:when>
                  <c:otherwise>
                    <a class="toggle-btn inactivo"
                       href="${pageContext.request.contextPath}/funcionario/vehiculo?action=estado&id=${v[0]}&estado=ACTIVO"
                       title="Activar">
                      <i class="fi fi-rr-toggle-off"></i>
                    </a>
                  </c:otherwise>
                </c:choose>
              </td>
            </tr>
          </c:forEach>

          <c:if test="${empty lista}">
            <tr>
              <td colspan="9" style="padding:18px 20px; text-align:center; color: var(--text-muted);">
                No hay vehículos registrados
              </td>
            </tr>
          </c:if>
        </tbody>
      </table>

      <div class="table-footer">
        <div class="table-info" id="tableInfo">Mostrando 0 de 0</div>
        <div id="pagination"></div>
      </div>
    </div>

  </div>
</main>

<!-- ========================= MODAL ============================= -->
<div class="modal-overlay" id="modalOverlay" aria-hidden="true">
  <div class="modal" role="dialog" aria-modal="true">

    <div class="modal-header">
      <h2>Registrar Vehículo</h2>
      <button type="button" class="modal-close" id="modalClose" title="Cerrar">
        <i class="fi fi-rr-cross-small"></i>
      </button>
    </div>

    <form id="vehiculoForm" method="post" action="${pageContext.request.contextPath}/funcionario/vehiculo">
      <input type="hidden" name="action" value="crear">

      <div class="form-grid">

        <!-- CONTRIBUYENTE BUSCABLE -->
        <div class="form-group full">
          <label class="form-label">Contribuyente</label>

          <div class="cselect" id="csContribuyente">
            <div class="cselect-control">
              <input
                type="text"
                class="form-input cselect-input"
                id="contribuyenteInput"
                placeholder="Buscar contribuyente..."
                autocomplete="off"
              />
              <button type="button" class="cselect-btn" id="contribuyenteToggle" aria-label="Abrir">
                <i class="fi fi-rr-angle-small-down"></i>
              </button>
            </div>

            <div class="cselect-menu" id="contribuyenteMenu" role="listbox" aria-hidden="true"></div>
          </div>

          <!-- valor real -->
          <input type="hidden" name="idContribuyente" id="idContribuyente" required>

          <!-- dataset escondido -->
          <div id="contribuyentesData" style="display:none;">
            <c:forEach var="c" items="${contribuyentes}">
              <span class="contrib-item" data-id="${c[0]}"><c:out value="${c[1]}"/></span>
            </c:forEach>
          </div>

          <small class="hint" id="contribuyenteHint">Escribe para buscar y selecciona uno.</small>
        </div>

        <div class="form-group">
          <label class="form-label">Placa</label>
          <input type="text" name="placa" class="form-input" maxlength="15" required>
        </div>

        <div class="form-group">
          <label class="form-label">Marca</label>
          <input type="text" name="marca" class="form-input" required>
        </div>

        <div class="form-group">
          <label class="form-label">Modelo</label>
          <input type="text" name="modelo" class="form-input" required>
        </div>

        <div class="form-group">
          <label class="form-label">Año</label>
          <input type="number" name="anio" class="form-input" min="1900" max="2100" required>
        </div>

        <div class="form-group">
          <label class="form-label">Fecha de Inscripción</label>
          <input type="date" name="fechaInscripcion" class="form-input" required>
        </div>

        <div class="form-group full">
          <label class="form-label">Valor</label>
          <input type="number" step="0.01" name="valor" class="form-input" required>
        </div>

      </div>

      <div class="modal-footer">
        <button type="button" class="btn-secondary" id="modalCancel">Cancelar</button>
        <button type="submit" class="btn-primary">
          <i class="fi fi-rr-disk"></i> Guardar
        </button>
      </div>
    </form>

  </div>
</div>

<!-- JS -->
<script src="${pageContext.request.contextPath}/js/pagination.js"></script>
<script src="${pageContext.request.contextPath}/js/vehiculo.js?v=4"></script>

</body>
</html>
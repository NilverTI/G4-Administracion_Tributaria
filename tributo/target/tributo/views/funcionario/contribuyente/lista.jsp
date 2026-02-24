<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gestión de Contribuyentes</title>

  <!-- CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css">

  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">
</head>

<body>

<%@ include file="/includes/sidebar.jsp" %>

<main class="main">
  <%@ include file="/includes/topbar.jsp" %>

  <div class="content">

    <div class="page-header">
      <div class="page-header-left">
        <h1>Gestión de Contribuyentes</h1>
        <p>${empty lista ? 0 : lista.size()} contribuyentes registrados</p>
      </div>

      <button class="btn-primary" id="btnNuevo" type="button">
        <i class="fi fi-rr-plus"></i> Nuevo Contribuyente
      </button>
    </div>

    <!-- FILTROS -->
    <div class="filter-bar">
      <div class="filter-search">
        <i class="fi fi-rr-search"></i>
        <input type="text" id="tableSearch" placeholder="Buscar por nombre o DNI...">
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
          <th>DNI</th>
          <th>Nombre</th>
          <th>Email</th>
          <th>Estado</th>
          <th>Acciones</th>
        </tr>
        </thead>

        <tbody id="tableBody">
        <c:forEach var="c" items="${lista}">
          <%-- c[0]=id, c[1]=dni, c[2]=nombres, c[3]=apellidos, c[5]=email, c[7]=estado --%>
          <tr data-estado="${c[7]}">
            <td><c:out value="${c[1]}"/></td>
            <td><c:out value="${c[2]}"/> <c:out value="${c[3]}"/></td>
            <td><c:out value="${c[5]}"/></td>

            <td>
              <c:choose>
                <c:when test="${c[7] == 'ACTIVO'}">
                  <span class="badge badge-activo">Activo</span>
                </c:when>
                <c:otherwise>
                  <span class="badge badge-inactivo">Inactivo</span>
                </c:otherwise>
              </c:choose>
            </td>

            <td>
              <c:choose>
                <c:when test="${c[7] == 'ACTIVO'}">
                  <a class="toggle-btn activo"
                     href="${pageContext.request.contextPath}/funcionario/contribuyente?action=estado&id=${c[0]}&estado=INACTIVO"
                     title="Desactivar">
                    <i class="fi fi-rr-toggle-on"></i>
                  </a>
                </c:when>
                <c:otherwise>
                  <a class="toggle-btn inactivo"
                     href="${pageContext.request.contextPath}/funcionario/contribuyente?action=estado&id=${c[0]}&estado=ACTIVO"
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
            <td colspan="5" class="empty-table" style="padding:18px 20px; text-align:center; color: var(--text-muted);">
              No hay contribuyentes registrados.
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

<!-- MODAL -->
<div class="modal-overlay" id="modalOverlay" aria-hidden="true">
  <div class="modal" role="dialog" aria-modal="true">

    <div class="modal-header">
      <h2>Nuevo Contribuyente</h2>
      <button type="button" class="modal-close" id="modalClose" title="Cerrar">
        <i class="fi fi-rr-cross-small"></i>
      </button>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/funcionario/contribuyente">
      <input type="hidden" name="action" value="crear">
      <input type="hidden" name="tipoDoc" value="DNI">

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">DNI</label>
          <input class="form-input" name="numeroDoc" type="text" maxlength="20" required>
        </div>

        <div class="form-group">
          <label class="form-label">Teléfono</label>
          <input class="form-input" name="telefono" type="text" maxlength="20">
        </div>

        <div class="form-group">
          <label class="form-label">Nombres</label>
          <input class="form-input" name="nombres" type="text" maxlength="100" required>
        </div>

        <div class="form-group">
          <label class="form-label">Apellidos</label>
          <input class="form-input" name="apellidos" type="text" maxlength="100" required>
        </div>

        <div class="form-group full">
          <label class="form-label">Correo electrónico</label>
          <input class="form-input" name="email" type="email" maxlength="150">
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

<script>
  window.__CTX__ = "${pageContext.request.contextPath}";
</script>

<!-- ✅ orden correcto: primero pagination (define initTablePagination), luego contribuyente -->
<script src="${pageContext.request.contextPath}/js/pagination.js"></script>
<script src="${pageContext.request.contextPath}/js/contribuyente.js"></script>

</body>
</html>
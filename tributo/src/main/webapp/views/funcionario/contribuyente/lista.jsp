<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Gestion de Contribuyentes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css?v=20260303-8">

  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">
</head>

<body>

<jsp:include page="/includes/sidebar.jsp" />

<main class="main">
  <jsp:include page="/includes/topbar.jsp" />

  <div class="content">

    <div class="page-header">
      <div class="page-header-left">
        <h1>Gestion de Contribuyentes</h1>
      </div>
      <button class="btn-primary" id="btnNuevo">
        <i class="fi fi-rr-plus"></i> Nuevo Contribuyente
      </button>
    </div>

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

    <div class="table-card">
      <table class="data-table">
        <thead>
          <tr>
            <th>DNI</th>
            <th>Nombre</th>
            <th>Telefono</th>
            <th>Email</th>
            <th>Direccion</th>
            <th>Estado</th>
            <th>Acciones</th>
          </tr>
        </thead>

        <tbody id="tableBody">
          <c:forEach var="c" items="${lista}">
            <tr data-estado="${c[7]}">
              <td class="td-dni">${c[1]}</td>
              <td>
                <div class="contributor-name">${c[2]} ${c[3]}</div>
              </td>
              <td>${empty c[4] ? '-' : c[4]}</td>
              <td class="td-email">${empty c[5] ? '-' : c[5]}</td>
              <td>${empty c[6] ? '-' : c[6]}</td>

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
                <div class="action-group">
                  <a class="action-icon"
                     href="${pageContext.request.contextPath}/funcionario/contribuyente?action=ver&id=${c[0]}"
                     title="Ver detalle">
                    <i class="fi fi-rr-eye"></i>
                  </a>

                  <a class="action-icon edit"
                     href="${pageContext.request.contextPath}/funcionario/contribuyente?action=editar&id=${c[0]}"
                     title="Editar contribuyente">
                    <i class="fi fi-rr-edit"></i>
                  </a>

                  <c:choose>
                    <c:when test="${c[7] == 'ACTIVO'}">
                      <a class="action-icon danger"
                         href="${pageContext.request.contextPath}/funcionario/contribuyente?action=estado&id=${c[0]}&estado=INACTIVO"
                         title="Desactivar contribuyente">
                        <i class="fi fi-rr-toggle-on"></i>
                      </a>
                    </c:when>
                    <c:otherwise>
                      <a class="action-icon success"
                         href="${pageContext.request.contextPath}/funcionario/contribuyente?action=estado&id=${c[0]}&estado=ACTIVO"
                         title="Activar contribuyente">
                        <i class="fi fi-rr-toggle-off"></i>
                      </a>
                    </c:otherwise>
                  </c:choose>
                </div>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>

      <div class="table-pagination-footer">
        <div class="pagination-left">
          <label for="pageSizeSelect">Mostrar</label>
          <select id="pageSizeSelect" class="page-size-select">
            <option value="5" selected>5</option>
            <option value="10">10</option>
            <option value="25">25</option>
          </select>
        </div>

        <nav class="pagination-right" id="paginationControls" aria-label="Paginacion"></nav>
      </div>
    </div>

  </div>
</main>

<div class="modal-overlay" id="modalOverlay">
  <div class="modal">

    <div class="modal-header">
      <h2>Nuevo Contribuyente</h2>
      <button type="button" class="modal-close" id="modalClose">
        <i class="fi fi-rr-cross-small"></i>
      </button>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/funcionario/contribuyente">
      <input type="hidden" name="action" value="crear">

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">DNI</label>
          <input class="form-input" name="numeroDoc" type="text" required>
        </div>

        <div class="form-group">
          <label class="form-label">Telefono</label>
          <input class="form-input" name="telefono" type="text">
        </div>

        <div class="form-group">
          <label class="form-label">Nombres</label>
          <input class="form-input" name="nombres" type="text" required>
        </div>

        <div class="form-group">
          <label class="form-label">Apellidos</label>
          <input class="form-input" name="apellidos" type="text" required>
        </div>

        <div class="form-group">
          <label class="form-label">Fecha de nacimiento</label>
          <input class="form-input" name="fechaNacimiento" type="date">
        </div>

        <div class="form-group">
          <label class="form-label">Correo electronico</label>
          <input class="form-input" name="email" type="email">
        </div>

        <div class="form-group full">
          <label class="form-label">Direccion</label>
          <input class="form-input" name="direccion" type="text">
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

<script src="${pageContext.request.contextPath}/js/pagination.js?v=20260303-5"></script>

</body>
</html>

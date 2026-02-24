<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Gestión de Inmuebles</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/inmueble.css">

   <!-- Google Fonts -->

  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">
</head>

<body>

  <%@ include file="/includes/sidebar.jsp" %>

  <main class="main">

    <%@ include file="/includes/topbar.jsp" %>

    <div class="content">

      <div class="page-header">
        <div class="page-header-left">
          <h1>Gestión de Inmuebles</h1>
        </div>

        <button class="btn-primary" id="btnNuevo">
          <i class="fi fi-rr-plus"></i> Nuevo Inmueble
        </button>
      </div>

      <div class="filter-bar">
        <div class="filter-search">
          <i class="fi fi-rr-search"></i>
          <input type="text" id="tableSearch" placeholder="Buscar dirección...">
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
              <th>ID</th>
              <th>Nombre</th>
              <th>Dirección</th>
              <th>Zona</th>
              <th>Valor</th>
              <th>Estado</th>
              <th>Fecha Registro</th>
              <th>Acciones</th>
            </tr>
          </thead>

          <tbody id="tableBody">
            <c:forEach var="i" items="${lista}">
              <tr data-estado="${i[7]}">
                <td>${i[0]}</td>
                <td>${i[1]}</td>
                <td>${i[2]}</td>
                <td>${i[3]}</td>

                <td>S/ <fmt:formatNumber value="${i[5]}" pattern="###,###"/></td>

                <td>
                  <c:choose>
                    <c:when test="${i[7] == 'ACTIVO'}">
                      <span class="badge badge-activo">Activo</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge badge-inactivo">Inactivo</span>
                    </c:otherwise>
                  </c:choose>
                </td>

                <td><fmt:formatDate value="${i[8]}" pattern="d MMM yyyy"/></td>

                <td>
                  <c:choose>
                    <c:when test="${i[7] == 'ACTIVO'}">
                      <a class="toggle-btn activo"
                         href="${pageContext.request.contextPath}/funcionario/inmueble?action=estado&id=${i[0]}&estado=INACTIVO">
                        <i class="fi fi-rr-toggle-on"></i>
                      </a>
                    </c:when>
                    <c:otherwise>
                      <a class="toggle-btn inactivo"
                         href="${pageContext.request.contextPath}/funcionario/inmueble?action=estado&id=${i[0]}&estado=ACTIVO">
                        <i class="fi fi-rr-toggle-off"></i>
                      </a>
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>

        <!-- ✅ Footer integrado -->
        <div class="table-footer">
          <div class="table-info" id="tableInfo">Mostrando 0 de 0</div>
          <div id="pagination"></div>
        </div>

      </div>

    </div>

  </main>

  <!-- MODAL NUEVO INMUEBLE -->
  <div class="modal-overlay" id="modalOverlay">
    <div class="modal">

      <div class="modal-header">
        <h2>Nuevo Inmueble</h2>
        <button type="button" class="modal-close" id="modalClose">
          <i class="fi fi-rr-cross-small"></i>
        </button>
      </div>

      <form method="post" action="${pageContext.request.contextPath}/funcionario/inmueble">
        <input type="hidden" name="action" value="crear">

        <div class="form-grid">
          <div class="form-group">
            <label class="form-label">Contribuyente</label>
            <select class="form-input" name="idContribuyente" required>
              <c:forEach var="c" items="${contribuyentes}">
                <option value="${c.id}">
                  ${c.persona.nombres} ${c.persona.apellidos}
                </option>
              </c:forEach>
            </select>
          </div>

          <div class="form-group full">
            <label class="form-label">Dirección</label>
            <input class="form-input" name="direccion" required>
          </div>

          <div class="form-group">
            <label class="form-label">Valor Catastral</label>
            <input class="form-input" type="number" step="0.01" name="valor" required>
          </div>

          <div class="form-group">
            <label class="form-label">Zona</label>
            <select class="form-input" name="idZona" required>
              <c:forEach var="z" items="${zonas}">
                <option value="${z.id}">${z.nombre}</option>
              </c:forEach>
            </select>
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
  <script src="${pageContext.request.contextPath}/js/inmueble.js"></script>
  <script src="${pageContext.request.contextPath}/js/pagination.js"></script>

</body>
</html>
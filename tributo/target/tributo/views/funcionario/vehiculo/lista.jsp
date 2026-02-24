<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Gestión de Vehículos</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css">

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
          <h1>Gestión de Vehículos</h1>
          <p><c:out value="${cantidad}" /> vehículos registrados</p>
        </div>

        <button class="btn-primary" id="btnNuevo">
          <i class="fi fi-rr-plus"></i> Registrar Vehículo
        </button>
      </div>

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
                <td>${v[0]}</td>
                <td>${v[1]}</td>
                <td>${v[2]}</td>
                <td>${v[3]}</td>
                <td>${v[4]}</td>

                <td>S/ <fmt:formatNumber value="${v[5]}" type="number" maxFractionDigits="0"/></td>

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
                  <fmt:formatDate value="${v[10]}" pattern="d MMM yyyy"/>
                </td>

                <td>
                  <c:choose>
                    <c:when test="${v[9] == 'ACTIVO'}">
                      <a class="toggle-btn activo"
                         href="${pageContext.request.contextPath}/funcionario/vehiculo?action=estado&id=${v[0]}&estado=INACTIVO">
                        <i class="fi fi-rr-toggle-on"></i>
                      </a>
                    </c:when>
                    <c:otherwise>
                      <a class="toggle-btn inactivo"
                         href="${pageContext.request.contextPath}/funcionario/vehiculo?action=estado&id=${v[0]}&estado=ACTIVO">
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

  <!-- MODAL VEHÍCULO -->
  <div class="modal-overlay" id="modalOverlay">
    <div class="modal">

      <div class="modal-header">
        <h2>Registrar Vehículo</h2>
        <button type="button" class="modal-close" id="modalClose">
          <i class="fi fi-rr-cross-small"></i>
        </button>
      </div>

      <form method="post" action="${pageContext.request.contextPath}/funcionario/vehiculo">
        <input type="hidden" name="action" value="crear">

        <div class="form-grid">
          <div class="form-group">
            <label class="form-label">Contribuyente</label>
            <select name="idContribuyente" class="form-input" required>
              <c:forEach var="c" items="${contribuyentes}">
                <option value="${c[0]}">${c[1]}</option>
              </c:forEach>
            </select>
          </div>

          <div class="form-group">
            <label class="form-label">Placa</label>
            <input type="text" name="placa" class="form-input" required>
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
            <input type="number" name="anio" class="form-input" required>
          </div>

          <div class="form-group">
            <label class="form-label">Fecha de Inscripción</label>
            <input type="date" name="fechaInscripcion" class="form-input" required>
          </div>

          <div class="form-group">
            <label class="form-label">Valor</label>
            <input type="number" step="0.01" name="valor" class="form-input" required>
          </div>

          <div class="form-group">
            <label class="form-label">%</label>
            <input type="number" step="0.01" name="porcentaje" class="form-input" required>
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
  <script src="${pageContext.request.contextPath}/js/vehiculo.js"></script>
  <script src="${pageContext.request.contextPath}/js/pagination.js"></script>

</body>
</html>
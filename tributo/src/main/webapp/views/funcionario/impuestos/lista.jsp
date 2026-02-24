<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Gestión de Impuestos</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Impuestos.css">

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
          <h1>Gestión de Impuestos</h1>
          <p>${empty lista ? 0 : lista.size()} impuestos registrados</p>
        </div>

        <button class="btn-primary" id="btnAbrirModal" type="button">
          <i class="fi fi-rr-plus"></i> Generar Impuesto
        </button>
      </div>

      <!-- Filtros -->
      <div class="filter-bar">
        <div class="filter-search">
          <i class="fi fi-rr-search"></i>
          <input type="text" id="tableSearch" placeholder="Buscar por contribuyente o código...">
        </div>

        <div class="filter-select">
          <i class="fi fi-rr-filter"></i>
          <select id="tipoFilter">
            <option value="">Todos</option>
            <option value="PREDIAL">Predial</option>
            <option value="VEHICULAR">Vehicular</option>
            <option value="ALCABALA">Alcabala</option>
          </select>
        </div>

        <div class="filter-select">
          <i class="fi fi-rr-filter"></i>
          <select id="estadoFilter">
            <option value="">Todos</option>
            <option value="PENDIENTE">Pendiente</option>
            <option value="FRACCIONADO">Fraccionado</option>
            <option value="PAGADO">Pagado</option>
            <option value="VENCIDO">Vencido</option>
          </select>
        </div>
      </div>

      <!-- Tabla -->
      <div class="table-card">
        <table class="data-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Contribuyente</th>
              <th>Tipo</th>
              <th>Año</th>
              <th>Total</th>
              <th>Pagado</th>
              <th>Estado</th>
              <th>Cuotas</th>
            </tr>
          </thead>

          <tbody id="tableBody">
            <c:forEach var="i" items="${lista}">
              <tr
                data-tipo="${i[2]}"
                data-estado="${i[6]}"
              >
                <td class="td-code">IMP<c:out value="${i[0]}"/></td>
                <td class="contributor-name"><c:out value="${i[1]}"/></td>

                <td>
                  <span class="pill pill-${fn:toLowerCase(i[2])}">
                    <c:out value="${i[2]}"/>
                  </span>
                </td>

                <td><c:out value="${i[3]}"/></td>

                <td class="td-money">S/ <c:out value="${i[4]}"/></td>
                <td class="td-money">S/ <c:out value="${i[5]}"/></td>

                <td>
                  <span class="badge badge-${fn:toLowerCase(i[6])}">
                    <c:out value="${i[6]}"/>
                  </span>
                </td>

                <td>
                  <button
                    type="button"
                    class="action-link"
                    data-impuesto-id="<c:out value='${i[0]}'/>"
                  >
                    <i class="fi fi-rr-eye"></i> Ver
                  </button>
                </td>
              </tr>
            </c:forEach>

            <c:if test="${empty lista}">
              <tr>
                <td colspan="8" style="padding:18px 20px; text-align:center; color: var(--text-muted);">
                  No hay impuestos registrados.
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

  <!-- MODAL GENERAR -->
  <div class="modal-overlay" id="modalGenerar">
    <div class="modal">
      <div class="modal-header">
        <h2>Generar Impuesto</h2>
        <button class="modal-close" type="button" id="closeGenerar">
          <i class="fi fi-rr-cross-small"></i>
        </button>
      </div>

      <form method="post" action="${pageContext.request.contextPath}/funcionario/impuesto">
        <input type="hidden" name="action" value="generar">

        <div class="form-group full">
          <label class="form-label">Contribuyente</label>
          <select name="idContribuyente" class="form-input" required>
            <option value="">Seleccionar</option>
            <c:forEach var="c" items="${contribuyentes}">
              <option value="${c[0]}"><c:out value="${c[1]}"/></option>
            </c:forEach>
          </select>
        </div>

        <div class="form-grid">
          <div class="form-group">
            <label class="form-label">Tipo</label>
            <select name="tipo" class="form-input" required>
              <option value="">Seleccionar</option>
              <option value="PREDIAL">Predial</option>
              <option value="VEHICULAR">Vehicular</option>
              <option value="ALCABALA">Alcabala</option>
            </select>
          </div>

          <div class="form-group">
            <label class="form-label">Año</label>
            <input type="number" name="anio" class="form-input" value="2025" min="2000" max="2100" required>
          </div>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn-secondary" id="cancelGenerar">Cancelar</button>
          <button type="submit" class="btn-primary">
            <i class="fi fi-rr-disk"></i> Generar
          </button>
        </div>
      </form>
    </div>
  </div>

  <!-- MODAL CUOTAS -->
  <div class="modal-overlay" id="modalCuotas">
    <div class="modal">
      <div class="modal-header">
        <h2>Detalle de Cuotas</h2>
        <button class="modal-close" type="button" id="closeCuotas">
          <i class="fi fi-rr-cross-small"></i>
        </button>
      </div>

      <div id="cuotasContainer"></div>
    </div>
  </div>

  <!-- ✅ Importante: primero scripts, luego init -->
  <script>
    window.__CTX__ = "${pageContext.request.contextPath}";
  </script>

  <script src="${pageContext.request.contextPath}/js/pagination.js"></script>
  <script src="${pageContext.request.contextPath}/js/impuestos.js"></script>

  <script>
    document.addEventListener("DOMContentLoaded", () => {
      window.initTablePagination({
        perPage: 6,
        tableBodyId: "tableBody",
        searchId: "tableSearch",
        estadoFilterId: "estadoFilter",
        paginationId: "pagination",
        tableInfoId: "tableInfo"
      });
    });
  </script>
</body>
</html>
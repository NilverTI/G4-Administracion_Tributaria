<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>SAT Municipal - Gestión de Cuotas</title>

  <!-- ✅ MISMO CSS (NO se rompe) -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cuota.css">

  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">
</head>

<body>

<%@ include file="/includes/sidebar.jsp" %>

<main class="main">
  <%@ include file="/includes/topbar.jsp" %>

  <section class="content">

    <!-- HEADER -->
    <div class="page-header">
      <div class="page-header-left">
        <h1>Gestión de Cuotas</h1>
        <p>${empty lista ? 0 : lista.size()} fraccionamientos registrados</p>
      </div>

      <button class="btn-primary" id="btnFraccionamiento" type="button">
        <i class="fi fi-rr-plus"></i> Crear Fraccionamiento
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
        <input type="text" id="tableSearch" placeholder="Buscar por contribuyente o impuesto...">
      </div>

      <!-- ✅ opcional: mantener filtro, ahora filtra por estado general -->
      <div class="filter-select">
        <i class="fi fi-rr-filter"></i>
        <select id="estadoFilter">
          <option value="">Todos</option>
          <option value="PENDIENTE">Pendiente</option>
          <option value="PARCIAL">Parcial</option>
          <option value="PAGADO">Pagado</option>
        </select>
      </div>

    </div>

    <!-- TABLA (AGRUPADA POR IMPUESTO / FRACCIONAMIENTO) -->
    <div class="table-card">

      <table class="data-table">
        <thead>
        <tr>
          <th>Impuesto</th>
          <th>Contribuyente</th>
          <th>Tipo</th>
          <th>Año</th>
          <th>Cuotas</th>
          <th>Total</th>
          <th>Próx. venc.</th>
          <th>Estado</th>
          <th></th>
        </tr>
        </thead>

        <tbody id="tableBody">

        <c:forEach var="f" items="${lista}">
          <%-- f: Map con keys: idImpuesto, codigoImpuesto, contribuyente, tipo, anio, totalCuotas, totalMonto, proximoVenc, estadoGeneral --%>
          <c:set var="est" value="${fn:toUpperCase(fn:trim(f.estadoGeneral))}" />

          <tr data-estado="${est}">
            <td class="td-code"><c:out value="${f.codigoImpuesto}"/></td>
            <td class="contributor-name"><c:out value="${f.contribuyente}"/></td>

            <td><c:out value="${f.tipo}"/></td>
            <td><c:out value="${f.anio}"/></td>

            <td><c:out value="${f.totalCuotas}"/></td>

            <td class="td-money">S/ <c:out value="${f.totalMonto}"/></td>

            <td><c:out value="${f.proximoVenc}"/></td>

            <td>
              <c:choose>
                <c:when test="${est == 'PAGADO'}">
                  <span class="badge badge-activo">Pagado</span>
                </c:when>
                <c:when test="${est == 'PARCIAL'}">
                  <span class="badge badge-inactivo">Parcial</span>
                </c:when>
                <c:otherwise>
                  <span class="badge badge-pendiente">Pendiente</span>
                </c:otherwise>
              </c:choose>
            </td>

            <td>
              <button type="button"
                class="btn-secondary btn-ver-cuotas"
                data-id-impuesto="${f.idImpuesto}"
                data-cod-impuesto="${f.codigoImpuesto}"
                data-contribuyente="${fn:escapeXml(f.contribuyente)}">
                Ver cuotas
              </button>
            </td>
          </tr>
        </c:forEach>

        <c:if test="${empty lista}">
          <tr>
            <td colspan="9" class="empty-table" style="padding:18px 20px; text-align:center; color: var(--text-muted);">
              No hay fraccionamientos registrados
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

  </section>
</main>

<!-- ✅ MODAL: CREAR FRACCIONAMIENTO (igualito) -->
<div class="modal-overlay" id="modalFraccionamiento">
  <div class="modal" style="max-width: 560px;">

    <div class="modal-header">
      <h2>Crear Fraccionamiento</h2>
      <button type="button" class="modal-close" id="closeFraccionamiento" title="Cerrar">
        <i class="fi fi-rr-cross-small"></i>
      </button>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/funcionario/cuota">
      <input type="hidden" name="action" value="crearFraccionamiento">

      <div class="form-grid">

        <div class="form-group full">
          <label class="form-label">Impuesto</label>
          <select class="form-input" name="idImpuesto" required>
            <option value="">Seleccionar impuesto</option>
            <c:forEach var="i" items="${impuestos}">
              <option value="${i[0]}">
                <c:out value="${i[1]}"/> - <c:out value="${i[2]}"/> (<c:out value="${i[3]}"/> <c:out value="${i[4]}"/>)
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="form-group">
          <label class="form-label">Número de Cuotas</label>
          <input type="number" class="form-input" name="numeroCuotas" value="4" min="1" max="48" required>
        </div>

        <div class="form-group">
          <label class="form-label">Fecha Primera Cuota</label>
          <input type="date" class="form-input" name="fechaPrimeraCuota" required>
        </div>

      </div>

      <div class="modal-footer">
        <button type="button" class="btn-secondary" id="cancelFraccionamiento">Cancelar</button>
        <button type="submit" class="btn-primary">
          <i class="fi fi-rr-disk"></i> Crear
        </button>
      </div>
    </form>

  </div>
</div>

<!-- ✅ MODAL: DETALLE CUOTAS (nuevo, pero con tus clases para que se vea igual) -->
<div class="modal-overlay" id="modalDetalleCuotas">
  <div class="modal" style="max-width: 760px; width: 95%;">

    <div class="modal-header">
      <div>
        <h2>Detalle de Cuotas</h2>
        <p class="page-subtitle" id="detalleSubtitle" style="margin:0;">
          <!-- se rellena por JS -->
        </p>
      </div>
      <button type="button" class="modal-close" id="closeDetalleCuotas" title="Cerrar">
        <i class="fi fi-rr-cross-small"></i>
      </button>
    </div>

    <div class="table-card" style="border-radius:14px; overflow:hidden;">
      <table class="data-table">
        <thead>
        <tr>
          <th>Cuota</th>
          <th>Monto</th>
          <th>Vencimiento</th>
          <th>Estado</th>
        </tr>
        </thead>
        <tbody id="detalleCuotasBody">
          <tr>
            <td colspan="4" class="empty-table">Seleccione un fraccionamiento...</td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="modal-footer">
      <button type="button" class="btn-secondary" id="cancelDetalleCuotas">Cerrar</button>
    </div>
  </div>
</div>

<script>
  window.__CTX__ = "${pageContext.request.contextPath}";
</script>

<!-- ✅ scripts -->
<script src="${pageContext.request.contextPath}/js/pagination.js"></script>
<script src="${pageContext.request.contextPath}/js/cuota.js"></script>

<!-- ✅ init paginación -->
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
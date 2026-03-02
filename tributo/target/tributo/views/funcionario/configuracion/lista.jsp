<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gestión de Cuotas</title>

  <!-- CSS GLOBAL -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cuota.css">

  <!-- Google Fonts -->
  <link rel="stylesheet"
        href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&display=swap">

  <!-- Iconos -->
  <link rel="stylesheet"
        href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">
</head>

<body>
<%@ include file="/includes/sidebar.jsp" %>

<main class="main">
  <%@ include file="/includes/topbar.jsp" %>

  <div class="content">

    <!-- Header -->
    <div class="page-header cuota-header">
      <div class="page-header-left">
        <h1>Gestión de Cuotas</h1>
        <p>
          <c:choose>
            <c:when test="${not empty lista}">
              <c:out value="${fn:length(lista)}"/> fraccionamientos registrados
            </c:when>
            <c:otherwise>0 fraccionamientos registrados</c:otherwise>
          </c:choose>
        </p>
      </div>

      <button class="btn-primary" type="button" id="btnCrearFracc">
        <i class="fi fi-rr-plus"></i> Crear Fraccionamiento
      </button>
    </div>

    <!-- Alerts -->
    <c:if test="${not empty err}">
      <div class="alert alert-error"><c:out value="${err}"/></div>
    </c:if>
    <c:if test="${not empty ok}">
      <div class="alert alert-ok"><c:out value="${ok}"/></div>
    </c:if>

    <!-- Filters -->
    <div class="toolbar">
      <div class="searchbox">
        <i class="fi fi-rr-search"></i>
        <input id="searchInput" type="text" placeholder="Buscar por contribuyente o impuesto..." autocomplete="off">
      </div>

      <div class="filterbox">
        <i class="fi fi-rr-filter"></i>
        <select id="estadoFilter">
          <option value="TODOS">Todos</option>
          <option value="PENDIENTE">Pendiente</option>
          <option value="PARCIAL">Parcial</option>
          <option value="PAGADO">Pagado</option>
        </select>
      </div>
    </div>

    <!-- Table -->
    <div class="table-card">
      <table class="data-table" id="tablaFracc">
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
          <th>Acción</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
          <c:when test="${empty lista}">
            <tr>
              <td colspan="9" class="empty-row">No hay fraccionamientos registrados.</td>
            </tr>
          </c:when>

          <c:otherwise>
            <c:forEach var="g" items="${lista}">
              <tr class="fracc-row"
                  data-impuesto="${g.codigoImpuesto}"
                  data-contribuyente="${g.contribuyente}"
                  data-estado="${g.estadoGeneral}">

                <td><c:out value="${g.codigoImpuesto}"/></td>
                <td><c:out value="${g.contribuyente}"/></td>

                <!-- Tipo / Año: vienen vacíos si tu SP no los devuelve.
                     Igual los dejamos listos para cuando lo actualices. -->
                <td><c:out value="${g.tipo}"/></td>
                <td><c:out value="${g.anio}"/></td>

                <td><c:out value="${g.totalCuotas}"/></td>

                <td>
                  S/
                  <fmt:formatNumber value="${g.totalMonto}" minFractionDigits="2" maxFractionDigits="2"/>
                </td>

                <td>
                  <c:choose>
                    <c:when test="${empty g.proximoVenc}">—</c:when>
                    <c:otherwise><c:out value="${g.proximoVenc}"/></c:otherwise>
                  </c:choose>
                </td>

                <td>
                  <c:choose>
                    <c:when test="${g.estadoGeneral == 'PAGADO'}">
                      <span class="badge badge-pagado">Pagado</span>
                    </c:when>
                    <c:when test="${g.estadoGeneral == 'PARCIAL'}">
                      <span class="badge badge-parcial">Parcial</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge badge-pendiente">Pendiente</span>
                    </c:otherwise>
                  </c:choose>
                </td>

                <td>
                  <button type="button"
                          class="btn-light btnVerCuotas"
                          data-id-impuesto="${g.idImpuesto}">
                    Ver cuotas
                  </button>
                </td>

              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
        </tbody>
      </table>
    </div>

  </div>
</main>


<!-- ================= MODAL: CREAR FRACCIONAMIENTO ================= -->
<div class="modal-overlay" id="modalFracc" aria-hidden="true">
  <div class="modal" role="dialog" aria-modal="true" aria-labelledby="modalFraccTitle">

    <div class="modal-header">
      <h2 id="modalFraccTitle">Crear fraccionamiento</h2>
      <button type="button" class="modal-close" data-close="modalFracc" title="Cerrar">
        <i class="fi fi-rr-cross-small"></i>
      </button>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/funcionario/cuota">
      <input type="hidden" name="action" value="crearFraccionamiento">

      <div class="form-grid">

        <div class="form-field">
          <label>Impuesto</label>
          <select name="idImpuesto" required>
            <option value="" disabled selected>Selecciona un impuesto</option>
            <c:forEach var="i" items="${impuestos}">
              <!-- i[0]=id_impuesto, i[1]=IMP0001, i[2]=Nombre, i[3]=tipo, i[4]=anio, i[5]=monto_total -->
              <option value="${i[0]}">
                <c:out value="${i[1]}"/> - <c:out value="${i[2]}"/>
                <c:if test="${not empty i[3]}"> | <c:out value="${i[3]}"/></c:if>
                <c:if test="${not empty i[4]}"> - <c:out value="${i[4]}"/></c:if>
                <c:if test="${not empty i[5]}"> | S/ <c:out value="${i[5]}"/></c:if>
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="form-field">
          <label>Número de cuotas</label>
          <input type="number" name="numeroCuotas" min="1" max="60" required>
        </div>

        <div class="form-field">
          <label>Fecha primera cuota</label>
          <input type="date" name="fechaPrimeraCuota" required>
        </div>

      </div>

      <div class="modal-footer">
        <button type="button" class="btn-secondary" data-close="modalFracc">Cancelar</button>
        <button type="submit" class="btn-primary">
          <i class="fi fi-rr-disk"></i> Crear
        </button>
      </div>
    </form>

  </div>
</div>


<!-- ================= MODAL: DETALLE CUOTAS ================= -->
<div class="modal-overlay" id="modalDetalle" aria-hidden="true">
  <div class="modal modal-lg" role="dialog" aria-modal="true" aria-labelledby="modalDetalleTitle">

    <div class="modal-header">
      <h2 id="modalDetalleTitle">Detalle de cuotas</h2>
      <button type="button" class="modal-close" data-close="modalDetalle" title="Cerrar">
        <i class="fi fi-rr-cross-small"></i>
      </button>
    </div>

    <div class="modal-body">
      <div class="detalle-meta" id="detalleMeta">Cargando…</div>

      <div class="table-card">
        <table class="data-table" id="tablaDetalle">
          <thead>
          <tr>
            <th>N°</th>
            <th>Vencimiento</th>
            <th>Monto</th>
            <th>Estado</th>
          </tr>
          </thead>
          <tbody id="detalleBody">
          <tr><td colspan="4" class="empty-row">Cargando…</td></tr>
          </tbody>
        </table>
      </div>
    </div>

    <div class="modal-footer">
      <button type="button" class="btn-secondary" data-close="modalDetalle">Cerrar</button>
    </div>

  </div>
</div>


<!-- JS -->
<script src="${pageContext.request.contextPath}/js/cuota.js?v=1"></script>

</body>
</html>
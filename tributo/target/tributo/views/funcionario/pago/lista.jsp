<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Registro de Pagos</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Flaticon -->
    <link rel="stylesheet"
          href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">
</head>

<body>

<%@ include file="/includes/sidebar.jsp" %>

<main class="main">

    <%@ include file="/includes/topbar.jsp" %>

    <div class="content">

        <!-- HEADER -->
        <div class="page-header">
            <div class="page-header-left">
                <h1>Registro de Pagos</h1>
                <p>${empty lista ? 0 : lista.size()} pagos registrados</p>
            </div>

            <!-- ✅ type="button" para que no intente submit -->
            <button class="btn-primary" id="btnNuevoPago" type="button">
                <i class="fi fi-rr-plus"></i> Registrar Pago
            </button>
        </div>

        <!-- FILTRO -->
        <div class="filter-bar">
            <div class="filter-search">
                <i class="fi fi-rr-search"></i>
                <input type="text" id="tableSearch" placeholder="Buscar por contribuyente o comprobante...">
            </div>
        </div>

        <!-- TABLA -->
        <div class="table-card">

            <table class="data-table">
                <thead>
                <tr>
                    <th>Comprobante</th>
                    <th>Contribuyente</th>
                    <th>Impuesto</th>
                    <th>Medio</th>
                    <th>Fecha</th>
                    <th>Monto</th>
                </tr>
                </thead>

                <tbody id="tableBody">

                <c:forEach var="p" items="${lista}">
                    <tr>
                        <td class="td-code">
                            <c:out value="${p.codigo}"/>
                        </td>

                        <td>
                            <c:out value="${p.cuota.impuesto.contribuyente.persona.nombres}"/>
                            <c:out value="${p.cuota.impuesto.contribuyente.persona.apellidos}"/>
                        </td>

                        <td class="td-code">
                            <c:out value="${p.cuota.impuesto.codigo}"/>
                        </td>

                        <td>
                            <span class="badge badge-activo">
                                <c:out value="${p.medioPago}"/>
                            </span>
                        </td>

                        <td>
                            <!-- OJO: fmt:formatDate funciona bien con java.util.Date.
                                 Si fechaPago es LocalDate, mejor imprimir directo -->
                            <c:out value="${p.fechaPago}"/>
                        </td>

                        <td class="td-money">
                            S/ <c:out value="${p.monto}"/>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty lista}">
                    <tr>
                        <td colspan="6" class="empty-table" style="padding:18px 20px; text-align:center; color: var(--text-muted);">
                            No hay pagos registrados
                        </td>
                    </tr>
                </c:if>

                </tbody>
            </table>

            <!-- ✅ Footer + paginación como tus otras vistas -->
            <div class="table-footer">
                <div class="table-info" id="tableInfo">Mostrando 0 de 0</div>
                <div id="pagination"></div>
            </div>

        </div>

    </div>

</main>

<!-- 🔥 MODAL REGISTRAR PAGO -->
<div class="modal-overlay" id="modalPago" aria-hidden="true">
    <div class="modal" role="dialog" aria-modal="true">

        <div class="modal-header">
            <h2>Registrar Pago</h2>
            <button type="button" class="modal-close" id="modalClosePago" title="Cerrar">
                <i class="fi fi-rr-cross-small"></i>
            </button>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/funcionario/pago">

            <div class="form-grid">

                <div class="form-group full">
                    <label class="form-label">Cuota Pendiente</label>

                    <select class="form-input" name="idCuota" required>
                        <option value="">Seleccionar</option>

                        <c:forEach var="c" items="${cuotas}">
                            <option value="${c.id}">
                                <c:out value="${c.impuesto.codigo}"/> -
                                Cuota <c:out value="${c.numero}"/>/<c:out value="${c.totalCuotas}"/> -
                                S/ <c:out value="${c.monto}"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Medio de Pago</label>
                    <select class="form-input" name="medioPago" required>
                        <option value="Tarjeta">Tarjeta</option>
                        <option value="Transferencia">Transferencia</option>
                        <option value="Efectivo">Efectivo</option>
                        <option value="Online">Online</option>
                    </select>
                </div>

            </div>

            <div class="modal-footer">
                <button type="button" class="btn-secondary" id="modalCancelPago">
                    Cancelar
                </button>

                <button type="submit" class="btn-primary">
                    <i class="fi fi-rr-disk"></i> Registrar Pago
                </button>
            </div>

        </form>

    </div>
</div>

<script>
  window.initTablePagination({
    perPage: 6,
    tableBodyId: "tableBody",
    searchId: "tableSearch",
    paginationId: "pagination",
    tableInfoId: "tableInfo"
  });
</script>

<script src="${pageContext.request.contextPath}/js/pago.js"></script>

<script src="${pageContext.request.contextPath}/js/pagination.js"></script>
<script src="${pageContext.request.contextPath}/js/pago.js"></script>

</body>
</html>
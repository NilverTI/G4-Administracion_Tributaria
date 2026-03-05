<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SAT Municipal - Mis Cuotas</title>

    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente-portal.css?v=20260303-4">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css?v=20260303-5">
</head>
<body>

<%@ include file="/includes/contribuyente/sidebar.jsp" %>

<main class="main">
    <%@ include file="/includes/contribuyente/topbar.jsp" %>

    <div class="content contribuyente-page">
        <div class="page-header">
            <h1>Mis Cuotas</h1>
            <p>Detalle de cuotas de fraccionamientos vinculados a sus impuestos.</p>
        </div>

        <c:if test="${not empty sessionScope.flashError}">
            <div class="portal-alert portal-alert-error">${sessionScope.flashError}</div>
            <c:remove var="flashError" scope="session"/>
        </c:if>

        <div class="summary-grid">
            <div class="summary-card">
                <span class="summary-label">Cuotas Registradas</span>
                <div class="summary-value">${items.size()}</div>
                <div class="summary-sub">Historial completo de sus cuotas</div>
            </div>
            <div class="summary-card">
                <span class="summary-label">Pendientes</span>
                <div class="summary-value">${pendientes}</div>
                <div class="summary-sub">Aun por regularizar</div>
            </div>
            <div class="summary-card">
                <span class="summary-label">Pagadas</span>
                <div class="summary-value">${pagadas}</div>
                <div class="summary-sub">Cuotas cerradas</div>
            </div>
        </div>

        <div class="section-card">
            <div class="section-head">
                <div>
                    <h2>Listado de Cuotas</h2>
                    <p>Informacion actualizada desde su historial de fraccionamientos.</p>
                </div>
            </div>

            <div class="section-toolbar">
                <input type="text" id="cuotasSearch" class="search-input" placeholder="Buscar por tipo, codigo o periodo...">
            </div>

            <c:choose>
                <c:when test="${empty items}">
                    <div class="empty-state">No tiene cuotas registradas.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrap">
                        <table class="portal-table">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tipo</th>
                                <th>Impuesto</th>
                                <th>Cuota</th>
                                <th>Periodo</th>
                                <th>Vencimiento</th>
                                <th>Monto</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                            </thead>
                            <tbody id="cuotasTableBody">
                            <c:forEach var="item" items="${items}">
                                <tr data-row="1">
                                    <td>${item[0]}</td>
                                    <td>${item[1]}</td>
                                    <td>${item[2]}</td>
                                    <td>${item[3]}/${item[4]}</td>
                                    <td>${item[5]}</td>
                                    <td>${item[6]}</td>
                                    <td class="mono">S/ <fmt:formatNumber value="${item[7]}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item[8] == 'PAGADO'}">
                                                <span class="status-badge status-paid">Pagado</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-pending">Pendiente</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/contribuyente/cuotas?detalle=${item[11]}"
                                           class="table-link-btn">
                                            <i class="fi fi-rr-eye"></i> Ver
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div id="cuotasPagination"></div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/js/pagination.js?v=20260303-5"></script>
<script>
    if (window.ListingTools) {
        window.ListingTools.createTableController({
            itemSelector: "#cuotasTableBody tr[data-row='1']",
            paginationSelector: "#cuotasPagination",
            searchInputSelector: "#cuotasSearch"
        });
    }
</script>

</body>
</html>

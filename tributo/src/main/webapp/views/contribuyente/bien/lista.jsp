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
    <title>SAT Municipal - Mis Bienes</title>

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
            <h1>Mis Bienes</h1>
            <p>Relacion de inmuebles y vehiculos asociados a su cuenta.</p>
        </div>

        <div class="summary-grid">
            <div class="summary-card">
                <span class="summary-label">Total de Bienes</span>
                <div class="summary-value">${totalBienes}</div>
                <div class="summary-sub">Entre inmuebles y vehiculos</div>
            </div>
            <div class="summary-card">
                <span class="summary-label">Inmuebles</span>
                <div class="summary-value">${inmuebles.size()}</div>
                <div class="summary-sub">Predios registrados</div>
            </div>
            <div class="summary-card">
                <span class="summary-label">Vehiculos</span>
                <div class="summary-value">${vehiculos.size()}</div>
                <div class="summary-sub">Unidades registradas</div>
            </div>
        </div>

        <div class="split-grid">
            <section class="section-card">
                <div class="section-head">
                    <div>
                        <h2>Inmuebles</h2>
                        <p>Propiedades registradas a su nombre.</p>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${empty inmuebles}">
                        <div class="empty-state">No tiene inmuebles registrados.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-wrap">
                            <table class="portal-table">
                                <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Direccion</th>
                                    <th>Zona</th>
                                    <th>Tipo</th>
                                    <th>Valor</th>
                                </tr>
                                </thead>
                                <tbody id="inmueblesTableBody">
                                <c:forEach var="item" items="${inmuebles}">
                                    <tr data-row="1">
                                        <td>${item[0]}</td>
                                        <td>${item[1]}</td>
                                        <td>${item[2]}</td>
                                        <td>${item[3]}</td>
                                        <td class="mono">S/ <fmt:formatNumber value="${item[4]}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <div id="inmueblesPagination"></div>
                    </c:otherwise>
                </c:choose>
            </section>

            <section class="section-card">
                <div class="section-head">
                    <div>
                        <h2>Vehiculos</h2>
                        <p>Vehiculos vinculados a su cuenta tributaria.</p>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${empty vehiculos}">
                        <div class="empty-state">No tiene vehiculos registrados.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-wrap">
                            <table class="portal-table">
                                <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Placa</th>
                                    <th>Marca</th>
                                    <th>Modelo</th>
                                    <th>Valor</th>
                                </tr>
                                </thead>
                                <tbody id="vehiculosTableBody">
                                <c:forEach var="item" items="${vehiculos}">
                                    <tr data-row="1">
                                        <td>${item[0]}</td>
                                        <td>${item[1]}</td>
                                        <td>${item[2]}</td>
                                        <td>${item[3]}</td>
                                        <td class="mono">S/ <fmt:formatNumber value="${item[5]}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <div id="vehiculosPagination"></div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/js/pagination.js?v=20260303-5"></script>
<script>
    if (window.ListingTools) {
        window.ListingTools.createTableController({
            itemSelector: "#inmueblesTableBody tr[data-row='1']",
            paginationSelector: "#inmueblesPagination"
        });

        window.ListingTools.createTableController({
            itemSelector: "#vehiculosTableBody tr[data-row='1']",
            paginationSelector: "#vehiculosPagination"
        });
    }
</script>

</body>
</html>

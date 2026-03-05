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
    <title>SAT Municipal - Detalle de Fraccionamiento</title>

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
        <div class="page-header page-header-inline">
            <div>
                <h1>Detalle de Fraccionamiento</h1>
                <p>ID #${fraccionamiento[0]} - ${fraccionamiento[3]}</p>
            </div>
            <a href="${pageContext.request.contextPath}/contribuyente/cuotas" class="table-link-btn table-link-btn-secondary">
                <i class="fi fi-rr-arrow-left"></i> Volver
            </a>
        </div>

        <div class="summary-grid">
            <div class="summary-card">
                <span class="summary-label">Tipo</span>
                <div class="summary-value summary-value-sm">${fraccionamiento[1]}</div>
            </div>
            <div class="summary-card">
                <span class="summary-label">Contribuyente</span>
                <div class="summary-value summary-value-sm">${fraccionamiento[4]}</div>
            </div>
            <div class="summary-card">
                <span class="summary-label">Monto Anual</span>
                <div class="summary-value summary-value-sm">
                    S/ <fmt:formatNumber value="${fraccionamiento[6]}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                </div>
            </div>
            <div class="summary-card">
                <span class="summary-label">Periodicidad</span>
                <div class="summary-value summary-value-sm">${fraccionamiento[7]}</div>
            </div>
            <div class="summary-card">
                <span class="summary-label">Cuotas Pagadas</span>
                <div class="summary-value summary-value-sm">${fraccionamiento[10]}/${fraccionamiento[9]}</div>
            </div>
            <div class="summary-card">
                <span class="summary-label">Estado</span>
                <div class="summary-sub">
                    <c:choose>
                        <c:when test="${fraccionamiento[12] == 'CERRADO'}">
                            <span class="status-badge status-paid">CERRADO</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge status-active">ACTIVO</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="section-card">
            <div class="section-head">
                <div>
                    <h2>Cuotas del Fraccionamiento</h2>
                    <p>Detalle completo de cuotas registradas para este fraccionamiento.</p>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty cuotas}">
                    <div class="empty-state">No se encontraron cuotas para este fraccionamiento.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrap">
                        <table class="portal-table">
                            <thead>
                            <tr>
                                <th>ID Cuota</th>
                                <th>Nro</th>
                                <th>Periodo</th>
                                <th>Vencimiento</th>
                                <th>Monto Programado</th>
                                <th>Estado</th>
                                <th>Fecha Pago</th>
                                <th>Monto Pagado</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="cuota" items="${cuotas}">
                                <tr>
                                    <td>${cuota[0]}</td>
                                    <td>${cuota[1]}</td>
                                    <td>${cuota[2]}</td>
                                    <td><fmt:formatDate value="${cuota[3]}" pattern="d MMM yyyy"/></td>
                                    <td class="mono">S/ <fmt:formatNumber value="${cuota[4]}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${cuota[5] == 'PAGADO'}">
                                                <span class="status-badge status-paid">PAGADO</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-pending">PENDIENTE</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty cuota[6]}">
                                                <fmt:formatDate value="${cuota[6]}" pattern="d MMM yyyy"/>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty cuota[7]}">
                                                <span class="mono">S/ <fmt:formatNumber value="${cuota[7]}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

</body>
</html>

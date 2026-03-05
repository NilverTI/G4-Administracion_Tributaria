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
    <title>SAT Municipal - Portal Contribuyente</title>

    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente-dashboard.css?v=20260303-2">
</head>

<body>

<%@ include file="/includes/contribuyente/sidebar.jsp" %>

<main class="main">
    <%@ include file="/includes/contribuyente/topbar.jsp" %>

    <div class="content contribuyente-content">
        <div class="page-header">
            <h1>Mi Dashboard</h1>
            <p>Resumen de su situacion tributaria</p>
        </div>

        <div class="stat-grid">
            <div class="stat-card">
                <div class="stat-top">
                    <span class="stat-label">Deuda Total</span>
                    <div class="stat-icon icon-blue"><i class="fi fi-rr-dollar"></i></div>
                </div>
                <div class="stat-value">
                    S/ <fmt:formatNumber value="${dashboard.deudaTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-top">
                    <span class="stat-label">Impuestos Pendientes</span>
                    <div class="stat-icon icon-amber"><i class="fi fi-rr-receipt"></i></div>
                </div>
                <div class="stat-value">${dashboard.impuestosPendientes}</div>
                <span class="stat-note">Con saldo por regularizar</span>
            </div>

            <div class="stat-card">
                <div class="stat-top">
                    <span class="stat-label">Impuestos Pagados</span>
                    <div class="stat-icon icon-green"><i class="fi fi-rr-check-circle"></i></div>
                </div>
                <div class="stat-value">${dashboard.impuestosPagados}</div>
                <span class="stat-note">Sin deuda</span>
            </div>

            <div class="stat-card">
                <div class="stat-top">
                    <span class="stat-label">Cuotas Pendientes</span>
                    <div class="stat-icon icon-purple"><i class="fi fi-rr-calendar-clock"></i></div>
                </div>
                <div class="stat-value">${dashboard.proximasCuotas}</div>
                <span class="stat-note">Fraccionamientos activos</span>
            </div>
        </div>

        <div class="panel-grid">
            <section class="panel-card">
                <div class="panel-header">
                    <h2 class="panel-title">Impuestos Pendientes</h2>
                    <a href="${pageContext.request.contextPath}/contribuyente/impuesto?tipo=TODOS" class="panel-link">Ver todos</a>
                </div>

                <div class="panel-list">
                    <c:choose>
                        <c:when test="${empty dashboard.impuestosPendientesDetalle}">
                            <article class="panel-item">
                                <div>
                                    <h3 class="item-title">Sin impuestos pendientes</h3>
                                    <p class="item-sub">No tiene saldos por regularizar.</p>
                                </div>
                                <div class="item-right">
                                    <span class="item-amount">S/ 0.00</span>
                                    <span class="pill pill-info">Al dia</span>
                                </div>
                            </article>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${dashboard.impuestosPendientesDetalle}">
                                <article class="panel-item">
                                    <div>
                                        <h3 class="item-title">${item.tipo} ${item.anio}</h3>
                                        <p class="item-sub">Vence: ${item.fechaVencimiento}</p>
                                    </div>

                                    <div class="item-right">
                                        <span class="item-amount">
                                            S/ <fmt:formatNumber value="${item.montoTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                        </span>
                                        <c:choose>
                                            <c:when test="${item.estado == 'Fraccionado'}">
                                                <span class="pill pill-info">${item.estado}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="pill pill-warn">${item.estado}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </article>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>

            <section class="panel-card">
                <div class="panel-header">
                    <h2 class="panel-title">Cuotas Pendientes</h2>
                    <a href="${pageContext.request.contextPath}/contribuyente/cuotas" class="panel-link">Ver detalle</a>
                </div>

                <div class="panel-list">
                    <c:choose>
                        <c:when test="${empty dashboard.proximasCuotasDetalle}">
                            <article class="panel-item">
                                <div>
                                    <h3 class="item-title">Sin cuotas pendientes</h3>
                                    <p class="item-sub">No tiene fraccionamientos activos por pagar.</p>
                                </div>

                                <div class="item-right">
                                    <span class="item-amount">S/ 0.00</span>
                                    <span class="pill pill-info">Al dia</span>
                                </div>
                            </article>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="cuota" items="${dashboard.proximasCuotasDetalle}">
                                <article class="panel-item">
                                    <div>
                                        <h3 class="item-title">${cuota.titulo}</h3>
                                        <p class="item-sub">Vence: ${cuota.fechaVencimiento}</p>
                                    </div>

                                    <div class="item-right">
                                        <span class="item-amount">
                                            S/ <fmt:formatNumber value="${cuota.monto}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                        </span>
                                        <a class="pay-btn" href="${pageContext.request.contextPath}/contribuyente/cuotas">
                                            <i class="fi fi-rr-eye"></i> Ver
                                        </a>
                                    </div>
                                </article>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/js/dashboard.js"></script>

</body>
</html>

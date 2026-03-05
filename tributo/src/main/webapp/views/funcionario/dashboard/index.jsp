<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
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
    <title>SAT Municipal - Panel Funcionario</title>

    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet"
          href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>

<body>

<jsp:include page="/includes/sidebar.jsp" />

<main class="main">

    <jsp:include page="/includes/topbar.jsp" />

    <div class="content">
        <div class="page-header">
            <h1>Bienvenido, ${sessionScope.usuario.persona.nombres}</h1>
            <p>Resumen general del sistema tributario</p>
        </div>

        <div class="stat-grid">
            <div class="stat-card">
                <div class="stat-top">
                    <span class="stat-label">Contribuyentes</span>
                    <div class="stat-icon icon-blue"><i class="fi fi-rr-users"></i></div>
                </div>
                <div class="stat-value">${dashboard.totalContribuyentes}</div>
                <span class="stat-badge badge-green"><i class="fi fi-rr-trending-up"></i> ${dashboard.totalActivos} activos</span>
            </div>

            <div class="stat-card">
                <div class="stat-top">
                    <span class="stat-label">Inmuebles</span>
                    <div class="stat-icon icon-teal"><i class="fi fi-rr-building"></i></div>
                </div>
                <div class="stat-value">${dashboard.totalInmuebles}</div>
                <span class="stat-badge badge-gray">${dashboard.inmueblesActivos} activos</span>
            </div>

            <div class="stat-card">
                <div class="stat-top">
                    <span class="stat-label">Vehiculos</span>
                    <div class="stat-icon icon-purple"><i class="fi fi-rr-car"></i></div>
                </div>
                <div class="stat-value">${dashboard.totalVehiculos}</div>
                <span class="stat-badge badge-gray">${dashboard.vehiculosActivos} activos</span>
            </div>

            <div class="stat-card">
                <div class="stat-top">
                    <span class="stat-label">Deuda Pendiente</span>
                    <div class="stat-icon icon-amber"><i class="fi fi-rr-dollar"></i></div>
                </div>
                <div class="stat-value" style="font-size:20px;">
                    S/ <fmt:formatNumber value="${dashboard.deudaPendiente}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                </div>
                <span class="stat-badge badge-red"><i class="fi fi-rr-triangle-warning"></i> Pendiente por cobrar</span>
            </div>

            <div class="stat-card">
                <div class="stat-top">
                    <span class="stat-label">Tributos ${dashboard.anioActual}</span>
                    <div class="stat-icon icon-green"><i class="fi fi-rr-chart-line-up"></i></div>
                </div>
                <div class="stat-value" style="font-size:20px;">
                    S/ <fmt:formatNumber value="${dashboard.totalRegistradoAnio}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                </div>
                <span class="stat-badge badge-green"><i class="fi fi-rr-trending-up"></i> Segun registros</span>
            </div>
        </div>

        <div class="bottom-grid">
            <div class="card">
                <div class="card-header">
                    <span class="card-title">Tributos registrados por mes ${dashboard.anioActual}</span>
                </div>
                <div class="chart-wrap">
                    <canvas
                        id="recaudacionChart"
                        data-labels="${dashboard.chartLabelsCsv}"
                        data-predial="${dashboard.chartPredialCsv}"
                        data-vehicular="${dashboard.chartVehicularCsv}"
                        data-alcabala="${dashboard.chartAlcabalaCsv}"></canvas>
                </div>
                <div class="chart-legend">
                    <div class="legend-item">
                        <div class="legend-dot" style="background:#0f1f3d"></div>Predial
                    </div>
                    <div class="legend-item">
                        <div class="legend-dot" style="background:#38bdf8"></div>Vehicular
                    </div>
                    <div class="legend-item">
                        <div class="legend-dot" style="background:#10b981"></div>Alcabala
                    </div>
                </div>
            </div>

            <div class="card vencidos-card">
                <div class="vencido-header">
                    <span class="warn-icon"><i class="fi fi-rr-triangle-warning"></i></span>
                    <h3>Alertas Tributarias</h3>
                </div>

                <c:choose>
                    <c:when test="${empty dashboard.alertas}">
                        <div class="vencido-item">
                            <div class="vencido-top">
                                <span class="vencido-name">Sin alertas pendientes</span>
                                <span class="tag-pendiente">Al dia</span>
                            </div>
                            <div class="vencido-sub">No hay obligaciones proximas ni vencidas.</div>
                            <div class="vencido-amount">S/ 0.00</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="alerta" items="${dashboard.alertas}">
                            <div class="vencido-item">
                                <div class="vencido-top">
                                    <span class="vencido-name">${alerta.contribuyente}</span>
                                    <c:choose>
                                        <c:when test="${alerta.estado == 'Vencido'}">
                                            <span class="tag-vencido">${alerta.estado}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="tag-pendiente">${alerta.estado}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="vencido-sub">
                                    ${alerta.descripcion}
                                    <c:if test="${not empty alerta.fechaVencimiento}">
                                        | Vence: ${alerta.fechaVencimiento}
                                    </c:if>
                                </div>
                                <div class="vencido-amount">
                                    S/ <fmt:formatNumber value="${alerta.monto}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>

                <a class="ver-todos" href="${pageContext.request.contextPath}/funcionario/cuotas">
                    <i class="fi fi-rr-list"></i> Ver cuotas y fraccionamientos
                </a>
            </div>
        </div>
    </div>

</main>

<script src="${pageContext.request.contextPath}/js/dashboard.js"></script>

</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Detalle Impuesto Vehicular</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

    <style>
        .tax-view {
            animation: taxFadeUp .3s ease;
        }

        @keyframes taxFadeUp {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .tax-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 18px;
        }

        .tax-title h1 {
            font-size: 30px;
            line-height: 1.1;
            letter-spacing: -0.02em;
            margin: 0;
        }

        .tax-title p {
            margin-top: 8px;
            color: var(--text-muted);
            font-size: 13px;
        }

        .tax-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }

        .tax-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(180px, 1fr));
            gap: 12px;
            margin-bottom: 14px;
        }

        .tax-kpi {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 16px;
        }

        .tax-kpi-label {
            color: var(--text-muted);
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: .06em;
            margin-bottom: 8px;
        }

        .tax-kpi-value {
            font-size: 24px;
            font-weight: 700;
            letter-spacing: -0.01em;
            color: var(--text);
        }

        .tax-panel {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 18px;
            margin-bottom: 14px;
        }

        .tax-panel h2 {
            margin: 0 0 14px;
            font-size: 18px;
            letter-spacing: -0.01em;
        }

        .tax-data {
            display: grid;
            grid-template-columns: repeat(3, minmax(180px, 1fr));
            gap: 12px;
        }

        .tax-item {
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 12px;
            background: #fbfdff;
        }

        .tax-item-label {
            display: block;
            color: var(--text-muted);
            font-size: 12px;
            margin-bottom: 6px;
        }

        .tax-item-value {
            font-size: 16px;
            font-weight: 600;
            color: var(--text);
        }

        .tax-table-wrap {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 14px;
            overflow: hidden;
        }

        .tax-table-head {
            padding: 16px 18px;
            border-bottom: 1px solid var(--border);
        }

        .tax-table-head h2 {
            margin: 0;
            font-size: 18px;
        }

        .tax-table {
            width: 100%;
            border-collapse: collapse;
        }

        .tax-table thead tr {
            background: #f8fafc;
        }

        .tax-table th,
        .tax-table td {
            text-align: left;
            padding: 14px 18px;
            border-bottom: 1px solid var(--border);
        }

        .tax-table th {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: .06em;
            color: var(--text-muted);
        }

        .tax-table td {
            font-size: 14px;
            color: var(--text);
        }

        .tax-table tbody tr:last-child td {
            border-bottom: none;
        }

        .tax-mono {
            font-family: 'JetBrains Mono', monospace;
            font-weight: 600;
        }

        .tax-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .tax-badge-dot {
            width: 6px;
            height: 6px;
            border-radius: 999px;
        }

        .tax-badge-pending {
            background: #f1f5f9;
            color: #475569;
        }

        .tax-badge-pending .tax-badge-dot {
            background: #64748b;
        }

        .tax-badge-paid {
            background: #dcfce7;
            color: #166534;
        }

        .tax-badge-paid .tax-badge-dot {
            background: #16a34a;
        }

        @media (max-width: 1100px) {
            .tax-grid,
            .tax-data {
                grid-template-columns: repeat(2, minmax(180px, 1fr));
            }
        }

        @media (max-width: 760px) {
            .tax-header {
                flex-direction: column;
                align-items: stretch;
            }

            .tax-actions {
                justify-content: flex-start;
            }

            .tax-grid,
            .tax-data {
                grid-template-columns: 1fr;
            }

            .tax-title h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
<jsp:include page="/includes/sidebar.jsp" />

<main class="main">
    <jsp:include page="/includes/topbar.jsp" />

    <div class="content tax-view">
        <div class="tax-header">
            <div class="tax-title">
                <h1>Detalle de Impuesto Vehicular</h1>
                <p>Codigo #${imp[0]} · Registro <fmt:formatDate value="${imp[9]}" pattern="d MMM yyyy"/></p>
            </div>

            <div class="tax-actions">
                <a href="${pageContext.request.contextPath}/funcionario/impuesto" class="btn-secondary">
                    <i class="fi fi-rr-arrow-left"></i> Volver
                </a>
                <c:if test="${estadoPagoGeneral == 'PENDIENTE' && estadoVehiculo == 'ACTIVO' && puedeGenerarCuotas}">
                    <a href="${pageContext.request.contextPath}/funcionario/cuotas?action=crear&tipoImpuesto=VEHICULAR&idReferencia=${imp[0]}" class="btn-primary">
                        <i class="fi fi-rr-add"></i> Generar Cuotas
                    </a>
                </c:if>
            </div>
        </div>

        <div class="tax-grid">
            <div class="tax-kpi">
                <div class="tax-kpi-label">Total 3 anios</div>
                <div class="tax-kpi-value">S/ <fmt:formatNumber value="${imp[7]}" type="number" maxFractionDigits="2"/></div>
            </div>
            <div class="tax-kpi">
                <div class="tax-kpi-label">Impuesto anual</div>
                <div class="tax-kpi-value">S/ <fmt:formatNumber value="${imp[6]}" type="number" maxFractionDigits="2"/></div>
            </div>
            <div class="tax-kpi">
                <div class="tax-kpi-label">Estado</div>
                <div class="tax-kpi-value">
                    <c:choose>
                        <c:when test="${estadoPagoGeneral == 'PENDIENTE'}">
                            <span class="tax-badge tax-badge-pending"><span class="tax-badge-dot"></span>Pendiente</span>
                        </c:when>
                        <c:otherwise>
                            <span class="tax-badge tax-badge-paid"><span class="tax-badge-dot"></span>Pagado</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="tax-panel">
            <h2>Datos generales</h2>
            <div class="tax-data">
                <div class="tax-item">
                    <span class="tax-item-label">Contribuyente</span>
                    <span class="tax-item-value">${imp[1]}</span>
                </div>
                <div class="tax-item">
                    <span class="tax-item-label">Vehiculo</span>
                    <span class="tax-item-value">${imp[2]}</span>
                </div>
                <div class="tax-item">
                    <span class="tax-item-label">Anio de inscripcion</span>
                    <span class="tax-item-value">${imp[3]}</span>
                </div>
                <div class="tax-item">
                    <span class="tax-item-label">Valor del vehiculo</span>
                    <span class="tax-item-value">S/ <fmt:formatNumber value="${imp[4]}" type="number" maxFractionDigits="2"/></span>
                </div>
                <div class="tax-item">
                    <span class="tax-item-label">Porcentaje aplicado</span>
                    <span class="tax-item-value"><fmt:formatNumber value="${imp[5]}" type="number" maxFractionDigits="2"/>%</span>
                </div>
                <div class="tax-item">
                    <span class="tax-item-label">Fecha de registro</span>
                    <span class="tax-item-value"><fmt:formatDate value="${imp[9]}" pattern="d MMM yyyy"/></span>
                </div>
            </div>
        </div>

        <div class="tax-table-wrap">
            <div class="tax-table-head">
                <h2>Detalle por anio</h2>
            </div>

            <table class="tax-table">
                <thead>
                <tr>
                    <th>Anio</th>
                    <th>Monto</th>
                    <th>Estado</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="d" items="${detalle}">
                    <tr>
                        <td>${d[1]}</td>
                        <td class="tax-mono">S/ <fmt:formatNumber value="${d[2]}" type="number" maxFractionDigits="2"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${d[3] == 'PAGADO'}">
                                    <span class="tax-badge tax-badge-paid"><span class="tax-badge-dot"></span>Pagado</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="tax-badge tax-badge-pending"><span class="tax-badge-dot"></span>Pendiente</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</main>
</body>
</html>

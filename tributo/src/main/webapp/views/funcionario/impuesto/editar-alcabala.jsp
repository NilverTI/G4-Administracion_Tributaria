<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar Alcabala</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

    <style>
        .edit-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 18px;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(170px, 1fr));
            gap: 12px;
            margin-bottom: 14px;
        }

        .detail-item {
            border: 1px solid var(--border);
            background: #fbfdff;
            border-radius: 12px;
            padding: 12px;
        }

        .detail-item label {
            display: block;
            font-size: 12px;
            color: var(--text-muted);
            margin-bottom: 4px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(180px, 1fr));
            gap: 12px;
        }

        .actions {
            display: flex;
            gap: 10px;
            margin-top: 14px;
        }

        .alert {
            border-radius: 12px;
            padding: 11px 14px;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 14px;
            border: 1px solid transparent;
        }

        .alert-error {
            background: #fef2f2;
            color: #991b1b;
            border-color: #fecaca;
        }

        @media (max-width: 920px) {
            .detail-grid, .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<jsp:include page="/includes/sidebar.jsp" />

<main class="main">
    <jsp:include page="/includes/topbar.jsp" />

    <div class="content">
        <div class="page-header">
            <div class="page-header-left">
                <h1>Editar Impuesto de Alcabala</h1>
                <p>Codigo: <strong>${alcabalaEdit[0]}</strong></p>
            </div>

            <a href="${pageContext.request.contextPath}/funcionario/impuesto?tab=alcabala" class="btn-secondary">
                <i class="fi fi-rr-arrow-left"></i> Volver
            </a>
        </div>

        <c:if test="${not empty sessionScope.flashError}">
            <div class="alert alert-error">${sessionScope.flashError}</div>
            <c:remove var="flashError" scope="session"/>
        </c:if>

        <fmt:formatDate value="${alcabalaEdit[2]}" pattern="yyyy-MM-dd" var="fechaVentaIso"/>
        <fmt:formatNumber value="${alcabalaEdit[1]}" type="number" maxFractionDigits="2" minFractionDigits="0" groupingUsed="false" var="valorVentaFmt"/>

        <div class="edit-card">
            <div class="detail-grid">
                <div class="detail-item">
                    <label>Estado</label>
                    <span>${alcabalaEdit[3]}</span>
                </div>
                <div class="detail-item">
                    <label>Valor catastral referencia</label>
                    <span>S/ <fmt:formatNumber value="${alcabalaEdit[4]}" type="number" maxFractionDigits="2"/></span>
                </div>
                <div class="detail-item">
                    <label>Nota</label>
                    <span>Al guardar se recalculan base imponible y monto segun UIT del anio.</span>
                </div>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/funcionario/impuesto">
                <input type="hidden" name="action" value="alcabala.editar">
                <input type="hidden" name="idAlcabala" value="${alcabalaEdit[0]}">

                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Valor de venta</label>
                        <input class="form-input" type="number" name="valorVenta" step="0.01" min="0" required value="${valorVentaFmt}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Fecha de venta</label>
                        <input class="form-input" type="date" name="fechaVenta" required value="${fechaVentaIso}">
                    </div>
                </div>

                <div class="actions">
                    <a href="${pageContext.request.contextPath}/funcionario/impuesto?tab=alcabala" class="btn-secondary">Cancelar</a>
                    <button type="submit" class="btn-primary">
                        <i class="fi fi-rr-disk"></i> Guardar cambios
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>
</body>
</html>

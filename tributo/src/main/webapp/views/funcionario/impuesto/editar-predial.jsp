<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar Impuesto Predial</title>

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
                <h1>Editar Impuesto Predial</h1>
                <p>Codigo: <strong>${predialEdit[0]}</strong></p>
            </div>

            <a href="${pageContext.request.contextPath}/funcionario/impuesto?tab=predial" class="btn-secondary">
                <i class="fi fi-rr-arrow-left"></i> Volver
            </a>
        </div>

        <c:if test="${not empty sessionScope.flashError}">
            <div class="alert alert-error">${sessionScope.flashError}</div>
            <c:remove var="flashError" scope="session"/>
        </c:if>

        <fmt:formatNumber value="${predialEdit[5]}" type="number" maxFractionDigits="4" minFractionDigits="0" groupingUsed="false" var="tasaAplicadaFmt"/>
        <fmt:formatNumber value="${predialEdit[6]}" type="number" maxFractionDigits="2" minFractionDigits="0" groupingUsed="false" var="montoAnualFmt"/>

        <div class="edit-card">
            <div class="detail-grid">
                <div class="detail-item">
                    <label>Contribuyente</label>
                    <span>${predialEdit[1]}</span>
                </div>
                <div class="detail-item">
                    <label>Direccion</label>
                    <span>${predialEdit[2]}</span>
                </div>
                <div class="detail-item">
                    <label>Zona</label>
                    <span>${predialEdit[3]}</span>
                </div>
                <div class="detail-item">
                    <label>Valor catastral</label>
                    <span>S/ <fmt:formatNumber value="${predialEdit[4]}" type="number" maxFractionDigits="2"/></span>
                </div>
                <div class="detail-item">
                    <label>Estado</label>
                    <span>${predialEdit[7]}</span>
                </div>
                <div class="detail-item">
                    <label>Fecha inicio</label>
                    <fmt:formatDate value="${predialEdit[10]}" pattern="d MMM yyyy"/>
                </div>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/funcionario/impuesto">
                <input type="hidden" name="action" value="predial.editar">
                <input type="hidden" name="idPredial" value="${predialEdit[0]}">

                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Tasa aplicada (%)</label>
                        <input class="form-input" type="number" name="tasaAplicada" step="0.0001" min="0" required value="${tasaAplicadaFmt}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Monto anual</label>
                        <input class="form-input" type="number" name="montoAnual" step="0.01" min="0" required value="${montoAnualFmt}">
                    </div>
                </div>

                <div class="actions">
                    <a href="${pageContext.request.contextPath}/funcionario/impuesto?tab=predial" class="btn-secondary">Cancelar</a>
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

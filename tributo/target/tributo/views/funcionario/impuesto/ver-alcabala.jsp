<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Detalle Impuesto de Alcabala</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

    <style>
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(170px, 1fr));
            gap: 12px;
            margin-top: 14px;
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

        .detail-item strong {
            font-size: 16px;
        }

        @media (max-width: 920px) {
            .detail-grid {
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
                <h1>Detalle Impuesto de Alcabala</h1>
                <p>Codigo: <strong>${alcabala[0]}</strong></p>
            </div>

            <a href="${pageContext.request.contextPath}/funcionario/impuesto?tab=alcabala" class="btn-secondary">
                <i class="fi fi-rr-arrow-left"></i> Volver
            </a>
        </div>

        <div class="detail-card">
            <h2>Datos de calculo</h2>

            <div class="detail-grid">
                <div class="detail-item">
                    <label>Comprador (quien paga)</label>
                    <span>${alcabala[1]}</span>
                </div>

                <div class="detail-item">
                    <label>Propietario vendedor</label>
                    <span>${alcabala[2]}</span>
                </div>

                <div class="detail-item">
                    <label>Direccion inmueble</label>
                    <span>${alcabala[3]}</span>
                </div>

                <div class="detail-item">
                    <label>Estado</label>
                    <span>${alcabala[13]}</span>
                </div>

                <div class="detail-item">
                    <label>Valor catastral referencia</label>
                    <strong>S/ <fmt:formatNumber value="${alcabala[4]}" type="number" maxFractionDigits="2"/></strong>
                </div>

                <div class="detail-item">
                    <label>Valor de venta</label>
                    <strong>S/ <fmt:formatNumber value="${alcabala[5]}" type="number" maxFractionDigits="2"/></strong>
                </div>

                <div class="detail-item">
                    <label>Base de calculo (max)</label>
                    <strong>S/ <fmt:formatNumber value="${alcabala[6]}" type="number" maxFractionDigits="2"/></strong>
                </div>

                <div class="detail-item">
                    <label>Monto inafecto (10 UIT)</label>
                    <span>S/ <fmt:formatNumber value="${alcabala[7]}" type="number" maxFractionDigits="2"/></span>
                </div>

                <div class="detail-item">
                    <label>Base imponible</label>
                    <span>S/ <fmt:formatNumber value="${alcabala[8]}" type="number" maxFractionDigits="2"/></span>
                </div>

                <div class="detail-item">
                    <label>Tasa aplicada</label>
                    <span><fmt:formatNumber value="${alcabala[9]}" type="number" maxFractionDigits="2"/>%</span>
                </div>

                <div class="detail-item">
                    <label>Monto alcabala</label>
                    <strong>S/ <fmt:formatNumber value="${alcabala[10]}" type="number" maxFractionDigits="2"/></strong>
                </div>

                <div class="detail-item">
                    <label>Anio UIT</label>
                    <span>${alcabala[11]}</span>
                </div>

                <div class="detail-item">
                    <label>Valor UIT</label>
                    <span>S/ <fmt:formatNumber value="${alcabala[12]}" type="number" maxFractionDigits="2"/></span>
                </div>

                <div class="detail-item">
                    <label>Fecha de venta</label>
                    <fmt:formatDate value="${alcabala[14]}" pattern="d MMM yyyy"/>
                </div>

                <div class="detail-item">
                    <label>Fecha de registro</label>
                    <fmt:formatDate value="${alcabala[15]}" pattern="d MMM yyyy"/>
                </div>
            </div>
        </div>
    </div>
</main>

</body>
</html>

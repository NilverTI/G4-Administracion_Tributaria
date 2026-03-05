<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Detalle de Vehiculo</title>

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
                <h1>Detalle de Vehiculo</h1>
                <p>Codigo: <strong>${vehiculo[0]}</strong></p>
            </div>

            <a href="${pageContext.request.contextPath}/funcionario/vehiculo" class="btn-secondary">
                <i class="fi fi-rr-arrow-left"></i> Volver
            </a>
        </div>

        <div class="detail-card">
            <h2>Datos generales</h2>

            <div class="detail-grid">
                <div class="detail-item">
                    <label>Contribuyente</label>
                    <span>${vehiculo[10]}</span>
                </div>

                <div class="detail-item">
                    <label>Placa</label>
                    <strong>${vehiculo[1]}</strong>
                </div>

                <div class="detail-item">
                    <label>Marca</label>
                    <span>${vehiculo[2]}</span>
                </div>

                <div class="detail-item">
                    <label>Modelo</label>
                    <span>${vehiculo[3]}</span>
                </div>

                <div class="detail-item">
                    <label>Anio</label>
                    <span>${vehiculo[4]}</span>
                </div>

                <div class="detail-item">
                    <label>Fecha de inscripcion</label>
                    <fmt:formatDate value="${vehiculo[5]}" pattern="d MMM yyyy"/>
                </div>

                <div class="detail-item">
                    <label>Valor</label>
                    <strong>S/ <fmt:formatNumber value="${vehiculo[6]}" type="number" maxFractionDigits="2"/></strong>
                </div>

                <div class="detail-item">
                    <label>Porcentaje vehicular</label>
                    <span><fmt:formatNumber value="${vehiculo[7]}" type="number" maxFractionDigits="2"/>%</span>
                </div>

                <div class="detail-item">
                    <label>Estado</label>
                    <span>${vehiculo[8]}</span>
                </div>

                <div class="detail-item">
                    <label>Registro</label>
                    <fmt:formatDate value="${vehiculo[9]}" pattern="d MMM yyyy"/>
                </div>
            </div>
        </div>
    </div>
</main>
</body>
</html>

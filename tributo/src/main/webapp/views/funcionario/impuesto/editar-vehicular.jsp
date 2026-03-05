<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar Vehiculo</title>

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

        .form-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(180px, 1fr));
            gap: 12px;
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

        .actions {
            display: flex;
            gap: 10px;
            margin-top: 14px;
        }

        @media (max-width: 920px) {
            .form-grid {
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
                <h1>Editar Vehiculo</h1>
                <p>Actualiza placa, marca, modelo, anio, fecha de inscripcion y valor.</p>
            </div>

            <a href="${pageContext.request.contextPath}/funcionario/impuesto?tab=vehicular" class="btn-secondary">
                <i class="fi fi-rr-arrow-left"></i> Volver
            </a>
        </div>

        <c:if test="${not empty sessionScope.flashError}">
            <div class="alert alert-error">${sessionScope.flashError}</div>
            <c:remove var="flashError" scope="session"/>
        </c:if>

        <fmt:formatDate value="${vehiculoEdit[6]}" pattern="yyyy-MM-dd" var="fechaInscripcionIso"/>
        <fmt:formatNumber value="${vehiculoEdit[7]}" type="number" maxFractionDigits="2" minFractionDigits="0" groupingUsed="false" var="valorVehiculo"/>

        <div class="edit-card">
            <form method="post" action="${pageContext.request.contextPath}/funcionario/impuesto">
                <input type="hidden" name="action" value="vehicular.editar">
                <input type="hidden" name="idVehiculo" value="${vehiculoEdit[0]}">

                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Placa</label>
                        <input class="form-input" type="text" name="placa" maxlength="20" required value="${vehiculoEdit[2]}">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Marca</label>
                        <input class="form-input" type="text" name="marca" maxlength="60" required value="${vehiculoEdit[3]}">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Modelo</label>
                        <input class="form-input" type="text" name="modelo" maxlength="60" required value="${vehiculoEdit[4]}">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Anio</label>
                        <input class="form-input" type="number" name="anio" min="1950" max="2100" required value="${vehiculoEdit[5]}">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Fecha de inscripcion</label>
                        <input class="form-input" type="date" name="fechaInscripcion" required value="${fechaInscripcionIso}">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Valor</label>
                        <input class="form-input" type="number" name="valor" min="0" step="0.01" required value="${valorVehiculo}">
                    </div>
                </div>

                <div class="actions">
                    <a href="${pageContext.request.contextPath}/funcionario/impuesto?tab=vehicular" class="btn-secondary">Cancelar</a>
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

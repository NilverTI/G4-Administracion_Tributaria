<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar Vehiculo</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css?v=20260303-7">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

    <style>
        .edit-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 18px;
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
                <p>Codigo: <strong>${vehiculo[0]}</strong></p>
            </div>

            <a href="${pageContext.request.contextPath}/funcionario/vehiculo" class="btn-secondary">
                <i class="fi fi-rr-arrow-left"></i> Volver
            </a>
        </div>

        <c:if test="${not empty sessionScope.flashError}">
            <div class="alert alert-error">${sessionScope.flashError}</div>
            <c:remove var="flashError" scope="session"/>
        </c:if>

        <fmt:formatDate value="${vehiculo[6]}" pattern="yyyy-MM-dd" var="fechaInscripcionIso"/>
        <fmt:formatNumber value="${vehiculo[7]}" type="number" maxFractionDigits="2" minFractionDigits="0" groupingUsed="false" var="valorVehiculo"/>
        <c:set var="contribuyenteActualTexto" value=""/>
        <c:forEach var="c" items="${contribuyentes}">
            <c:if test="${c[0] == vehiculo[1]}">
                <c:set var="contribuyenteActualTexto" value="${c[1]}"/>
            </c:if>
        </c:forEach>

        <div class="edit-card">
            <form method="post" action="${pageContext.request.contextPath}/funcionario/vehiculo">
                <input type="hidden" name="action" value="editar">
                <input type="hidden" name="idVehiculo" value="${vehiculo[0]}">

                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Contribuyente</label>
                        <div class="contribuyente-picker" data-contribuyente-picker>
                            <input type="hidden" name="idContribuyente" value="${vehiculo[1]}" data-contribuyente-id>
                            <input
                                    type="text"
                                    class="form-input"
                                    list="editarVehiculoContribuyenteOptions"
                                    placeholder="Buscar por DNI o nombre"
                                    autocomplete="off"
                                    value="${contribuyenteActualTexto}"
                                    data-contribuyente-input
                                    required>
                            <datalist id="editarVehiculoContribuyenteOptions">
                                <c:forEach var="c" items="${contribuyentes}">
                                    <option value="${c[1]}" data-search="${c[2]} ${c[1]}" data-id="${c[0]}"></option>
                                </c:forEach>
                            </datalist>
                            <span class="contribuyente-picker__hint">Busque por DNI o nombre y seleccione un contribuyente de la lista.</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Placa</label>
                        <input class="form-input" type="text" name="placa" maxlength="20" required value="${vehiculo[2]}">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Marca</label>
                        <input class="form-input" type="text" name="marca" maxlength="80" required value="${vehiculo[3]}">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Modelo</label>
                        <input class="form-input" type="text" name="modelo" maxlength="80" required value="${vehiculo[4]}">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Anio</label>
                        <input class="form-input" type="number" name="anio" min="1900" max="2100" required value="${vehiculo[5]}">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Fecha de inscripcion</label>
                        <input class="form-input" type="date" name="fechaInscripcion" required value="${fechaInscripcionIso}">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Valor</label>
                        <input class="form-input" type="number" name="valor" min="0" step="0.01" required value="${valorVehiculo}">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Estado actual</label>
                        <input class="form-input" type="text" readonly value="${vehiculo[8]}">
                    </div>
                </div>

                <div class="actions">
                    <a href="${pageContext.request.contextPath}/funcionario/vehiculo" class="btn-secondary">Cancelar</a>
                    <button type="submit" class="btn-primary">
                        <i class="fi fi-rr-disk"></i> Guardar cambios
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>
<script src="${pageContext.request.contextPath}/js/contribuyente-picker.js?v=20260303-3"></script>
</body>
</html>

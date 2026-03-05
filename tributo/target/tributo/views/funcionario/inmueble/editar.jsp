<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar Inmueble</title>

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

        .type-options {
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
            margin-top: 6px;
        }

        .type-option {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            font-size: 13px;
            color: var(--text);
        }

        .hidden {
            display: none;
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
                <h1>Editar Inmueble</h1>
                <p>Codigo: <strong>${inmueble[0]}</strong></p>
            </div>

            <a href="${pageContext.request.contextPath}/funcionario/inmueble" class="btn-secondary">
                <i class="fi fi-rr-arrow-left"></i> Volver
            </a>
        </div>

        <c:if test="${not empty sessionScope.flashError}">
            <div class="alert alert-error">${sessionScope.flashError}</div>
            <c:remove var="flashError" scope="session"/>
        </c:if>

        <fmt:formatNumber value="${inmueble[4]}" type="number" maxFractionDigits="2" minFractionDigits="0" groupingUsed="false" var="valorFmt"/>
        <fmt:formatNumber value="${inmueble[6]}" type="number" maxFractionDigits="2" minFractionDigits="0" groupingUsed="false" var="areaTerrenoFmt"/>
        <fmt:formatNumber value="${inmueble[7]}" type="number" maxFractionDigits="2" minFractionDigits="0" groupingUsed="false" var="areaConstruidaFmt"/>
        <c:set var="contribuyenteActualTexto" value=""/>
        <c:forEach var="c" items="${contribuyentes}">
            <c:if test="${c.id == inmueble[1]}">
                <c:set var="contribuyenteActualTexto" value="${c.persona.nombres} ${c.persona.apellidos}"/>
            </c:if>
        </c:forEach>

        <div class="edit-card">
            <form method="post" action="${pageContext.request.contextPath}/funcionario/inmueble">
                <input type="hidden" name="action" value="editar">
                <input type="hidden" name="idInmueble" value="${inmueble[0]}">

                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Contribuyente</label>
                        <div class="contribuyente-picker" data-contribuyente-picker>
                            <input type="hidden" name="idContribuyente" value="${inmueble[1]}" data-contribuyente-id>
                            <input
                                    type="text"
                                    class="form-input"
                                    list="editarInmuebleContribuyenteOptions"
                                    placeholder="Buscar por DNI o nombre"
                                    autocomplete="off"
                                    value="${contribuyenteActualTexto}"
                                    data-contribuyente-input
                                    required>
                            <datalist id="editarInmuebleContribuyenteOptions">
                                <c:forEach var="c" items="${contribuyentes}">
                                    <option
                                            value="${c.persona.nombres} ${c.persona.apellidos}"
                                            data-search="${c.persona.numeroDocumento} ${c.persona.nombres} ${c.persona.apellidos}"
                                            data-id="${c.id}"></option>
                                </c:forEach>
                            </datalist>
                            <span class="contribuyente-picker__hint">Busque por DNI o nombre y seleccione un contribuyente de la lista.</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Zona</label>
                        <select class="form-input" name="idZona" required>
                            <c:forEach var="z" items="${zonas}">
                                <option value="${z.id}" <c:if test="${z.id == inmueble[2]}">selected</c:if>>${z.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group full">
                        <label class="form-label">Direccion</label>
                        <input class="form-input" name="direccion" maxlength="255" required value="${inmueble[3]}">
                    </div>

                    <div class="form-group full">
                        <label class="form-label">Tipo de inmueble</label>
                        <div class="type-options">
                            <label class="type-option">
                                <input type="radio" name="tipoUso" value="TERRENO" <c:if test="${inmueble[5] != 'CONSTRUIDO'}">checked</c:if>>
                                Terreno
                            </label>
                            <label class="type-option">
                                <input type="radio" name="tipoUso" value="CONSTRUIDO" <c:if test="${inmueble[5] == 'CONSTRUIDO'}">checked</c:if>>
                                Inmueble construido
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Area terreno (m2)</label>
                        <input class="form-input" type="number" step="0.01" min="0.01" name="areaTerrenoM2" required value="${areaTerrenoFmt}">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Valor catastral</label>
                        <input class="form-input" type="number" step="0.01" min="0" name="valor" required value="${valorFmt}">
                    </div>

                    <div id="construidoFields" class="form-group full <c:if test="${inmueble[5] != 'CONSTRUIDO'}">hidden</c:if>">
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label">Area construida (m2)</label>
                                <input id="areaConstruidaInput" class="form-input" type="number" step="0.01" min="0.01" name="areaConstruidaM2" value="${areaConstruidaFmt}">
                            </div>

                            <div class="form-group">
                                <label class="form-label">Tipo de material</label>
                                <select id="tipoMaterialSelect" class="form-input" name="tipoMaterial">
                                    <option value="">Seleccione...</option>
                                    <option value="NOBLE" <c:if test="${inmueble[8] == 'NOBLE'}">selected</c:if>>Noble</option>
                                    <option value="RUSTICO" <c:if test="${inmueble[8] == 'RUSTICO'}">selected</c:if>>Rustico</option>
                                    <option value="MIXTO" <c:if test="${inmueble[8] == 'MIXTO'}">selected</c:if>>Mixto</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="actions">
                    <a href="${pageContext.request.contextPath}/funcionario/inmueble" class="btn-secondary">Cancelar</a>
                    <button type="submit" class="btn-primary">
                        <i class="fi fi-rr-disk"></i> Guardar cambios
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/js/contribuyente-picker.js?v=20260303-3"></script>
<script src="${pageContext.request.contextPath}/js/inmueble.js?v=20260303-4"></script>
</body>
</html>

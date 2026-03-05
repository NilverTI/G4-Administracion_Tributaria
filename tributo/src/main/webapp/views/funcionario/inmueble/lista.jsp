<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestion de Inmuebles</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css?v=20260303-7">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/inmueble.css">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

    <style>
        .alert {
            border-radius: 12px;
            padding: 11px 14px;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 14px;
            border: 1px solid transparent;
        }

        .alert-ok {
            background: #ecfdf3;
            color: #166534;
            border-color: #bbf7d0;
        }

        .alert-error {
            background: #fef2f2;
            color: #991b1b;
            border-color: #fecaca;
        }

        .table-card-scroll {
            overflow-x: auto;
            overflow-y: hidden;
        }

        .inmueble-table {
            min-width: 1140px;
        }

        .inmueble-table td,
        .inmueble-table th {
            white-space: nowrap;
        }

        .inmueble-table td:nth-child(2),
        .inmueble-table td:nth-child(3) {
            white-space: normal;
            min-width: 180px;
        }

        .action-group {
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .action-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: 8px;
            border: 1px solid var(--border);
            background: #fff;
            color: var(--text-muted);
            text-decoration: none;
            transition: .2s;
        }

        .action-icon:hover {
            border-color: #cbd5e1;
            color: var(--text);
            background: #f8fafc;
        }

        .action-icon.edit:hover {
            border-color: #bfdbfe;
            color: #1d4ed8;
            background: #eff6ff;
        }

        .action-icon.danger:hover {
            border-color: #fecaca;
            color: #b91c1c;
            background: #fef2f2;
        }

        .action-icon.success:hover {
            border-color: #bbf7d0;
            color: #166534;
            background: #ecfdf3;
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
    </style>
</head>

<body>
<jsp:include page="/includes/sidebar.jsp" />

<main class="main">
    <jsp:include page="/includes/topbar.jsp" />

    <div class="content">
        <div class="page-header">
            <div class="page-header-left">
                <h1>Gestion de Inmuebles</h1>
                <p>Administra terrenos e inmuebles construidos.</p>
            </div>

            <button class="btn-primary" id="btnNuevo">
                <i class="fi fi-rr-plus"></i> Nuevo Inmueble
            </button>
        </div>

        <c:if test="${not empty sessionScope.flashOk}">
            <div class="alert alert-ok">${sessionScope.flashOk}</div>
            <c:remove var="flashOk" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.flashError}">
            <div class="alert alert-error">${sessionScope.flashError}</div>
            <c:remove var="flashError" scope="session"/>
        </c:if>

        <div class="filter-bar">
            <div class="filter-search">
                <i class="fi fi-rr-search"></i>
                <input type="text" id="tableSearch" placeholder="Buscar direccion, contribuyente o tipo...">
            </div>

            <div class="filter-select">
                <i class="fi fi-rr-filter"></i>
                <select id="estadoFilter">
                    <option value="">Todos</option>
                    <option value="ACTIVO">Activo</option>
                    <option value="INACTIVO">Inactivo</option>
                </select>
            </div>
        </div>

        <div class="table-card table-card-scroll">
            <table class="data-table inmueble-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Contribuyente</th>
                    <th>Direccion</th>
                    <th>Zona</th>
                    <th>Tipo</th>
                    <th>Valor Catastral</th>
                    <th>Estado</th>
                    <th>Registro</th>
                    <th>Acciones</th>
                </tr>
                </thead>

                <tbody id="tableBody">
                <c:forEach var="i" items="${lista}">
                    <tr data-estado="${i[9]}">
                        <td>${i[0]}</td>
                        <td>${i[1]}</td>
                        <td>${i[2]}</td>
                        <td>${i[3]}</td>
                        <td>${i[5]}</td>
                        <td>S/ <fmt:formatNumber value="${i[4]}" type="number" maxFractionDigits="2"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${i[9] == 'ACTIVO'}">
                                    <span class="badge badge-activo">Activo</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-inactivo">Inactivo</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatDate value="${i[10]}" pattern="d MMM yyyy"/></td>
                        <td>
                            <div class="action-group">
                                <a href="${pageContext.request.contextPath}/funcionario/inmueble?action=ver&id=${i[0]}"
                                   class="action-icon" title="Ver detalle">
                                    <i class="fi fi-rr-eye"></i>
                                </a>

                                <a href="${pageContext.request.contextPath}/funcionario/inmueble?action=editar&id=${i[0]}"
                                   class="action-icon edit" title="Editar inmueble">
                                    <i class="fi fi-rr-edit"></i>
                                </a>

                                <c:choose>
                                    <c:when test="${i[9] == 'ACTIVO'}">
                                        <a href="${pageContext.request.contextPath}/funcionario/inmueble?action=estado&id=${i[0]}&estado=INACTIVO"
                                           class="action-icon danger" title="Desactivar inmueble">
                                            <i class="fi fi-rr-toggle-on"></i>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/funcionario/inmueble?action=estado&id=${i[0]}&estado=ACTIVO"
                                           class="action-icon success" title="Activar inmueble">
                                            <i class="fi fi-rr-toggle-off"></i>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <div class="table-pagination-footer">
                <div class="pagination-left">
                    <label for="pageSizeSelect">Mostrar</label>
                    <select id="pageSizeSelect" class="page-size-select">
                        <option value="5" selected>5</option>
                        <option value="10">10</option>
                        <option value="25">25</option>
                    </select>
                </div>

                <nav class="pagination-right" id="paginationControls" aria-label="Paginacion"></nav>
            </div>
        </div>
    </div>
</main>

<div class="modal-overlay" id="modalOverlay">
    <div class="modal">
        <div class="modal-header">
            <h2>Nuevo Inmueble</h2>
            <button type="button" class="modal-close" id="modalClose">
                <i class="fi fi-rr-cross-small"></i>
            </button>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/funcionario/inmueble">
            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label">Contribuyente</label>
                    <div class="contribuyente-picker" data-contribuyente-picker>
                        <input type="hidden" name="idContribuyente" value="" data-contribuyente-id>
                        <input
                                type="text"
                                class="form-input"
                                list="inmuebleContribuyenteOptions"
                                placeholder="Buscar por DNI o nombre"
                                autocomplete="off"
                                data-contribuyente-input
                                required>
                        <datalist id="inmuebleContribuyenteOptions">
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
                            <option value="${z.id}">${z.nombre}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group full">
                    <label class="form-label">Direccion</label>
                    <input class="form-input" name="direccion" maxlength="255" required>
                </div>

                <div class="form-group full">
                    <label class="form-label">Tipo de inmueble</label>
                    <div class="type-options">
                        <label class="type-option">
                            <input type="radio" name="tipoUso" value="TERRENO" checked>
                            Terreno
                        </label>
                        <label class="type-option">
                            <input type="radio" name="tipoUso" value="CONSTRUIDO">
                            Inmueble construido
                        </label>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Area terreno (m2)</label>
                    <input class="form-input" type="number" step="0.01" min="0.01" name="areaTerrenoM2" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Valor catastral</label>
                    <input class="form-input" type="number" step="0.01" min="0" name="valor" required>
                </div>

                <div id="construidoFields" class="form-group full hidden">
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label">Area construida (m2)</label>
                            <input id="areaConstruidaInput" class="form-input" type="number" step="0.01" min="0.01" name="areaConstruidaM2">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Tipo de material</label>
                            <select id="tipoMaterialSelect" class="form-input" name="tipoMaterial">
                                <option value="">Seleccione...</option>
                                <option value="NOBLE">Noble</option>
                                <option value="RUSTICO">Rustico</option>
                                <option value="MIXTO">Mixto</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn-secondary" id="modalCancel">Cancelar</button>
                <button type="submit" class="btn-primary">
                    <i class="fi fi-rr-disk"></i> Guardar
                </button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/pagination.js?v=20260303-5"></script>
<script src="${pageContext.request.contextPath}/js/contribuyente-picker.js?v=20260303-3"></script>
<script src="${pageContext.request.contextPath}/js/inmueble.js?v=20260303-4"></script>
</body>
</html>

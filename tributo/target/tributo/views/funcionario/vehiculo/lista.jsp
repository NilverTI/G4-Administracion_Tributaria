<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestion de Vehiculos</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css?v=20260303-7">
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
    </style>
</head>
<body>
<jsp:include page="/includes/sidebar.jsp" />

<main class="main">
    <jsp:include page="/includes/topbar.jsp" />

    <div class="content">
        <div class="page-header">
            <div class="page-header-left">
                <h1>Gestion de Vehiculos</h1>
                <p><c:out value="${cantidad}" /> vehiculos registrados</p>
            </div>

            <button class="btn-primary" id="btnNuevo">
                <i class="fi fi-rr-plus"></i> Registrar Vehiculo
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
                <input type="text" id="tableSearch" placeholder="Buscar por placa, marca o contribuyente...">
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

        <div class="table-card">
            <table class="data-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Placa</th>
                    <th>Contribuyente</th>
                    <th>Vehiculo</th>
                    <th>Anio</th>
                    <th>Valor</th>
                    <th>Estado</th>
                    <th>Registro</th>
                    <th>Acciones</th>
                </tr>
                </thead>

                <tbody id="tableBody">
                <c:forEach var="v" items="${lista}">
                    <tr data-estado="${v[9]}">
                        <td>${v[0]}</td>
                        <td>${v[1]}</td>
                        <td>${v[2]}</td>
                        <td>${v[3]}</td>
                        <td>${v[4]}</td>
                        <td>S/ <fmt:formatNumber value="${v[5]}" type="number" maxFractionDigits="0"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${v[9] == 'ACTIVO'}">
                                    <span class="badge badge-activo">Activo</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-inactivo">Inactivo</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatDate value="${v[10]}" pattern="d MMM yyyy"/></td>
                        <td>
                            <div class="action-group">
                                <a class="action-icon"
                                   href="${pageContext.request.contextPath}/funcionario/vehiculo?action=ver&id=${v[0]}"
                                   title="Ver detalle">
                                    <i class="fi fi-rr-eye"></i>
                                </a>

                                <a class="action-icon edit"
                                   href="${pageContext.request.contextPath}/funcionario/vehiculo?action=editar&id=${v[0]}"
                                   title="Editar vehiculo">
                                    <i class="fi fi-rr-edit"></i>
                                </a>

                                <c:choose>
                                    <c:when test="${v[9] == 'ACTIVO'}">
                                        <a class="action-icon danger"
                                           href="${pageContext.request.contextPath}/funcionario/vehiculo?action=estado&id=${v[0]}&estado=INACTIVO"
                                           title="Desactivar vehiculo">
                                            <i class="fi fi-rr-toggle-on"></i>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="action-icon success"
                                           href="${pageContext.request.contextPath}/funcionario/vehiculo?action=estado&id=${v[0]}&estado=ACTIVO"
                                           title="Activar vehiculo">
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

            <div id="pagination"></div>
        </div>
    </div>
</main>

<div class="modal-overlay" id="modalOverlay">
    <div class="modal">
        <div class="modal-header">
            <h2>Registrar Vehiculo</h2>
            <button type="button" class="modal-close" id="modalClose">
                <i class="fi fi-rr-cross-small"></i>
            </button>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/funcionario/vehiculo">
            <input type="hidden" name="action" value="crear">

            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label">Contribuyente</label>
                    <div class="contribuyente-picker" data-contribuyente-picker>
                        <input type="hidden" name="idContribuyente" value="" data-contribuyente-id>
                        <input
                                type="text"
                                class="form-input"
                                list="vehiculoContribuyenteOptions"
                                placeholder="Buscar por DNI o nombre"
                                autocomplete="off"
                                data-contribuyente-input
                                required>
                        <datalist id="vehiculoContribuyenteOptions">
                            <c:forEach var="c" items="${contribuyentes}">
                                <option value="${c[1]}" data-search="${c[2]} ${c[1]}" data-id="${c[0]}"></option>
                            </c:forEach>
                        </datalist>
                        <span class="contribuyente-picker__hint">Busque por DNI o nombre y seleccione un contribuyente de la lista.</span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Placa</label>
                    <input type="text" name="placa" class="form-input" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Marca</label>
                    <input type="text" name="marca" class="form-input" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Modelo</label>
                    <input type="text" name="modelo" class="form-input" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Anio</label>
                    <input type="number" name="anio" class="form-input" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Fecha de Inscripcion</label>
                    <input type="date" name="fechaInscripcion" class="form-input" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Valor</label>
                    <input type="number" step="0.01" name="valor" class="form-input" required>
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
<script>
    document.addEventListener("DOMContentLoaded", function () {
        if (window.ListingTools) {
            window.ListingTools.createTableController({
                itemSelector: "#tableBody tr",
                paginationSelector: "#pagination",
                searchInputSelector: "#tableSearch",
                filters: [
                    function (row) {
                        const estadoFilter = document.getElementById("estadoFilter");
                        const estado = (estadoFilter ? estadoFilter.value : "").toUpperCase();
                        const rowEstado = (row.dataset.estado || "").toUpperCase();
                        return !estado || rowEstado === estado;
                    }
                ],
                resetOnSelectors: ["#estadoFilter"]
            });
        }

        const modal = document.getElementById("modalOverlay");
        const btnNuevo = document.getElementById("btnNuevo");
        const btnClose = document.getElementById("modalClose");
        const btnCancel = document.getElementById("modalCancel");

        if (!modal || !btnNuevo || !btnClose || !btnCancel) {
            return;
        }

        function closeModal() {
            modal.classList.remove("open");
            const form = modal.querySelector("form");
            if (form) {
                form.reset();
            }
        }

        btnNuevo.addEventListener("click", function () {
            modal.classList.add("open");
        });

        btnClose.addEventListener("click", closeModal);
        btnCancel.addEventListener("click", closeModal);

        modal.addEventListener("click", function (event) {
            if (event.target === modal) {
                closeModal();
            }
        });
    });
</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestion de Impuestos</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css?v=20260303-5">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

    <style>
        .tabs {
            display: flex;
            gap: 12px;
            margin-bottom: 18px;
        }

        .tab-btn {
            padding: 10px 20px;
            border-radius: 12px;
            border: 1px solid var(--border);
            background: var(--card);
            color: var(--text);
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: .2s;
        }

        .tab-btn.active {
            background: var(--navy);
            color: #fff;
            border-color: var(--navy);
        }

        .tab-content {
            display: none;
            animation: fadeUp .25s ease;
        }

        .tab-content.active {
            display: block;
        }

        .tab-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 14px;
        }

        .tab-header p {
            font-size: 13px;
            color: var(--text-muted);
            margin-top: 4px;
        }

        .tab-header-actions {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            margin-left: auto;
            flex-wrap: wrap;
        }

        .tab-search {
            min-width: 280px;
        }

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

        .compact-table td,
        .compact-table th {
            padding-top: 12px;
            padding-bottom: 12px;
        }

        .badge-suspendido {
            background: #fef3c7;
            color: #92400e;
        }

        .badge-cerrado {
            background: #fee2e2;
            color: #991b1b;
        }

        .badge-pendiente {
            background: #e2e8f0;
            color: #334155;
        }

        .helper-mono {
            font-family: 'JetBrains Mono', monospace;
            font-size: 13px;
            font-weight: 600;
        }

        .form-inline {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
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

        .table-card-scroll {
            overflow-x: auto;
            overflow-y: hidden;
        }

        .alcabala-table {
            min-width: 1060px;
        }

        .alcabala-table th,
        .alcabala-table td {
            white-space: nowrap;
        }

        .alcabala-table td:nth-child(2),
        .alcabala-table td:nth-child(3),
        .alcabala-table td:nth-child(4) {
            white-space: normal;
            min-width: 140px;
        }

        .alcabala-table td:last-child {
            min-width: 122px;
        }

        @media (max-width: 880px) {
            .tab-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .tab-header-actions {
                width: 100%;
                margin-left: 0;
            }
            .tab-search {
                width: 100%;
                min-width: 0;
            }
            .tabs {
                flex-wrap: wrap;
            }
            .form-inline {
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
                <h1>Gestion de Impuestos</h1>
                <p>Administra impuestos vehiculares, prediales y de alcabala.</p>
            </div>

            <a href="${pageContext.request.contextPath}/funcionario/cuotas" class="btn-primary">
                <i class="fi fi-rr-calendar"></i> Gestionar Cuotas
            </a>
        </div>

        <c:if test="${not empty sessionScope.flashOk}">
            <div class="alert alert-ok">${sessionScope.flashOk}</div>
            <c:remove var="flashOk" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.flashError}">
            <div class="alert alert-error">${sessionScope.flashError}</div>
            <c:remove var="flashError" scope="session"/>
        </c:if>

        <div class="tabs" id="impuestoTabs" data-active-tab="${activeTab}">
            <button type="button" class="tab-btn" data-tab="vehicular">Vehicular</button>
            <button type="button" class="tab-btn" data-tab="predial">Predial</button>
            <button type="button" class="tab-btn" data-tab="alcabala">Alcabala</button>
        </div>

        <!-- Vehicular -->
        <section class="tab-content" id="tab-vehicular">
            <div class="tab-header">
                <div>
                    <h2>Impuestos Vehiculares</h2>
                    <p><c:out value="${listaVehicular.size()}"/> registros</p>
                </div>
                <div class="tab-header-actions">
                    <div class="filter-search tab-search">
                        <i class="fi fi-rr-search"></i>
                        <input type="text" id="vehicularSearch" placeholder="Buscar por codigo, contribuyente o placa...">
                    </div>
                    <a href="${pageContext.request.contextPath}/funcionario/impuesto?action=vehicular"
                       class="btn-primary">
                        <i class="fi fi-rr-plus"></i> Crear Impuesto
                    </a>
                </div>
            </div>

            <div class="table-card">
                <table class="data-table compact-table">
                    <thead>
                    <tr>
                        <th>Codigo</th>
                        <th>Contribuyente</th>
                        <th>Placa</th>
                        <th>Anio Ins.</th>
                        <th>Total</th>
                        <th>Pagado</th>
                        <th>Estado Pago</th>
                        <th>Vehiculo</th>
                        <th>Registro</th>
                        <th>Acciones</th>
                    </tr>
                    </thead>
                    <tbody id="vehicularTableBody">
                    <c:forEach var="i" items="${listaVehicular}">
                        <tr data-row="1">
                            <td>${i[0]}</td>
                            <td>${i[1]}</td>
                            <td>${i[2]}</td>
                            <td>${i[3]}</td>
                            <td>S/ <fmt:formatNumber value="${i[4]}" type="number" maxFractionDigits="2"/></td>
                            <td>S/ <fmt:formatNumber value="${i[5]}" type="number" maxFractionDigits="2"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${i[6] == 'PAGADO'}">
                                        <span class="badge badge-activo">Pagado</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-pendiente">Pendiente</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
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
                            <td><fmt:formatDate value="${i[7]}" pattern="d MMM yyyy"/></td>
                            <td>
                                <div class="action-group">
                                    <a href="${pageContext.request.contextPath}/funcionario/impuesto?action=ver&id=${i[0]}"
                                       class="action-icon" title="Ver detalle">
                                        <i class="fi fi-rr-eye"></i>
                                    </a>

                                    <c:if test="${not empty i[8]}">
                                        <a href="${pageContext.request.contextPath}/funcionario/impuesto?action=vehicular.editar&idVehiculo=${i[8]}"
                                           class="action-icon edit" title="Editar vehiculo">
                                            <i class="fi fi-rr-edit"></i>
                                        </a>

                                        <c:choose>
                                            <c:when test="${i[9] == 'ACTIVO'}">
                                                <a href="${pageContext.request.contextPath}/funcionario/impuesto?action=vehicular.estado&idVehiculo=${i[8]}&estado=INACTIVO"
                                                   class="action-icon danger" title="Desactivar vehiculo">
                                                    <i class="fi fi-rr-toggle-on"></i>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/funcionario/impuesto?action=vehicular.estado&idVehiculo=${i[8]}&estado=ACTIVO"
                                                   class="action-icon success" title="Activar vehiculo">
                                                    <i class="fi fi-rr-toggle-off"></i>
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                <div id="vehicularPagination"></div>
            </div>
        </section>

        <!-- Predial -->
        <section class="tab-content" id="tab-predial">
            <div class="tab-header">
                <div>
                    <h2>Impuestos Prediales</h2>
                    <p><c:out value="${listaPredial.size()}"/> registros</p>
                </div>
                <div class="tab-header-actions">
                    <div class="filter-search tab-search">
                        <i class="fi fi-rr-search"></i>
                        <input type="text" id="predialSearch" placeholder="Buscar por codigo, contribuyente o direccion...">
                    </div>
                    <a href="${pageContext.request.contextPath}/funcionario/impuesto?action=predial"
                       class="btn-primary">
                        <i class="fi fi-rr-plus"></i> Crear Impuesto Predial
                    </a>
                </div>
            </div>

            <div class="table-card table-card-scroll">
                <table class="data-table compact-table alcabala-table">
                    <thead>
                    <tr>
                        <th>Codigo</th>
                        <th>Contribuyente</th>
                        <th>Direccion</th>
                        <th>Zona</th>
                        <th>Valor Cat.</th>
                        <th>Tasa</th>
                        <th>Monto Anual</th>
                        <th>Estado</th>
                        <th>Registro</th>
                        <th>Acciones</th>
                    </tr>
                    </thead>
                    <tbody id="predialTableBody">
                    <c:forEach var="p" items="${listaPredial}">
                        <tr data-row="1">
                            <td>${p[0]}</td>
                            <td>${p[1]}</td>
                            <td>${p[2]}</td>
                            <td>${p[3]}</td>
                            <td>S/ <fmt:formatNumber value="${p[4]}" type="number" maxFractionDigits="2"/></td>
                            <td><fmt:formatNumber value="${p[5]}" type="number" maxFractionDigits="2"/>%</td>
                            <td class="helper-mono">S/ <fmt:formatNumber value="${p[6]}" type="number" maxFractionDigits="2"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${p[7] == 'ACTIVO'}">
                                        <span class="badge badge-activo">Activo</span>
                                    </c:when>
                                    <c:when test="${p[7] == 'SUSPENDIDO'}">
                                        <span class="badge badge-suspendido">Suspendido</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-cerrado">Cerrado</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><fmt:formatDate value="${p[9]}" pattern="d MMM yyyy"/></td>
                            <td>
                                <div class="action-group">
                                    <a href="${pageContext.request.contextPath}/funcionario/impuesto?action=verPredial&id=${p[0]}"
                                       class="action-icon" title="Ver detalle">
                                        <i class="fi fi-rr-eye"></i>
                                    </a>

                                    <a href="${pageContext.request.contextPath}/funcionario/impuesto?action=predial.editar&idPredial=${p[0]}"
                                       class="action-icon edit" title="Editar predial">
                                        <i class="fi fi-rr-edit"></i>
                                    </a>

                                    <c:choose>
                                        <c:when test="${p[7] == 'ACTIVO'}">
                                            <a href="${pageContext.request.contextPath}/funcionario/impuesto?action=predial.estado.rapido&idPredial=${p[0]}&estado=SUSPENDIDO"
                                               class="action-icon danger" title="Suspender predial">
                                                <i class="fi fi-rr-toggle-on"></i>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/funcionario/impuesto?action=predial.estado.rapido&idPredial=${p[0]}&estado=ACTIVO"
                                               class="action-icon success" title="Activar predial">
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
                <div id="predialPagination"></div>
            </div>
        </section>

        <!-- Alcabala -->
        <section class="tab-content" id="tab-alcabala">
            <div class="tab-header">
                <div>
                    <h2>Impuestos de Alcabala</h2>
                    <p><c:out value="${listaAlcabala.size()}"/> registros</p>
                </div>
                <div class="tab-header-actions">
                    <div class="filter-search tab-search">
                        <i class="fi fi-rr-search"></i>
                        <input type="text" id="alcabalaSearch" placeholder="Buscar por codigo, comprador o direccion...">
                    </div>
                    <button type="button" class="btn-primary" id="btnNuevaAlcabala">
                        <i class="fi fi-rr-plus"></i> Registrar Alcabala
                    </button>
                </div>
            </div>

            <div class="table-card">
                <table class="data-table compact-table">
                    <thead>
                    <tr>
                        <th>Codigo</th>
                        <th>Comprador</th>
                        <th>Propietario</th>
                        <th>Direccion</th>
                        <th>Venta</th>
                        <th>Impuesto</th>
                        <th>Estado</th>
                        <th>Fecha Venta</th>
                        <th>Acciones</th>
                    </tr>
                    </thead>
                    <tbody id="alcabalaTableBody">
                    <c:forEach var="a" items="${listaAlcabala}">
                        <tr data-row="1">
                            <td>${a[0]}</td>
                            <td>${a[1]}</td>
                            <td>${a[2]}</td>
                            <td>${a[3]}</td>
                            <td>S/ <fmt:formatNumber value="${a[4]}" type="number" maxFractionDigits="2"/></td>
                            <td class="helper-mono">S/ <fmt:formatNumber value="${a[7]}" type="number" maxFractionDigits="2"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${a[8] == 'REGISTRADO' || a[8] == 'ACTIVO'}">
                                        <span class="badge badge-activo">${a[8]}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-inactivo">${a[8]}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><fmt:formatDate value="${a[9]}" pattern="d MMM yyyy"/></td>
                            <td>
                                <div class="action-group">
                                    <a href="${pageContext.request.contextPath}/funcionario/impuesto?action=verAlcabala&id=${a[0]}"
                                       class="action-icon" title="Ver detalle">
                                        <i class="fi fi-rr-eye"></i>
                                    </a>

                                    <a href="${pageContext.request.contextPath}/funcionario/impuesto?action=alcabala.editar&idAlcabala=${a[0]}"
                                       class="action-icon edit" title="Editar alcabala">
                                        <i class="fi fi-rr-edit"></i>
                                    </a>

                                    <c:choose>
                                        <c:when test="${a[8] == 'REGISTRADO' || a[8] == 'ACTIVO'}">
                                            <a href="${pageContext.request.contextPath}/funcionario/impuesto?action=alcabala.estado&idAlcabala=${a[0]}&estado=INACTIVO"
                                               class="action-icon danger" title="Desactivar alcabala">
                                                <i class="fi fi-rr-toggle-on"></i>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/funcionario/impuesto?action=alcabala.estado&idAlcabala=${a[0]}&estado=ACTIVO"
                                               class="action-icon success" title="Activar alcabala">
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
                <div id="alcabalaPagination"></div>
            </div>
        </section>

    </div>
</main>

<!-- Modal Alcabala -->
<div class="modal-overlay" id="modalAlcabala">
    <div class="modal">
        <div class="modal-header">
            <h2>Registrar Alcabala</h2>
            <button type="button" class="modal-close" id="closeModalAlcabala">
                <i class="fi fi-rr-cross-small"></i>
            </button>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/funcionario/impuesto">
            <input type="hidden" name="action" value="crearAlcabala">

            <div class="form-grid">
                <div class="form-group full">
                    <label class="form-label">Inmueble</label>
                    <select class="form-input" name="idInmueble" required>
                        <c:forEach var="inm" items="${inmueblesAlcabala}">
                            <option value="${inm[0]}">
                                #${inm[0]} - ${inm[1]} - ${inm[2]}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group full">
                    <label class="form-label">Comprador (contribuyente que paga)</label>
                    <select class="form-input" name="idComprador" required>
                        <c:forEach var="c" items="${contribuyentesCombo}">
                            <option value="${c[0]}">${c[1]}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Valor de venta</label>
                    <input class="form-input" type="number" step="0.01" min="0" name="valorVenta" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Fecha de venta</label>
                    <input class="form-input" type="date" name="fechaVenta" required>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn-secondary" id="cancelModalAlcabala">Cancelar</button>
                <button type="submit" class="btn-primary">
                    <i class="fi fi-rr-disk"></i> Registrar
                </button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/pagination.js?v=20260303-5"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const buttons = document.querySelectorAll(".tab-btn");
        const tabs = document.querySelectorAll(".tab-content");
        const wrapper = document.getElementById("impuestoTabs");
        const defaultTab = wrapper?.dataset?.activeTab || "vehicular";

        function activate(tabName) {
            buttons.forEach(btn => {
                btn.classList.toggle("active", btn.dataset.tab === tabName);
            });
            tabs.forEach(tab => {
                tab.classList.toggle("active", tab.id === "tab-" + tabName);
            });
        }

        buttons.forEach(btn => {
            btn.addEventListener("click", () => activate(btn.dataset.tab));
        });

        activate(defaultTab);

        if (window.ListingTools) {
            window.ListingTools.createTableController({
                itemSelector: "#vehicularTableBody tr[data-row='1']",
                paginationSelector: "#vehicularPagination",
                searchInputSelector: "#vehicularSearch"
            });

            window.ListingTools.createTableController({
                itemSelector: "#predialTableBody tr[data-row='1']",
                paginationSelector: "#predialPagination",
                searchInputSelector: "#predialSearch"
            });

            window.ListingTools.createTableController({
                itemSelector: "#alcabalaTableBody tr[data-row='1']",
                paginationSelector: "#alcabalaPagination",
                searchInputSelector: "#alcabalaSearch"
            });
        }

        const modal = document.getElementById("modalAlcabala");
        const btnOpen = document.getElementById("btnNuevaAlcabala");
        const btnClose = document.getElementById("closeModalAlcabala");
        const btnCancel = document.getElementById("cancelModalAlcabala");

        function openModal() {
            if (modal) {
                modal.classList.add("open");
            }
        }

        function closeModal() {
            if (modal) {
                modal.classList.remove("open");
            }
        }

        if (btnOpen) btnOpen.addEventListener("click", openModal);
        if (btnClose) btnClose.addEventListener("click", closeModal);
        if (btnCancel) btnCancel.addEventListener("click", closeModal);

        if (modal) {
            modal.addEventListener("click", function (e) {
                if (e.target === modal) {
                    closeModal();
                }
            });
        }
    });
</script>

</body>
</html>

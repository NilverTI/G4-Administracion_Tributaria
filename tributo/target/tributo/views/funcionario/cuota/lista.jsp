<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Cuotas y Pagos</title>

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
        }

        .type-filter {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 8px 12px;
            font-size: 13px;
            color: var(--text-muted);
        }

        .type-filter select {
            border: none;
            outline: none;
            background: transparent;
            font-family: 'Sora', sans-serif;
            color: var(--text);
            font-size: 13px;
            cursor: pointer;
        }

        .tab-search {
            min-width: 280px;
        }

        .table-card-scroll {
            overflow-x: auto;
            overflow-y: hidden;
        }

        .table-wide {
            min-width: 1220px;
        }

        .table-wide th,
        .table-wide td {
            white-space: nowrap;
        }

        .table-wide td:nth-child(4) {
            white-space: normal;
            min-width: 190px;
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

        .badge-fraccionado {
            background: #e0f2fe;
            color: #075985;
        }

        .badge-cerrado {
            background: #dcfce7;
            color: #166534;
        }

        .badge-historico {
            background: #e2e8f0;
            color: #334155;
        }

        .helper-mono {
            font-family: 'JetBrains Mono', monospace;
            font-size: 13px;
            font-weight: 600;
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

        .action-icon.primary:hover {
            border-color: #bfdbfe;
            color: #1d4ed8;
            background: #eff6ff;
        }

        .btn-toggle-history {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 10px 14px;
            border-radius: 10px;
            border: 1px solid var(--border);
            background: var(--card);
            color: var(--text);
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            transition: .2s;
        }

        .btn-toggle-history:hover {
            border-color: #cbd5e1;
            background: #f8fafc;
        }

        @media (max-width: 880px) {
            .tab-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .tab-header-actions {
                width: 100%;
                justify-content: flex-start;
                margin-left: 0;
            }

            .tab-search {
                width: 100%;
                min-width: 0;
            }

            .tabs {
                flex-wrap: wrap;
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
                <h1>Gestion de Cuotas y Pagos</h1>
                <p>Fracciona impuestos activos y registra el pago de cada cuota.</p>
            </div>

            <a href="${pageContext.request.contextPath}/funcionario/cuotas?action=crear" class="btn-primary">
                <i class="fi fi-rr-plus"></i> Crear Cuotas
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

        <div class="tabs" id="cuotaTabs" data-active-tab="${activeTab}">
            <button type="button" class="tab-btn" data-tab="cuotas">Fraccionamientos</button>
            <button type="button" class="tab-btn" data-tab="pagos">Pagos Pendientes</button>
        </div>

        <section class="tab-content" id="tab-cuotas">
            <c:choose>
                <c:when test="${mostrarHistoricosFracc}">
                    <c:url var="toggleHistoricosFraccUrl" value="/funcionario/cuotas">
                        <c:param name="tab" value="cuotas"/>
                        <c:param name="historicosFracc" value="0"/>
                        <c:param name="historicosPagos" value="${mostrarHistoricosPagos ? '1' : '0'}"/>
                    </c:url>
                </c:when>
                <c:otherwise>
                    <c:url var="toggleHistoricosFraccUrl" value="/funcionario/cuotas">
                        <c:param name="tab" value="cuotas"/>
                        <c:param name="historicosFracc" value="1"/>
                        <c:param name="historicosPagos" value="${mostrarHistoricosPagos ? '1' : '0'}"/>
                    </c:url>
                </c:otherwise>
            </c:choose>

            <div class="tab-header">
                <div>
                    <h2>Listado de Fraccionamientos</h2>
                    <p>
                        <c:out value="${fraccionamientos.size()}"/> registros
                        <c:if test="${mostrarHistoricosFracc}">
                            (incluye historicos)
                        </c:if>
                    </p>
                </div>
                <div class="tab-header-actions">
                    <div class="filter-search tab-search">
                        <i class="fi fi-rr-search"></i>
                        <input type="text" id="fraccionamientoSearch" placeholder="Buscar por ID, tipo o contribuyente...">
                    </div>
                    <div class="type-filter">
                        <span>Tipo</span>
                        <select id="tipoCuotasFilter">
                            <option value="TODOS">Todos</option>
                            <option value="PREDIAL">Predial</option>
                            <option value="VEHICULAR">Vehicular</option>
                            <option value="ALCABALA">Alcabala</option>
                        </select>
                    </div>
                    <a href="${toggleHistoricosFraccUrl}" class="btn-toggle-history">
                        <c:choose>
                            <c:when test="${mostrarHistoricosFracc}">Ocultar historicos</c:when>
                            <c:otherwise>Ver historicos</c:otherwise>
                        </c:choose>
                    </a>
                </div>
            </div>

            <div class="table-card table-card-scroll">
                <table class="data-table table-wide">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tipo</th>
                        <th>Impuesto</th>
                        <th>Contribuyente</th>
                        <th>Monto Anual</th>
                        <th>Periodicidad</th>
                        <th>Cuotas</th>
                        <th>Estado</th>
                        <th>Registro</th>
                        <th>Acciones</th>
                    </tr>
                    </thead>
                    <tbody id="fraccionamientoTableBody">
                    <c:choose>
                        <c:when test="${empty fraccionamientos}">
                            <tr>
                                <td colspan="10">No hay fraccionamientos registrados.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="f" items="${fraccionamientos}">
                                <tr data-row="1" data-tipo="${f[1]}" data-historico="${f[13]}">
                                    <td>${f[0]}</td>
                                    <td>${f[1]}</td>
                                    <td>IMP-${f[2]}</td>
                                    <td>${f[4]}</td>
                                    <td class="helper-mono">S/ <fmt:formatNumber value="${f[6]}" type="number" maxFractionDigits="2"/></td>
                                    <td>${f[7]}</td>
                                    <td>${f[9]}/${f[8]}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${f[13] == false}">
                                                <span class="badge badge-historico">Historico</span>
                                            </c:when>
                                            <c:when test="${f[11] == 'CERRADO'}">
                                                <span class="badge badge-cerrado">Cerrado</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-fraccionado">Activo</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><fmt:formatDate value="${f[12]}" pattern="d MMM yyyy"/></td>
                                    <td>
                                        <div class="action-group">
                                            <a href="${pageContext.request.contextPath}/funcionario/cuotas?action=ver&id=${f[0]}"
                                               class="action-icon primary"
                                               title="Ver mas">
                                                <i class="fi fi-rr-eye"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
                <div id="fraccionamientoPagination"></div>
            </div>
        </section>

        <section class="tab-content" id="tab-pagos">
            <c:choose>
                <c:when test="${mostrarHistoricosPagos}">
                    <c:url var="toggleHistoricosPagosUrl" value="/funcionario/cuotas">
                        <c:param name="tab" value="pagos"/>
                        <c:param name="historicosFracc" value="${mostrarHistoricosFracc ? '1' : '0'}"/>
                        <c:param name="historicosPagos" value="0"/>
                    </c:url>
                </c:when>
                <c:otherwise>
                    <c:url var="toggleHistoricosPagosUrl" value="/funcionario/cuotas">
                        <c:param name="tab" value="pagos"/>
                        <c:param name="historicosFracc" value="${mostrarHistoricosFracc ? '1' : '0'}"/>
                        <c:param name="historicosPagos" value="1"/>
                    </c:url>
                </c:otherwise>
            </c:choose>

            <div class="tab-header">
                <div>
                    <h2>Cuotas Pendientes de Pago</h2>
                    <p>
                        <c:out value="${cuotasPendientes.size()}"/> cuotas por cobrar
                        <c:if test="${mostrarHistoricosPagos}">
                            (incluye historicos)
                        </c:if>
                    </p>
                </div>
                <div class="tab-header-actions">
                    <div class="filter-search tab-search">
                        <i class="fi fi-rr-search"></i>
                        <input type="text" id="pagosSearch" placeholder="Buscar por ID, tipo o contribuyente...">
                    </div>
                    <div class="type-filter">
                        <span>Tipo</span>
                        <select id="tipoPagosFilter">
                            <option value="TODOS">Todos</option>
                            <option value="PREDIAL">Predial</option>
                            <option value="VEHICULAR">Vehicular</option>
                            <option value="ALCABALA">Alcabala</option>
                        </select>
                    </div>
                    <a href="${toggleHistoricosPagosUrl}" class="btn-toggle-history">
                        <c:choose>
                            <c:when test="${mostrarHistoricosPagos}">Ocultar historicos</c:when>
                            <c:otherwise>Ver historicos</c:otherwise>
                        </c:choose>
                    </a>
                </div>
            </div>

            <div class="table-card table-card-scroll">
                <table class="data-table table-wide">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tipo</th>
                        <th>Impuesto</th>
                        <th>Contribuyente</th>
                        <th>Monto Anual</th>
                        <th>Periodicidad</th>
                        <th>Cuotas</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>
                    </thead>
                    <tbody id="pagosTableBody">
                    <c:choose>
                        <c:when test="${empty cuotasPendientes}">
                            <tr>
                                <td colspan="9">No hay cuotas pendientes en este momento.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="p" items="${cuotasPendientes}">
                                <tr data-row="1" data-tipo="${p[1]}" data-historico="${p[13]}">
                                    <td>${p[0]}</td>
                                    <td>${p[1]}</td>
                                    <td>IMP-${p[2]}</td>
                                    <td>${p[4]}</td>
                                    <td class="helper-mono">S/ <fmt:formatNumber value="${p[5]}" type="number" maxFractionDigits="2"/></td>
                                    <td>${p[6]}</td>
                                    <td>${p[8]}/${p[7]}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p[13] == false}">
                                                <span class="badge badge-historico">Historico</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-fraccionado">Pendiente</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            <a href="${pageContext.request.contextPath}/funcionario/cuotas?action=ver&id=${p[0]}"
                                               class="action-icon primary"
                                               title="Detalle">
                                                <i class="fi fi-rr-eye"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
                <div id="pagosPagination"></div>
            </div>
        </section>
    </div>
</main>

<script src="${pageContext.request.contextPath}/js/pagination.js?v=20260303-5"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const buttons = document.querySelectorAll(".tab-btn");
        const tabs = document.querySelectorAll(".tab-content");
        const wrapper = document.getElementById("cuotaTabs");
        const defaultTab = wrapper?.dataset?.activeTab || "cuotas";

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
                itemSelector: "#fraccionamientoTableBody tr[data-row='1']",
                paginationSelector: "#fraccionamientoPagination",
                searchInputSelector: "#fraccionamientoSearch",
                filters: [
                    function (row) {
                        const filter = document.getElementById("tipoCuotasFilter");
                        const tipo = (filter ? filter.value : "TODOS").toUpperCase();
                        const tipoRow = (row.dataset.tipo || "").toUpperCase();
                        return tipo === "TODOS" || tipoRow === tipo;
                    }
                ],
                resetOnSelectors: ["#tipoCuotasFilter"]
            });

            window.ListingTools.createTableController({
                itemSelector: "#pagosTableBody tr[data-row='1']",
                paginationSelector: "#pagosPagination",
                searchInputSelector: "#pagosSearch",
                filters: [
                    function (row) {
                        const filter = document.getElementById("tipoPagosFilter");
                        const tipo = (filter ? filter.value : "TODOS").toUpperCase();
                        const tipoRow = (row.dataset.tipo || "").toUpperCase();
                        return tipo === "TODOS" || tipoRow === tipo;
                    }
                ],
                resetOnSelectors: ["#tipoPagosFilter"]
            });
        }
    });
</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Configuracion del Sistema</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css?v=20260303-9">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&display=swap">
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

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 8px;
            margin-bottom: 12px;
        }

        .summary-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 10px 12px;
        }

        .summary-card p {
            font-size: 11px;
            color: var(--text-muted);
            margin-bottom: 3px;
        }

        .summary-card strong {
            display: block;
            font-size: 18px;
            line-height: 1;
            margin-bottom: 2px;
            color: var(--text);
        }

        .summary-card span {
            font-size: 11px;
            color: var(--text-muted);
        }

        .tabs {
            display: flex;
            gap: 12px;
            margin-bottom: 18px;
        }

        .tab-btn {
            padding: 10px 20px;
            border-radius: 12px;
            background: var(--card);
            border: 1px solid var(--border);
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: .2s;
            color: var(--text);
        }

        .tab-btn.active {
            background: var(--navy);
            color: #fff;
            border-color: var(--navy);
        }

        .tab-content {
            display: none;
            animation: fadeUp .3s ease;
        }

        .tab-content.active {
            display: block;
        }

        .section-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 12px;
        }

        .section-actions {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            margin-left: auto;
        }

        .tab-search {
            min-width: 280px;
        }

        .section-title h2 {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 2px;
        }

        .section-title p {
            font-size: 13px;
            color: var(--text-muted);
        }

        .table-card-scroll {
            overflow-x: auto;
            overflow-y: hidden;
            margin-bottom: 12px;
        }

        .data-table {
            min-width: 760px;
        }

        .data-table tbody tr {
            cursor: default;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            white-space: nowrap;
        }

        .badge-activo {
            background: #d1fae5;
            color: #065f46;
        }

        .badge-inactivo {
            background: #f1f5f9;
            color: #475569;
        }

        .helper-mono {
            font-family: 'JetBrains Mono', monospace;
            font-size: 13px;
            font-weight: 600;
        }

        .action-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 7px 10px;
            font-size: 12px;
            font-weight: 600;
            color: var(--text-muted);
            text-decoration: none;
            background: #fff;
            transition: .2s;
        }

        .action-link:hover {
            border-color: #bfdbfe;
            color: #1d4ed8;
            background: #eff6ff;
        }

        .action-btn {
            border: 1px solid var(--border);
            border-radius: 10px;
            width: 34px;
            height: 34px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            background: #fff;
            color: var(--text-muted);
            transition: .2s;
        }

        .action-btn:hover {
            border-color: #bfdbfe;
            color: #1d4ed8;
            background: #eff6ff;
        }

        @media (max-width: 960px) {
            .summary-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .section-head,
            .page-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .section-actions {
                width: 100%;
                margin-left: 0;
            }

            .tab-search {
                width: 100%;
                min-width: 0;
            }
        }

        @media (max-width: 620px) {
            .summary-grid {
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
                <h1>Configuracion del Sistema</h1>
                <p>Gestion de zonas, UIT y parametros vehiculares.</p>
            </div>
            <button class="btn-primary" type="button" onclick="openModal('func')">
                <i class="fi fi-rr-user-add"></i> Nuevo funcionario
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

        <c:set var="zonasActivas" value="0"/>
        <c:forEach var="z" items="${zonas}">
            <c:if test="${z[4] == 'ACTIVO'}">
                <c:set var="zonasActivas" value="${zonasActivas + 1}"/>
            </c:if>
        </c:forEach>

        <c:set var="vehActivos" value="0"/>
        <c:forEach var="v" items="${vehiculares}">
            <c:if test="${v[2] == 'ACTIVO'}">
                <c:set var="vehActivos" value="${vehActivos + 1}"/>
            </c:if>
        </c:forEach>

        <div class="summary-grid">
            <article class="summary-card">
                <p>Zonas</p>
                <strong><c:out value="${zonas.size()}"/></strong>
                <span><c:out value="${zonasActivas}"/> activas</span>
            </article>
            <article class="summary-card">
                <p>UIT</p>
                <strong><c:out value="${uits.size()}"/></strong>
                <span>registros configurados</span>
            </article>
            <article class="summary-card">
                <p>Vehicular %</p>
                <strong><c:out value="${vehiculares.size()}"/></strong>
                <span><c:out value="${vehActivos}"/> activos</span>
            </article>
        </div>

        <div class="tabs" id="configTabs" data-active-tab="${empty activeTab ? 'zonas' : activeTab}">
            <button type="button" class="tab-btn" data-tab="zonas">Zonas</button>
            <button type="button" class="tab-btn" data-tab="uit">UIT</button>
            <button type="button" class="tab-btn" data-tab="veh">Vehicular %</button>
        </div>

        <section class="tab-content" id="tab-zonas">
            <div class="section-head">
                <div class="section-title">
                    <h2>Listado de Zonas</h2>
                    <p><c:out value="${zonas.size()}"/> registros</p>
                </div>
                <div class="section-actions">
                    <div class="filter-search tab-search">
                        <i class="fi fi-rr-search"></i>
                        <input type="text" id="zonasSearch" placeholder="Buscar por ID, codigo o nombre...">
                    </div>
                    <button class="btn-primary" type="button" onclick="openModal('zonas')">
                        <i class="fi fi-rr-plus"></i> Nueva zona
                    </button>
                </div>
            </div>

            <div class="table-card table-card-scroll">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Codigo</th>
                        <th>Nombre</th>
                        <th>Tasa Predial</th>
                        <th>Estado</th>
                        <th>Accion</th>
                    </tr>
                    </thead>
                    <tbody id="zonasTableBody">
                    <c:choose>
                        <c:when test="${empty zonas}">
                            <tr><td colspan="6">No hay zonas registradas.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="z" items="${zonas}">
                                <tr data-row="1">
                                    <td>${z[0]}</td>
                                    <td class="helper-mono">${z[1]}</td>
                                    <td>${z[2]}</td>
                                    <td class="helper-mono"><fmt:formatNumber value="${z[3]}" type="number" minFractionDigits="2" maxFractionDigits="4"/>%</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${z[4] == 'ACTIVO'}">
                                                <span class="badge badge-activo">Activo</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-inactivo">Inactivo</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a class="action-link"
                                           href="${pageContext.request.contextPath}/funcionario/configuracion?action=zonas.estado&id=${z[0]}&estado=${z[4]=='ACTIVO'?'INACTIVO':'ACTIVO'}&tab=zonas"
                                           title="Cambiar estado">
                                            <i class="fi fi-rr-refresh"></i>
                                            ${z[4]=='ACTIVO'?'Inactivar':'Activar'}
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
                <div id="zonasPagination"></div>
            </div>
        </section>

        <section class="tab-content" id="tab-uit">
            <div class="section-head">
                <div class="section-title">
                    <h2>Listado UIT</h2>
                    <p><c:out value="${uits.size()}"/> registros</p>
                </div>
                <div class="section-actions">
                    <div class="filter-search tab-search">
                        <i class="fi fi-rr-search"></i>
                        <input type="text" id="uitSearch" placeholder="Buscar por anio o valor...">
                    </div>
                    <button class="btn-primary" type="button" onclick="openModal('uit')">
                        <i class="fi fi-rr-plus"></i> Registrar UIT
                    </button>
                </div>
            </div>

            <div class="table-card table-card-scroll">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>Anio</th>
                        <th>Valor (S/)</th>
                        <th>Accion</th>
                    </tr>
                    </thead>
                    <tbody id="uitTableBody">
                    <c:choose>
                        <c:when test="${empty uits}">
                            <tr><td colspan="3">No hay UIT registradas.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="u" items="${uits}">
                                <tr data-row="1">
                                    <td>${u[0]}</td>
                                    <td class="helper-mono">S/ <fmt:formatNumber value="${u[1]}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    <td>
                                        <button type="button" class="action-btn"
                                                onclick="openModalEditUIT('${u[0]}', '${u[1]}')"
                                                title="Editar UIT">
                                            <i class="fi fi-rr-edit"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
                <div id="uitPagination"></div>
            </div>
        </section>

        <section class="tab-content" id="tab-veh">
            <div class="section-head">
                <div class="section-title">
                    <h2>Configuracion Vehicular</h2>
                    <p><c:out value="${vehiculares.size()}"/> registros</p>
                </div>
                <div class="section-actions">
                    <div class="filter-search tab-search">
                        <i class="fi fi-rr-search"></i>
                        <input type="text" id="vehSearch" placeholder="Buscar por anio, porcentaje o estado...">
                    </div>
                    <button class="btn-primary" type="button" onclick="openModal('veh')">
                        <i class="fi fi-rr-plus"></i> Nuevo porcentaje
                    </button>
                </div>
            </div>

            <div class="table-card table-card-scroll">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>Anio</th>
                        <th>Porcentaje</th>
                        <th>Estado</th>
                        <th>Accion</th>
                    </tr>
                    </thead>
                    <tbody id="vehTableBody">
                    <c:choose>
                        <c:when test="${empty vehiculares}">
                            <tr><td colspan="4">No hay configuraciones vehiculares registradas.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="v" items="${vehiculares}">
                                <tr data-row="1">
                                    <td>${v[0]}</td>
                                    <td class="helper-mono"><fmt:formatNumber value="${v[1]}" type="number" minFractionDigits="2" maxFractionDigits="4"/>%</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${v[2] == 'ACTIVO'}">
                                                <span class="badge badge-activo">Activo</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-inactivo">Inactivo</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a class="action-link"
                                           href="${pageContext.request.contextPath}/funcionario/configuracion?action=veh.estado&anio=${v[0]}&estado=${v[2]=='ACTIVO'?'INACTIVO':'ACTIVO'}&tab=veh"
                                           title="Cambiar estado">
                                            <i class="fi fi-rr-refresh"></i>
                                            ${v[2]=='ACTIVO'?'Inactivar':'Activar'}
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
                <div id="vehPagination"></div>
            </div>
        </section>
    </div>
</main>

<div class="modal-overlay" id="modalOverlay">
    <div class="modal">
        <div class="modal-header">
            <h2 id="modalTitle"></h2>
            <button class="modal-close" type="button" onclick="closeModal()">
                <i class="fi fi-rr-cross-small"></i>
            </button>
        </div>

        <form method="post" id="modalForm" action="${pageContext.request.contextPath}/funcionario/configuracion">
            <input type="hidden" name="action" id="modalAction">
            <input type="hidden" name="tab" id="modalTab" value="zonas">

            <div class="form-grid" id="modalFields"></div>

            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeModal()">Cancelar</button>
                <button type="submit" class="btn-primary">
                    <i class="fi fi-rr-disk"></i> Guardar
                </button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/pagination.js?v=20260303-5"></script>
<script>
    (function () {
        const tabsHost = document.getElementById("configTabs");
        const tabButtons = document.querySelectorAll(".tab-btn");
        const tabContents = document.querySelectorAll(".tab-content");
        const modalTab = document.getElementById("modalTab");

        const defaultTab = (tabsHost?.dataset?.activeTab || "zonas").toLowerCase();

        function normalizeTab(tab) {
            const value = (tab || "").toLowerCase();
            if (value === "zonas" || value === "uit" || value === "veh") {
                return value;
            }
            return "zonas";
        }

        function setModalTab(tab) {
            if (modalTab) {
                modalTab.value = normalizeTab(tab);
            }
        }

        function updateTabInUrl(tab) {
            const url = new URL(window.location.href);
            url.searchParams.set("tab", normalizeTab(tab));
            history.replaceState({}, "", url.toString());
        }

        function activate(tab) {
            const key = normalizeTab(tab);

            tabButtons.forEach(btn => {
                btn.classList.toggle("active", btn.dataset.tab === key);
            });

            tabContents.forEach(content => {
                content.classList.toggle("active", content.id === "tab-" + key);
            });

            setModalTab(key);
            updateTabInUrl(key);
        }

        tabButtons.forEach(btn => {
            btn.addEventListener("click", function () {
                activate(this.dataset.tab);
            });
        });

        activate(defaultTab);

        if (window.ListingTools) {
            window.ListingTools.createTableController({
                itemSelector: "#zonasTableBody tr[data-row='1']",
                paginationSelector: "#zonasPagination",
                searchInputSelector: "#zonasSearch"
            });

            window.ListingTools.createTableController({
                itemSelector: "#uitTableBody tr[data-row='1']",
                paginationSelector: "#uitPagination",
                searchInputSelector: "#uitSearch"
            });

            window.ListingTools.createTableController({
                itemSelector: "#vehTableBody tr[data-row='1']",
                paginationSelector: "#vehPagination",
                searchInputSelector: "#vehSearch"
            });
        }
    })();

    function openModal(type) {
        const overlay = document.getElementById("modalOverlay");
        const title = document.getElementById("modalTitle");
        const fields = document.getElementById("modalFields");
        const action = document.getElementById("modalAction");
        const modalTab = document.getElementById("modalTab");

        fields.innerHTML = "";

        if (type === "zonas") {
            title.innerText = "Registrar Zona";
            action.value = "zonas.crear";
            modalTab.value = "zonas";
            fields.innerHTML = `
                <div class="form-group">
                    <label class="form-label">Codigo</label>
                    <input class="form-input" name="codigo" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Nombre</label>
                    <input class="form-input" name="nombre" required>
                </div>
                <div class="form-group full">
                    <label class="form-label">Tasa (%)</label>
                    <input class="form-input" type="number" step="0.01" name="tasa" min="0" required>
                </div>
            `;
        } else if (type === "uit") {
            title.innerText = "Registrar UIT";
            action.value = "uit.crear";
            modalTab.value = "uit";
            fields.innerHTML = `
                <div class="form-group">
                    <label class="form-label">Anio</label>
                    <input class="form-input" type="number" name="anio" min="2000" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Valor</label>
                    <input class="form-input" type="number" step="0.01" name="valor" min="0" required>
                </div>
            `;
        } else if (type === "veh") {
            title.innerText = "Nuevo Porcentaje Vehicular";
            action.value = "veh.crear";
            modalTab.value = "veh";
            fields.innerHTML = `
                <div class="form-group">
                    <label class="form-label">Anio</label>
                    <input class="form-input" type="number" name="anio" min="2000" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Porcentaje</label>
                    <input class="form-input" type="number" step="0.01" name="porcentaje" min="0" required>
                </div>
            `;
        } else {
            title.innerText = "Crear Funcionario";
            action.value = "func.crear";
            modalTab.value = "zonas";
            fields.innerHTML = `
                <div class="form-group full">
                    <label class="form-label">Persona registrada</label>
                    <select class="form-input" name="correo" required>
                        <option value="">Seleccione una persona</option>
                        <c:forEach var="p" items="${personasFuncionarios}">
                            <option value="${p[2]}">${p[1]} (${p[2]}) - ${p[3]}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Contrasena</label>
                    <input class="form-input" type="password" name="password" minlength="8" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Confirmar contrasena</label>
                    <input class="form-input" type="password" name="confirmarPassword" minlength="8" required>
                </div>
            `;
        }

        overlay.classList.add("open");
    }

    function openModalEditUIT(anio, valor) {
        const overlay = document.getElementById("modalOverlay");
        const title = document.getElementById("modalTitle");
        const fields = document.getElementById("modalFields");
        const action = document.getElementById("modalAction");
        const modalTab = document.getElementById("modalTab");

        title.innerText = "Actualizar UIT";
        action.value = "uit.update";
        modalTab.value = "uit";

        fields.innerHTML = `
            <div class="form-group">
                <label class="form-label">Anio</label>
                <input class="form-input" type="number" name="anio" value="${anio}" readonly>
            </div>
            <div class="form-group">
                <label class="form-label">Valor</label>
                <input class="form-input" type="number" step="0.01" name="valor" min="0" value="${valor}" required>
            </div>
        `;

        overlay.classList.add("open");
    }

    function closeModal() {
        document.getElementById("modalOverlay").classList.remove("open");
    }
</script>
</body>
</html>

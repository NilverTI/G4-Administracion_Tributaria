<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SAT Municipal - Mis Impuestos</title>

    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente-impuesto.css?v=20260303-5">
</head>
<body>

<%@ include file="/includes/contribuyente/sidebar.jsp" %>

<main class="main">
    <%@ include file="/includes/contribuyente/topbar.jsp" %>

    <c:url var="baseImpuestosUrl" value="/contribuyente/impuesto"/>

    <div class="content mis-impuestos-page">
        <div class="page-header">
            <h1>Mis Impuestos</h1>
            <p>Historial completo de impuestos</p>
        </div>

        <div class="filter-card">
            <div class="filter-toolbar">
                <select id="tipoFilter" class="filter-select" data-base-url="${baseImpuestosUrl}">
                    <option value="TODOS" ${filtroTipo == 'TODOS' ? 'selected' : ''}>Todos</option>
                    <option value="PREDIAL" ${filtroTipo == 'PREDIAL' ? 'selected' : ''}>Predial</option>
                    <option value="VEHICULAR" ${filtroTipo == 'VEHICULAR' ? 'selected' : ''}>Vehicular</option>
                </select>
                <input type="text" id="impuestoSearch" class="filter-search-input" placeholder="Buscar por tipo, anio o estado...">
            </div>
        </div>

        <div class="impuesto-list" id="impuestoList">
            <c:choose>
                <c:when test="${empty items}">
                    <div class="empty-card">
                        No tiene impuestos registrados para este filtro.
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="item" items="${items}">
                        <div class="impuesto-item">
                            <div class="impuesto-main">
                                <div class="impuesto-top">
                                    <span class="badge-tag tag-tipo">${item.tipo}</span>
                                    <span class="impuesto-anio">${item.anio}</span>
                                    <c:choose>
                                        <c:when test="${item.estado == 'Fraccionado'}">
                                            <span class="badge-tag tag-fraccionado">${item.estado}</span>
                                        </c:when>
                                        <c:when test="${item.estado == 'Pagado'}">
                                            <span class="badge-tag tag-pagado">${item.estado}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-tag tag-pendiente">${item.estado}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="impuesto-monto">
                                    S/ <fmt:formatNumber value="${item.montoTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                </div>

                                <div class="impuesto-sub">
                                    Pagado: S/
                                    <fmt:formatNumber value="${item.montoPagado}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                    |
                                    Vence: ${item.fechaVencimiento}
                                </div>
                            </div>

                            <c:url var="detalleUrl" value="/contribuyente/impuesto">
                                <c:param name="tipo" value="${filtroTipo}"/>
                                <c:param name="detalleTipo" value="${item.detalleTipo}"/>
                                <c:param name="detalleId" value="${item.idReferencia}"/>
                            </c:url>

                            <a href="${detalleUrl}" class="btn-detalle">
                                <i class="fi fi-rr-eye"></i> Ver detalle
                            </a>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
        <div id="impuestoPagination"></div>
    </div>
</main>

<c:url var="closeModalUrl" value="/contribuyente/impuesto">
    <c:param name="tipo" value="${filtroTipo}"/>
</c:url>

<c:if test="${not empty detalle}">
    <div class="modal-overlay" id="detalleOverlay">
        <div class="detail-modal">
            <div class="modal-head">
                <h2>Detalle del Impuesto</h2>
                <a href="${closeModalUrl}" class="modal-close" aria-label="Cerrar">×</a>
            </div>

            <div class="modal-summary">
                <div class="summary-item">
                    <span class="label">Tipo</span>
                    <span class="value">${detalle.tipo}</span>
                </div>
                <div class="summary-item">
                    <span class="label">Anio</span>
                    <span class="value">${detalle.anio}</span>
                </div>
                <div class="summary-item">
                    <span class="label">Monto Total</span>
                    <span class="value mono">S/ <fmt:formatNumber value="${detalle.montoTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                </div>
                <div class="summary-item">
                    <span class="label">Estado</span>
                    <c:choose>
                        <c:when test="${detalle.estado == 'Fraccionado'}">
                            <span class="badge-tag tag-fraccionado">${detalle.estado}</span>
                        </c:when>
                        <c:when test="${detalle.estado == 'Pagado'}">
                            <span class="badge-tag tag-pagado">${detalle.estado}</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge-tag tag-pendiente">${detalle.estado}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <h3 class="modal-section-title">Cuotas</h3>
            <div class="cuotas-list">
                <c:forEach var="cuota" items="${detalle.cuotas}">
                    <div class="cuota-item">
                        <div>
                            <div class="cuota-title">${cuota.titulo}</div>
                            <div class="cuota-sub">Vence: ${cuota.fechaVencimiento}</div>
                        </div>

                        <div class="cuota-right">
                            <div class="cuota-monto">
                                S/ <fmt:formatNumber value="${cuota.monto}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                            </div>
                            <c:choose>
                                <c:when test="${cuota.estado == 'Pagada'}">
                                    <span class="badge-tag tag-pagado">${cuota.estado}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-tag tag-pendiente">${cuota.estado}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</c:if>

<script src="${pageContext.request.contextPath}/js/pagination.js?v=20260303-5"></script>
<script>
    document.getElementById("tipoFilter")?.addEventListener("change", function () {
        const baseUrl = this.dataset.baseUrl;
        window.location.href = baseUrl + "?tipo=" + encodeURIComponent(this.value);
    });

    if (window.ListingTools) {
        window.ListingTools.createCardController({
            itemSelector: "#impuestoList .impuesto-item",
            paginationSelector: "#impuestoPagination",
            searchInputSelector: "#impuestoSearch"
        });
    }

    const overlay = document.getElementById("detalleOverlay");
    if (overlay) {
        overlay.addEventListener("click", function (e) {
            if (e.target === overlay) {
                window.location.href = "${closeModalUrl}";
            }
        });
    }
</script>

</body>
</html>

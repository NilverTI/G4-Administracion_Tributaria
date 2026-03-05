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
    <title>SAT Municipal - Pagos</title>

    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente-portal.css?v=20260303-4">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css?v=20260303-5">
</head>
<body>

<%@ include file="/includes/contribuyente/sidebar.jsp" %>

<main class="main">
    <%@ include file="/includes/contribuyente/topbar.jsp" %>

    <div class="content contribuyente-page">
        <div class="page-header">
            <h1>Pagos</h1>
            <p>Pague sus cuotas pendientes y revise el historial de abonos registrados.</p>
        </div>

        <c:if test="${not empty sessionScope.flashOk}">
            <div class="portal-alert portal-alert-ok">${sessionScope.flashOk}</div>
            <c:remove var="flashOk" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.flashError}">
            <div class="portal-alert portal-alert-error">${sessionScope.flashError}</div>
            <c:remove var="flashError" scope="session"/>
        </c:if>

        <div class="summary-grid">
            <div class="summary-card">
                <span class="summary-label">Cuotas por Pagar</span>
                <div class="summary-value">${pendingItems.size()}</div>
                <div class="summary-sub">Disponibles para pago inmediato</div>
            </div>
            <div class="summary-card">
                <span class="summary-label">Saldo Pendiente</span>
                <div class="summary-value">
                    S/ <fmt:formatNumber value="${totalPendiente}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                </div>
                <div class="summary-sub">Total programado por cancelar</div>
            </div>
            <div class="summary-card">
                <span class="summary-label">Pagos Registrados</span>
                <div class="summary-value">${items.size()}</div>
                <div class="summary-sub">Cuotas confirmadas como pagadas</div>
            </div>
            <div class="summary-card">
                <span class="summary-label">Monto Acumulado</span>
                <div class="summary-value">
                    S/ <fmt:formatNumber value="${totalPagado}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                </div>
                <div class="summary-sub">Total abonado historicamente</div>
            </div>
        </div>

        <div class="section-card">
            <div class="section-head">
                <div>
                    <h2>Cuotas Pendientes de Pago</h2>
                    <p>Seleccione una cuota y simule el pago desde la pasarela web.</p>
                </div>
            </div>

            <div class="section-toolbar">
                <input type="text" id="pendingSearch" class="search-input" placeholder="Buscar por tipo, codigo o periodo...">
            </div>

            <c:choose>
                <c:when test="${empty pendingItems}">
                    <div class="empty-state">No tiene cuotas pendientes por pagar.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrap">
                        <table class="portal-table">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tipo</th>
                                <th>Impuesto</th>
                                <th>Cuota</th>
                                <th>Periodo</th>
                                <th>Vencimiento</th>
                                <th>Monto</th>
                                <th>Accion</th>
                            </tr>
                            </thead>
                            <tbody id="pendingTableBody">
                            <c:forEach var="item" items="${pendingItems}">
                                <tr data-row="1">
                                    <td>${item[0]}</td>
                                    <td>${item[1]}</td>
                                    <td>${item[2]}</td>
                                    <td>${item[3]}/${item[4]}</td>
                                    <td>${item[5]}</td>
                                    <td>${item[6]}</td>
                                    <td class="mono">S/ <fmt:formatNumber value="${item[7]}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    <td>
                                        <button
                                                type="button"
                                                class="pay-action-btn"
                                                data-cuota-id="${item[0]}"
                                                data-tipo="${item[1]}"
                                                data-codigo="${item[2]}"
                                                data-cuota="${item[3]}/${item[4]}"
                                                data-periodo="${item[5]}"
                                                data-vencimiento="${item[6]}"
                                                data-monto="<fmt:formatNumber value='${item[7]}' type='number' minFractionDigits='2' maxFractionDigits='2'/>">
                                            <i class="fi fi-rr-credit-card"></i> Pagar
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div id="pendingPagination"></div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="section-card">
            <div class="section-head">
                <div>
                    <h2>Historial de Pagos</h2>
                    <p>Movimientos confirmados en su cuenta tributaria.</p>
                </div>
            </div>

            <div class="section-toolbar">
                <input type="text" id="pagosSearch" class="search-input" placeholder="Buscar por tipo, codigo o cuota...">
            </div>

            <c:choose>
                <c:when test="${empty items}">
                    <div class="empty-state">No tiene pagos registrados todavia.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrap">
                        <table class="portal-table">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tipo</th>
                                <th>Impuesto</th>
                                <th>Cuota</th>
                                <th>Periodo</th>
                                <th>Vencimiento</th>
                                <th>Fecha Pago</th>
                                <th>Monto</th>
                            </tr>
                            </thead>
                            <tbody id="pagosTableBody">
                            <c:forEach var="item" items="${items}">
                                <tr data-row="1">
                                    <td>${item[0]}</td>
                                    <td>${item[1]}</td>
                                    <td>${item[2]}</td>
                                    <td>${item[3]}/${item[4]}</td>
                                    <td>${item[5]}</td>
                                    <td>${item[6]}</td>
                                    <td>${item[7]}</td>
                                    <td class="mono">S/ <fmt:formatNumber value="${item[8]}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div id="pagosPagination"></div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<div class="payment-overlay" id="paymentOverlay">
    <div class="payment-modal">
        <div class="payment-head">
            <div>
                <h2>Pasarela de Pago</h2>
                <p>Simulacion visual de pago. El registro de la cuota si se actualizara en la base.</p>
            </div>
            <button type="button" class="payment-close" id="paymentClose" aria-label="Cerrar">
                <i class="fi fi-rr-cross-small"></i>
            </button>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/contribuyente/pagos" id="paymentForm">
            <input type="hidden" name="action" value="pagar">
            <input type="hidden" name="idCuota" id="payCuotaId">

            <div class="payment-summary">
                <div class="payment-row">
                    <span>Impuesto</span>
                    <strong id="payCodigo">-</strong>
                </div>
                <div class="payment-row">
                    <span>Cuota</span>
                    <strong id="payCuotaLabel">-</strong>
                </div>
                <div class="payment-row">
                    <span>Periodo</span>
                    <strong id="payPeriodo">-</strong>
                </div>
                <div class="payment-row">
                    <span>Vencimiento</span>
                    <strong id="payVencimiento">-</strong>
                </div>
                <div class="payment-row payment-total">
                    <span>Total a pagar</span>
                    <strong id="payMonto">S/ 0.00</strong>
                </div>
            </div>

            <div class="payment-methods">
                <label class="payment-method">
                    <input type="radio" name="metodoPago" value="Tarjeta Visa" checked>
                    <span class="payment-method-icon"><i class="fi fi-rr-credit-card"></i></span>
                    <span>
                        <strong>Tarjeta Visa</strong>
                        <small>Pago inmediato en linea</small>
                    </span>
                </label>

                <label class="payment-method">
                    <input type="radio" name="metodoPago" value="Tarjeta MasterCard">
                    <span class="payment-method-icon"><i class="fi fi-rr-credit-card"></i></span>
                    <span>
                        <strong>MasterCard</strong>
                        <small>Procesamiento referencial</small>
                    </span>
                </label>

                <label class="payment-method">
                    <input type="radio" name="metodoPago" value="Yape / Plin">
                    <span class="payment-method-icon"><i class="fi fi-rr-mobile-notch"></i></span>
                    <span>
                        <strong>Yape / Plin</strong>
                        <small>Transferencia rapida</small>
                    </span>
                </label>

                <label class="payment-method">
                    <input type="radio" name="metodoPago" value="Transferencia Bancaria">
                    <span class="payment-method-icon"><i class="fi fi-rr-bank"></i></span>
                    <span>
                        <strong>Transferencia</strong>
                        <small>Abono bancario registrado</small>
                    </span>
                </label>
            </div>

            <div class="payment-actions">
                <button type="button" class="btn-secondary" id="paymentCancel">Cancelar</button>
                <button type="submit" class="btn-primary">
                    <i class="fi fi-rr-shield-check"></i> Confirmar Pago
                </button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/pagination.js?v=20260303-5"></script>
<script>
    if (window.ListingTools) {
        window.ListingTools.createTableController({
            itemSelector: "#pendingTableBody tr[data-row='1']",
            paginationSelector: "#pendingPagination",
            searchInputSelector: "#pendingSearch"
        });

        window.ListingTools.createTableController({
            itemSelector: "#pagosTableBody tr[data-row='1']",
            paginationSelector: "#pagosPagination",
            searchInputSelector: "#pagosSearch"
        });
    }

    (function () {
        const overlay = document.getElementById("paymentOverlay");
        const closeButton = document.getElementById("paymentClose");
        const cancelButton = document.getElementById("paymentCancel");
        const cuotaId = document.getElementById("payCuotaId");
        const codigo = document.getElementById("payCodigo");
        const cuotaLabel = document.getElementById("payCuotaLabel");
        const periodo = document.getElementById("payPeriodo");
        const vencimiento = document.getElementById("payVencimiento");
        const monto = document.getElementById("payMonto");

        if (!overlay || !cuotaId) {
            return;
        }

        function closeModal() {
            overlay.classList.remove("open");
        }

        document.querySelectorAll(".pay-action-btn").forEach(function (button) {
            button.addEventListener("click", function () {
                cuotaId.value = button.dataset.cuotaId || "";
                codigo.textContent = (button.dataset.tipo || "") + " " + (button.dataset.codigo || "");
                cuotaLabel.textContent = button.dataset.cuota || "-";
                periodo.textContent = button.dataset.periodo || "-";
                vencimiento.textContent = button.dataset.vencimiento || "-";
                monto.textContent = "S/ " + (button.dataset.monto || "0.00");
                overlay.classList.add("open");
            });
        });

        closeButton?.addEventListener("click", closeModal);
        cancelButton?.addEventListener("click", closeModal);
        overlay.addEventListener("click", function (event) {
            if (event.target === overlay) {
                closeModal();
            }
        });
    })();
</script>

</body>
</html>

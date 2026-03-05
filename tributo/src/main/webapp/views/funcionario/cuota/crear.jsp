<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Crear Cuotas</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

    <style>
        .table-card-scroll {
            overflow-x: auto;
            overflow-y: hidden;
        }

        .table-wide {
            min-width: 1100px;
        }

        .table-wide th,
        .table-wide td {
            white-space: nowrap;
        }

        .helper-mono {
            font-family: 'JetBrains Mono', monospace;
            font-size: 13px;
            font-weight: 600;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-top: 4px;
        }

        .summary-item {
            border: 1px dashed var(--border);
            border-radius: 10px;
            padding: 10px 12px;
            background: #f8fafc;
        }

        .summary-item label {
            display: block;
            font-size: 12px;
            color: var(--text-muted);
            margin-bottom: 4px;
        }

        .summary-item strong {
            font-size: 14px;
        }

        .meta-text {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 8px;
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
            margin-bottom: 12px;
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
    </style>
</head>
<body>

<jsp:include page="/includes/sidebar.jsp" />

<main class="main">
    <jsp:include page="/includes/topbar.jsp" />

    <div class="content">
        <div class="page-header">
            <div class="page-header-left">
                <h1>Crear Cuotas</h1>
                <p>Selecciona un impuesto activo y define su fraccionamiento por meses.</p>
            </div>

            <a href="${pageContext.request.contextPath}/funcionario/cuotas" class="btn-secondary">
                <i class="fi fi-rr-arrow-left"></i> Volver
            </a>
        </div>

        <div class="type-filter">
            <span>Tipo</span>
            <select id="tipoCrearFilter">
                <option value="TODOS">Todos</option>
                <option value="PREDIAL">Predial</option>
                <option value="VEHICULAR">Vehicular</option>
                <option value="ALCABALA">Alcabala</option>
            </select>
        </div>

        <div class="table-card table-card-scroll">
            <table class="data-table table-wide">
                <thead>
                <tr>
                    <th>Tipo</th>
                    <th>Impuesto</th>
                    <th>Contribuyente</th>
                    <th>Monto Anual</th>
                    <th>Estado</th>
                    <th>Accion</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty impuestosActivos}">
                        <tr>
                            <td colspan="6">No hay impuestos activos disponibles para fraccionamiento.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="i" items="${impuestosActivos}">
                            <tr data-tipo="${i.tipoImpuesto}">
                                <td>${i.tipoImpuesto}</td>
                                <td>${i.codigoImpuesto}</td>
                                <td>${i.contribuyente}</td>
                                <td class="helper-mono">S/ <fmt:formatNumber value="${i.montoAnual}" type="number" maxFractionDigits="2"/></td>
                                <td><span class="badge badge-activo">${i.estado}</span></td>
                                <td>
                                    <button type="button"
                                            class="btn-primary btn-fraccionar"
                                            data-tipo="${i.tipoImpuesto}"
                                            data-id="${i.idReferencia}"
                                            data-codigo="${i.codigoImpuesto}"
                                            data-contribuyente="${i.contribuyente}"
                                            data-descripcion="${i.descripcion}"
                                            data-monto="${i.montoAnual}">
                                        <i class="fi fi-rr-split"></i> Crear
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</main>

<div class="modal-overlay" id="modalFraccionamiento">
    <div class="modal">
        <div class="modal-header">
            <h2>Crear Fraccionamiento</h2>
            <button type="button" class="modal-close" id="closeModal">
                <i class="fi fi-rr-cross-small"></i>
            </button>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/funcionario/cuotas">
            <input type="hidden" name="action" value="crearFraccionamiento">
            <input type="hidden" name="tipoImpuesto" id="tipoImpuestoInput">
            <input type="hidden" name="idReferencia" id="idReferenciaInput">

            <div class="form-grid">
                <div class="form-group full">
                    <label class="form-label">Impuesto seleccionado</label>
                    <input type="text" class="form-input" id="impuestoText" readonly>
                </div>

                <div class="form-group">
                    <label class="form-label">Contribuyente</label>
                    <input type="text" class="form-input" id="contribuyenteText" readonly>
                </div>

                <div class="form-group">
                    <label class="form-label">Monto anual</label>
                    <input type="text" class="form-input" id="montoAnualText" readonly>
                </div>

                <div class="form-group full">
                    <label class="form-label">Periodicidad</label>
                    <select class="form-input" name="mesesPorCuota" id="mesesPorCuotaSelect" required>
                        <option value="1">Mensual (12 cuotas)</option>
                        <option value="2">Bimestral (6 cuotas)</option>
                        <option value="3">Trimestral (4 cuotas)</option>
                        <option value="4">Cuatrimestral (3 cuotas)</option>
                        <option value="6">Semestral (2 cuotas)</option>
                        <option value="12">Anual (1 cuota)</option>
                    </select>
                </div>

                <div class="form-group full">
                    <div class="summary-grid">
                        <div class="summary-item">
                            <label>Total de cuotas</label>
                            <strong id="resumenCuotas">12</strong>
                        </div>
                        <div class="summary-item">
                            <label>Monto estimado por cuota</label>
                            <strong id="resumenMonto">S/ 0.00</strong>
                        </div>
                    </div>
                    <p class="meta-text">Se generaran cuotas con vencimientos automÃ¡ticos segun la periodicidad elegida.</p>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn-secondary" id="cancelModal">Cancelar</button>
                <button type="submit" class="btn-primary">
                    <i class="fi fi-rr-disk"></i> Guardar Fraccionamiento
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const modal = document.getElementById("modalFraccionamiento");
        const closeModalBtn = document.getElementById("closeModal");
        const cancelModalBtn = document.getElementById("cancelModal");
        const buttons = document.querySelectorAll(".btn-fraccionar");

        const tipoInput = document.getElementById("tipoImpuestoInput");
        const idInput = document.getElementById("idReferenciaInput");
        const impuestoText = document.getElementById("impuestoText");
        const contribuyenteText = document.getElementById("contribuyenteText");
        const montoAnualText = document.getElementById("montoAnualText");
        const mesesSelect = document.getElementById("mesesPorCuotaSelect");
        const resumenCuotas = document.getElementById("resumenCuotas");
        const resumenMonto = document.getElementById("resumenMonto");

        const preTipo = "${preTipoImpuesto}";
        const preId = "${preIdReferencia}";
        let montoActual = 0;
        let tipoActual = "";

        function formatMoney(value) {
            const number = Number.isFinite(value) ? value : 0;
            return "S/ " + number.toFixed(2);
        }

        function actualizarResumen() {
            const meses = parseInt(mesesSelect.value, 10) || 12;
            const cuotas = 12 / meses;
            const montoCuota = cuotas > 0 ? montoActual / cuotas : montoActual;
            resumenCuotas.textContent = cuotas.toString();
            resumenMonto.textContent = formatMoney(montoCuota);
        }

        function openModal(button) {
            const tipo = button.dataset.tipo || "";
            tipoActual = tipo;
            tipoInput.value = button.dataset.tipo || "";
            idInput.value = button.dataset.id || "";
            impuestoText.value = (button.dataset.codigo || "") + " - " + (button.dataset.descripcion || "");
            contribuyenteText.value = button.dataset.contribuyente || "";

            montoActual = parseFloat(button.dataset.monto || "0");
            montoAnualText.value = formatMoney(montoActual);

            if (tipo === "ALCABALA") {
                mesesSelect.value = "12";
                resumenCuotas.textContent = "1";
                resumenMonto.textContent = formatMoney(montoActual);
            } else {
                mesesSelect.value = "1";
                actualizarResumen();
            }
            actualizarResumen();

            modal.classList.add("open");
        }

        function closeModal() {
            modal.classList.remove("open");
        }

        buttons.forEach(button => {
            button.addEventListener("click", function () {
                openModal(button);
            });

            if (preTipo && preId && button.dataset.tipo === preTipo && button.dataset.id === preId) {
                openModal(button);
            }
        });

        document.getElementById("tipoCrearFilter")?.addEventListener("change", function () {
            const tipo = this.value;
            document.querySelectorAll(".table-wide tbody tr[data-tipo]").forEach(row => {
                const rowTipo = (row.dataset.tipo || "").toUpperCase();
                const visible = tipo === "TODOS" || rowTipo === tipo;
                row.style.display = visible ? "" : "none";
            });
        });

        mesesSelect.addEventListener("change", function () {
            if (tipoActual === "ALCABALA") {
                mesesSelect.value = "12";
            }
            actualizarResumen();
        });
        if (closeModalBtn) closeModalBtn.addEventListener("click", closeModal);
        if (cancelModalBtn) cancelModalBtn.addEventListener("click", closeModal);

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

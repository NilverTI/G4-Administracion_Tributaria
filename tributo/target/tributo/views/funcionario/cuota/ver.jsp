<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Detalle de Fraccionamiento</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

    <style>
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(160px, 1fr));
            gap: 12px;
            margin-bottom: 14px;
        }

        .detail-card-item {
            border: 1px solid var(--border);
            border-radius: 12px;
            background: #fbfdff;
            padding: 12px;
        }

        .detail-card-item label {
            display: block;
            color: var(--text-muted);
            font-size: 12px;
            margin-bottom: 6px;
        }

        .detail-card-item strong {
            font-size: 16px;
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

        .badge-cerrado {
            background: #dcfce7;
            color: #166534;
        }

        .badge-pendiente {
            background: #f1f5f9;
            color: #475569;
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
            cursor: pointer;
        }

        .action-icon:hover {
            border-color: #bfdbfe;
            color: #1d4ed8;
            background: #eff6ff;
        }

        .table-card-scroll {
            overflow-x: auto;
            overflow-y: hidden;
        }

        .table-wide {
            min-width: 980px;
        }

        .table-wide th,
        .table-wide td {
            white-space: nowrap;
        }

        .table-wide td:nth-child(3) {
            white-space: normal;
            min-width: 160px;
        }

        .detail-readonly {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .readonly-box {
            border: 1px solid var(--border);
            border-radius: 10px;
            background: #f8fafc;
            padding: 12px;
        }

        .readonly-box label {
            display: block;
            color: var(--text-muted);
            font-size: 12px;
            margin-bottom: 6px;
        }

        .readonly-box strong {
            font-size: 14px;
            word-break: break-word;
        }

        @media (max-width: 960px) {
            .detail-grid {
                grid-template-columns: repeat(2, minmax(160px, 1fr));
            }

            .detail-readonly {
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
                <h1>Detalle de Fraccionamiento</h1>
                <p>
                    ID #${fraccionamiento[0]} -
                    IMP-${fraccionamiento[2]}
                </p>
            </div>

            <a href="${pageContext.request.contextPath}/funcionario/cuotas" class="btn-secondary">
                <i class="fi fi-rr-arrow-left"></i> Volver
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

        <c:if test="${not habilitadoPago}">
            <div class="alert alert-error">Este fraccionamiento ya no esta habilitado para registrar pagos.</div>
        </c:if>

        <div class="detail-grid">
            <div class="detail-card-item">
                <label>Tipo</label>
                <strong>${fraccionamiento[1]}</strong>
            </div>
            <div class="detail-card-item">
                <label>Contribuyente</label>
                <strong>${fraccionamiento[4]}</strong>
            </div>
            <div class="detail-card-item">
                <label>Monto Anual</label>
                <strong class="helper-mono">S/ <fmt:formatNumber value="${fraccionamiento[6]}" type="number" maxFractionDigits="2"/></strong>
            </div>
            <div class="detail-card-item">
                <label>Periodicidad</label>
                <strong>${fraccionamiento[7]}</strong>
            </div>
            <div class="detail-card-item">
                <label>Cuotas</label>
                <strong>${fraccionamiento[10]}/${fraccionamiento[9]}</strong>
            </div>
            <div class="detail-card-item">
                <label>Estado</label>
                <c:choose>
                    <c:when test="${fraccionamiento[12] == 'CERRADO'}">
                        <span class="badge badge-cerrado">CERRADO</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge badge-pendiente">ACTIVO</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="detail-card-item">
                <label>Registro</label>
                <strong><fmt:formatDate value="${fraccionamiento[13]}" pattern="d MMM yyyy"/></strong>
            </div>
            <div class="detail-card-item">
                <label>Cierre</label>
                <strong>
                    <c:choose>
                        <c:when test="${not empty fraccionamiento[14]}">
                            <fmt:formatDate value="${fraccionamiento[14]}" pattern="d MMM yyyy"/>
                        </c:when>
                        <c:otherwise>-</c:otherwise>
                    </c:choose>
                </strong>
            </div>
        </div>

        <div class="table-card table-card-scroll">
            <table class="data-table table-wide">
                <thead>
                <tr>
                    <th>ID Cuota</th>
                    <th>Nro</th>
                    <th>Periodo</th>
                    <th>Vencimiento</th>
                    <th>Monto Programado</th>
                    <th>Estado</th>
                    <th>Fecha Pago</th>
                    <th>Monto Pagado</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="c" items="${cuotas}">
                    <tr>
                        <td>${c[0]}</td>
                        <td>${c[1]}</td>
                        <td>${c[2]}</td>
                        <td><fmt:formatDate value="${c[3]}" pattern="d MMM yyyy"/></td>
                        <td class="helper-mono">S/ <fmt:formatNumber value="${c[4]}" type="number" maxFractionDigits="2"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${c[5] == 'PAGADO'}">
                                    <span class="badge badge-cerrado">PAGADO</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-pendiente">PENDIENTE</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty c[6]}">
                                    <fmt:formatDate value="${c[6]}" pattern="d MMM yyyy"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty c[7]}">
                                    <span class="helper-mono">S/ <fmt:formatNumber value="${c[7]}" type="number" maxFractionDigits="2"/></span>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="action-group">
                                <c:if test="${c[5] == 'PAGADO'}">
                                    <button type="button"
                                            class="action-icon btn-ver-pago"
                                            data-id-cuota="${c[0]}"
                                            data-periodo="${c[2]}"
                                            data-fecha-pago="${empty c[6] ? '-' : c[6]}"
                                            data-monto-pagado="${empty c[7] ? '0.00' : c[7]}"
                                            data-observacion="<c:out value='${c[8]}'/>"
                                            title="Ver detalle del pago">
                                        <i class="fi fi-rr-eye"></i>
                                    </button>
                                </c:if>

                                <c:if test="${c[5] == 'PENDIENTE' && habilitadoPago}">
                                    <button type="button"
                                            class="action-icon btn-pagar"
                                            data-id-cuota="${c[0]}"
                                            data-monto="${c[4]}"
                                            title="Registrar pago">
                                        <i class="fi fi-rr-credit-card"></i>
                                    </button>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</main>

<div class="modal-overlay" id="modalPago">
    <div class="modal">
        <div class="modal-header">
            <h2>Registrar Pago de Cuota</h2>
            <button type="button" class="modal-close" id="closeModalPago">
                <i class="fi fi-rr-cross-small"></i>
            </button>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/funcionario/cuotas">
            <input type="hidden" name="action" value="registrarPagoCuota">
            <input type="hidden" name="idCuota" id="idCuotaInput">
            <input type="hidden" name="idFraccionamiento" value="${fraccionamiento[0]}">

            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label">ID cuota</label>
                    <input type="text" id="idCuotaText" class="form-input" readonly>
                </div>

                <div class="form-group">
                    <label class="form-label">Fecha pago</label>
                    <input type="date" name="fechaPago" id="fechaPagoInput" class="form-input" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Monto pagado</label>
                    <input type="number" step="0.01" min="0.01" name="montoPagado" id="montoPagadoInput" class="form-input" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Metodo de pago</label>
                    <select name="metodoPago" class="form-input" required>
                        <option value="Efectivo en caja">Efectivo en caja</option>
                        <option value="Tarjeta">Tarjeta</option>
                        <option value="Transferencia bancaria">Transferencia bancaria</option>
                        <option value="Yape / Plin">Yape / Plin</option>
                    </select>
                </div>

                <div class="form-group full">
                    <label class="form-label">Observacion</label>
                    <input type="text" name="observacionPago" class="form-input" maxlength="255" placeholder="Detalle adicional (opcional)">
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn-secondary" id="cancelModalPago">Cancelar</button>
                <button type="submit" class="btn-primary">
                    <i class="fi fi-rr-disk"></i> Confirmar pago
                </button>
            </div>
        </form>
    </div>
</div>

<div class="modal-overlay" id="modalDetallePago">
    <div class="modal">
        <div class="modal-header">
            <h2>Detalle del Pago</h2>
            <button type="button" class="modal-close" id="closeModalDetallePago">
                <i class="fi fi-rr-cross-small"></i>
            </button>
        </div>

        <div class="detail-readonly">
            <div class="readonly-box">
                <label>ID cuota</label>
                <strong id="detallePagoCuota">-</strong>
            </div>
            <div class="readonly-box">
                <label>Periodo</label>
                <strong id="detallePagoPeriodo">-</strong>
            </div>
            <div class="readonly-box">
                <label>Fecha de pago</label>
                <strong id="detallePagoFecha">-</strong>
            </div>
            <div class="readonly-box">
                <label>Monto pagado</label>
                <strong class="helper-mono" id="detallePagoMonto">S/ 0.00</strong>
            </div>
            <div class="readonly-box">
                <label>Metodo de pago</label>
                <strong id="detallePagoMetodo">No especificado</strong>
            </div>
            <div class="readonly-box">
                <label>Observacion</label>
                <strong id="detallePagoObs">-</strong>
            </div>
        </div>

        <div class="modal-footer">
            <button type="button" class="btn-secondary" id="cancelModalDetallePago">Cerrar</button>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const modal = document.getElementById("modalPago");
        const modalDetalle = document.getElementById("modalDetallePago");
        const btnClose = document.getElementById("closeModalPago");
        const btnCancel = document.getElementById("cancelModalPago");
        const btnsPagar = document.querySelectorAll(".btn-pagar");
        const btnsVerPago = document.querySelectorAll(".btn-ver-pago");
        const cuotaPagar = parseInt("${cuotaPagar}", 10) || 0;

        const idCuotaInput = document.getElementById("idCuotaInput");
        const idCuotaText = document.getElementById("idCuotaText");
        const montoInput = document.getElementById("montoPagadoInput");
        const fechaPagoInput = document.getElementById("fechaPagoInput");
        const closeDetalle = document.getElementById("closeModalDetallePago");
        const cancelDetalle = document.getElementById("cancelModalDetallePago");

        const detallePagoCuota = document.getElementById("detallePagoCuota");
        const detallePagoPeriodo = document.getElementById("detallePagoPeriodo");
        const detallePagoFecha = document.getElementById("detallePagoFecha");
        const detallePagoMonto = document.getElementById("detallePagoMonto");
        const detallePagoMetodo = document.getElementById("detallePagoMetodo");
        const detallePagoObs = document.getElementById("detallePagoObs");

        function getTodayISO() {
            return new Date().toISOString().slice(0, 10);
        }

        function openModal(button) {
            const idCuota = button.dataset.idCuota || "";
            const monto = button.dataset.monto || "0";

            idCuotaInput.value = idCuota;
            idCuotaText.value = idCuota;
            montoInput.value = Number(monto).toFixed(2);
            fechaPagoInput.value = getTodayISO();

            modal.classList.add("open");
        }

        function closeModal() {
            modal.classList.remove("open");
        }

        function closeModalDetalle() {
            if (modalDetalle) {
                modalDetalle.classList.remove("open");
            }
        }

        function parseDetallePago(rawText) {
            const text = (rawText || "").trim();
            if (!text) {
                return {
                    metodo: "No especificado",
                    observacion: "-"
                };
            }

            const portalPrefix = "Pago desde portal contribuyente - ";
            if (text.indexOf(portalPrefix) === 0) {
                return {
                    metodo: text.substring(portalPrefix.length) || "No especificado",
                    observacion: "Registrado desde portal del contribuyente"
                };
            }

            const metodoPrefix = "Metodo: ";
            if (text.indexOf(metodoPrefix) === 0) {
                const content = text.substring(metodoPrefix.length);
                const parts = content.split(" | ");
                return {
                    metodo: parts[0] || "No especificado",
                    observacion: parts.slice(1).join(" | ") || "-"
                };
            }

            return {
                metodo: "No especificado",
                observacion: text
            };
        }

        function openModalDetalle(button) {
            const detalle = parseDetallePago(button.dataset.observacion);

            detallePagoCuota.textContent = button.dataset.idCuota || "-";
            detallePagoPeriodo.textContent = button.dataset.periodo || "-";
            detallePagoFecha.textContent = button.dataset.fechaPago || "-";
            detallePagoMonto.textContent = "S/ " + (button.dataset.montoPagado || "0.00");
            detallePagoMetodo.textContent = detalle.metodo;
            detallePagoObs.textContent = detalle.observacion;

            if (modalDetalle) {
                modalDetalle.classList.add("open");
            }
        }

        btnsPagar.forEach(button => {
            button.addEventListener("click", function () {
                openModal(button);
            });

            if (cuotaPagar > 0 && parseInt(button.dataset.idCuota, 10) === cuotaPagar) {
                openModal(button);
            }
        });

        btnsVerPago.forEach(button => {
            button.addEventListener("click", function () {
                openModalDetalle(button);
            });
        });

        if (btnClose) btnClose.addEventListener("click", closeModal);
        if (btnCancel) btnCancel.addEventListener("click", closeModal);
        if (closeDetalle) closeDetalle.addEventListener("click", closeModalDetalle);
        if (cancelDetalle) cancelDetalle.addEventListener("click", closeModalDetalle);

        if (modal) {
            modal.addEventListener("click", function (e) {
                if (e.target === modal) {
                    closeModal();
                }
            });
        }

        if (modalDetalle) {
            modalDetalle.addEventListener("click", function (e) {
                if (e.target === modalDetalle) {
                    closeModalDetalle();
                }
            });
        }
    });
</script>

</body>
</html>

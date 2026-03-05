<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Detalle Impuesto Predial</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

    <style>
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(170px, 1fr));
            gap: 12px;
            margin-top: 14px;
        }

        .detail-item {
            border: 1px solid var(--border);
            background: #fbfdff;
            border-radius: 12px;
            padding: 12px;
        }

        .detail-item label {
            display: block;
            font-size: 12px;
            color: var(--text-muted);
            margin-bottom: 4px;
        }

        .detail-item strong {
            font-size: 16px;
        }

        .action-panel {
            margin-top: 16px;
            border: 1px solid var(--border);
            border-radius: 14px;
            background: var(--card);
            padding: 16px;
        }

        .action-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            align-items: end;
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

        @media (max-width: 920px) {
            .detail-grid, .action-grid {
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
                <h1>Detalle Impuesto Predial</h1>
                <p>Codigo: <strong>${predial[0]}</strong></p>
            </div>

            <a href="${pageContext.request.contextPath}/funcionario/impuesto?tab=predial" class="btn-secondary">
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

        <div class="detail-card">
            <h2>Datos Generales</h2>

            <div class="detail-grid">
                <div class="detail-item">
                    <label>Contribuyente</label>
                    <span>${predial[1]}</span>
                </div>
                <div class="detail-item">
                    <label>Direccion</label>
                    <span>${predial[2]}</span>
                </div>
                <div class="detail-item">
                    <label>Zona</label>
                    <span>${predial[3]}</span>
                </div>
                <div class="detail-item">
                    <label>Valor catastral</label>
                    <strong>S/ <fmt:formatNumber value="${predial[4]}" type="number" maxFractionDigits="2"/></strong>
                </div>
                <div class="detail-item">
                    <label>Tasa aplicada</label>
                    <span><fmt:formatNumber value="${predial[5]}" type="number" maxFractionDigits="2"/>%</span>
                </div>
                <div class="detail-item">
                    <label>Monto anual</label>
                    <strong>S/ <fmt:formatNumber value="${predial[6]}" type="number" maxFractionDigits="2"/></strong>
                </div>
                <div class="detail-item">
                    <label>Estado</label>
                    <span>${predial[7]}</span>
                </div>
                <div class="detail-item">
                    <label>Motivo actual</label>
                    <span>${predial[8]}</span>
                </div>
                <div class="detail-item">
                    <label>Detalle motivo</label>
                    <span>${predial[9]}</span>
                </div>
                <div class="detail-item">
                    <label>Fecha inicio</label>
                    <fmt:formatDate value="${predial[10]}" pattern="d MMM yyyy"/>
                </div>
                <div class="detail-item">
                    <label>Fecha cierre</label>
                    <c:choose>
                        <c:when test="${not empty predial[11]}">
                            <fmt:formatDate value="${predial[11]}" pattern="d MMM yyyy"/>
                        </c:when>
                        <c:otherwise>-</c:otherwise>
                    </c:choose>
                </div>
                <div class="detail-item">
                    <label>Registro</label>
                    <fmt:formatDate value="${predial[12]}" pattern="d MMM yyyy"/>
                </div>
            </div>
        </div>

        <div class="action-panel">
            <h2>Cambiar estado</h2>

            <form method="post" action="${pageContext.request.contextPath}/funcionario/impuesto">
                <input type="hidden" name="action" value="predial.estado">
                <input type="hidden" name="idPredial" value="${predial[0]}">

                <div class="action-grid">
                    <div class="form-group">
                        <label class="form-label">Nuevo estado</label>
                        <select class="form-input" name="estado" required>
                            <option value="ACTIVO">ACTIVO</option>
                            <option value="SUSPENDIDO">SUSPENDIDO</option>
                            <option value="CERRADO">CERRADO</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Motivo</label>
                        <select class="form-input" name="motivo">
                            <option value="">Seleccione...</option>
                            <option value="VENTA">VENTA</option>
                            <option value="FALLECIMIENTO">FALLECIMIENTO</option>
                            <option value="EXONERADO">EXONERADO</option>
                            <option value="EDAD_LIMITE">EDAD_LIMITE</option>
                            <option value="INMUEBLE_INACTIVO">INMUEBLE_INACTIVO</option>
                            <option value="OTRO">OTRO</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Detalle (si OTRO)</label>
                        <input class="form-input" type="text" name="detalleMotivo" maxlength="255">
                    </div>
                </div>

                <div style="margin-top: 12px;">
                    <button type="submit" class="btn-primary">
                        <i class="fi fi-rr-refresh"></i> Guardar estado
                    </button>
                </div>
            </form>
        </div>

        <div class="table-card" style="margin-top:16px;">
            <table class="data-table">
                <thead>
                <tr>
                    <th>Fecha</th>
                    <th>Anterior</th>
                    <th>Nuevo</th>
                    <th>Motivo</th>
                    <th>Detalle</th>
                    <th>Origen</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="h" items="${historial}">
                    <tr>
                        <td><fmt:formatDate value="${h[6]}" pattern="d MMM yyyy"/></td>
                        <td>${h[1]}</td>
                        <td>${h[2]}</td>
                        <td>${h[3]}</td>
                        <td>${h[4]}</td>
                        <td>${h[5]}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</main>

</body>
</html>

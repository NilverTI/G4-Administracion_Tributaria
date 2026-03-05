<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Detalle de Contribuyente</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css?v=20260303-8">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

    <style>
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 16px;
        }

        .detail-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 18px;
        }

        .detail-card label {
            display: block;
            font-size: 13px;
            color: var(--text-muted);
            margin-bottom: 8px;
        }

        .detail-card strong {
            font-size: 16px;
            color: var(--text);
            word-break: break-word;
        }

        .detail-card.full {
            grid-column: 1 / -1;
        }

        @media (max-width: 960px) {
            .detail-grid {
                grid-template-columns: 1fr;
            }

            .detail-card.full {
                grid-column: auto;
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
                <h1>Detalle de Contribuyente</h1>
                <p>Codigo: <strong>CON-${contribuyente[0]}</strong></p>
            </div>

            <a href="${pageContext.request.contextPath}/funcionario/contribuyente" class="btn-secondary">
                <i class="fi fi-rr-arrow-left"></i> Volver
            </a>
        </div>

        <div class="detail-grid">
            <div class="detail-card">
                <label>Documento</label>
                <strong>${contribuyente[3]} ${contribuyente[4]}</strong>
            </div>

            <div class="detail-card">
                <label>Nombres</label>
                <strong>${contribuyente[5]}</strong>
            </div>

            <div class="detail-card">
                <label>Apellidos</label>
                <strong>${contribuyente[6]}</strong>
            </div>

            <div class="detail-card">
                <label>Telefono</label>
                <strong>${empty contribuyente[7] ? '-' : contribuyente[7]}</strong>
            </div>

            <div class="detail-card">
                <label>Correo</label>
                <strong>${empty contribuyente[8] ? '-' : contribuyente[8]}</strong>
            </div>

            <div class="detail-card">
                <label>Estado</label>
                <strong>${contribuyente[2]}</strong>
            </div>

            <div class="detail-card full">
                <label>Direccion</label>
                <strong>${empty contribuyente[9] ? '-' : contribuyente[9]}</strong>
            </div>

            <div class="detail-card">
                <label>Fecha de Nacimiento</label>
                <strong>
                    <c:choose>
                        <c:when test="${not empty contribuyente[10]}">
                            <fmt:formatDate value="${contribuyente[10]}" pattern="d MMM yyyy" />
                        </c:when>
                        <c:otherwise>-</c:otherwise>
                    </c:choose>
                </strong>
            </div>

            <div class="detail-card">
                <label>Registro Tributario</label>
                <strong>
                    <c:choose>
                        <c:when test="${not empty contribuyente[1]}">
                            <fmt:formatDate value="${contribuyente[1]}" pattern="d MMM yyyy" />
                        </c:when>
                        <c:otherwise>-</c:otherwise>
                    </c:choose>
                </strong>
            </div>

            <div class="detail-card">
                <label>Estado de Persona</label>
                <strong>${contribuyente[11]}</strong>
            </div>
        </div>
    </div>
</main>
</body>
</html>

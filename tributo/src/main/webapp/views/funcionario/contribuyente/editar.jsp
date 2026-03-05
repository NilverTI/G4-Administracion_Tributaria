<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar Contribuyente</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css?v=20260303-8">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

    <style>
        .edit-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 18px;
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
                <h1>Editar Contribuyente</h1>
                <p>Codigo: <strong>CON-${contribuyente[0]}</strong></p>
            </div>

            <a href="${pageContext.request.contextPath}/funcionario/contribuyente" class="btn-secondary">
                <i class="fi fi-rr-arrow-left"></i> Volver
            </a>
        </div>

        <c:if test="${not empty contribuyente[10]}">
            <fmt:formatDate value="${contribuyente[10]}" pattern="yyyy-MM-dd" var="fechaNacimientoIso" />
        </c:if>

        <div class="edit-card">
            <form method="post" action="${pageContext.request.contextPath}/funcionario/contribuyente">
                <input type="hidden" name="action" value="editar">
                <input type="hidden" name="idContribuyente" value="${contribuyente[0]}">

                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">DNI</label>
                        <input class="form-input" name="numeroDoc" type="text" required value="${contribuyente[4]}">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Telefono</label>
                        <input class="form-input" name="telefono" type="text" value="${empty contribuyente[7] ? '' : contribuyente[7]}">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Nombres</label>
                        <input class="form-input" name="nombres" type="text" required value="${contribuyente[5]}">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Apellidos</label>
                        <input class="form-input" name="apellidos" type="text" required value="${contribuyente[6]}">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Fecha de nacimiento</label>
                        <input class="form-input" name="fechaNacimiento" type="date" value="${fechaNacimientoIso}">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Correo electronico</label>
                        <input class="form-input" name="email" type="email" value="${empty contribuyente[8] ? '' : contribuyente[8]}">
                    </div>

                    <div class="form-group full">
                        <label class="form-label">Direccion</label>
                        <input class="form-input" name="direccion" type="text" value="${empty contribuyente[9] ? '' : contribuyente[9]}">
                    </div>
                </div>

                <div class="modal-footer">
                    <a href="${pageContext.request.contextPath}/funcionario/contribuyente" class="btn-secondary">Cancelar</a>
                    <button type="submit" class="btn-primary">
                        <i class="fi fi-rr-disk"></i> Guardar cambios
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>
</body>
</html>

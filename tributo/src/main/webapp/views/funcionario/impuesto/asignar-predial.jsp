<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Crear Impuesto Predial</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">
</head>
<body>

<jsp:include page="/includes/sidebar.jsp" />

<main class="main">
    <jsp:include page="/includes/topbar.jsp" />

    <div class="content">
        <div class="page-header">
            <div class="page-header-left">
                <h1>Crear Impuesto Predial</h1>
                <p>Seleccione un inmueble activo para generar impuesto predial.</p>
            </div>

            <a href="${pageContext.request.contextPath}/funcionario/impuesto?tab=predial"
               class="btn-secondary">
                <i class="fi fi-rr-arrow-left"></i> Volver
            </a>
        </div>

        <div class="table-card">
            <table class="data-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Contribuyente</th>
                    <th>Direccion</th>
                    <th>Zona</th>
                    <th>Valor Catastral</th>
                    <th>Tasa</th>
                    <th>Accion</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="i" items="${inmuebles}">
                    <tr>
                        <td>${i[0]}</td>
                        <td>${i[1]}</td>
                        <td>${i[2]}</td>
                        <td>${i[3]}</td>
                        <td>S/ <fmt:formatNumber value="${i[4]}" type="number" maxFractionDigits="2"/></td>
                        <td><fmt:formatNumber value="${i[5]}" type="number" maxFractionDigits="2"/>%</td>
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/funcionario/impuesto" style="display:inline;">
                                <input type="hidden" name="action" value="crearPredial">
                                <input type="hidden" name="idInmueble" value="${i[0]}">
                                <button type="submit" class="btn-primary">
                                    <i class="fi fi-rr-add"></i> Generar
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</main>

</body>
</html>

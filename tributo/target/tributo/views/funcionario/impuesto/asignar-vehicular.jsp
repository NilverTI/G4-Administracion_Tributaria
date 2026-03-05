<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>

    <meta charset="UTF-8">
    <title>Crear Impuesto Vehicular</title>

    <!-- CSS GLOBAL -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css">

    <!-- ICONOS -->
    <link rel="stylesheet"
          href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

</head>
<body>

<!-- SIDEBAR -->
<jsp:include page="/includes/sidebar.jsp" />

<main class="main">

    <!-- TOPBAR -->
    <jsp:include page="/includes/topbar.jsp" />

    <div class="content">

        <!-- TITULO -->
        <div class="page-header">
            <div class="page-header-left">
                <h1>Crear Impuesto Vehicular</h1>
                <p>Seleccione un vehiculo para generar su impuesto.</p>
            </div>

            <a href="${pageContext.request.contextPath}/funcionario/impuesto"
               class="btn-secondary">
                <i class="fi fi-rr-arrow-left"></i> Volver
            </a>
        </div>

        <!-- TARJETA -->
        <div class="table-card">

            <table class="data-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Placa</th>
                    <th>Contribuyente</th>
                    <th>Vehiculo</th>
                    <th>Anio Inscripcion</th>
                    <th>Valor</th>
                    <th>%</th>
                    <th>Accion</th>
                </tr>
                </thead>

                <tbody>

                <c:forEach var="v" items="${vehiculos}">
                    <tr>

                        <td>${v[0]}</td>
                        <td>${v[1]}</td>
                        <td>${v[2]}</td>
                        <td>${v[3]}</td>
                        <td>${v[4]}</td>

                        <td>
                            S/ <fmt:formatNumber value="${v[5]}" type="number" maxFractionDigits="2"/>
                        </td>

                        <td>${v[6]}%</td>

                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/funcionario/impuesto" style="display:inline;">
                                <input type="hidden" name="action" value="crearVehicular">
                                <input type="hidden" name="idVehiculo" value="${v[0]}">
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

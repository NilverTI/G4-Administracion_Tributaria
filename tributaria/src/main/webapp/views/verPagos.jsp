<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Ver Pagos</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>

<jsp:include page="../includes/header.jsp"/>
<jsp:include page="../includes/navbar.jsp"/>

<div class="content">
    <h2>📋 Lista de Pagos</h2>

    <table class="table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Contribuyente</th>
                <th>Monto</th>
                <th>Fecha</th>
                <th>Concepto</th>
            </tr>
        </thead>
        <tbody>
            <!-- DEMO (luego esto vendrá de BD) -->
            <tr>
                <td>1</td>
                <td>Juan Pérez</td>
                <td>S/ 150.00</td>
                <td>2026-02-05</td>
                <td>Arbitrios</td>
            </tr>
            <tr>
                <td>2</td>
                <td>María López</td>
                <td>S/ 320.00</td>
                <td>2026-02-03</td>
                <td>Impuesto Predial</td>
            </tr>
        </tbody>
    </table>
</div>

<jsp:include page="../includes/footer.jsp"/>

</body>
</html>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Registrar Pago</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>

<jsp:include page="../includes/header.jsp"/>
<jsp:include page="../includes/navbar.jsp"/>

<div class="content">
    <div class="form-container">
        <h2>➕ Registrar Pago</h2>

        <!-- Por ahora solo DEMO (no guarda). Luego lo conectas a un Servlet -->
        <form action="#" method="post">
            <label>Contribuyente</label>
            <input type="text" name="contribuyente" placeholder="Ej: Juan Pérez" required>

            <label>Monto (S/)</label>
            <input type="number" step="0.01" name="monto" placeholder="Ej: 150.00" required>

            <label>Fecha</label>
            <input type="date" name="fecha" required>

            <label>Concepto</label>
            <select name="concepto" required>
                <option value="">-- Seleccionar --</option>
                <option>Impuesto Predial</option>
                <option>Arbitrios</option>
                <option>Multa</option>
                <option>Otro</option>
            </select>

            <button type="submit">Guardar Pago</button>
        </form>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>

</body>
</html>

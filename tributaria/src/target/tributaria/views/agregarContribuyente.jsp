<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registrar Contribuyente - SG Tributaria</title>
    <link rel="stylesheet" href="../css/styles.css">
</head>

<body>

<%@ include file="/includes/navbar.jsp" %>

<div class="form-container">
    <h2>Registrar Contribuyente</h2>

    <form method="post" action="RegistrarContribuyenteServlet">

        <label>Nombres</label>
        <input type="text" name="nombres" required>

        <label>Apellidos</label>
        <input type="text" name="apellidos" required>

        <label>Razón Social</label>
        <input type="text" name="razon_social">

        <label>Tipo de Persona</label>
        <select name="tipo_persona" required>
            <option value="1">Natural</option>
            <option value="2">Jurídica</option>
        </select>

        <button type="submit">Registrar</button>

    </form>
</div>

</body>
</html>

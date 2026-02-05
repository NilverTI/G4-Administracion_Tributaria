<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel Funcionario</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>

<body>
    
    <div class="content">

    <h2>Panel del Funcionario</h2>

    <div class="card">
        <h3>Contribuyentes registrados</h3>
        <p>${cantidadContribuyentes}</p>
    </div>

    <div class="card">
        <h3>Usuarios creados</h3>
        <p>${cantidadUsuarios}</p>
    </div>

</div>

<%@ include file="../includes/footer.jsp" %>

</body>



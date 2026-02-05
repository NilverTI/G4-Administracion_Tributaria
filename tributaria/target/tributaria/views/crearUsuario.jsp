<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Crear Usuario - Contribuyente</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>

<body>

<div class="form-container">
    <h2>Crear Usuario</h2>

    <!-- Mostrar mensajes -->
    <c:if test="${not empty error}">
        <p style="color:red; font-weight:bold;">${error}</p>
    </c:if>

    <c:if test="${not empty exito}">
        <p style="color:green; font-weight:bold;">${exito}</p>
    </c:if>


    <form action="${pageContext.request.contextPath}/crearUsuario" method="post">

        <label>Código de contribuyente</label>
        <input type="text" name="codigo" required>

        <label>Nombre de usuario</label>
        <input type="text" name="username" required>

        <label>Contraseña</label>
        <input type="password" name="password" required>

        <button type="submit">Crear Cuenta</button>
    </form>

</div>

</body>
</html>
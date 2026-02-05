<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>SG Tributaria - Iniciar Sesión</title>

    <!-- Importar CSS con ruta correcta -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>

<body class="login-body">

    <div class="login-container">

        <h2 class="login-title">SG Tributaria</h2>
        <p class="login-subtitle">Acceso al sistema</p>

        <form action="${pageContext.request.contextPath}/login" method="post" class="login-form">

            <label>Usuario</label>
            <input type="text" name="usuario" class="input-field" required>

            <label>Contraseña</label>
            <input type="password" name="password" class="input-field" required>

            <button type="submit" class="btn-login">Ingresar</button>

            <% if(request.getParameter("error") != null) { %>
                <p class="error-message">⚠ Usuario o contraseña incorrectos</p>
            <% } %>

        </form>

    </div>

</body>
</html>

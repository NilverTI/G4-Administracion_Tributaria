<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SG Tributaria - Iniciar Sesión</title>

    <!-- CSS principal -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>

<body class="login-body">

    <div class="login-wrapper">

        <!-- Tarjeta -->
        <div class="login-container">

            <!-- Logo/Marca -->
            <div class="login-brand">
                <div class="login-badge">SG</div>
                <div>
                    <h2 class="login-title">SG Tributaria</h2>
                    <p class="login-subtitle">Acceso al sistema</p>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/login" method="post" class="login-form">

                <label for="usuario">Usuario</label>
                <input id="usuario" type="text" name="usuario" class="input-field" placeholder="Ingrese su usuario" required>

                <label for="password">Contraseña</label>
                <input id="password" type="password" name="password" class="input-field" placeholder="Ingrese su contraseña" required>

                <button type="submit" class="btn-login">Ingresar</button>

                <% if (request.getParameter("error") != null) { %>
                    <div class="alert-error">
                        ⚠ Usuario o contraseña incorrectos
                    </div>
                <% } %>

            </form>

            <!-- Link inferior -->
            <div class="login-footer">
                <a href="${pageContext.request.contextPath}/views/crearUsuario.jsp" class="btn-link">
                    ¿No tienes usuario? Crea tu cuenta aquí
                </a>
            </div>

        </div>

        <!-- Pie opcional -->
        <p class="login-copy">© 2026 SG Tributaria</p>
    </div>

</body>
</html>

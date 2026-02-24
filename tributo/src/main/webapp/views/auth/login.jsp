<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Login - Sistema Tributario</title>

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;500;600;700&display=swap" rel="stylesheet">

  <!-- Bootstrap 5 CDN (solo para alert, spacing, etc.) -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- Tu CSS -->
  <link rel="stylesheet" href="<c:url value='/css/login.css'/>">
</head>

<body class="login-page">
  <!-- Fondo Canvas (tipo Opulento) -->
  <canvas id="opulento-bg" aria-hidden="true"></canvas>

  <main class="login-wrap">
    <section class="login-card" aria-label="Formulario de inicio de sesión">

      <header class="login-header">
        <div class="brand">
          <div class="brand-icon">ST</div>
          <div class="brand-text">
            <h1>Sistema de Administracion Tributaria</h1>
            <p>Municipalidad Distrital</p>
          </div>
        </div>
      </header>

      <div class="login-body">
        <form action="login" method="post" class="login-form">

          <!-- Usuario -->
          <div class="form-group">
            <label class="form-label" for="username">Usuario</label>
            <input class="form-input"
                   type="text"
                   id="username"
                   name="username"
                   placeholder="Ingrese su usuario"
                   autocomplete="username"
                   autofocus
                   required />
          </div>

          <!-- Password -->
          <div class="form-group">
            <label class="form-label" for="password">Contraseña</label>
            <input class="form-input"
                   type="password"
                   id="password"
                   name="password"
                   placeholder="••••••••"
                   autocomplete="current-password"
                   required />
          </div>

          <!-- Error (JSTL original) -->
          <c:if test="${not empty error}">
            <div class="alert alert-danger mt-3" role="alert">
              ${error}
            </div>
          </c:if>

          <!-- Submit -->
          <button type="submit" class="btn-primary-login">
            Iniciar sesión
          </button>

          <p class="login-foot">
            © <span id="year"></span> Sistema Tributario
          </p>

        </form>
      </div>

    </section>
  </main>

  <!-- JS -->
  <script src="<c:url value='/js/login.js'/>"></script>
</body>
</html>
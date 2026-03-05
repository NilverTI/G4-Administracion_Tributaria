<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Crear Cuenta - Sistema Tributario</title>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;500;600;700&display=swap" rel="stylesheet">

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="<c:url value='/css/login.css'/>">
</head>

<body class="login-page">
  <canvas id="opulento-bg" aria-hidden="true"></canvas>

  <main class="login-wrap">
    <section class="login-card" aria-label="Formulario de creacion de cuenta">
      <header class="login-header">
        <div class="brand">
          <div class="brand-icon">ST</div>
          <div class="brand-text">
            <h1>Crear cuenta de contribuyente</h1>
            <p>Use el correo registrado por el funcionario</p>
          </div>
        </div>
      </header>

      <div class="login-body">
        <form action="<c:url value='/registro'/>" method="post" class="login-form">
          <div class="form-group">
            <label class="form-label" for="correo">Correo</label>
            <input class="form-input"
                   type="email"
                   id="correo"
                   name="correo"
                   value="${correo}"
                   placeholder="correo@ejemplo.com"
                   autocomplete="email"
                   required />
          </div>

          <div class="form-group">
            <label class="form-label" for="password">Contrasena</label>
            <input class="form-input"
                   type="password"
                   id="password"
                   name="password"
                   placeholder="Minimo 8 caracteres"
                   autocomplete="new-password"
                   required />
          </div>

          <div class="form-group">
            <label class="form-label" for="confirmarPassword">Confirmar contrasena</label>
            <input class="form-input"
                   type="password"
                   id="confirmarPassword"
                   name="confirmarPassword"
                   placeholder="Repita la contrasena"
                   autocomplete="new-password"
                   required />
          </div>

          <c:if test="${not empty error}">
            <div class="alert alert-danger mt-3" role="alert">
              ${error}
            </div>
          </c:if>

          <button type="submit" class="btn-primary-login">
            Crear cuenta
          </button>

          <a href="<c:url value='/login'/>" class="btn-secondary-login">
            Volver al login
          </a>
        </form>
      </div>
    </section>
  </main>

  <script src="<c:url value='/js/login.js'/>"></script>
</body>
</html>

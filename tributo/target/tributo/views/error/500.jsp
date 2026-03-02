<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Error</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css">
</head>
<body>
  <%@ include file="/includes/sidebar.jsp" %>
  <main class="main">
    <%@ include file="/includes/topbar.jsp" %>
  <div style="max-width:720px; margin:60px auto; padding:22px; background: var(--card); border:1px solid var(--border); border-radius:16px;">
    <h2 style="margin:0 0 8px;">Ocurrió un problema</h2>
    <p style="margin:0 0 16px; color: var(--text-muted);">
      No se pudo procesar tu solicitud. Intenta nuevamente.
    </p>

    <a class="btn-primary" href="${pageContext.request.contextPath}/funcionario/vehiculo">
      Volver a Vehículos
    </a>
  </div>
</body>
</html>
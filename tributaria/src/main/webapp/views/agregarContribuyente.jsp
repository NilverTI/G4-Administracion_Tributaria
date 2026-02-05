<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registrar Contribuyente - SG Tributaria</title>

    <!-- CSS principal (ruta correcta y segura) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>

<body>

    <!-- NAVBAR / SIDEBAR -->
    <jsp:include page="../includes/navbar.jsp" />

    <!-- CONTENIDO -->
    <div class="content">
        <div class="form-container">
            <h2>Registrar Contribuyente</h2>

            <!-- FORMULARIO -->
            <form method="post"
                  action="${pageContext.request.contextPath}/RegistrarContribuyenteServlet">

                <label>Nombres</label>
                <input type="text" name="nombres" required>

                <label>Apellidos</label>
                <input type="text" name="apellidos" required>

                <label>Razón Social</label>
                <input type="text" name="razon_social">

                <label>Tipo de Persona</label>
                <select name="tipo_persona" required>
                    <option value="">-- Seleccionar --</option>
                    <option value="1">Natural</option>
                    <option value="2">Jurídica</option>
                </select>

                <button type="submit">Registrar</button>
            </form>

            <!-- MENSAJES -->
            <%
                String ok = request.getParameter("ok");
                String error = request.getParameter("error");

                if ("1".equals(ok)) {
            %>
                <p style="color: green; margin-top: 15px; font-weight: bold;">
                    ✔ Contribuyente registrado correctamente
                </p>
            <%
                } else if ("1".equals(error)) {
            %>
                <p style="color: red; margin-top: 15px; font-weight: bold;">
                    ✖ Error: complete los campos obligatorios
                </p>
            <%
                } else if ("2".equals(error)) {
            %>
                <p style="color: red; margin-top: 15px; font-weight: bold;">
                    ✖ Error al registrar en la base de datos
                </p>
            <%
                }
            %>

        </div>
    </div>

</body>
</html>

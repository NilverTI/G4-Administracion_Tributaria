<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Listar Contribuyentes</title>

    <!-- CSS principal -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>

    <!-- HEADER -->
    <jsp:include page="../includes/header.jsp" />

    <!-- SIDEBAR / NAVBAR -->
    <jsp:include page="../includes/navbar.jsp" />

    <!-- CONTENIDO PRINCIPAL -->
    <div class="content">

        <h2>📋 Lista de Contribuyentes</h2>

        <table class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tipo Persona</th>
                    <th>Documento</th>
                    <th>Nombres / Razón Social</th>
                    <th>Dirección</th>
                    <th>Acciones</th>
                </tr>
            </thead>

            <tbody>
                <!-- ===== DATOS DE PRUEBA (DEMO) ===== -->
                <!-- Luego esto lo reemplazas por datos de BD con JSTL -->
                <tr>
                    <td>1</td>
                    <td>Natural</td>
                    <td>12345678</td>
                    <td>Juan Pérez</td>
                    <td>Av. Lima 123</td>
                    <td>
                        <a href="#" style="color:#1a73e8; text-decoration:none;">✏️ Editar</a>
                        &nbsp; | &nbsp;
                        <a href="#" style="color:#d32f2f; text-decoration:none;">🗑 Eliminar</a>
                    </td>
                </tr>

                <tr>
                    <td>2</td>
                    <td>Jurídica</td>
                    <td>20123456789</td>
                    <td>Empresa ABC SAC</td>
                    <td>Jr. Comercio 456</td>
                    <td>
                        <a href="#" style="color:#1a73e8; text-decoration:none;">✏️ Editar</a>
                        &nbsp; | &nbsp;
                        <a href="#" style="color:#d32f2f; text-decoration:none;">🗑 Eliminar</a>
                    </td>
                </tr>
            </tbody>
        </table>

    </div>

    <!-- FOOTER -->
    <jsp:include page="../includes/footer.jsp" />

</body>
</html>

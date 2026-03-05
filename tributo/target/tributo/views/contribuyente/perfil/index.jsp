<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SAT Municipal - Perfil</title>

    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente-portal.css?v=20260303-4">
</head>
<body>

<%@ include file="/includes/contribuyente/sidebar.jsp" %>

<main class="main">
    <%@ include file="/includes/contribuyente/topbar.jsp" %>

    <div class="content contribuyente-page">
        <div class="page-header">
            <h1>Perfil</h1>
            <p>Datos personales y resumen de su cuenta tributaria.</p>
        </div>

        <c:if test="${not empty sessionScope.flashOk}">
            <div class="portal-alert portal-alert-ok">${sessionScope.flashOk}</div>
            <c:remove var="flashOk" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.flashError}">
            <div class="portal-alert portal-alert-error">${sessionScope.flashError}</div>
            <c:remove var="flashError" scope="session"/>
        </c:if>

        <div class="summary-grid">
            <div class="summary-card">
                <span class="summary-label">Inmuebles</span>
                <div class="summary-value">${perfilInmuebles}</div>
                <div class="summary-sub">Predios vinculados</div>
            </div>
            <div class="summary-card">
                <span class="summary-label">Vehiculos</span>
                <div class="summary-value">${perfilVehiculos}</div>
                <div class="summary-sub">Vehiculos vinculados</div>
            </div>
            <div class="summary-card">
                <span class="summary-label">Cuotas Pendientes</span>
                <div class="summary-value">${perfilCuotasPendientes}</div>
                <div class="summary-sub">Por regularizar</div>
            </div>
            <div class="summary-card">
                <span class="summary-label">Pagos Registrados</span>
                <div class="summary-value">${perfilPagos}</div>
                <div class="summary-sub">Movimientos confirmados</div>
            </div>
        </div>

        <div class="profile-grid">
            <section class="section-card">
                <div class="section-head">
                    <div>
                        <h2>Datos Personales</h2>
                        <p>Informacion registrada en su cuenta.</p>
                    </div>
                </div>

                <div class="detail-list">
                    <div class="detail-item">
                        <span class="detail-label">Documento</span>
                        <span class="detail-value">${perfilUsuario.persona.numeroDocumento}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Nombres</span>
                        <span class="detail-value">${perfilUsuario.persona.nombres}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Apellidos</span>
                        <span class="detail-value">${perfilUsuario.persona.apellidos}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Telefono</span>
                        <span class="detail-value">${empty perfilUsuario.persona.telefono ? '-' : perfilUsuario.persona.telefono}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Correo</span>
                        <span class="detail-value">${empty perfilUsuario.persona.email ? '-' : perfilUsuario.persona.email}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Direccion</span>
                        <span class="detail-value">${empty perfilUsuario.persona.direccion ? '-' : perfilUsuario.persona.direccion}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Fecha Nacimiento</span>
                        <span class="detail-value">${empty perfilUsuario.persona.fechaNacimiento ? '-' : perfilUsuario.persona.fechaNacimiento}</span>
                    </div>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/contribuyente/perfil" class="profile-form">
                    <input type="hidden" name="action" value="actualizar-datos">

                    <div class="profile-form-grid">
                        <div class="profile-field">
                            <label for="perfilTelefono">Telefono</label>
                            <input
                                    id="perfilTelefono"
                                    type="text"
                                    name="telefono"
                                    maxlength="20"
                                    value="${empty perfilUsuario.persona.telefono ? '' : perfilUsuario.persona.telefono}"
                                    placeholder="Ingrese su telefono">
                        </div>

                        <div class="profile-field profile-field-full">
                            <label for="perfilDireccion">Direccion</label>
                            <input
                                    id="perfilDireccion"
                                    type="text"
                                    name="direccion"
                                    maxlength="255"
                                    value="${empty perfilUsuario.persona.direccion ? '' : perfilUsuario.persona.direccion}"
                                    placeholder="Ingrese su direccion">
                        </div>
                    </div>

                    <div class="profile-actions">
                        <button type="submit" class="profile-btn-primary">
                            <i class="fi fi-rr-disk"></i> Guardar datos
                        </button>
                    </div>
                </form>
            </section>

            <section class="section-card">
                <div class="section-head">
                    <div>
                        <h2>Cuenta de Acceso</h2>
                        <p>Datos de autenticacion y estado actual.</p>
                    </div>
                </div>

                <div class="detail-list">
                    <div class="detail-item">
                        <span class="detail-label">Usuario</span>
                        <span class="detail-value">${perfilUsuario.username}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Rol</span>
                        <span class="detail-value">${perfilUsuario.rol.nombre}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Estado</span>
                        <span class="detail-value">${perfilUsuario.estado}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Fecha de Registro</span>
                        <span class="detail-value">${empty perfilUsuario.persona.fechaRegistro ? '-' : perfilUsuario.persona.fechaRegistro}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Cuenta Creada</span>
                        <span class="detail-value">${empty perfilUsuario.fechaCreacion ? '-' : perfilUsuario.fechaCreacion}</span>
                    </div>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/contribuyente/perfil" class="profile-form profile-form-top">
                    <input type="hidden" name="action" value="cambiar-password">

                    <div class="profile-form-grid">
                        <div class="profile-field profile-field-full">
                            <label for="passwordActual">Contraseña actual</label>
                            <input
                                    id="passwordActual"
                                    type="password"
                                    name="passwordActual"
                                    minlength="8"
                                    required
                                    placeholder="Ingrese su contraseña actual">
                        </div>

                        <div class="profile-field">
                            <label for="nuevaPassword">Nueva contraseña</label>
                            <input
                                    id="nuevaPassword"
                                    type="password"
                                    name="nuevaPassword"
                                    minlength="8"
                                    required
                                    placeholder="Minimo 8 caracteres">
                        </div>

                        <div class="profile-field">
                            <label for="confirmarPassword">Confirmar contraseña</label>
                            <input
                                    id="confirmarPassword"
                                    type="password"
                                    name="confirmarPassword"
                                    minlength="8"
                                    required
                                    placeholder="Repita la nueva contraseña">
                        </div>
                    </div>

                    <div class="profile-actions">
                        <button type="submit" class="profile-btn-primary profile-btn-dark">
                            <i class="fi fi-rr-lock"></i> Actualizar contraseña
                        </button>
                    </div>
                </form>
            </section>
        </div>
    </div>
</main>

</body>
</html>

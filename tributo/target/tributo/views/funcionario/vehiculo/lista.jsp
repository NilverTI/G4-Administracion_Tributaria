<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

        <!DOCTYPE html>
        <html lang="es">

        <head>

            <meta charset="UTF-8">
            <title>Gestión de Vehículos</title>

            <!-- CSS GLOBAL (el mismo que usan contribuyentes e inmuebles) -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css">

            <!-- Google Fonts -->
            <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">

            <!-- Iconos -->
            <link rel="stylesheet"
                href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

        </head>

        <body>

            <!-- SIDEBAR -->
            <%@ include file="/includes/sidebar.jsp" %>

                <main class="main">

                    <!-- TOPBAR -->
                    <%@ include file="/includes/topbar.jsp" %>

                        <div class="content">

                            <!-- Encabezado -->
                            <div class="page-header">
                                <div class="page-header-left">
                                    <h1>Gestión de Vehículos</h1>
                                    <p>
                                        <c:out value="${cantidad}" /> vehículos registrados
                                    </p>
                                </div>

                                <button class="btn-primary" id="btnNuevo">
                                    <i class="fi fi-rr-plus"></i> Registrar Vehículo
                                </button>
                            </div>

                            <!-- Barra de búsqueda -->
                            <div class="filter-bar">

                                <div class="filter-search">
                                    <i class="fi fi-rr-search"></i>
                                    <input type="text" id="tableSearch"
                                        placeholder="Buscar por placa, marca o contribuyente...">
                                </div>

                                <div class="filter-select">
                                    <i class="fi fi-rr-filter"></i>
                                    <select id="estadoFilter">
                                        <option value="">Todos</option>
                                        <option value="ACTIVO">Activo</option>
                                        <option value="INACTIVO">Inactivo</option>
                                    </select>
                                </div>

                            </div>

                            <!-- Tabla -->
                            <div class="table-card">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Placa</th>
                                            <th>Contribuyente</th>
                                            <th>Vehículo</th>
                                            <th>Año</th>
                                            <th>Valor</th>
                                            <th>Estado</th>
                                            <th>Registro</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>

                                    <tbody id="tableBody">

                                        <c:forEach var="v" items="${lista}">
                                            <tr data-estado="${v[9]}">

                                                <!-- ID -->
                                                <td>${v[0]}</td>

                                                <!-- PLACA -->
                                                <td>${v[1]}</td>

                                                <!-- CONTRIBUYENTE -->
                                                <td>${v[2]}</td>

                                                <!-- VEHÍCULO -->
                                                <td>${v[3]}</td>

                                                <!-- AÑO -->
                                                <td>${v[4]}</td>

                                                <!-- VALOR -->
                                                <td>S/
                                                    <fmt:formatNumber value="${v[5]}" type="number"
                                                        maxFractionDigits="0" />
                                                </td>

                                                <!-- ESTADO (v[9]) -->
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${v[9] == 'ACTIVO'}">
                                                            <span class="badge badge-activo">Activo</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-inactivo">Inactivo</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <!-- REGISTRO (v[10]) -->
                                                <td>
                                                    <fmt:formatDate value="${v[10]}" pattern="d MMM yyyy" />
                                                </td>

                                                <!-- ACCIONES -->
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${v[9] == 'ACTIVO'}">
                                                            <a class="toggle-btn activo"
                                                                href="${pageContext.request.contextPath}/funcionario/vehiculo?action=estado&id=${v[0]}&estado=INACTIVO">
                                                                <i class="fi fi-rr-toggle-on"></i>
                                                            </a>
                                                        </c:when>

                                                        <c:otherwise>
                                                            <a class="toggle-btn inactivo"
                                                                href="${pageContext.request.contextPath}/funcionario/vehiculo?action=estado&id=${v[0]}&estado=ACTIVO">
                                                                <i class="fi fi-rr-toggle-off"></i>
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                            </tr>
                                        </c:forEach>

                                    </tbody>
                                </table>

                                <div id="pagination"></div>
                            </div>

                        </div>

                </main>


                <!-- ========================= MODAL ============================= -->
                <div class="modal-overlay" id="modalOverlay">

                    <div class="modal">

                        <div class="modal-header">
                            <h2>Registrar Vehículo</h2>
                            <button type="button" class="modal-close" id="modalClose">
                                <i class="fi fi-rr-cross-small"></i>
                            </button>
                        </div>

                        <form method="post" action="${pageContext.request.contextPath}/funcionario/vehiculo">

                            <input type="hidden" name="action" value="crear">

                            <div class="form-grid">

                                <div class="form-group">
                                    <label class="form-label">Contribuyente</label>
                                    <select name="idContribuyente" class="form-input" required>
                                        <c:forEach var="c" items="${contribuyentes}">
                                            <option value="${c[0]}">${c[1]}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Placa</label>
                                    <input type="text" name="placa" class="form-input" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Marca</label>
                                    <input type="text" name="marca" class="form-input" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Modelo</label>
                                    <input type="text" name="modelo" class="form-input" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Año</label>
                                    <input type="number" name="anio" class="form-input" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Fecha de Inscripción</label>
                                    <input type="date" name="fechaInscripcion" class="form-input" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Valor</label>
                                    <input type="number" step="0.01" name="valor" class="form-input" required>
                                </div>

                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn-secondary" id="modalCancel">Cancelar</button>
                                <button type="submit" class="btn-primary">
                                    <i class="fi fi-rr-disk"></i> Guardar
                                </button>
                            </div>

                        </form>

                    </div>

                </div>


                <!-- JS -->
                <script src="${pageContext.request.contextPath}/js/contribuyente.js"></script>
                <script src="${pageContext.request.contextPath}/js/paginacion.js"></script>

        </body>

        </html>
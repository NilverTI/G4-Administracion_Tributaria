<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Configuración del Sistema</title>

  <!-- CSS GLOBAL -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contribuyente.css">

  <!-- Google Fonts -->
  <link rel="stylesheet"
        href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&display=swap">

  <!-- Iconos -->
  <link rel="stylesheet"
        href="https://cdn-uicons.flaticon.com/3.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css">

  <style>
    /* Tabs (minimal) */
    .tabs { display:flex; gap:12px; margin-bottom: 22px; }
    .tab-btn{
      padding: 10px 20px;
      border-radius: 12px;
      background: var(--card);
      border: 1px solid var(--border);
      cursor: pointer;
      font-size: 14px;
      font-weight: 700;
      transition: .2s;
    }
    .tab-btn.active{
      background: var(--navy);
      color:#fff;
      border-color: var(--navy);
    }
    .tab-content{ display:none; }
    .tab-content.active{ display:block; }
  </style>
</head>

<body>

<%@ include file="/includes/sidebar.jsp" %>

<main class="main">
  <%@ include file="/includes/topbar.jsp" %>

  <div class="content">

    <!-- Header -->
    <div class="page-header">
      <div class="page-header-left">
        <h1>Configuración del Sistema</h1>
        <p>Gestión de zonas, UIT y parámetros vehiculares</p>
      </div>

      <!-- ✅ Botón único (arriba derecha). JS lo cambia según tab -->
      <button class="btn-primary" id="btnNuevoItem" type="button">
        <i class="fi fi-rr-plus"></i> Nuevo
      </button>
    </div>

    <!-- Tabs -->
    <div class="tabs" role="tablist" aria-label="Configuración">
      <button class="tab-btn active" type="button" data-tab="tab-zonas">Zonas</button>
      <button class="tab-btn" type="button" data-tab="tab-uit">UIT</button>
      <button class="tab-btn" type="button" data-tab="tab-veh">Vehicular %</button>
    </div>

    <!-- ================= ZONAS ================= -->
    <section class="tab-content active" id="tab-zonas">
      <div class="table-card">
        <table class="data-table">
          <thead>
          <tr>
            <th>ID</th>
            <th>Código</th>
            <th>Nombre</th>
            <th>Tasa</th>
            <th>Estado</th>
            <th>Acción</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="z" items="${zonas}">
            <tr>
              <td><c:out value="${z[0]}"/></td>
              <td><c:out value="${z[1]}"/></td>
              <td><c:out value="${z[2]}"/></td>
              <td><c:out value="${z[3]}"/>%</td>
              <td>
                <c:choose>
                  <c:when test="${z[4] == 'ACTIVO'}">
                    <span class="badge badge-activo">Activo</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge badge-inactivo">Inactivo</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <a class="toggle-btn"
                   href="${pageContext.request.contextPath}/funcionario/configuracion?action=zonas.estado&id=${z[0]}&estado=${z[4]=='ACTIVO'?'INACTIVO':'ACTIVO'}"
                   title="Cambiar estado">
                  <i class="fi fi-rr-refresh"></i>
                </a>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </section>

    <!-- ================= UIT ================= -->
    <section class="tab-content" id="tab-uit">
      <div class="table-card">
        <table class="data-table">
          <thead>
          <tr>
            <th>Año</th>
            <th>Valor (S/)</th>
            <th>Acción</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="u" items="${uits}">
            <tr>
              <td><c:out value="${u[0]}"/></td>
              <td>S/ <c:out value="${u[1]}"/></td>
              <td>
                <button type="button" class="toggle-btn"
                        data-edit-uit="1"
                        data-anio="${u[0]}"
                        data-valor="${u[1]}"
                        title="Editar UIT">
                  <i class="fi fi-rr-edit"></i>
                </button>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </section>

    <!-- ================= VEHICULAR ================= -->
    <section class="tab-content" id="tab-veh">
      <div class="table-card">
        <table class="data-table">
          <thead>
          <tr>
            <th>Año</th>
            <th>Porcentaje</th>
            <th>Estado</th>
            <th>Acción</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="v" items="${vehiculares}">
            <tr>
              <td><c:out value="${v[0]}"/></td>
              <td><c:out value="${v[1]}"/> %</td>
              <td>
                <c:choose>
                  <c:when test="${v[2]=='ACTIVO'}">
                    <span class="badge badge-activo">Activo</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge badge-inactivo">Inactivo</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <a class="toggle-btn"
                   href="${pageContext.request.contextPath}/funcionario/configuracion?action=veh.estado&anio=${v[0]}&estado=${v[2]=='ACTIVO'?'INACTIVO':'ACTIVO'}"
                   title="Cambiar estado">
                  <i class="fi fi-rr-refresh"></i>
                </a>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </section>

  </div>
</main>

<!-- Modal genérico -->
<div class="modal-overlay" id="modalOverlay" aria-hidden="true">
  <div class="modal" role="dialog" aria-modal="true">

    <div class="modal-header">
      <h2 id="modalTitle"></h2>
      <button type="button" class="modal-close" onclick="closeModal()" title="Cerrar">
        <i class="fi fi-rr-cross-small"></i>
      </button>
    </div>

    <!-- ✅ action apunta al servlet -->
    <form method="post" action="${pageContext.request.contextPath}/funcionario/configuracion">
      <input type="hidden" name="action" id="modalAction">
      <div class="form-grid" id="modalFields"></div>

      <div class="modal-footer">
        <button type="button" class="btn-secondary" onclick="closeModal()">Cancelar</button>
        <button type="submit" class="btn-primary">
          <i class="fi fi-rr-disk"></i> Guardar
        </button>
      </div>
    </form>

  </div>
</div>

<!-- JS (cache-bust) -->
<script src="${pageContext.request.contextPath}/js/configuracion.js?v=3"></script>

<script>
  // ✅ Fallback mínimo por si configuracion.js no carga (evita que se "muera" todo)
  // Si tu configuracion.js está bien, esto no estorba.
  (function(){
    const btnNuevoItem = document.getElementById("btnNuevoItem");
    const tabBtns = document.querySelectorAll(".tab-btn");
    const tabContents = document.querySelectorAll(".tab-content");

    function setHeaderButton(tabId){
      if(!btnNuevoItem) return;

      if(tabId === "tab-zonas"){
        btnNuevoItem.innerHTML = '<i class="fi fi-rr-plus"></i> Nueva zona';
        btnNuevoItem.onclick = () => window.openModal && window.openModal("zonas");
      } else if(tabId === "tab-uit"){
        btnNuevoItem.innerHTML = '<i class="fi fi-rr-plus"></i> Registrar UIT';
        btnNuevoItem.onclick = () => window.openModal && window.openModal("uit");
      } else if(tabId === "tab-veh"){
        btnNuevoItem.innerHTML = '<i class="fi fi-rr-plus"></i> Nuevo porcentaje';
        btnNuevoItem.onclick = () => window.openModal && window.openModal("veh");
      } else {
        btnNuevoItem.innerHTML = '<i class="fi fi-rr-plus"></i> Nuevo';
        btnNuevoItem.onclick = null;
      }
    }

    // Tabs (si no hay JS externo)
    tabBtns.forEach(btn=>{
      btn.addEventListener("click", (e)=>{
        e.preventDefault();
        tabBtns.forEach(b=>b.classList.remove("active"));
        tabContents.forEach(c=>c.classList.remove("active"));

        btn.classList.add("active");
        const id = btn.dataset.tab;
        const panel = document.getElementById(id);
        if(panel) panel.classList.add("active");

        setHeaderButton(id);
      });
    });

    const active = document.querySelector(".tab-btn.active");
    setHeaderButton(active?.dataset?.tab || "tab-zonas");

    // Edit UIT (sin onclick inline)
    document.addEventListener("click", (e) => {
      const btn = e.target.closest("[data-edit-uit='1']");
      if(!btn) return;
      const anio = btn.getAttribute("data-anio");
      const valor = btn.getAttribute("data-valor");
      if(window.openModalEditUIT) window.openModalEditUIT(anio, valor);
    });
  })();
</script>

</body>
</html>
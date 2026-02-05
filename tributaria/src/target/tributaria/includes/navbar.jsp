<div class="sidebar">
    <a href="panelFuncionario.jsp">🏛 Dashboard</a>

    <button class="sidebar-toggle" type="button">
        👥 Contribuyentes <span class="chev">▸</span>
    </button>
    <div class="sidebar-submenu">
        <a href="../views/agregarContribuyente.jsp">➕ Registrar Contribuyente</a>
        <a href="listar.jsp">📋 Listar Contribuyentes</a>
    </div>

    <button class="sidebar-toggle" type="button">
        💳 Pagos <span class="chev">▸</span>
    </button>
    <div class="sidebar-submenu">
        <a href="verPagos.jsp">👀 Ver Pagos</a>
        <a href="registrarPago.jsp">➕ Registrar Pago</a>
    </div>

    <a href="LogoutServlet">🚪 Cerrar Sesión</a>
</div>

<script>
  document.querySelectorAll(".sidebar-toggle").forEach(btn => {
    btn.addEventListener("click", () => {
      const submenu = btn.nextElementSibling;
      const chev = btn.querySelector(".chev");
      const open = submenu.classList.toggle("open");
      btn.classList.toggle("active", open);
      chev.textContent = open ? "▾" : "▸";
    });
  });
</script>

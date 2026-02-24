// /webapp/js/cuota.js

(() => {
  const $ = (id) => document.getElementById(id);

  const btnOpen = $("btnFraccionamiento");
  const modal = $("modalFraccionamiento");
  const btnClose = $("closeFraccionamiento");
  const btnCancel = $("cancelFraccionamiento");

  function openModal() {
    if (!modal) return;
    modal.classList.add("open");

    // foco al primer input/select del form
    const first = modal.querySelector("select, input, button, textarea");
    if (first) first.focus();
  }

  function closeModal() {
    if (!modal) return;
    modal.classList.remove("open");

    // opcional: limpiar formulario
    const form = modal.querySelector("form");
    if (form) form.reset();
  }

  // abrir
  btnOpen?.addEventListener("click", openModal);

  // cerrar por botones
  btnClose?.addEventListener("click", closeModal);
  btnCancel?.addEventListener("click", closeModal);

  // cerrar clickeando el overlay (fuera del modal)
  modal?.addEventListener("click", (e) => {
    if (e.target === modal) closeModal();
  });

  // cerrar con ESC
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && modal?.classList.contains("open")) {
      closeModal();
    }
  });

  // ==========================
  // (Opcional) filtros en tabla
  // ==========================
  const search = $("tableSearch");
  const estadoFilter = $("estadoFilter");
  const tbody = $("tableBody");

  function applyFilter() {
    if (!tbody) return;

    const q = (search?.value || "").trim().toLowerCase();
    const est = (estadoFilter?.value || "").trim().toUpperCase();

    const rows = Array.from(tbody.querySelectorAll("tr"));

    rows.forEach((tr) => {
      // si es fila "No hay cuotas", no tocar
      if (tr.querySelector("td[colspan]")) return;

      const rowText = tr.innerText.toLowerCase();
      const rowEstado = (tr.getAttribute("data-estado") || "").toUpperCase();

      const okText = !q || rowText.includes(q);
      const okEstado = !est || rowEstado === est;

      tr.style.display = okText && okEstado ? "" : "none";
    });
  }

  search?.addEventListener("input", applyFilter);
  estadoFilter?.addEventListener("change", applyFilter);
})();
document.addEventListener("DOMContentLoaded", () => {

  // ✅ Si pagination no cargó, NO revientes toda la página (así el modal igual funciona)
  if (typeof window.initTablePagination === "function") {
    window.initTablePagination({
      perPage: 6,
      tableBodyId: "tableBody",
      searchId: "tableSearch",
      estadoFilterId: "estadoFilter",
      paginationId: "pagination",
      tableInfoId: "tableInfo"
    });
  } else {
    console.warn("pagination.js no cargó: initTablePagination no existe.");
  }

  // ─────────────────────────────
  // MODAL NUEVO CONTRIBUYENTE
  // ─────────────────────────────
  const modal = document.getElementById("modalOverlay");
  const btnNuevo = document.getElementById("btnNuevo");
  const btnClose = document.getElementById("modalClose");
  const btnCancel = document.getElementById("modalCancel");

  if (!modal || !btnNuevo) {
    console.warn("No encuentro modalOverlay o btnNuevo en el DOM.");
    return;
  }

  const openModal = () => {
    modal.classList.add("open");
    modal.setAttribute("aria-hidden", "false");
  };

  const closeModal = () => {
    modal.classList.remove("open");
    modal.setAttribute("aria-hidden", "true");
    const form = modal.querySelector("form");
    if (form) form.reset();
  };

  btnNuevo.addEventListener("click", openModal);
  btnClose?.addEventListener("click", closeModal);
  btnCancel?.addEventListener("click", closeModal);

  modal.addEventListener("click", (e) => {
    if (e.target === modal) closeModal();
  });

  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && modal.classList.contains("open")) closeModal();
  });
});
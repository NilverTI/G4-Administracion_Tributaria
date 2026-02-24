document.addEventListener("DOMContentLoaded", () => {

  // ✅ Paginación + filtros (reutilizable)
  if (window.initTablePagination) {
    window.initTablePagination({
      perPage: 6,
      tableBodyId: "tableBody",
      searchId: "tableSearch",
      estadoFilterId: "estadoFilter",
      paginationId: "pagination"
    });
  }

  // ─────────────────────────────────────────────
  // MODAL REGISTRAR VEHÍCULO
  // ─────────────────────────────────────────────
  const modal = document.getElementById("modalOverlay");
  const btnNuevo = document.getElementById("btnNuevo");
  const btnClose = document.getElementById("modalClose");
  const btnCancel = document.getElementById("modalCancel");

  const openModal = () => modal?.classList.add("open");

  const closeModal = () => {
    modal?.classList.remove("open");
    const form = modal?.querySelector("form");
    if (form) form.reset();
  };

  btnNuevo?.addEventListener("click", openModal);
  btnClose?.addEventListener("click", closeModal);
  btnCancel?.addEventListener("click", closeModal);

  modal?.addEventListener("click", (e) => {
    if (e.target === modal) closeModal();
  });

});
// /webapp/js/configuracion.js
(() => {
  "use strict";

  const $ = (id) => document.getElementById(id);

  // Botón único (arriba a la derecha)
  const btnNuevoItem = $("btnNuevoItem");

  // =========================
  // Tabs
  // =========================
  function initTabs() {
    const tabBtns = document.querySelectorAll(".tab-btn");
    const tabContents = document.querySelectorAll(".tab-content");

    if (!tabBtns.length || !tabContents.length) return;

    function setHeaderButton(tabId) {
      if (!btnNuevoItem) return;

      // Cambia texto/icono + acción según tab activa
      if (tabId === "tab-zonas") {
        btnNuevoItem.innerHTML = `<i class="fi fi-rr-plus"></i> Nueva zona`;
        btnNuevoItem.onclick = () => window.openModal("zonas");
      } else if (tabId === "tab-uit") {
        btnNuevoItem.innerHTML = `<i class="fi fi-rr-plus"></i> Registrar UIT`;
        btnNuevoItem.onclick = () => window.openModal("uit");
      } else if (tabId === "tab-veh") {
        btnNuevoItem.innerHTML = `<i class="fi fi-rr-plus"></i> Nuevo porcentaje`;
        btnNuevoItem.onclick = () => window.openModal("veh");
      } else {
        btnNuevoItem.innerHTML = `<i class="fi fi-rr-plus"></i> Nuevo`;
        btnNuevoItem.onclick = null;
      }
    }

    // Inicializa según el tab que ya está activo en el HTML
    const activeBtn = document.querySelector(".tab-btn.active");
    setHeaderButton(activeBtn?.dataset?.tab || "tab-zonas");

    tabBtns.forEach((btn) => {
      btn.addEventListener("click", (e) => {
        e.preventDefault();

        tabBtns.forEach((b) => b.classList.remove("active"));
        tabContents.forEach((c) => c.classList.remove("active"));

        btn.classList.add("active");

        const tabId = btn.dataset.tab;
        const panel = tabId ? document.getElementById(tabId) : null;
        if (panel) panel.classList.add("active");

        setHeaderButton(tabId);
      });
    });
  }

  // =========================
  // Modal dinámico
  // =========================
  const modalOverlay = $("modalOverlay");
  const modalTitle = $("modalTitle");
  const modalFields = $("modalFields");
  const modalAction = $("modalAction");

  function ensureModal() {
    return modalOverlay && modalTitle && modalFields && modalAction;
  }

  function openModal(type) {
    if (!ensureModal()) return;

    modalFields.innerHTML = "";

    if (type === "zonas") {
      modalTitle.innerText = "Registrar Zona";
      modalAction.value = "zonas.crear";
      modalFields.innerHTML = `
        <div class="form-group">
          <label class="form-label">Código</label>
          <input class="form-input" name="codigo" required>
        </div>
        <div class="form-group">
          <label class="form-label">Nombre</label>
          <input class="form-input" name="nombre" required>
        </div>
        <div class="form-group full">
          <label class="form-label">Tasa (%)</label>
          <input class="form-input" type="number" step="0.01" name="tasa" required>
        </div>
      `;
    } else if (type === "uit") {
      modalTitle.innerText = "Registrar UIT";
      modalAction.value = "uit.crear";
      modalFields.innerHTML = `
        <div class="form-group">
          <label class="form-label">Año</label>
          <input class="form-input" type="number" name="anio" required>
        </div>
        <div class="form-group">
          <label class="form-label">Valor</label>
          <input class="form-input" type="number" step="0.01" name="valor" required>
        </div>
      `;
    } else if (type === "veh") {
      modalTitle.innerText = "Nuevo Porcentaje Vehicular";
      modalAction.value = "veh.crear";
      modalFields.innerHTML = `
        <div class="form-group">
          <label class="form-label">Año</label>
          <input class="form-input" type="number" name="anio" required>
        </div>
        <div class="form-group">
          <label class="form-label">Porcentaje</label>
          <input class="form-input" type="number" step="0.01" name="porcentaje" required>
        </div>
      `;
    } else {
      return;
    }

    modalOverlay.classList.add("open");
    modalOverlay.querySelector("input, select, textarea, button")?.focus();
  }

  function openModalEditUIT(anio, valor) {
    if (!ensureModal()) return;

    modalTitle.innerText = "Actualizar UIT";
    modalAction.value = "uit.update";

    modalFields.innerHTML = `
      <div class="form-group">
        <label class="form-label">Año</label>
        <input class="form-input" type="number" name="anio" value="${String(anio ?? "")}" readonly>
      </div>
      <div class="form-group">
        <label class="form-label">Valor</label>
        <input class="form-input" type="number" step="0.01" name="valor" value="${String(valor ?? "")}" required>
      </div>
    `;

    modalOverlay.classList.add("open");
    modalOverlay.querySelector("input:not([readonly])")?.focus();
  }

  function closeModal() {
    if (!modalOverlay) return;
    modalOverlay.classList.remove("open");
    modalFields.innerHTML = "";
    modalTitle.innerText = "";
    modalAction.value = "";
  }

  function initModalClose() {
    if (!modalOverlay) return;

    modalOverlay.addEventListener("click", (e) => {
      if (e.target === modalOverlay) closeModal();
    });

    document.addEventListener("keydown", (e) => {
      if (e.key === "Escape" && modalOverlay.classList.contains("open")) closeModal();
    });
  }

  // Exponer para onclick internos
  window.openModal = openModal;
  window.openModalEditUIT = openModalEditUIT;
  window.closeModal = closeModal;

  function init() {
    initTabs();
    initModalClose();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
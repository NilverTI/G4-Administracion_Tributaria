// /js/configuracion.js
(() => {
  "use strict";

  // =========================
  // Datos iniciales (demo)
  // =========================
  let zonas = [
    { id: "Z001", zona: "Zona A", tasa: 1.2 },
    { id: "Z002", zona: "Zona B", tasa: 0.8 },
    { id: "Z003", zona: "Zona C", tasa: 0.5 },
    { id: "Z004", zona: "Zona D", tasa: 0.3 },
  ];

  // =========================
  // Helpers DOM
  // =========================
  const $ = (id) => document.getElementById(id);

  const tbody = $("tbodyZonas");
  const modalOverlay = $("modalOverlay");

  const btnAgregar = $("btnAgregar");
  const btnCerrar = $("btnCerrar");
  const btnCancelar = $("btnCancelar");

  const formZona = $("formZona");
  const zonaId = $("zonaId");
  const zonaNombre = $("zonaNombre");
  const zonaTasa = $("zonaTasa");

  const searchInput =
    $("tableSearch") || $("topbarSearch") || $("search") || null;

  // =========================
  // Utils
  // =========================
  function escapeHtml(str) {
    return String(str)
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#039;");
  }

  function formatTasa(num) {
    const n = Number(num);
    if (Number.isNaN(n)) return "0%";
    const fixed = (Math.round(n * 10) / 10).toString(); // 1 decimal máximo
    return `${fixed}%`;
  }

  // =========================
  // Render tabla
  // =========================
  function renderTabla(data) {
    if (!tbody) return;

    tbody.innerHTML = "";

    if (!data || data.length === 0) {
      const tr = document.createElement("tr");
      tr.innerHTML = `
        <td colspan="3" style="padding:16px 20px; color: var(--text-muted);">
          No hay resultados.
        </td>
      `;
      tbody.appendChild(tr);
      return;
    }

    data.forEach((z) => {
      const tr = document.createElement("tr");
      tr.innerHTML = `
        <td>${escapeHtml(z.id)}</td>
        <td style="font-weight:600;">${escapeHtml(z.zona)}</td>
        <td style="text-align:right; font-family:'JetBrains Mono', monospace; font-weight:600;">
          ${formatTasa(z.tasa)}
        </td>
      `;
      tbody.appendChild(tr);
    });
  }

  // =========================
  // Buscar
  // =========================
  function applyCurrentFilter() {
    const q = (searchInput?.value || "").trim().toLowerCase();

    if (!q) {
      renderTabla(zonas);
      return;
    }

    const filtered = zonas.filter((z) => {
      const id = (z.id || "").toLowerCase();
      const zn = (z.zona || "").toLowerCase();
      const tasa = formatTasa(z.tasa).toLowerCase();
      return id.includes(q) || zn.includes(q) || tasa.includes(q);
    });

    renderTabla(filtered);
  }

  // =========================
  // Modal
  // =========================
  function openModal() {
    if (!modalOverlay) return;
    modalOverlay.classList.add("open");
    // foco al primer input
    zonaId?.focus();
  }

  function closeModal() {
    if (!modalOverlay) return;
    modalOverlay.classList.remove("open");
    formZona?.reset();
  }

  // ESC cierra modal
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && modalOverlay?.classList.contains("open")) {
      closeModal();
    }
  });

  // click fuera cierra modal
  modalOverlay?.addEventListener("click", (e) => {
    if (e.target === modalOverlay) closeModal();
  });

  // botones modal
  btnAgregar?.addEventListener("click", openModal);
  btnCerrar?.addEventListener("click", closeModal);
  btnCancelar?.addEventListener("click", closeModal);

  // =========================
  // Guardar zona/tasa
  // =========================
  formZona?.addEventListener("submit", (e) => {
    e.preventDefault();

    const id = (zonaId?.value || "").trim();
    const zona = (zonaNombre?.value || "").trim();
    const tasaStr = (zonaTasa?.value || "").trim();
    const tasa = Number(tasaStr);

    if (!id || !zona || tasaStr === "" || Number.isNaN(tasa)) return;

    // ID único (case-insensitive)
    const exists = zonas.some((x) => (x.id || "").toLowerCase() === id.toLowerCase());
    if (exists) {
      alert("Ese ID ya existe. Usa otro (ej: Z005).");
      zonaId?.focus();
      return;
    }

    zonas.push({ id, zona, tasa });

    // mantener filtro actual
    applyCurrentFilter();
    closeModal();
  });

  // =========================
  // Tabs (cambia paneles)
  // =========================
  const panels = {
    zonas: $("panel-zonas"),
    uit: $("panel-uit"),
    usuarios: $("panel-usuarios"),
    bitacora: $("panel-bitacora"),
  };

  function showTab(key) {
    Object.keys(panels).forEach((k) => {
      if (panels[k]) panels[k].style.display = k === key ? "" : "none";
    });

    document.querySelectorAll(".tab-btn").forEach((b) => {
      const active = b.dataset.tab === key;
      b.classList.toggle("active", active);
      b.setAttribute("aria-selected", active ? "true" : "false");
    });
  }

  document.querySelectorAll(".tab-btn").forEach((btn) => {
    btn.addEventListener("click", () => showTab(btn.dataset.tab));
  });

  // =========================
  // Init
  // =========================
  function init() {
    // buscador
    searchInput?.addEventListener("input", applyCurrentFilter);

    // render inicial
    renderTabla(zonas);

    // por defecto
    showTab("zonas");
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
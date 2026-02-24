// /js/impuestos.js
(() => {
  "use strict";

  const CTX = window.__CTX__ || "";

  const modalGenerar = document.getElementById("modalGenerar");
  const modalCuotas = document.getElementById("modalCuotas");

  const btnAbrir = document.getElementById("btnAbrirModal");
  const closeGenerar = document.getElementById("closeGenerar");
  const cancelGenerar = document.getElementById("cancelGenerar");

  const closeCuotas = document.getElementById("closeCuotas");
  const cuotasContainer = document.getElementById("cuotasContainer");

  const qFilter = document.getElementById("qFilter");
  const tipoFilter = document.getElementById("tipoFilter");
  const estadoFilter = document.getElementById("estadoFilter");

  // ✅ pagination.js espera: tableBody + tableSearch + estadoFilter
  // Para no tocar tu pagination.js, “puenteamos”:
  const tableSearch = document.getElementById("tableSearch") || qFilter;
  const tableBody = document.getElementById("tableBody");

  // --------------------------
  // Modal helpers
  // --------------------------
  function openModal(el) {
    if (!el) return;
    el.classList.add("open");
  }

  function closeModal(el) {
    if (!el) return;
    el.classList.remove("open");
  }

  btnAbrir?.addEventListener("click", () => openModal(modalGenerar));
  closeGenerar?.addEventListener("click", () => closeModal(modalGenerar));
  cancelGenerar?.addEventListener("click", () => closeModal(modalGenerar));

  closeCuotas?.addEventListener("click", () => closeModal(modalCuotas));

  // click fuera
  [modalGenerar, modalCuotas].forEach((m) => {
    m?.addEventListener("click", (e) => {
      if (e.target === m) closeModal(m);
    });
  });

  // ESC
  document.addEventListener("keydown", (e) => {
    if (e.key !== "Escape") return;
    if (modalGenerar?.classList.contains("open")) closeModal(modalGenerar);
    if (modalCuotas?.classList.contains("open")) closeModal(modalCuotas);
  });

  // --------------------------
  // Ver cuotas (AJAX JSON)
  // --------------------------
  function esc(s) {
    return String(s)
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#039;");
  }

  function badgeClass(estadoRaw) {
    const e = String(estadoRaw || "").toLowerCase();
    if (e.includes("pag")) return "badge-pagado";
    if (e.includes("venc")) return "badge-vencido";
    if (e.includes("frac")) return "badge-fraccionado";
    return "badge-pendiente";
  }

  async function verCuotas(id) {
    try {
      if (!cuotasContainer) return;

      cuotasContainer.innerHTML = `
        <div style="padding:14px 16px; color: var(--text-muted);">
          Cargando cuotas...
        </div>
      `;

      const url = `${CTX}/funcionario/impuesto?action=cuotas&id=${encodeURIComponent(id)}`;
      const res = await fetch(url, { headers: { "Accept": "application/json" } });

      if (!res.ok) throw new Error("No se pudo cargar cuotas");

      const data = await res.json();

      if (!Array.isArray(data) || data.length === 0) {
        cuotasContainer.innerHTML = `
          <div style="padding:14px 16px; color: var(--text-muted);">
            Este impuesto no tiene cuotas.
          </div>
        `;
        openModal(modalCuotas);
        return;
      }

      cuotasContainer.innerHTML = data.map((c) => {
        const estado = c.estado ?? "PENDIENTE";
        return `
          <div class="cuota-item">
            <div class="cuota-left">
              <strong>Cuota ${esc(c.numero)}</strong>
              <small>Vence: ${esc(c.vencimiento)}</small>
            </div>
            <div class="cuota-right">
              <span>S/ ${esc(c.monto)}</span>
              <span class="badge ${badgeClass(estado)}">${esc(estado)}</span>
            </div>
          </div>
        `;
      }).join("");

      openModal(modalCuotas);

    } catch (err) {
      if (cuotasContainer) {
        cuotasContainer.innerHTML = `
          <div style="padding:14px 16px; color: var(--red); font-weight:600;">
            Error cargando cuotas.
          </div>
        `;
      }
      openModal(modalCuotas);
    }
  }

  // Delegación de eventos para botones "Ver"
  document.addEventListener("click", (e) => {
    const btn = e.target.closest(".action-link[data-impuesto-id]");
    if (!btn) return;
    verCuotas(btn.dataset.impuestoId);
  });

  // --------------------------
  // Filtros extra (tipo + estado)
  // --------------------------
  function applyRowFilters() {
    if (!tableBody) return;
    const rows = Array.from(tableBody.querySelectorAll("tr"));

    const q = (qFilter?.value || "").trim().toLowerCase();
    const tipo = (tipoFilter?.value || "").trim().toUpperCase();
    const estado = (estadoFilter?.value || "").trim().toUpperCase();

    rows.forEach((row) => {
      const text = row.innerText.toLowerCase();
      const rowTipo = String(row.dataset.tipo || "").toUpperCase();
      const rowEstado = String(row.dataset.estado || "").toUpperCase();

      const matchQ = !q || text.includes(q);
      const matchTipo = !tipo || rowTipo === tipo;
      const matchEstado = !estado || rowEstado === estado;

      row.style.display = (matchQ && matchTipo && matchEstado) ? "" : "none";
    });

    // ✅ si tu pagination.js está cargado, llamará a paginate() cuando detecte input/change.
    // Igual “forzamos” un evento para que se repinte:
    document.dispatchEvent(new Event("impuestos:filter"));
  }

  qFilter?.addEventListener("input", applyRowFilters);
  tipoFilter?.addEventListener("change", applyRowFilters);
  estadoFilter?.addEventListener("change", applyRowFilters);

  // Hook para repaginar: tu pagination.js no conoce este evento,
  // pero si en tu pagination.js ya está escuchando input/change en tableSearch/estadoFilter,
  // esto igual funciona porque ya disparamos cambios arriba.
})();
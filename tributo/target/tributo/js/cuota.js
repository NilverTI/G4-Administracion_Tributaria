(() => {
  "use strict";

  const CTX = (typeof CONTEXT_PATH !== "undefined") ? CONTEXT_PATH : "";
  const $ = (id) => document.getElementById(id);

  // =========================
  // Modal helpers
  // =========================
  function openModal(overlay) {
    if (!overlay) return;
    overlay.classList.add("open");
    overlay.setAttribute("aria-hidden", "false");
    document.body.style.overflow = "hidden";
  }

  function closeModal(overlay) {
    if (!overlay) return;
    overlay.classList.remove("open");
    overlay.setAttribute("aria-hidden", "true");
    document.body.style.overflow = "";
  }

  function isOpen(overlay) {
    return !!overlay && overlay.classList.contains("open");
  }

  function bindModalClose(overlay, closeBtn, cancelBtn) {
    closeBtn?.addEventListener("click", () => closeModal(overlay));
    cancelBtn?.addEventListener("click", () => closeModal(overlay));

    // click en overlay (fuera del modal)
    overlay?.addEventListener("click", (e) => {
      if (e.target === overlay) closeModal(overlay);
    });
  }

  // =========================
  // Utils
  // =========================
  function escapeHtml(value) {
    return String(value ?? "")
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#039;");
  }

  function estadoBadgeHtml(estado) {
    const up = String(estado || "").trim().toUpperCase();

    if (up === "PAGADA" || up === "PAGADO") {
      return `<span class="badge badge-activo">Pagado</span>`;
    }
    if (up.includes("VENC")) {
      return `<span class="badge badge-inactivo">Vencido</span>`;
    }
    return `<span class="badge badge-pendiente">Pendiente</span>`;
  }

  // =========================
  // CSelect Pro (Impuesto)
  // =========================
  function initImpuestoSelect() {
    const root = $("csImpuesto");
    const displayBtn = $("impuestoDisplay");
    const displayText = $("impuestoDisplayText");
    const dropdown = $("impuestoDropdown");
    const input = $("impuestoInput");
    const menu = $("impuestoMenu");
    const hidden = $("idImpuesto");
    const dataBox = $("impuestosData");

    if (!root || !displayBtn || !displayText || !dropdown || !input || !menu || !hidden || !dataBox) return;

    const items = Array.from(dataBox.querySelectorAll(".imp-item")).map((el) => {
      const label = el.dataset.label || "";
      return {
        id: el.dataset.id || "",
        label,
        search: label.toLowerCase(),
      };
    });

    function openDropdown() {
      dropdown.classList.add("open");
      dropdown.setAttribute("aria-hidden", "false");
      displayBtn.setAttribute("aria-expanded", "true");
      input.focus();
    }

    function closeDropdown() {
      dropdown.classList.remove("open");
      dropdown.setAttribute("aria-hidden", "true");
      displayBtn.setAttribute("aria-expanded", "false");
    }

    function render(list, activeId = "") {
      if (!list || list.length === 0) {
        menu.innerHTML = `<div class="cselect-empty">Sin resultados</div>`;
        return;
      }

      menu.innerHTML = list.slice(0, 200).map((it) => {
        const active = String(it.id) === String(activeId) ? "active" : "";
        return `
          <button type="button" class="cselect-option ${active}" data-id="${escapeHtml(it.id)}">
            ${escapeHtml(it.label)}
          </button>
        `;
      }).join("");

      menu.querySelectorAll(".cselect-option").forEach((btn) => {
        btn.addEventListener("click", () => {
          const id = btn.dataset.id;
          const label = btn.textContent.trim();

          hidden.value = id;
          displayText.textContent = label;
          displayText.classList.remove("is-placeholder");

          input.value = "";
          closeDropdown();
        });
      });
    }

    // init
    displayText.classList.add("is-placeholder");
    render(items, hidden.value);

    // toggle click
    displayBtn.addEventListener("click", (e) => {
      e.preventDefault();
      e.stopPropagation();

      if (dropdown.classList.contains("open")) closeDropdown();
      else {
        render(items, hidden.value);
        openDropdown();
      }
    });

    // buscar
    input.addEventListener("input", () => {
      const q = input.value.trim().toLowerCase();
      const filtered = q ? items.filter((x) => x.search.includes(q)) : items;
      render(filtered, hidden.value);
    });

    // click fuera
    document.addEventListener("click", (e) => {
      if (!root.contains(e.target)) closeDropdown();
    });

    // teclado
    input.addEventListener("keydown", (e) => {
      if (e.key === "Enter") {
        e.preventDefault();
        const first = menu.querySelector(".cselect-option");
        if (first) first.click();
      }
      if (e.key === "Escape") {
        e.preventDefault();
        closeDropdown();
      }
    });
  }

  // =========================
  // Detalle cuotas
  // =========================
  async function cargarDetalleCuotas(idImpuesto, meta) {
    const tbody = $("detalleCuotasBody");
    const subtitle = $("detalleSubtitle");

    if (subtitle) {
      const parts = [];
      if (meta?.codigo) parts.push(`<b>${escapeHtml(meta.codigo)}</b>`);
      if (meta?.contribuyente) parts.push(escapeHtml(meta.contribuyente));
      if (meta?.tipo || meta?.anio) parts.push(`(${escapeHtml(meta.tipo || "")} ${escapeHtml(meta.anio || "")})`);
      subtitle.innerHTML = parts.join(" — ");
    }

    if (!tbody) return;

    tbody.innerHTML = `
      <tr>
        <td colspan="4" class="empty-table">Cargando...</td>
      </tr>
    `;

    try {
      const url = `${CTX}/funcionario/cuota?action=detalle&idImpuesto=${encodeURIComponent(idImpuesto)}`;
      const res = await fetch(url, { headers: { "Accept": "application/json" } });

      if (!res.ok) throw new Error("HTTP " + res.status);

      const data = await res.json();

      if (!Array.isArray(data) || data.length === 0) {
        tbody.innerHTML = `
          <tr><td colspan="4" class="empty-table">No hay cuotas para este impuesto</td></tr>
        `;
        return;
      }

      tbody.innerHTML = data.map((c) => {
        const numero = c?.numero ?? "";
        const total = c?.total ?? "";
        const monto = c?.monto ?? "";
        const venc = c?.vencimiento ?? "";
        const estado = c?.estado ?? "";

        return `
          <tr>
            <td>${escapeHtml(numero)} / ${escapeHtml(total)}</td>
            <td class="td-money">S/ ${escapeHtml(monto)}</td>
            <td>${escapeHtml(venc)}</td>
            <td>${estadoBadgeHtml(estado)}</td>
          </tr>
        `;
      }).join("");

    } catch (err) {
      tbody.innerHTML = `
        <tr><td colspan="4" class="empty-table">Error cargando cuotas</td></tr>
      `;
    }
  }

  // =========================
  // Init
  // =========================
  document.addEventListener("DOMContentLoaded", () => {
    // Modales
    const modalFrac = $("modalFraccionamiento");
    const btnFrac = $("btnFraccionamiento");
    const closeFrac = $("closeFraccionamiento");
    const cancelFrac = $("cancelFraccionamiento");

    const modalDetalle = $("modalDetalleCuotas");
    const closeDetalle = $("closeDetalleCuotas");
    const cancelDetalle = $("cancelDetalleCuotas");

    // Abrir modal fraccionamiento
    btnFrac?.addEventListener("click", () => openModal(modalFrac));
    bindModalClose(modalFrac, closeFrac, cancelFrac);
    bindModalClose(modalDetalle, closeDetalle, cancelDetalle);

    // ESC cierra el que esté abierto
    document.addEventListener("keydown", (e) => {
      if (e.key !== "Escape") return;
      if (isOpen(modalDetalle)) closeModal(modalDetalle);
      if (isOpen(modalFrac)) closeModal(modalFrac);
    });

    // Select Pro
    initImpuestoSelect();

    // Delegación: Ver cuotas (funciona con paginación)
    document.addEventListener("click", async (e) => {
      const btn = e.target.closest(".btn-ver-cuotas");
      if (!btn) return;

      const idImpuesto = btn.dataset.idImpuesto;
      if (!idImpuesto || Number(idImpuesto) <= 0) {
        alert("No se pudo identificar el impuesto (ID inválido).");
        return;
      }

      const meta = {
        codigo: btn.dataset.codImpuesto || "",
        contribuyente: btn.dataset.contribuyente || "",
        tipo: btn.dataset.tipo || "",
        anio: btn.dataset.anio || "",
      };

      openModal(modalDetalle);
      await cargarDetalleCuotas(idImpuesto, meta);
    });
  });

})();
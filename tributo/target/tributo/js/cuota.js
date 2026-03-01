
(() => {
  const $ = (id) => document.getElementById(id);
  const btnOpen = $("btnFraccionamiento");
  const modal = $("modalFraccionamiento");
  const btnClose = $("closeFraccionamiento");
  const btnCancel = $("cancelFraccionamiento");

  function openModal() {
    if (!modal) return;
    modal.classList.add("open");
    const first = modal.querySelector("select, input, button, textarea");
    if (first) first.focus();
  }

  function closeModal() {
    if (!modal) return;
    modal.classList.remove("open");
    const form = modal.querySelector("form");
    if (form) form.reset();
  }

  btnOpen?.addEventListener("click", openModal);
  btnClose?.addEventListener("click", closeModal);
  btnCancel?.addEventListener("click", closeModal);

  modal?.addEventListener("click", (e) => {
    if (e.target === modal) closeModal();
  });

  const search = $("tableSearch");
  const estadoFilter = $("estadoFilter");
  const tbody = $("tableBody");

  function applyFilter() {
    if (!tbody) return;

    const q = (search?.value || "").trim().toLowerCase();
    const est = (estadoFilter?.value || "").trim().toUpperCase();

    const rows = Array.from(tbody.querySelectorAll("tr"));

    rows.forEach((tr) => {
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

  const modalDetalle = $("modalDetalleCuotas");
  const closeDetalle = $("closeDetalleCuotas");
  const cancelDetalle = $("cancelDetalleCuotas");
  const detalleBody = $("detalleCuotasBody");
  const detalleSubtitle = $("detalleSubtitle");

  function openDetalleModal() {
    if (!modalDetalle) return;
    modalDetalle.classList.add("open");
  }

  function closeDetalleModal() {
    if (!modalDetalle) return;
    modalDetalle.classList.remove("open");
    if (detalleBody) {
      detalleBody.innerHTML = `
        <tr>
          <td colspan="4" class="empty-table">Seleccione un fraccionamiento...</td>
        </tr>`;
    }
    if (detalleSubtitle) detalleSubtitle.textContent = "";
  }

  closeDetalle?.addEventListener("click", closeDetalleModal);
  cancelDetalle?.addEventListener("click", closeDetalleModal);

  modalDetalle?.addEventListener("click", (e) => {
    if (e.target === modalDetalle) closeDetalleModal();
  });

  document.addEventListener("keydown", (e) => {
    if (e.key !== "Escape") return;
    if (modal?.classList.contains("open")) closeModal();
    if (modalDetalle?.classList.contains("open")) closeDetalleModal();
  });

  function badgeHTML(estadoRaw) {
    const est = (estadoRaw || "").toString().trim().toUpperCase();

    if (est === "PAGADO" || est === "PAGADA") {
      return `<span class="badge badge-activo">Pagada</span>`;
    }
    if (est === "VENCIDO" || est === "VENCIDA") {
      return `<span class="badge badge-inactivo">Vencida</span>`;
    }
    return `<span class="badge badge-pendiente">Pendiente</span>`;
  }

  async function cargarDetalleCuotas({ idImpuesto, codigoImpuesto, contribuyente }) {
    const ctx = window.__CTX__ || "";
    const url = `${ctx}/funcionario/cuota?action=detalle&idImpuesto=${encodeURIComponent(idImpuesto)}`;

    if (detalleSubtitle) {
      detalleSubtitle.textContent = `${codigoImpuesto || ""} — ${contribuyente || ""}`.trim();
    }

    if (detalleBody) {
      detalleBody.innerHTML = `
        <tr>
          <td colspan="4" class="empty-table">Cargando...</td>
        </tr>`;
    }

    try {
      const res = await fetch(url, { headers: { "Accept": "application/json" } });

      if (!res.ok) {
        if (detalleBody) {
          detalleBody.innerHTML = `
            <tr>
              <td colspan="4" class="empty-table">Error al cargar (HTTP ${res.status})</td>
            </tr>`;
        }
        return;
      }

      const data = await res.json();

      if (!Array.isArray(data) || data.length === 0) {
        if (detalleBody) {
          detalleBody.innerHTML = `
            <tr>
              <td colspan="4" class="empty-table">No hay cuotas para este impuesto</td>
            </tr>`;
        }
        return;
      }
      const html = data.map((c) => {
        const cuotaTxt = `${c.numero}/${c.total}`;
        return `
          <tr>
            <td class="td-code">${cuotaTxt}</td>
            <td class="td-money">S/ ${c.monto}</td>
            <td>${c.vencimiento}</td>
            <td>${badgeHTML(c.estado)}</td>
          </tr>
        `;
      }).join("");

      if (detalleBody) detalleBody.innerHTML = html;

    } catch (err) {
      if (detalleBody) {
        detalleBody.innerHTML = `
          <tr>
            <td colspan="4" class="empty-table">Error de red al cargar cuotas</td>
          </tr>`;
      }
    }
  }

  document.addEventListener("click", (e) => {
    const btn = e.target.closest(".btn-ver-cuotas");
    if (!btn) return;

    const idImpuesto = btn.getAttribute("data-id-impuesto");
    const codigoImpuesto = btn.getAttribute("data-cod-impuesto") || "";
    const contribuyente = btn.getAttribute("data-contribuyente") || "";

    if (!idImpuesto) return;

    openDetalleModal();
    cargarDetalleCuotas({ idImpuesto, codigoImpuesto, contribuyente });
  });

})();
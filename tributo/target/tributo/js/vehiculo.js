document.addEventListener("DOMContentLoaded", () => {
  // =========================
  // Paginación + filtros
  // =========================
  if (window.initTablePagination) {
    window.initTablePagination({
      perPage: 6,
      tableBodyId: "tableBody",
      searchId: "tableSearch",
      estadoFilterId: "estadoFilter",
      paginationId: "pagination",
      tableInfoId: "tableInfo",
    });
  }

  // =========================
  // Modal
  // =========================
  const overlay = document.getElementById("modalOverlay");
  const btnNuevo = document.getElementById("btnNuevo");
  const btnClose = document.getElementById("modalClose");
  const btnCancel = document.getElementById("modalCancel");

  const openModal = () => {
    overlay?.classList.add("open");
    // abre el selector al abrir modal (opcional)
    setTimeout(() => contribInput?.focus(), 50);
  };

  const closeModal = () => {
    overlay?.classList.remove("open");
    // reset form
    const form = document.getElementById("vehiculoForm");
    form?.reset();

    // reset contribuyente custom
    if (idHidden) idHidden.value = "";
    if (contribInput) contribInput.value = "";
    setHint("Escribe para buscar y selecciona uno.", false);
    closeMenu();
  };

  btnNuevo?.addEventListener("click", openModal);
  btnClose?.addEventListener("click", closeModal);
  btnCancel?.addEventListener("click", closeModal);

  overlay?.addEventListener("click", (e) => {
    if (e.target === overlay) closeModal();
  });

  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && overlay?.classList.contains("open")) closeModal();
  });

  // =========================
  // Custom Select: Contribuyente
  // =========================
  const cs = document.getElementById("csContribuyente");
  const contribInput = document.getElementById("contribuyenteInput");
  const toggleBtn = document.getElementById("contribuyenteToggle");
  const menu = document.getElementById("contribuyenteMenu");
  const idHidden = document.getElementById("idContribuyente");
  const hint = document.getElementById("contribuyenteHint");

  // lee dataset
  const dataHost = document.getElementById("contribuyentesData");
  const contribuyentes = Array.from(
    dataHost?.querySelectorAll(".contrib-item") || []
  ).map((el) => ({
    id: el.getAttribute("data-id"),
    text: (el.textContent || "").trim(),
  }));

  function setHint(text, isError) {
    if (!hint) return;
    hint.textContent = text;
    hint.style.color = isError ? "var(--danger, #d64545)" : "var(--text-muted)";
  }

  function openMenu() {
    if (!cs || !menu) return;
    cs.classList.add("open");
    menu.setAttribute("aria-hidden", "false");
  }

  function closeMenu() {
    if (!cs || !menu) return;
    cs.classList.remove("open");
    menu.setAttribute("aria-hidden", "true");
  }

  function renderMenu(list) {
    if (!menu) return;

    menu.innerHTML = "";

    if (!list || list.length === 0) {
      const div = document.createElement("div");
      div.className = "cselect-empty";
      div.textContent = "Sin resultados.";
      menu.appendChild(div);
      return;
    }

    list.slice(0, 25).forEach((item) => {
      const row = document.createElement("div");
      row.className = "cselect-item";
      row.setAttribute("role", "option");
      row.dataset.id = item.id;
      row.dataset.text = item.text;
      row.innerHTML = `<span>${escapeHtml(item.text)}</span>`;
      row.addEventListener("mousedown", (e) => {
        // mousedown para que no pierda focus antes del click
        e.preventDefault();
        selectItem(item);
      });
      menu.appendChild(row);
    });
  }

  function escapeHtml(str) {
    return String(str)
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#039;");
  }

  function selectItem(item) {
    if (!item) return;
    if (contribInput) contribInput.value = item.text;
    if (idHidden) idHidden.value = item.id;

    setHint("Seleccionado ✅", false);
    closeMenu();
  }

  function applyFilter() {
    const q = (contribInput?.value || "").trim().toLowerCase();
    if (!q) {
      renderMenu(contribuyentes);
      return;
    }
    const filtered = contribuyentes.filter((x) =>
      (x.text || "").toLowerCase().includes(q)
    );
    renderMenu(filtered);
  }

  // init: pinta todos apenas cargue
  renderMenu(contribuyentes);

  // abrir/cerrar
  toggleBtn?.addEventListener("click", () => {
    if (!cs?.classList.contains("open")) {
      applyFilter();
      openMenu();
      contribInput?.focus();
    } else {
      closeMenu();
    }
  });

  // escribir => filtra + abre
  contribInput?.addEventListener("input", () => {
    // si escriben, invalida selección previa
    if (idHidden) idHidden.value = "";
    setHint("Escribe para buscar y selecciona uno.", false);

    applyFilter();
    openMenu();
  });

  // focus => muestra lista
  contribInput?.addEventListener("focus", () => {
    applyFilter();
    openMenu();
  });

  // click fuera => cierra
  document.addEventListener("click", (e) => {
    if (!cs) return;
    if (!cs.contains(e.target)) closeMenu();
  });

  // validación antes de enviar: si escribió pero no seleccionó
  const form = document.getElementById("vehiculoForm");
  form?.addEventListener("submit", (e) => {
    if (!idHidden?.value) {
      e.preventDefault();
      openMenu();
      setHint("Selecciona un contribuyente válido.", true);
      contribInput?.focus();
    }
  });
});
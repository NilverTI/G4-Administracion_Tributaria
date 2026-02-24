(function () {
  function norm(s) {
    return (s ?? "")
      .toString()
      .trim()
      .toLowerCase();
  }

  function buildPagination(paginationEl, currentPage, totalPages, onGo) {
    paginationEl.innerHTML = "";

    const wrap = document.createElement("div");
    wrap.className = "pagination";

    const btnPrev = document.createElement("button");
    btnPrev.className = "page-btn";
    btnPrev.textContent = "‹";
    btnPrev.disabled = currentPage <= 1;
    btnPrev.addEventListener("click", () => onGo(currentPage - 1));
    wrap.appendChild(btnPrev);

    const btnPage = document.createElement("button");
    btnPage.className = "page-btn active";
    btnPage.textContent = String(currentPage);
    btnPage.disabled = true;
    wrap.appendChild(btnPage);

    const btnNext = document.createElement("button");
    btnNext.className = "page-btn";
    btnNext.textContent = "›";
    btnNext.disabled = currentPage >= totalPages;
    btnNext.addEventListener("click", () => onGo(currentPage + 1));
    wrap.appendChild(btnNext);

    paginationEl.appendChild(wrap);
  }

  // Detecta input de búsqueda automáticamente
  function resolveSearchInput(opts) {
    const byId = (id) => (id ? document.getElementById(id) : null);

    // 1) si lo pasan por opts
    let el = byId(opts?.searchId);
    if (el) return el;

    // 2) defaults típicos
    el = document.getElementById("tableSearch");
    if (el) return el;

    el = document.getElementById("qFilter");
    if (el) return el;

    // 3) no hay search
    return null;
  }

  window.initTablePagination = function initTablePagination(opts) {
    const perPage = Number(opts?.perPage ?? 6);

    const tableBody = document.getElementById(opts?.tableBodyId ?? "tableBody");
    const estadoFilter = document.getElementById(opts?.estadoFilterId ?? "estadoFilter");
    const paginationEl = document.getElementById(opts?.paginationId ?? "pagination");
    const tableInfoEl = document.getElementById(opts?.tableInfoId ?? "tableInfo");

    const searchInput = resolveSearchInput(opts);

    if (!tableBody || !paginationEl) {
      console.warn("initTablePagination: faltan elementos (tableBody o pagination).");
      return;
    }

    // filas de datos (excluye mensajes vacíos)
    const allRows = Array.from(tableBody.querySelectorAll("tr"))
      .filter(r => r.querySelectorAll("td").length > 1);

    let currentPage = 1;

    // ✅ Aplica filtro de búsqueda + estado
    // ✅ y respeta display:none que ya pusiste (tipoFilter, etc.)
    function applyFilters() {
      const q = norm(searchInput?.value);
      const est = norm(estadoFilter?.value);

      return allRows.filter((row) => {
        // si otro script la ocultó (tipoFilter u otros), no la consideres
        const hiddenByOtherFilters = row.style.display === "none";
        if (hiddenByOtherFilters) return false;

        const rowText = norm(row.textContent);
        const rowEstado = norm(row.getAttribute("data-estado"));

        const okQ = !q || rowText.includes(q);
        const okE = !est || rowEstado === est;

        return okQ && okE;
      });
    }

    function render() {
      // Primero: mostrar todas (para recalcular desde cero)
      allRows.forEach(r => (r.style.display = ""));

      // Luego: deja solo las que pasan filtros (y las demás ocultas)
      const q = norm(searchInput?.value);
      const est = norm(estadoFilter?.value);

      const filtered = allRows.filter((row) => {
        // Si otro script quiere ocultar filas, que lo haga ANTES y dispare un evento.
        // Aquí solo filtramos por search/estado.
        const rowText = norm(row.textContent);
        const rowEstado = norm(row.getAttribute("data-estado"));

        const okQ = !q || rowText.includes(q);
        const okE = !est || rowEstado === est;

        return okQ && okE;
      });

      // Oculta las que no cumplen search/estado
      allRows.forEach((row) => {
        if (!filtered.includes(row)) row.style.display = "none";
      });

      // Ahora toma SOLO visibles para paginar (incluye filtros externos)
      const visibleRows = allRows.filter((row) => row.style.display !== "none");

      const total = visibleRows.length;
      const totalPages = Math.max(1, Math.ceil(total / perPage));
      if (currentPage > totalPages) currentPage = totalPages;

      // Oculta todas las visibles, luego muestra solo la página
      visibleRows.forEach(r => (r.style.display = "none"));

      const start = (currentPage - 1) * perPage;
      const end = start + perPage;

      visibleRows.slice(start, end).forEach(r => (r.style.display = ""));

      // Info
      if (tableInfoEl) {
        const showing = total === 0 ? 0 : Math.min(perPage, total - start);
        tableInfoEl.innerHTML = `
          <div class="info-main">Mostrando ${showing} de ${total} registros</div>
          <div class="info-sub">Página ${currentPage} de ${totalPages}</div>
        `;
      }

      // Pagination
      buildPagination(paginationEl, currentPage, totalPages, (p) => {
        currentPage = p;
        render();
      });
    }

    // listeners (búsqueda)
    if (searchInput) {
      searchInput.addEventListener("input", () => {
        currentPage = 1;
        render();
      });
    }

    // listeners (estado)
    estadoFilter?.addEventListener("change", () => {
      currentPage = 1;
      render();
    });

    // ✅ Si otro script filtra (tipoFilter) puede disparar este evento
    document.addEventListener("impuestos:filter", () => {
      currentPage = 1;
      render();
    });

    // primer render
    render();
  };
})();
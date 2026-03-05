(() => {
    const tableBody = document.getElementById("tableBody");
    const searchInput = document.getElementById("tableSearch");
    const estadoFilter = document.getElementById("estadoFilter");

    const paginationEl = document.getElementById("pagination");
    const infoEl = document.getElementById("tableInfo");

    const pageSize = 5; // <-- cambia si quieres (ej: 10)
    let currentPage = 1;

    // Lee todas las filas originales
    const allRows = Array.from(tableBody.querySelectorAll("tr"));

    function normalize(str) {
        return (str || "").toString().toLowerCase().trim();
    }

    function getFilteredRows() {
        const q = normalize(searchInput.value);
        const estado = normalize(estadoFilter.value);

        return allRows.filter(tr => {
            const rowText = normalize(tr.innerText);
            const rowEstado = normalize(tr.getAttribute("data-estado"));

            const matchQuery = !q || rowText.includes(q);
            const matchEstado = !estado || rowEstado === estado;

            return matchQuery && matchEstado;
        });
    }

    function setRowVisibility(rowsToShow) {
        // Oculta todo
        allRows.forEach(r => (r.style.display = "none"));
        // Muestra los que tocan
        rowsToShow.forEach(r => (r.style.display = ""));
    }

    function renderInfo(total, start, end) {
        if (total === 0) {
            infoEl.textContent = "Mostrando 0 registros";
            return;
        }
        infoEl.textContent = `Mostrando ${start}–${end} de ${total} registros`;
    }

    function createButton(label, disabled, onClick, className = "pagination__btn") {
        const btn = document.createElement("button");
        btn.type = "button";
        btn.className = className + (disabled ? " is-disabled" : "");
        btn.textContent = label;
        btn.disabled = disabled;
        btn.addEventListener("click", () => !disabled && onClick());
        return btn;
    }

    function createPage(page, active, onClick) {
        const btn = document.createElement("button");
        btn.type = "button";
        btn.className = "pagination__page" + (active ? " is-active" : "");
        btn.textContent = page;
        btn.addEventListener("click", onClick);
        return btn;
    }

    function createDots() {
        const span = document.createElement("span");
        span.className = "pagination__dots";
        span.textContent = "…";
        return span;
    }

    function renderPagination(totalPages) {
        paginationEl.innerHTML = "";
        if (totalPages <= 1) return;

        // Prev
        paginationEl.appendChild(
            createButton("‹", currentPage === 1, () => {
                currentPage--;
                update();
            })
        );

        // Ventana de páginas
        const windowSize = 5;
        let start = Math.max(1, currentPage - Math.floor(windowSize / 2));
        let end = Math.min(totalPages, start + windowSize - 1);
        start = Math.max(1, end - windowSize + 1);

        // Primera + dots si hace falta
        if (start > 1) {
            paginationEl.appendChild(createPage(1, currentPage === 1, () => { currentPage = 1; update(); }));
            if (start > 2) paginationEl.appendChild(createDots());
        }

        for (let p = start; p <= end; p++) {
            paginationEl.appendChild(
                createPage(p, p === currentPage, () => {
                    currentPage = p;
                    update();
                })
            );
        }

        // Dots + última si hace falta
        if (end < totalPages) {
            if (end < totalPages - 1) paginationEl.appendChild(createDots());
            paginationEl.appendChild(
                createPage(totalPages, currentPage === totalPages, () => {
                    currentPage = totalPages;
                    update();
                })
            );
        }

        // Next
        paginationEl.appendChild(
            createButton("›", currentPage === totalPages, () => {
                currentPage++;
                update();
            })
        );
    }

    function update() {
        const filtered = getFilteredRows();
        const totalItems = filtered.length;
        const totalPages = Math.max(1, Math.ceil(totalItems / pageSize));

        // Ajusta currentPage si quedó fuera (ej: al filtrar)
        if (currentPage > totalPages) currentPage = totalPages;
        if (currentPage < 1) currentPage = 1;

        const startIndex = (currentPage - 1) * pageSize;
        const endIndex = Math.min(startIndex + pageSize, totalItems);

        const pageRows = filtered.slice(startIndex, endIndex);
        setRowVisibility(pageRows);

        // Info
        const startItem = totalItems === 0 ? 0 : startIndex + 1;
        const endItem = totalItems === 0 ? 0 : endIndex;
        renderInfo(totalItems, startItem, endItem);

        // Paginación
        renderPagination(totalPages);
    }

    // Eventos
    searchInput.addEventListener("input", () => {
        currentPage = 1;
        update();
    });

    estadoFilter.addEventListener("change", () => {
        currentPage = 1;
        update();
    });

    // Init
    update();
})();
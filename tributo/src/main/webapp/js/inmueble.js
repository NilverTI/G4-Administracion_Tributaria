class InmuebleTablePager {
    constructor() {
        this.tableBody = document.getElementById("tableBody");
        this.searchInput = document.getElementById("tableSearch");
        this.estadoFilter = document.getElementById("estadoFilter");
        this.pageSizeSelect = document.getElementById("pageSizeSelect");
        this.pagination = document.getElementById("paginationControls");

        if (!this.tableBody || !this.pagination || !this.pageSizeSelect) {
            return;
        }

        this.rows = Array.from(this.tableBody.querySelectorAll("tr"));
        this.currentPage = 1;
        this.pageSize = parseInt(this.pageSizeSelect.value, 10) || 5;
        this.filteredRows = [...this.rows];

        this.bindEvents();
        this.refresh();
    }

    bindEvents() {
        if (this.searchInput) {
            this.searchInput.addEventListener("input", () => {
                this.currentPage = 1;
                this.refresh();
            });
        }

        if (this.estadoFilter) {
            this.estadoFilter.addEventListener("change", () => {
                this.currentPage = 1;
                this.refresh();
            });
        }

        this.pageSizeSelect.addEventListener("change", () => {
            this.pageSize = parseInt(this.pageSizeSelect.value, 10) || 5;
            this.currentPage = 1;
            this.refresh();
        });
    }

    normalize(text) {
        if (typeof window.normalizePaginationText === "function") {
            return window.normalizePaginationText(text);
        }

        return (text || "")
            .toString()
            .toLowerCase()
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "");
    }

    paginationItems(totalPages) {
        if (typeof window.buildPaginationItems === "function") {
            return window.buildPaginationItems(totalPages, this.currentPage);
        }

        if (totalPages <= 5) {
            return Array.from({ length: totalPages }, (_, index) => index + 1);
        }

        if (this.currentPage <= 3) {
            return [1, 2, 3, 4, "...", totalPages];
        }

        if (this.currentPage >= totalPages - 2) {
            return [1, "...", totalPages - 3, totalPages - 2, totalPages - 1, totalPages];
        }

        return [1, "...", this.currentPage - 1, this.currentPage, this.currentPage + 1, "...", totalPages];
    }

    applyFilters() {
        const search = this.normalize(this.searchInput ? this.searchInput.value : "");
        const estado = (this.estadoFilter ? this.estadoFilter.value : "").toUpperCase();

        this.filteredRows = this.rows.filter(row => {
            const rowText = this.normalize(row.textContent);
            const rowEstado = (row.dataset.estado || "").toUpperCase();

            const matchSearch = !search || rowText.includes(search);
            const matchEstado = !estado || rowEstado === estado;

            return matchSearch && matchEstado;
        });
    }

    totalPages() {
        return Math.max(1, Math.ceil(this.filteredRows.length / this.pageSize));
    }

    clampCurrentPage() {
        const max = this.totalPages();

        if (this.currentPage < 1) {
            this.currentPage = 1;
        }

        if (this.currentPage > max) {
            this.currentPage = max;
        }
    }

    renderRows() {
        this.rows.forEach(row => {
            row.style.display = "none";
        });

        const start = (this.currentPage - 1) * this.pageSize;
        const end = start + this.pageSize;

        this.filteredRows.slice(start, end).forEach(row => {
            row.style.display = "";
        });
    }

    createButton(label, options = {}) {
        const button = document.createElement("button");
        button.type = "button";
        button.className = "pager-btn";
        button.textContent = label;

        if (options.variant) {
            button.classList.add(options.variant);
        }

        if (options.active) {
            button.classList.add("active");
        }

        if (options.disabled) {
            button.classList.add("disabled");
            button.disabled = true;
        } else if (typeof options.onClick === "function") {
            button.addEventListener("click", options.onClick);
        }

        return button;
    }

    createEllipsis() {
        const ellipsis = document.createElement("span");
        ellipsis.className = "pager-ellipsis";
        ellipsis.textContent = "...";
        return ellipsis;
    }

    appendPageButton(page) {
        this.pagination.appendChild(this.createButton(String(page), {
            variant: "pager-page",
            active: page === this.currentPage,
            onClick: () => {
                this.currentPage = page;
                this.refresh(false);
            }
        }));
    }

    renderPagination() {
        const total = this.totalPages();
        const items = this.paginationItems(total);

        this.pagination.innerHTML = "";

        this.pagination.appendChild(this.createButton("\u2039", {
            variant: "pager-arrow",
            disabled: this.currentPage === 1,
            onClick: () => {
                this.currentPage -= 1;
                this.refresh(false);
            }
        }));

        items.forEach(item => {
            if (item === "...") {
                this.pagination.appendChild(this.createEllipsis());
                return;
            }

            this.appendPageButton(item);
        });

        this.pagination.appendChild(this.createButton("\u203A", {
            variant: "pager-arrow",
            disabled: this.currentPage === total,
            onClick: () => {
                this.currentPage += 1;
                this.refresh(false);
            }
        }));
    }

    refresh(applyFilters = true) {
        if (applyFilters) {
            this.applyFilters();
        }

        this.clampCurrentPage();
        this.renderRows();
        this.renderPagination();
    }
}

function initTableBehavior() {
    new InmuebleTablePager();
}

function initModalBehavior() {
    const modal = document.getElementById("modalOverlay");
    const btnNuevo = document.getElementById("btnNuevo");
    const btnClose = document.getElementById("modalClose");
    const btnCancel = document.getElementById("modalCancel");

    if (!modal || !btnNuevo || !btnClose || !btnCancel) {
        return;
    }

    function openModal() {
        modal.classList.add("open");
    }

    function closeModal() {
        modal.classList.remove("open");
        const form = modal.querySelector("form");
        if (form) {
            form.reset();
        }
        syncTipoUsoFields();
    }

    btnNuevo.addEventListener("click", openModal);
    btnClose.addEventListener("click", closeModal);
    btnCancel.addEventListener("click", closeModal);

    modal.addEventListener("click", function (e) {
        if (e.target === modal) {
            closeModal();
        }
    });
}

function syncTipoUsoFields() {
    const tipoUsoChecked = document.querySelector("input[name='tipoUso']:checked");
    const construidoFields = document.getElementById("construidoFields");
    const areaConstruidaInput = document.getElementById("areaConstruidaInput");
    const tipoMaterialSelect = document.getElementById("tipoMaterialSelect");

    if (!tipoUsoChecked || !construidoFields || !areaConstruidaInput || !tipoMaterialSelect) {
        return;
    }

    const esConstruido = tipoUsoChecked.value === "CONSTRUIDO";
    construidoFields.classList.toggle("hidden", !esConstruido);
    areaConstruidaInput.required = esConstruido;
    tipoMaterialSelect.required = esConstruido;

    if (!esConstruido) {
        areaConstruidaInput.value = "";
        tipoMaterialSelect.value = "";
    }
}

function initTipoUsoBehavior() {
    const radios = document.querySelectorAll("input[name='tipoUso']");
    if (!radios.length) {
        return;
    }

    radios.forEach(function (radio) {
        radio.addEventListener("change", syncTipoUsoFields);
    });

    syncTipoUsoFields();
    setTimeout(syncTipoUsoFields, 0);
}

document.addEventListener("DOMContentLoaded", function () {
    initTableBehavior();
    initModalBehavior();
    initTipoUsoBehavior();
});

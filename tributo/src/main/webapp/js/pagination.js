const DEFAULT_PER_PAGE = 6;

function normalizePaginationText(value) {
    return (value || "")
        .toString()
        .toLowerCase()
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "");
}

function buildPaginationItems(totalPages, currentPage) {
    if (totalPages <= 5) {
        return Array.from({ length: totalPages }, function (_, index) {
            return index + 1;
        });
    }

    if (currentPage <= 3) {
        return [1, 2, 3, 4, "...", totalPages];
    }

    if (currentPage >= totalPages - 2) {
        return [1, "...", totalPages - 3, totalPages - 2, totalPages - 1, totalPages];
    }

    return [1, "...", currentPage - 1, currentPage, currentPage + 1, "...", totalPages];
}

function createSharedButton(label, options) {
    const button = document.createElement("button");
    const settings = options || {};

    button.type = "button";
    button.className = "page-btn" + (settings.variant ? " " + settings.variant : "");
    button.textContent = label;

    if (settings.active) {
        button.classList.add("active");
    }

    if (settings.disabled) {
        button.classList.add("disabled");
        button.disabled = true;
    } else if (typeof settings.onClick === "function") {
        button.addEventListener("click", settings.onClick);
    }

    return button;
}

function createSharedEllipsis() {
    const ellipsis = document.createElement("span");
    ellipsis.className = "page-ellipsis";
    ellipsis.textContent = "...";
    return ellipsis;
}

function renderSharedPagination(container, totalPages, currentPage, perPage, onChange, onPageSizeChange) {
    if (!container) {
        return;
    }

    container.innerHTML = "";
    container.className = "pagination";

    const safeTotalPages = Math.max(1, totalPages);
    const left = document.createElement("div");
    left.className = "pagination-left";

    const label = document.createElement("label");
    label.textContent = "Mostrar";

    const select = document.createElement("select");
    select.className = "page-size-select";

    [5, 10, 25].forEach(function (size) {
        const option = document.createElement("option");
        option.value = String(size);
        option.textContent = String(size);
        option.selected = size === perPage;
        select.appendChild(option);
    });

    if (typeof onPageSizeChange === "function") {
        select.addEventListener("change", function () {
            onPageSizeChange(parseInt(select.value, 10) || 5);
        });
    }

    left.appendChild(label);
    left.appendChild(select);
    container.appendChild(left);

    const controls = document.createElement("div");
    controls.className = "pagination-controls pagination-right";

    controls.appendChild(
        createSharedButton("\u2039", {
            variant: "page-arrow",
            disabled: currentPage <= 1,
            onClick: function () {
                onChange(currentPage - 1);
            }
        })
    );

    buildPaginationItems(safeTotalPages, currentPage).forEach(function (item) {
        if (item === "...") {
            controls.appendChild(createSharedEllipsis());
            return;
        }

        controls.appendChild(
            createSharedButton(String(item), {
                active: item === currentPage,
                onClick: function () {
                    onChange(item);
                }
            })
        );
    });

    controls.appendChild(
        createSharedButton("\u203A", {
            variant: "page-arrow",
            disabled: currentPage >= safeTotalPages,
            onClick: function () {
                onChange(currentPage + 1);
            }
        })
    );

    container.appendChild(controls);
}

function createCollectionController(config) {
    const items = Array.from(document.querySelectorAll(config.itemSelector || ""));
    const pagination = document.querySelector(config.paginationSelector || "");
    const searchInput = config.searchInputSelector
        ? document.querySelector(config.searchInputSelector)
        : null;
    const state = {
        currentPage: 1,
        perPage: config.perPage || DEFAULT_PER_PAGE
    };

    function matchesSearch(item) {
        const query = normalizePaginationText(searchInput ? searchInput.value : "");
        if (!query) {
            return true;
        }

        const text = normalizePaginationText(
            typeof config.getSearchText === "function"
                ? config.getSearchText(item)
                : item.textContent
        );

        return text.includes(query);
    }

    function matchesFilters(item) {
        if (!Array.isArray(config.filters) || !config.filters.length) {
            return true;
        }

        return config.filters.every(function (filterFn) {
            return filterFn(item);
        });
    }

    function setVisible(item, visible) {
        item.style.display = visible ? "" : "none";
    }

    function refresh(resetPage) {
        if (!items.length) {
            if (pagination) {
                pagination.innerHTML = "";
                pagination.classList.remove("pagination");
            }
            return;
        }

        if (resetPage) {
            state.currentPage = 1;
        }

        const filtered = items.filter(function (item) {
            return matchesSearch(item) && matchesFilters(item);
        });

        const totalPages = Math.max(1, Math.ceil(filtered.length / state.perPage));

        if (state.currentPage > totalPages) {
            state.currentPage = totalPages;
        }

        if (state.currentPage < 1) {
            state.currentPage = 1;
        }

        const start = (state.currentPage - 1) * state.perPage;
        const end = start + state.perPage;
        const pageItems = filtered.slice(start, end);

        items.forEach(function (item) {
            setVisible(item, false);
        });

        pageItems.forEach(function (item) {
            setVisible(item, true);
        });

        renderSharedPagination(
            pagination,
            totalPages,
            state.currentPage,
            state.perPage,
            function (page) {
                state.currentPage = page;
                refresh(false);
            },
            function (size) {
                state.perPage = size;
                state.currentPage = 1;
                refresh(false);
            }
        );
    }

    if (searchInput) {
        searchInput.addEventListener("input", function () {
            refresh(true);
        });
    }

    if (Array.isArray(config.resetOnSelectors)) {
        config.resetOnSelectors.forEach(function (selector) {
            const element = document.querySelector(selector);
            if (!element) {
                return;
            }

            element.addEventListener("change", function () {
                refresh(true);
            });
        });
    }

    refresh(false);

    return {
        refresh: refresh
    };
}

(function () {
    const paginationApi = {
        createTableController: function (config) {
            return createCollectionController(config);
        },
        createCardController: function (config) {
            return createCollectionController(config);
        },
        renderPagination: renderSharedPagination
    };

    window.PaginationTools = paginationApi;
    window.ListingTools = paginationApi;
})();

class ContribuyenteTablePager {
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
        this.initModal();
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

    applyFilters() {
        const search = normalizePaginationText(this.searchInput ? this.searchInput.value : "");
        const estado = (this.estadoFilter ? this.estadoFilter.value : "").toUpperCase();

        this.filteredRows = this.rows.filter(row => {
            const rowText = normalizePaginationText(row.textContent);
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
        const items = buildPaginationItems(total, this.currentPage);

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

    initModal() {
        const modal = document.getElementById("modalOverlay");
        const btnNuevo = document.getElementById("btnNuevo");
        const btnClose = document.getElementById("modalClose");
        const btnCancel = document.getElementById("modalCancel");

        if (!modal || !btnNuevo || !btnClose || !btnCancel) {
            return;
        }

        const closeModal = () => {
            modal.classList.remove("open");
            const form = modal.querySelector("form");
            if (form) {
                form.reset();
            }
        };

        btnNuevo.addEventListener("click", () => {
            modal.classList.add("open");
        });

        btnClose.addEventListener("click", closeModal);
        btnCancel.addEventListener("click", closeModal);

        modal.addEventListener("click", e => {
            if (e.target === modal) {
                closeModal();
            }
        });
    }
}

document.addEventListener("DOMContentLoaded", function () {
    new ContribuyenteTablePager();
});

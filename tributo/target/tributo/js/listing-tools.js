(function () {
    const DEFAULT_PER_PAGE = 6;

    function normalizeText(value) {
        return (value || "")
            .toString()
            .toLowerCase()
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "");
    }

    function buildPageItems(totalPages, currentPage) {
        if (totalPages <= 5) {
            return Array.from({ length: totalPages }, (_, index) => index + 1);
        }

        const items = [1];
        const start = Math.max(2, currentPage - 1);
        const end = Math.min(totalPages - 1, currentPage + 1);

        if (start > 2) {
            items.push("...");
        }

        for (let page = start; page <= end; page++) {
            items.push(page);
        }

        if (end < totalPages - 1) {
            items.push("...");
        }

        items.push(totalPages);
        return items;
    }

    function createArrow(label, disabled, onClick) {
        const button = document.createElement("button");
        button.type = "button";
        button.className = "page-btn page-arrow" + (disabled ? " disabled" : "");
        button.innerHTML = label;
        button.disabled = disabled;
        if (!disabled) {
            button.addEventListener("click", onClick);
        }
        return button;
    }

    function renderPagination(container, totalPages, currentPage, pageCount, totalCount, onChange) {
        if (!container) {
            return;
        }

        container.innerHTML = "";
        container.classList.add("pagination");

        if (totalPages <= 0) {
            return;
        }

        const info = document.createElement("div");
        info.className = "pagination-info";

        const infoMain = document.createElement("div");
        infoMain.className = "pagination-main";
        infoMain.textContent = "Mostrando " + pageCount + " de " + totalCount + " registros";

        const infoSub = document.createElement("div");
        infoSub.className = "pagination-sub";
        infoSub.textContent = "Pagina " + currentPage + " de " + totalPages;

        info.appendChild(infoMain);
        info.appendChild(infoSub);
        container.appendChild(info);

        const controls = document.createElement("div");
        controls.className = "pagination-controls";

        controls.appendChild(
            createArrow("&lsaquo;", currentPage <= 1, function () {
                onChange(currentPage - 1);
            })
        );

        buildPageItems(totalPages, currentPage).forEach(function (item) {
            if (item === "...") {
                const span = document.createElement("span");
                span.className = "page-ellipsis";
                span.textContent = "...";
                controls.appendChild(span);
                return;
            }

            const button = document.createElement("button");
            button.type = "button";
            button.className = "page-btn" + (item === currentPage ? " active" : "");
            button.textContent = item;
            button.addEventListener("click", function () {
                onChange(item);
            });
            controls.appendChild(button);
        });

        controls.appendChild(
            createArrow("&rsaquo;", currentPage >= totalPages, function () {
                onChange(currentPage + 1);
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
            const query = normalizeText(searchInput ? searchInput.value : "");
            if (!query) {
                return true;
            }

            const text = normalizeText(
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

            const start = (state.currentPage - 1) * state.perPage;
            const end = start + state.perPage;
            const pageCount = Math.max(0, Math.min(end, filtered.length) - start);

            items.forEach(function (item) {
                setVisible(item, false);
            });

            filtered.forEach(function (item, index) {
                setVisible(item, index >= start && index < end);
            });

            renderPagination(pagination, totalPages, state.currentPage, pageCount, filtered.length, function (page) {
                state.currentPage = page;
                refresh(false);
            });
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

    window.ListingTools = {
        createTableController: function (config) {
            return createCollectionController(config);
        },
        createCardController: function (config) {
            return createCollectionController(config);
        }
    };
})();

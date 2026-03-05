function normalizeContribuyentePickerText(value) {
    return (value || "")
        .toString()
        .trim()
        .toLowerCase()
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "");
}

function initContribuyentePickers() {
    const pickers = document.querySelectorAll("[data-contribuyente-picker]");

    pickers.forEach(function (picker) {
        const hiddenInput = picker.querySelector("[data-contribuyente-id]");
        const visibleInput = picker.querySelector("[data-contribuyente-input]");
        const datalist = picker.querySelector("datalist");

        if (!hiddenInput || !visibleInput || !datalist) {
            return;
        }

        const options = Array.from(datalist.querySelectorAll("option")).map(function (option, index) {
            return {
                id: option.dataset.id || "",
                label: option.value || "",
                normalized: normalizeContribuyentePickerText(option.value || ""),
                searchText: normalizeContribuyentePickerText(option.dataset.search || option.value || ""),
                key: (option.dataset.id || "") + "::" + (option.value || "") + "::" + index
            };
        });
        const form = visibleInput.form;
        const menu = document.createElement("div");
        let closeTimer = null;

        visibleInput.removeAttribute("list");
        datalist.hidden = true;

        menu.className = "contribuyente-picker__menu";
        picker.insertBefore(menu, datalist);

        function clearCloseTimer() {
            if (closeTimer) {
                window.clearTimeout(closeTimer);
                closeTimer = null;
            }
        }

        function closeMenu() {
            clearCloseTimer();
            menu.classList.remove("is-open");
            menu.innerHTML = "";
        }

        function getMatches() {
            const query = normalizeContribuyentePickerText(visibleInput.value);
            const base = !query
                ? options
                : options.filter(function (option) {
                    return option.searchText.includes(query);
                });

            return base.slice(0, 8);
        }

        function selectOption(option) {
            visibleInput.value = option.label;
            hiddenInput.value = option.id;
            visibleInput.setCustomValidity("");
            closeMenu();
        }

        function renderMenu() {
            const matches = getMatches();

            if (!matches.length) {
                closeMenu();
                return;
            }

            menu.innerHTML = "";

            matches.forEach(function (option) {
                const item = document.createElement("button");
                item.type = "button";
                item.className = "contribuyente-picker__option";
                item.textContent = option.label;
                item.dataset.key = option.key;

                item.addEventListener("mousedown", function (event) {
                    event.preventDefault();
                    selectOption(option);
                });

                menu.appendChild(item);
            });

            menu.classList.add("is-open");
        }

        function syncHiddenValue() {
            const typedValue = normalizeContribuyentePickerText(visibleInput.value);
            if (!typedValue) {
                hiddenInput.value = "";
                visibleInput.setCustomValidity("");
                return false;
            }

            const matchedOption = options.find(function (option) {
                return option.normalized === typedValue;
            });

            hiddenInput.value = matchedOption ? matchedOption.id : "";
            visibleInput.setCustomValidity(matchedOption ? "" : "Seleccione un contribuyente valido de la lista.");
            return Boolean(matchedOption);
        }

        visibleInput.addEventListener("focus", function () {
            clearCloseTimer();
            renderMenu();
        });

        visibleInput.addEventListener("input", function () {
            syncHiddenValue();
            renderMenu();
        });

        visibleInput.addEventListener("change", function () {
            const matched = syncHiddenValue();
            if (matched) {
                closeMenu();
            } else {
                renderMenu();
            }
        });

        visibleInput.addEventListener("blur", function () {
            syncHiddenValue();
            clearCloseTimer();
            closeTimer = window.setTimeout(closeMenu, 150);
        });

        if (form) {
            form.addEventListener("submit", function (event) {
                const matched = syncHiddenValue();

                if (!hiddenInput.value) {
                    if (!matched) {
                        renderMenu();
                    }
                    event.preventDefault();
                    visibleInput.reportValidity();
                    visibleInput.focus();
                }
            });

            form.addEventListener("reset", function () {
                setTimeout(syncHiddenValue, 0);
            });
        }

        picker.addEventListener("mousedown", function () {
            clearCloseTimer();
        });

        document.addEventListener("click", function (event) {
            if (!picker.contains(event.target)) {
                closeMenu();
            }
        });

        syncHiddenValue();
    });
}

document.addEventListener("DOMContentLoaded", initContribuyentePickers);

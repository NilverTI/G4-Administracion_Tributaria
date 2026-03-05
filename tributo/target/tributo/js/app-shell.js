document.addEventListener("DOMContentLoaded", function () {
    const body = document.body;
    const toggleButtons = document.querySelectorAll(".sidebar-toggle");
    const collapseKey = "sat-sidebar-collapsed";

    function setCollapsed(collapsed) {
        body.classList.toggle("sidebar-collapsed", collapsed);
        try {
            localStorage.setItem(collapseKey, collapsed ? "1" : "0");
        } catch (e) {
            // ignore storage failures
        }
    }

    function readCollapsed() {
        try {
            return localStorage.getItem(collapseKey) === "1";
        } catch (e) {
            return false;
        }
    }

    if (toggleButtons.length) {
        setCollapsed(readCollapsed());

        toggleButtons.forEach(function (button) {
            button.addEventListener("click", function () {
                setCollapsed(!body.classList.contains("sidebar-collapsed"));
            });
        });
    }
});

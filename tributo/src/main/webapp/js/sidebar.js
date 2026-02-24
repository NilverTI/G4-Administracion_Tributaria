// /js/sidebar.js
(() => {
  function initSidebar() {
    const sidebar = document.querySelector(".sidebar");
    const main = document.querySelector(".main");
    const toggleBtn = document.querySelector(".sidebar-toggle");

    if (!sidebar || !main || !toggleBtn) return;

    // Restaurar estado
    const saved = localStorage.getItem("sidebar_collapsed");
    if (saved === "1") {
      sidebar.classList.add("collapsed");
      main.classList.add("sidebar-collapsed");
    }

    // Evitar que se agreguen listeners duplicados
    if (toggleBtn.dataset.bound === "1") return;
    toggleBtn.dataset.bound = "1";

    toggleBtn.addEventListener("click", (e) => {
      e.preventDefault();
      e.stopPropagation();

      sidebar.classList.toggle("collapsed");
      main.classList.toggle("sidebar-collapsed");

      localStorage.setItem(
        "sidebar_collapsed",
        sidebar.classList.contains("collapsed") ? "1" : "0"
      );
    });
  }

  // ✅ Esto asegura que funcione aunque el script cargue antes o después del sidebar
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initSidebar);
  } else {
    initSidebar();
  }
})();
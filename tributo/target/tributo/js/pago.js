
document.addEventListener("DOMContentLoaded", () => {

    const modal = document.getElementById("modalPago");
    const btn = document.getElementById("btnNuevoPago");
    const close = document.getElementById("modalClosePago");
    const cancel = document.getElementById("modalCancelPago");

    function openModal() {
        modal.classList.add("open");
    }

    function closeModal() {
        modal.classList.remove("open");
    }

    btn?.addEventListener("click", openModal);
    close?.addEventListener("click", closeModal);
    cancel?.addEventListener("click", closeModal);

});
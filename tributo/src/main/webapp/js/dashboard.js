document.addEventListener("DOMContentLoaded", () => {

    /* =========================
       FILTER BUTTONS
    ========================== */
    const filterButtons = document.querySelectorAll(".filter-btn");
    filterButtons.forEach(btn => {
        btn.addEventListener("click", () => {
            filterButtons.forEach(b => b.classList.remove("active"));
            btn.classList.add("active");
        });
    });

    /* =========================
       CHART.JS
    ========================== */
    const chartElement = document.getElementById("recaudacionChart");

    if (chartElement && window.Chart) {
        const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
            'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];

        const predial = [45000, 38000, 50000, 29000, 40000, 32000,
            46000, 29000, 42000, 40000, 47000, 58000];

        const vehicular = [12000, 18000, 17000, 9000, 22000, 16000,
            10000, 8000, 14000, 16000, 14000, 25000];

        const alcabala = [8000, 5000, 6000, 4000, 14000, 7000,
            5000, 4000, 5000, 6000, 9000, 14000];

        const ctx = chartElement.getContext("2d");

        new Chart(ctx, {
            type: "bar",
            data: {
                labels: months,
                datasets: [
                    { label: "Predial", data: predial, backgroundColor: "#0f1f3d", borderRadius: 4, borderSkipped: false },
                    { label: "Vehicular", data: vehicular, backgroundColor: "#38bdf8", borderRadius: 4, borderSkipped: false },
                    { label: "Alcabala", data: alcabala, backgroundColor: "#10b981", borderRadius: 4, borderSkipped: false }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: (context) => ` S/ ${context.parsed.y.toLocaleString("es-PE")}`
                        }
                    }
                },
                scales: {
                    x: { grid: { display: false }, ticks: { font: { family: "Sora", size: 12 }, color: "#64748b" } },
                    y: {
                        grid: { color: "#f1f5f9" },
                        ticks: { font: { family: "Sora", size: 12 }, color: "#64748b", callback: (v) => `S/ ${v}` }
                    }
                }
            }
        });
    }

});
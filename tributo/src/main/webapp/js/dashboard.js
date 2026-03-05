document.addEventListener("DOMContentLoaded", function () {

    const navItems = document.querySelectorAll(".nav-item");

    navItems.forEach(item => {
        item.addEventListener("click", function () {
            navItems.forEach(i => i.classList.remove("active"));
            this.classList.add("active");
        });
    });

    const filterButtons = document.querySelectorAll(".filter-btn");

    filterButtons.forEach(btn => {
        btn.addEventListener("click", function () {
            filterButtons.forEach(b => b.classList.remove("active"));
            this.classList.add("active");
        });
    });

    const chartElement = document.getElementById("recaudacionChart");

    const parseLabels = (value) =>
        (value || "")
            .split(",")
            .map(item => item.trim())
            .filter(Boolean);

    const parseNumbers = (value) =>
        (value || "")
            .split(",")
            .map(item => Number(item.trim()))
            .map(item => Number.isFinite(item) ? item : 0);

    if (chartElement) {
        const months = parseLabels(chartElement.dataset.labels);
        const predial = parseNumbers(chartElement.dataset.predial);
        const vehicular = parseNumbers(chartElement.dataset.vehicular);
        const alcabala = parseNumbers(chartElement.dataset.alcabala);

        const ctx = chartElement.getContext("2d");

        new Chart(ctx, {
            type: "bar",
            data: {
                labels: months,
                datasets: [
                    {
                        label: "Predial",
                        data: predial,
                        backgroundColor: "#0f1f3d",
                        borderRadius: 4,
                        borderSkipped: false
                    },
                    {
                        label: "Vehicular",
                        data: vehicular,
                        backgroundColor: "#38bdf8",
                        borderRadius: 4,
                        borderSkipped: false
                    },
                    {
                        label: "Alcabala",
                        data: alcabala,
                        backgroundColor: "#10b981",
                        borderRadius: 4,
                        borderSkipped: false
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: context =>
                                ` S/ ${context.parsed.y.toLocaleString("es-PE")}`
                        }
                    }
                },
                scales: {
                    x: {
                        grid: { display: false },
                        ticks: {
                            font: { family: "Sora", size: 12 },
                            color: "#64748b"
                        }
                    },
                    y: {
                        grid: { color: "#f1f5f9" },
                        ticks: {
                            font: { family: "Sora", size: 12 },
                            color: "#64748b",
                            callback: value => `S/ ${value}`
                        }
                    }
                }
            }
        });
    }

});

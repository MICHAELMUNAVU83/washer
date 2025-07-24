// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

let Hooks = {};

Hooks.DashboardCharts = {
  mounted() {
    this.initializeCharts();
  },

  updated() {
    this.destroyCharts();
    this.initializeCharts();
  },

  destroyed() {
    this.destroyCharts();
  },

  initializeCharts() {
    const chartData = document.getElementById("chart-data");
    if (!chartData) return;

    try {
      const revenueData = JSON.parse(chartData.dataset.revenue);
      const servicesData = JSON.parse(chartData.dataset.services);
      const paymentData = JSON.parse(chartData.dataset.payment);

      this.createRevenueChart(revenueData);
      this.createServicesChart(servicesData);
      this.createPaymentChart(paymentData);
    } catch (error) {
      console.error("Error initializing charts:", error);
    }
  },

  destroyCharts() {
    if (this.revenueChart) {
      this.revenueChart.destroy();
      this.revenueChart = null;
    }
    if (this.servicesChart) {
      this.servicesChart.destroy();
      this.servicesChart = null;
    }
    if (this.paymentChart) {
      this.paymentChart.destroy();
      this.paymentChart = null;
    }
  },

  createRevenueChart(data) {
    const ctx = document.getElementById("revenue-chart");
    if (!ctx) return;

    this.revenueChart = new Chart(ctx, {
      type: "line",
      data: {
        labels: data.map((item) => item.date),
        datasets: [
          {
            label: "Daily Revenue",
            data: data.map((item) => item.revenue),
            borderColor: "#DC2626",
            backgroundColor: "rgba(220, 38, 38, 0.1)",
            borderWidth: 3,
            fill: true,
            tension: 0.4,
            pointBackgroundColor: "#DC2626",
            pointBorderColor: "#FFFFFF",
            pointBorderWidth: 2,
            pointRadius: 6,
            pointHoverRadius: 8,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false,
          },
          tooltip: {
            mode: "index",
            intersect: false,
            backgroundColor: "rgba(0, 0, 0, 0.8)",
            titleColor: "#FFFFFF",
            bodyColor: "#FFFFFF",
            borderColor: "#DC2626",
            borderWidth: 1,
            callbacks: {
              label: function (context) {
                return "Revenue: $" + context.parsed.y.toFixed(2);
              },
            },
          },
        },
        scales: {
          x: {
            display: true,
            grid: {
              color: "rgba(0, 0, 0, 0.1)",
            },
            ticks: {
              color: "#6B7280",
            },
          },
          y: {
            display: true,
            grid: {
              color: "rgba(0, 0, 0, 0.1)",
            },
            ticks: {
              color: "#6B7280",
              callback: function (value) {
                return "$" + value.toFixed(0);
              },
            },
          },
        },
        interaction: {
          mode: "nearest",
          axis: "x",
          intersect: false,
        },
      },
    });
  },

  createServicesChart(data) {
    const ctx = document.getElementById("services-chart");
    if (!ctx) return;

    // Generate colors for each service type
    const colors = [
      "#DC2626",
      "#EF4444",
      "#F87171",
      "#FCA5A5",
      "#FECACA",
      "#FEE2E2",
      "#991B1B",
      "#7F1D1D",
    ];

    this.servicesChart = new Chart(ctx, {
      type: "doughnut",
      data: {
        labels: data.map((item) => item.service_type),
        datasets: [
          {
            data: data.map((item) => item.count),
            backgroundColor: colors.slice(0, data.length),
            borderColor: "#FFFFFF",
            borderWidth: 2,
            hoverBorderWidth: 3,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: "bottom",
            labels: {
              padding: 20,
              color: "#374151",
              font: {
                size: 12,
              },
            },
          },
          tooltip: {
            backgroundColor: "rgba(0, 0, 0, 0.8)",
            titleColor: "#FFFFFF",
            bodyColor: "#FFFFFF",
            borderColor: "#DC2626",
            borderWidth: 1,
            callbacks: {
              label: function (context) {
                const total = context.dataset.data.reduce((a, b) => a + b, 0);
                const percentage = ((context.parsed / total) * 100).toFixed(1);
                return (
                  context.label +
                  ": " +
                  context.parsed +
                  " (" +
                  percentage +
                  "%)"
                );
              },
            },
          },
        },
        cutout: "60%",
      },
    });
  },

  createPaymentChart(data) {
    const ctx = document.getElementById("payment-chart");
    if (!ctx) return;

    this.paymentChart = new Chart(ctx, {
      type: "bar",
      data: {
        labels: data.map((item) => item.status),
        datasets: [
          {
            label: "Number of Services",
            data: data.map((item) => item.count),
            backgroundColor: ["#10B981", "#F59E0B"],
            borderColor: ["#059669", "#D97706"],
            borderWidth: 2,
            yAxisID: "y",
          },
          {
            label: "Amount ($)",
            data: data.map((item) => item.amount),
            backgroundColor: [
              "rgba(16, 185, 129, 0.3)",
              "rgba(245, 158, 11, 0.3)",
            ],
            borderColor: ["#10B981", "#F59E0B"],
            borderWidth: 2,
            type: "line",
            yAxisID: "y1",
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: {
          mode: "index",
          intersect: false,
        },
        plugins: {
          legend: {
            labels: {
              color: "#374151",
            },
          },
          tooltip: {
            backgroundColor: "rgba(0, 0, 0, 0.8)",
            titleColor: "#FFFFFF",
            bodyColor: "#FFFFFF",
            borderColor: "#DC2626",
            borderWidth: 1,
          },
        },
        scales: {
          x: {
            display: true,
            grid: {
              color: "rgba(0, 0, 0, 0.1)",
            },
            ticks: {
              color: "#6B7280",
            },
          },
          y: {
            type: "linear",
            display: true,
            position: "left",
            grid: {
              color: "rgba(0, 0, 0, 0.1)",
            },
            ticks: {
              color: "#6B7280",
            },
          },
          y1: {
            type: "linear",
            display: true,
            position: "right",
            grid: {
              drawOnChartArea: false,
            },
            ticks: {
              color: "#6B7280",
              callback: function (value) {
                return "$" + value.toFixed(0);
              },
            },
          },
        },
      },
    });
  },
};

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

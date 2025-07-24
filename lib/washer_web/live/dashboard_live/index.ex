defmodule WasherWeb.DashboardLive.Index do
  use WasherWeb, :system_live_view

  alias Washer.Analytics

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Dashboard")
      |> assign(:time_period, "7_days")
      |> assign(:current_page, "dashboard")
      |> assign(:loading, true)
      |> load_dashboard_data()

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("change_period", %{"period" => period}, socket) do
    {:noreply,
     socket
     |> assign(:time_period, period)
     |> assign(:loading, true)
     |> load_dashboard_data()}
  end

  @impl true
  def handle_event("refresh_data", _params, socket) do
    {:noreply,
     socket
     |> assign(:loading, true)
     |> load_dashboard_data()}
  end

  defp load_dashboard_data(socket) do
    time_period = socket.assigns.time_period
    date_range = get_date_range(time_period)

    # Load all dashboard data
    overview_stats = Analytics.get_overview_stats(date_range)
    branch_performance = Analytics.get_branch_performance(date_range)
    worker_performance = Analytics.get_top_workers(date_range, limit: 10)
    revenue_chart_data = Analytics.get_revenue_chart_data(date_range)
    services_chart_data = Analytics.get_services_chart_data(date_range)
    payment_status_data = Analytics.get_payment_status_data(date_range)

    socket
    |> assign(:loading, false)
    |> assign(:overview_stats, overview_stats)
    |> assign(:branch_performance, branch_performance)
    |> assign(:worker_performance, worker_performance)
    |> assign(:revenue_chart_data, revenue_chart_data)
    |> assign(:services_chart_data, services_chart_data)
    |> assign(:payment_status_data, payment_status_data)
    |> assign(:date_range, date_range)
  end

  defp get_date_range("7_days") do
    end_date = Date.utc_today()
    start_date = Date.add(end_date, -7)
    {start_date, end_date}
  end

  defp get_date_range("30_days") do
    end_date = Date.utc_today()
    start_date = Date.add(end_date, -30)
    {start_date, end_date}
  end

  defp get_date_range("90_days") do
    end_date = Date.utc_today()
    start_date = Date.add(end_date, -90)
    {start_date, end_date}
  end

  defp get_date_range("1_year") do
    end_date = Date.utc_today()
    start_date = Date.add(end_date, -365)
    {start_date, end_date}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6" id="dashboard-container" phx-hook="DashboardCharts">
      <!-- Header Section -->
      <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-4">
            <div class="bg-red-100 p-3 rounded-lg">
              <svg class="w-8 h-8 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
                />
              </svg>
            </div>
            <div>
              <h1 class="text-2xl font-bold text-gray-900">Dashboard</h1>
              <p class="text-gray-600 mt-1">Car wash management overview and analytics</p>
            </div>
          </div>
          <div class="flex items-center space-x-3">
            <!-- Time Period Selector -->
            <select
              phx-change="change_period"
              name="period"
              class="rounded-lg border-gray-300 text-sm focus:border-red-500 focus:ring-red-500"
            >
              <option value="7_days" selected={@time_period == "7_days"}>Last 7 Days</option>
              <option value="30_days" selected={@time_period == "30_days"}>Last 30 Days</option>
              <option value="90_days" selected={@time_period == "90_days"}>Last 90 Days</option>
              <option value="1_year" selected={@time_period == "1_year"}>Last Year</option>
            </select>
            
    <!-- Refresh Button -->
            <button
              phx-click="refresh_data"
              class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg font-medium transition-colors duration-200 flex items-center space-x-2"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
                />
              </svg>
              <span>Refresh</span>
            </button>
          </div>
        </div>
      </div>
      
    <!-- Loading State -->
      <div :if={@loading} class="text-center py-12">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-red-600 mx-auto"></div>
        <p class="text-gray-600 mt-4">Loading dashboard data...</p>
      </div>
      
    <!-- Dashboard Content -->
      <div :if={!@loading} class="space-y-6">
        <!-- Overview Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
          <!-- Total Revenue -->
          <div class="bg-gradient-to-r from-red-500 to-red-600 rounded-lg shadow-sm p-6 text-white">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-red-100 text-sm font-medium">Total Revenue</p>
                <p class="text-3xl font-bold">KES{@overview_stats.total_revenue}</p>
                <p class="text-red-100 text-sm">
                  {if @overview_stats.revenue_change >= 0, do: "+", else: ""}{@overview_stats.revenue_change}% vs previous period
                </p>
              </div>
              <div class="bg-red-400 bg-opacity-30 p-3 rounded-lg">
                <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"
                  />
                </svg>
              </div>
            </div>
          </div>
          
    <!-- Total Services -->
          <div class="bg-white border-2 border-red-200 rounded-lg shadow-sm p-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-gray-600 text-sm font-medium">Total Services</p>
                <p class="text-3xl font-bold text-gray-900">{@overview_stats.total_services}</p>
                <p class="text-gray-500 text-sm">
                  {if @overview_stats.services_change >= 0, do: "+", else: ""}{@overview_stats.services_change}% vs previous period
                </p>
              </div>
              <div class="bg-red-100 p-3 rounded-lg">
                <svg
                  class="w-8 h-8 text-red-600"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                  />
                </svg>
              </div>
            </div>
          </div>
          
    <!-- Active Customers -->
          <div class="bg-white border-2 border-red-200 rounded-lg shadow-sm p-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-gray-600 text-sm font-medium">Active Customers</p>
                <p class="text-3xl font-bold text-gray-900">{@overview_stats.active_customers}</p>
                <p class="text-gray-500 text-sm">Unique vehicles served</p>
              </div>
              <div class="bg-red-100 p-3 rounded-lg">
                <svg class="w-8 h-8 text-red-600" fill="currentColor" viewBox="0 0 20 20">
                  <path
                    fill-rule="evenodd"
                    d="M2 9.5A3.5 3.5 0 005.5 13H14.5a3.5 3.5 0 003.5-3.5A3.5 3.5 0 0014.5 6H5.5A3.5 3.5 0 002 9.5zM5.5 8a1.5 1.5 0 100 3 1.5 1.5 0 000-3zm9 0a1.5 1.5 0 100 3 1.5 1.5 0 000-3z"
                    clip-rule="evenodd"
                  />
                </svg>
              </div>
            </div>
          </div>
          
    <!-- Average Service Value -->
          <div class="bg-white border-2 border-red-200 rounded-lg shadow-sm p-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-gray-600 text-sm font-medium">Avg Service Value</p>
                <p class="text-3xl font-bold text-gray-900">KES{@overview_stats.avg_service_value}</p>
                <p class="text-gray-500 text-sm">Per service</p>
              </div>
              <div class="bg-red-100 p-3 rounded-lg">
                <svg
                  class="w-8 h-8 text-red-600"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"
                  />
                </svg>
              </div>
            </div>
          </div>
        </div>
        
    <!-- Charts Row -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <!-- Revenue Chart -->
          <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <div class="flex items-center justify-between mb-4">
              <h3 class="text-lg font-semibold text-gray-900">Revenue Over Time</h3>
              <div class="flex items-center space-x-2">
                <div class="w-3 h-3 bg-red-500 rounded-full"></div>
                <span class="text-sm text-gray-600">Daily Revenue</span>
              </div>
            </div>
            <div class="h-64">
              <canvas id="revenue-chart" width="400" height="200"></canvas>
            </div>
          </div>
          
    <!-- Services Chart -->
          <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <div class="flex items-center justify-between mb-4">
              <h3 class="text-lg font-semibold text-gray-900">Services Distribution</h3>
              <div class="flex items-center space-x-2">
                <div class="w-3 h-3 bg-red-500 rounded-full"></div>
                <span class="text-sm text-gray-600">Service Types</span>
              </div>
            </div>
            <div class="h-64">
              <canvas id="services-chart" width="400" height="200"></canvas>
            </div>
          </div>
        </div>
        
    <!-- Branch Performance -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200">
          <div class="px-6 py-4 border-b border-gray-200">
            <div class="flex items-center justify-between">
              <div class="flex items-center space-x-3">
                <svg class="w-6 h-6 text-red-600" fill="currentColor" viewBox="0 0 20 20">
                  <path
                    fill-rule="evenodd"
                    d="M4 4a2 2 0 00-2 2v8a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2H4zm2 6a2 2 0 114 0 2 2 0 01-4 0zm8 0a2 2 0 114 0 2 2 0 01-4 0z"
                    clip-rule="evenodd"
                  />
                </svg>
                <h2 class="text-lg font-semibold text-gray-900">Branch Performance</h2>
              </div>
              <.link
                navigate={~p"/branches"}
                class="text-red-600 hover:text-red-800 text-sm font-medium"
              >
                View All Branches →
              </.link>
            </div>
          </div>

          <div class="p-6">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              <div :for={branch <- @branch_performance} class="bg-gray-50 rounded-lg p-4">
                <div class="flex items-center justify-between mb-3">
                  <div class="flex items-center space-x-3">
                    <div class="bg-red-100 p-2 rounded-lg">
                      <svg class="w-5 h-5 text-red-600" fill="currentColor" viewBox="0 0 20 20">
                        <path
                          fill-rule="evenodd"
                          d="M4 4a2 2 0 00-2 2v8a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2H4zm2 6a2 2 0 114 0 2 2 0 01-4 0zm8 0a2 2 0 114 0 2 2 0 01-4 0z"
                          clip-rule="evenodd"
                        />
                      </svg>
                    </div>
                    <div>
                      <h4 class="font-semibold text-gray-900">{branch.name}</h4>
                      <p class="text-sm text-gray-600">{branch.location}</p>
                    </div>
                  </div>
                  <.link navigate={~p"/branches/#{branch.id}"} class="text-red-600 hover:text-red-800">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
                      />
                    </svg>
                  </.link>
                </div>

                <div class="space-y-2">
                  <div class="flex justify-between">
                    <span class="text-sm text-gray-600">Revenue:</span>
                    <span class="font-semibold text-gray-900">KES{branch.revenue}</span>
                  </div>
                  <div class="flex justify-between">
                    <span class="text-sm text-gray-600">Services:</span>
                    <span class="font-semibold text-gray-900">{branch.services_count}</span>
                  </div>
                  <div class="flex justify-between">
                    <span class="text-sm text-gray-600">Workers:</span>
                    <span class="font-semibold text-gray-900">{branch.workers_count}</span>
                  </div>
                  <div class="flex justify-between">
                    <span class="text-sm text-gray-600">Cars:</span>
                    <span class="font-semibold text-gray-900">{branch.cars_count}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
    <!-- Top Performing Workers -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200">
          <div class="px-6 py-4 border-b border-gray-200">
            <div class="flex items-center justify-between">
              <div class="flex items-center space-x-3">
                <svg class="w-6 h-6 text-red-600" fill="currentColor" viewBox="0 0 20 20">
                  <path d="M9 6a3 3 0 11-6 0 3 3 0 016 0zM17 6a3 3 0 11-6 0 3 3 0 016 0zM12.93 17c.046-.327.07-.66.07-1a6.97 6.97 0 00-1.5-4.33A5 5 0 0119 16v1h-6.07zM6 11a5 5 0 015 5v1H1v-1a5 5 0 015-5z" />
                </svg>
                <h2 class="text-lg font-semibold text-gray-900">Top Performing Workers</h2>
              </div>
              <.link
                navigate={~p"/workers"}
                class="text-red-600 hover:text-red-800 text-sm font-medium"
              >
                View All Workers →
              </.link>
            </div>
          </div>

          <div class="p-6">
            <div class="space-y-4">
              <div
                :for={{worker, index} <- Enum.with_index(@worker_performance)}
                class="flex items-center justify-between p-4 bg-gray-50 rounded-lg"
              >
                <div class="flex items-center space-x-4">
                  <!-- Ranking Badge -->
                  <div class={[
                    "w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold",
                    case index do
                      0 -> "bg-yellow-400 text-yellow-900"
                      1 -> "bg-gray-400 text-gray-900"
                      2 -> "bg-amber-600 text-amber-100"
                      _ -> "bg-red-100 text-red-600"
                    end
                  ]}>
                    {index + 1}
                  </div>

                  <div class="flex items-center space-x-3">
                    <div class="bg-red-100 p-2 rounded-lg">
                      <svg class="w-5 h-5 text-red-600" fill="currentColor" viewBox="0 0 20 20">
                        <path
                          fill-rule="evenodd"
                          d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z"
                          clip-rule="evenodd"
                        />
                      </svg>
                    </div>
                    <div>
                      <h4 class="font-semibold text-gray-900">{worker.name}</h4>
                      <p class="text-sm text-gray-600">{worker.branch_name}</p>
                    </div>
                  </div>
                </div>

                <div class="flex items-center space-x-6 text-sm">
                  <div class="text-right">
                    <p class="font-semibold text-gray-900">KES{worker.revenue}</p>
                    <p class="text-gray-500">Revenue</p>
                  </div>
                  <div class="text-right">
                    <p class="font-semibold text-gray-900">{worker.services_count}</p>
                    <p class="text-gray-500">Services</p>
                  </div>
                  <div class="text-right">
                    <p class="font-semibold text-gray-900">KES{worker.avg_service_value}</p>
                    <p class="text-gray-500">Avg Value</p>
                  </div>
                  <.link
                    navigate={~p"/workers/#{worker.id}"}
                    class="text-red-600 hover:text-red-800 p-2 rounded-lg hover:bg-red-50 transition-colors duration-200"
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
                      />
                    </svg>
                  </.link>
                </div>
              </div>
            </div>
          </div>
        </div>
        
    <!-- Payment Status Overview -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <!-- Payment Status Chart -->
          <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">Payment Status</h3>
            <div class="h-64">
              <canvas id="payment-chart" width="400" height="200"></canvas>
            </div>
          </div>
          
    <!-- Quick Actions -->
          <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">Quick Actions</h3>
            <div class="space-y-3">
              <.link navigate={~p"/services/new"}>
                <.button class="w-full bg-red-600 hover:bg-red-700 text-white px-4 py-3 rounded-lg font-medium transition-colors duration-200 flex items-center justify-center space-x-2">
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M12 6v6m0 0v6m0-6h6m-6 0H6"
                    />
                  </svg>
                  <span>Record New Service</span>
                </.button>
              </.link>

              <.link navigate={~p"/cars/new"}>
                <.button class="w-full bg-white border border-gray-300 hover:bg-gray-50 text-gray-700 px-4 py-3 rounded-lg font-medium transition-colors duration-200 flex items-center justify-center space-x-2">
                  <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                    <path
                      fill-rule="evenodd"
                      d="M2 9.5A3.5 3.5 0 005.5 13H14.5a3.5 3.5 0 003.5-3.5A3.5 3.5 0 0014.5 6H5.5A3.5 3.5 0 002 9.5zM5.5 8a1.5 1.5 0 100 3 1.5 1.5 0 000-3zm9 0a1.5 1.5 0 100 3 1.5 1.5 0 000-3z"
                      clip-rule="evenodd"
                    />
                  </svg>
                  <span>Register New Car</span>
                </.button>
              </.link>

              <.link navigate={~p"/workers/new"}>
                <.button class="w-full bg-white border border-gray-300 hover:bg-gray-50 text-gray-700 px-4 py-3 rounded-lg font-medium transition-colors duration-200 flex items-center justify-center space-x-2">
                  <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                    <path
                      fill-rule="evenodd"
                      d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z"
                      clip-rule="evenodd"
                    />
                  </svg>
                  <span>Add New Worker</span>
                </.button>
              </.link>

              <.link navigate={~p"/branches/new"}>
                <.button class="w-full bg-white border border-gray-300 hover:bg-gray-50 text-gray-700 px-4 py-3 rounded-lg font-medium transition-colors duration-200 flex items-center justify-center space-x-2">
                  <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                    <path
                      fill-rule="evenodd"
                      d="M4 4a2 2 0 00-2 2v8a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2H4zm2 6a2 2 0 114 0 2 2 0 01-4 0zm8 0a2 2 0 114 0 2 2 0 01-4 0z"
                      clip-rule="evenodd"
                    />
                  </svg>
                  <span>Add New Branch</span>
                </.button>
              </.link>
            </div>
          </div>
        </div>
      </div>
      
    <!-- Hidden data for charts -->
      <div
        id="chart-data"
        data-revenue={Jason.encode!(@revenue_chart_data)}
        data-services={Jason.encode!(@services_chart_data)}
        data-payment={Jason.encode!(@payment_status_data)}
        style="display: none;"
      >
      </div>
    </div>
    """
  end
end

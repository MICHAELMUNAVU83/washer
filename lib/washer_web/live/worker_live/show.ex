defmodule WasherWeb.WorkerLive.Show do
  use WasherWeb, :system_live_view

  alias Washer.Workers
  alias Washer.Services

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Worker")
     |> assign(:current_page, "workers")}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    services = Workers.services_for_worker(id)

    worker_analytics = %{
      total_revenue: Services.list_paid_services_by_worker_total_amount(id) || 0,
      services_count: length(services),
      avg_service_value: Services.get_average_service_value_by_worker(id)
    }

    {:noreply,
     socket
     |> assign(:worker_services, services)
     |> assign(:worker_analytics, worker_analytics)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:worker, Workers.get_worker!(id))}
  end

  defp page_title(:show), do: "Show Worker"
  defp page_title(:edit), do: "Edit Worker"

  @impl true

  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <!-- Header Section -->
      <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-4">
            <div class="bg-red-100 p-3 rounded-lg">
              <svg class="w-8 h-8 text-red-600" fill="currentColor" viewBox="0 0 20 20">
                <path
                  fill-rule="evenodd"
                  d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z"
                  clip-rule="evenodd"
                />
              </svg>
            </div>
            <div>
              <h1 class="text-2xl font-bold text-gray-900">{@worker.name}</h1>
              <div class="flex items-center space-x-4 mt-1">
                <div class="flex items-center space-x-2">
                  <svg
                    class="w-4 h-4 text-gray-400"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M3 8l7.89 4.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
                    />
                  </svg>
                  <span class="text-gray-600">{@worker.email}</span>
                </div>
                <div class="flex items-center space-x-2">
                  <svg
                    class="w-4 h-4 text-gray-400"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"
                    />
                  </svg>
                  <span class="text-gray-600">{@worker.phone_number}</span>
                </div>
                <div class="flex items-center space-x-2">
                  <svg class="w-4 h-4 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                    <path
                      fill-rule="evenodd"
                      d="M4 4a2 2 0 00-2 2v8a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2H4zm2 6a2 2 0 114 0 2 2 0 01-4 0zm8 0a2 2 0 114 0 2 2 0 01-4 0z"
                      clip-rule="evenodd"
                    />
                  </svg>
                  <span class="text-gray-600">{@worker.branch.name}</span>
                </div>
              </div>
            </div>
          </div>
          <div class="flex items-center space-x-3">
            <.link patch={~p"/workers/#{@worker}/show/edit"} phx-click={JS.push_focus()}>
              <.button class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg font-medium transition-colors duration-200 flex items-center space-x-2">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                  />
                </svg>
                <span>Edit Worker</span>
              </.button>
            </.link>
            <.link
              navigate={~p"/workers"}
              class="text-gray-600 hover:text-gray-900 px-4 py-2 rounded-lg hover:bg-gray-100 transition-colors duration-200 flex items-center space-x-2"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M10 19l-7-7m0 0l7-7m-7 7h18"
                />
              </svg>
              <span>Back to Workers</span>
            </.link>
          </div>
        </div>
      </div>
      
    <!-- Performance Analytics -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Revenue Generated Card -->
        <div class="bg-gradient-to-r from-red-500 to-red-600 rounded-lg shadow-sm p-6 text-white">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-red-100 text-sm font-medium">Revenue Generated</p>
              <p class="text-3xl font-bold">KES {@worker_analytics.total_revenue || "0.00"}</p>
              <p class="text-red-100 text-sm">All time earnings</p>
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
        
    <!-- Services Completed Card -->
        <div class="bg-white border-2 border-red-200 rounded-lg shadow-sm p-6">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-gray-600 text-sm font-medium">Services Completed</p>
              <p class="text-3xl font-bold text-gray-900">{@worker_analytics.services_count || 0}</p>
              <p class="text-gray-500 text-sm">
                {if @worker_analytics.services_count > 0,
                  do: "Total services",
                  else: "No services yet"}
              </p>
            </div>
            <div class="bg-red-100 p-3 rounded-lg">
              <svg class="w-8 h-8 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
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
        
    <!-- Average Service Value -->
        <div class="bg-white border-2 border-red-200 rounded-lg shadow-sm p-6">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-gray-600 text-sm font-medium">Avg Service Value</p>
              <p class="text-3xl font-bold text-gray-900">
                KES {@worker_analytics.avg_service_value || "0.00"}
              </p>
              <p class="text-gray-500 text-sm">Per service</p>
            </div>
            <div class="bg-red-100 p-3 rounded-lg">
              <svg class="w-8 h-8 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
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
      
    <!-- Services History -->
      <div class="bg-white rounded-lg shadow-sm border border-gray-200">
        <div class="px-6 py-4 border-b border-gray-200 flex items-center justify-between">
          <div class="flex items-center space-x-3">
            <svg class="w-6 h-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"
              />
            </svg>
            <h2 class="text-lg font-semibold text-gray-900">Services Performed</h2>
            <span class="text-sm text-gray-500">({length(@worker_services)} total services)</span>
          </div>
        </div>

        <div class="p-6">
          <div :if={length(@worker_services) > 0} class="space-y-4">
            <div
              :for={service <- @worker_services}
              class="border border-gray-200 rounded-lg p-4 hover:bg-gray-50 transition-colors duration-200"
            >
              <div class="flex items-start justify-between">
                <div class="flex-1">
                  <!-- Service Header -->
                  <div class="flex items-center space-x-3 mb-3">
                    <div class="bg-red-100 p-2 rounded-lg">
                      <svg
                        class="w-5 h-5 text-red-600"
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
                    <div class="flex-1">
                      <div class="flex items-center justify-between">
                        <div class="flex items-center space-x-3">
                          <h3 class="font-semibold text-gray-900">Service #{service.id}</h3>
                          <!-- Payment Status Badge -->
                          <span class={[
                            "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium",
                            if(service.payment_completed,
                              do: "bg-green-100 text-green-800",
                              else: "bg-yellow-100 text-yellow-800"
                            )
                          ]}>
                            <span class={[
                              "w-1.5 h-1.5 rounded-full mr-1.5",
                              if(service.payment_completed, do: "bg-green-400", else: "bg-yellow-400")
                            ]}>
                            </span>
                            {if service.payment_completed, do: "Paid", else: "Pending"}
                          </span>
                        </div>
                        <div class="text-right">
                          <span class="text-lg font-bold text-red-600">
                            KES{service.total_amount}
                          </span>
                          <p :if={service.payment_method} class="text-xs text-gray-500 mt-1">
                            via {String.capitalize(service.payment_method)}
                          </p>
                        </div>
                      </div>
                      <div class="flex items-center space-x-4 text-sm text-gray-600 mt-1">
                        <div class="flex items-center space-x-1">
                          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              stroke-width="2"
                              d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
                            />
                          </svg>
                          <span>{Calendar.strftime(service.date, "%b %d, %Y")}</span>
                        </div>
                        <div class="flex items-center space-x-1">
                          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              stroke-width="2"
                              d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
                            />
                          </svg>
                          <span>{Calendar.strftime(service.time, "%I:%M %p")}</span>
                        </div>
                        <div class="flex items-center space-x-1">
                          <svg class="w-4 h-4 text-red-600" fill="currentColor" viewBox="0 0 20 20">
                            <path
                              fill-rule="evenodd"
                              d="M2 9.5A3.5 3.5 0 005.5 13H14.5a3.5 3.5 0 003.5-3.5A3.5 3.5 0 0014.5 6H5.5A3.5 3.5 0 002 9.5zM5.5 8a1.5 1.5 0 100 3 1.5 1.5 0 000-3zm9 0a1.5 1.5 0 100 3 1.5 1.5 0 000-3z"
                              clip-rule="evenodd"
                            />
                          </svg>
                          <span class="font-mono">{service.car.number_plate}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                  
    <!-- Service Details -->
                  <div class="space-y-3">
                    <!-- Customer Information -->
                    <div class="flex items-center space-x-3">
                      <div class="bg-gray-100 p-2 rounded-lg">
                        <svg class="w-4 h-4 text-gray-600" fill="currentColor" viewBox="0 0 20 20">
                          <path
                            fill-rule="evenodd"
                            d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z"
                            clip-rule="evenodd"
                          />
                        </svg>
                      </div>
                      <div>
                        <p class="font-medium text-gray-900">{service.car.name}</p>
                        <p class="text-sm text-gray-600">{service.car.phone_number}</p>
                      </div>
                    </div>
                    
    <!-- Service Types -->
                    <div>
                      <p class="text-sm font-medium text-gray-700 mb-2">Services Performed:</p>
                      <div class="flex flex-wrap gap-2">
                        <span
                          :for={service_type <- String.split(service.types, ",", trim: true)}
                          class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium bg-red-100 text-red-800"
                        >
                          {String.trim(service_type)}
                        </span>
                      </div>
                    </div>
                    
    <!-- Service Description -->
                    <div :if={service.description && service.description != ""}>
                      <p class="text-sm font-medium text-gray-700">Service Notes:</p>
                      <p class="text-sm text-gray-600 bg-gray-50 rounded-lg p-3 mt-1">
                        {service.description}
                      </p>
                    </div>
                  </div>
                </div>
                
    <!-- Service Actions -->
                <div class="flex items-center space-x-2 ml-4">
                  <.link
                    navigate={~p"/services/#{service}"}
                    class="text-gray-600 hover:text-gray-900 p-2 rounded-lg hover:bg-gray-100 transition-colors duration-200"
                    title="View service details"
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                      />
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
                      />
                    </svg>
                  </.link>
                  <.link
                    navigate={~p"/cars/#{service.car.id}"}
                    class="text-red-600 hover:text-red-800 p-2 rounded-lg hover:bg-red-50 transition-colors duration-200"
                    title="View customer car"
                  >
                    <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                      <path
                        fill-rule="evenodd"
                        d="M2 9.5A3.5 3.5 0 005.5 13H14.5a3.5 3.5 0 003.5-3.5A3.5 3.5 0 0014.5 6H5.5A3.5 3.5 0 002 9.5zM5.5 8a1.5 1.5 0 100 3 1.5 1.5 0 000-3zm9 0a1.5 1.5 0 100 3 1.5 1.5 0 000-3z"
                        clip-rule="evenodd"
                      />
                    </svg>
                  </.link>
                </div>
              </div>
            </div>
          </div>
          
    <!-- Empty State for Services -->
          <div :if={length(@worker_services) == 0} class="text-center py-12">
            <div class="bg-gray-100 rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4">
              <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"
                />
              </svg>
            </div>
            <h3 class="text-lg font-medium text-gray-900 mb-2">No services performed</h3>
            <p class="text-gray-600 mb-6">This worker hasn't performed any services yet.</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Edit Modal -->
    <.modal
      :if={@live_action == :edit}
      id="worker-modal"
      show
      on_cancel={JS.patch(~p"/workers/#{@worker}")}
    >
      <.live_component
        module={WasherWeb.WorkerLive.FormComponent}
        id={@worker.id}
        title={@page_title}
        action={@live_action}
        worker={@worker}
        patch={~p"/workers/#{@worker}"}
      />
    </.modal>
    """
  end
end

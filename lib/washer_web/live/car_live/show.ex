defmodule WasherWeb.CarLive.Show do
  use WasherWeb, :system_live_view

  alias Washer.Cars
  alias Washer.Services

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Car")
     |> assign(:current_page, "cars")}
  end

  @impl true
  def handle_params(%{"id" => id, "service_id" => service_id}, _, socket) do
    services = Cars.list_services_done_to_car(id)

    car_analytics = %{
      total_spent: Services.list_paid_services_by_car_total_amount(id) || 0,
      services_count: length(services)
    }

    {:noreply,
     socket
     |> assign(:car_services, Cars.list_services_done_to_car(id))
     |> assign(:car_analytics, car_analytics)
     |> assign(:service, Services.get_service!(service_id))
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:car, Cars.get_car!(id))}
  end

  def handle_params(%{"id" => id}, _, socket) do
    services = Cars.list_services_done_to_car(id)

    car_analytics = %{
      total_spent: 100,
      services_count: length(services)
    }

    {:noreply,
     socket
     |> assign(:car_services, Cars.list_services_done_to_car(id))
     |> assign(:car_analytics, car_analytics)
     |> assign(:service, %Services.Service{})
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:car, Cars.get_car!(id))}
  end

  defp page_title(:show), do: "Show Car"
  defp page_title(:edit), do: "Edit Car"
  defp page_title(:new_service), do: "New Car Service"
  defp page_title(:edit_service), do: "Edit Car Service"

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
                  d="M2 9.5A3.5 3.5 0 005.5 13H14.5a3.5 3.5 0 003.5-3.5A3.5 3.5 0 0014.5 6H5.5A3.5 3.5 0 002 9.5zM5.5 8a1.5 1.5 0 100 3 1.5 1.5 0 000-3zm9 0a1.5 1.5 0 100 3 1.5 1.5 0 000-3z"
                  clip-rule="evenodd"
                />
                <path d="M6.5 15a2.5 2.5 0 000 5 2.5 2.5 0 000-5zM13.5 15a2.5 2.5 0 000 5 2.5 2.5 0 000-5z" />
              </svg>
            </div>
            <div>
              <h1 class="text-2xl font-bold text-gray-900 font-mono tracking-wider">
                {@car.number_plate}
              </h1>
              <div class="flex items-center space-x-4 mt-1">
                <div class="flex items-center space-x-2">
                  <svg class="w-4 h-4 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                    <path
                      fill-rule="evenodd"
                      d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z"
                      clip-rule="evenodd"
                    />
                  </svg>
                  <span class="text-gray-600 font-medium">{@car.name}</span>
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
                  <span class="text-gray-600">{@car.phone_number}</span>
                </div>
              </div>
            </div>
          </div>
          <div class="flex items-center space-x-3">
            <.link patch={~p"/cars/#{@car}/show/edit"} phx-click={JS.push_focus()}>
              <.button class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg font-medium transition-colors duration-200 flex items-center space-x-2">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                  />
                </svg>
                <span>Edit Car</span>
              </.button>
            </.link>
            <.link
              navigate={~p"/cars"}
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
              <span>Back to Cars</span>
            </.link>
          </div>
        </div>
      </div>
      
    <!-- Analytics and Registration Info -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Total Spent Card -->
        <div class="bg-gradient-to-r from-red-500 to-red-600 rounded-lg shadow-sm p-6 text-white">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-red-100 text-sm font-medium">Total Spent</p>
              <p class="text-3xl font-bold">KES {@car_analytics.total_spent || "0.00"}</p>
              <p class="text-red-100 text-sm">Lifetime services</p>
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
        
    <!-- Services Count Card -->
        <div class="bg-white border-2 border-red-200 rounded-lg shadow-sm p-6">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-gray-600 text-sm font-medium">Total Services</p>
              <p class="text-3xl font-bold text-gray-900">{@car_analytics.services_count || 0}</p>
              <p class="text-gray-500 text-sm">
                {if @car_analytics.services_count > 0, do: "Visits completed", else: "No services yet"}
              </p>
            </div>
            <div class="bg-red-100 p-3 rounded-lg">
              <svg class="w-8 h-8 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"
                />
              </svg>
            </div>
          </div>
        </div>
        
    <!-- Registration Info Card -->
        <div class="bg-white border-2 border-red-200 rounded-lg shadow-sm p-6">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-gray-600 text-sm font-medium">Registered At</p>
              <p class="text-lg font-bold text-gray-900">
                {@car.branch && @car.branch.name}
              </p>
              <p class="text-gray-500 text-sm">{Calendar.strftime(@car.inserted_at, "%b %d, %Y")}</p>
            </div>
            <div class="bg-red-100 p-3 rounded-lg">
              <svg class="w-8 h-8 text-red-600" fill="currentColor" viewBox="0 0 20 20">
                <path
                  fill-rule="evenodd"
                  d="M4 4a2 2 0 00-2 2v8a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2H4zm2 6a2 2 0 114 0 2 2 0 01-4 0zm8 0a2 2 0 114 0 2 2 0 01-4 0z"
                  clip-rule="evenodd"
                />
              </svg>
            </div>
          </div>
        </div>
      </div>
      
    <!-- Customer Contact Information -->
      <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
        <div class="flex items-center space-x-3 mb-4">
          <svg class="w-6 h-6 text-red-600" fill="currentColor" viewBox="0 0 20 20">
            <path
              fill-rule="evenodd"
              d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z"
              clip-rule="evenodd"
            />
          </svg>
          <h2 class="text-lg font-semibold text-gray-900">Customer Information</h2>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div class="flex items-center space-x-3">
            <div class="bg-gray-100 p-2 rounded-lg">
              <svg class="w-5 h-5 text-gray-600" fill="currentColor" viewBox="0 0 20 20">
                <path
                  fill-rule="evenodd"
                  d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z"
                  clip-rule="evenodd"
                />
              </svg>
            </div>
            <div>
              <p class="text-sm text-gray-500">Customer Name</p>
              <p class="font-semibold text-gray-900">{@car.name}</p>
            </div>
          </div>

          <div class="flex items-center space-x-3">
            <div class="bg-gray-100 p-2 rounded-lg">
              <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M3 8l7.89 4.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
                />
              </svg>
            </div>
            <div>
              <p class="text-sm text-gray-500">Email Address</p>
              <p class="font-semibold text-gray-900">{@car.email}</p>
            </div>
          </div>

          <div class="flex items-center space-x-3">
            <div class="bg-gray-100 p-2 rounded-lg">
              <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"
                />
              </svg>
            </div>
            <div>
              <p class="text-sm text-gray-500">Phone Number</p>
              <p class="font-semibold text-gray-900">{@car.phone_number}</p>
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
            <h2 class="text-lg font-semibold text-gray-900">Service History</h2>
            <span class="text-sm text-gray-500">({length(@car_services)} total services)</span>
          </div>
          <.link patch={~p"/cars/#{@car.id}/new_service"}>
            <.button class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg font-medium transition-colors duration-200 flex items-center space-x-2">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 6v6m0 0v6m0-6h6m-6 0H6"
                />
              </svg>
              <span>Add Service</span>
            </.button>
          </.link>
        </div>

        <div class="p-6">
          <div :if={length(@car_services) > 0} class="space-y-4">
            <div
              :for={service <- @car_services}
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
                            KES {service.total_amount}
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
                          <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                            <path
                              fill-rule="evenodd"
                              d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z"
                              clip-rule="evenodd"
                            />
                          </svg>
                          <span>{service.worker && service.worker.name}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                  
    <!-- Service Details -->
                  <div class="space-y-3">
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
                    
    <!-- Payment Information -->
                    <div class="bg-gray-50 rounded-lg p-3">
                      <div class="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                        <div>
                          <p class="font-medium text-gray-700">Payment Status:</p>
                          <p class={[
                            "font-semibold",
                            if(service.payment_completed,
                              do: "text-green-600",
                              else: "text-yellow-600"
                            )
                          ]}>
                            {if service.payment_completed, do: "Completed", else: "Pending Payment"}
                          </p>
                        </div>
                        <div :if={service.payment_method}>
                          <p class="font-medium text-gray-700">Payment Method:</p>
                          <p class="text-gray-900 font-semibold">
                            {String.capitalize(service.payment_method)}
                          </p>
                        </div>
                        <div>
                          <p class="font-medium text-gray-700">Total Amount:</p>
                          <p class="text-red-600 font-bold text-lg">KES{service.total_amount}</p>
                        </div>
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

                <div class="flex flex-col items-center space-y-2 ml-4">
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
                    patch={~p"/cars/#{@car.id}/edit_service/#{service.id}"}
                    class="text-red-600 hover:text-red-800 p-2 rounded-lg hover:bg-red-50 transition-colors duration-200"
                    title="Edit service"
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                      />
                    </svg>
                  </.link>
                </div>
              </div>
            </div>
          </div>
          
    <!-- Empty State for Services -->
          <div :if={length(@car_services) == 0} class="text-center py-12">
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
            <h3 class="text-lg font-medium text-gray-900 mb-2">No services recorded</h3>
            <p class="text-gray-600 mb-6">This vehicle hasn't received any services yet.</p>
            <.link patch={~p"/cars/#{@car.id}/new_service"}>
              <.button class="bg-red-600 hover:bg-red-700 text-white">
                Record First Service
              </.button>
            </.link>
          </div>
        </div>
      </div>
      
    <!-- Quick Actions -->
      <div class="bg-gray-50 rounded-lg p-4 border border-gray-200">
        <h3 class="text-lg font-medium text-gray-900 mb-4">Quick Actions</h3>
        <div class="flex flex-wrap gap-3">
          <.link patch={~p"/cars/#{@car.id}/new_service"}>
            <.button class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg flex items-center space-x-2">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 6v6m0 0v6m0-6h6m-6 0H6"
                />
              </svg>
              <span>New Service</span>
            </.button>
          </.link>

          <.link :if={@car.branch} navigate={~p"/branches/#{@car.branch.id}"}>
            <button class="bg-white border border-gray-300 hover:bg-gray-50 text-gray-700 px-4 py-2 rounded-lg flex items-center space-x-2">
              <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                <path
                  fill-rule="evenodd"
                  d="M4 4a2 2 0 00-2 2v8a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2H4zm2 6a2 2 0 114 0 2 2 0 01-4 0zm8 0a2 2 0 114 0 2 2 0 01-4 0z"
                  clip-rule="evenodd"
                />
              </svg>
              <span>View Branch</span>
            </button>
          </.link>

          <.link navigate={~p"/cars"}>
            <button class="bg-white border border-gray-300 hover:bg-gray-50 text-gray-700 px-4 py-2 rounded-lg flex items-center space-x-2">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M4 6h16M4 10h16M4 14h16M4 18h16"
                />
              </svg>
              <span>All Cars</span>
            </button>
          </.link>
        </div>
      </div>
    </div>

    <!-- Edit Modal -->
    <.modal :if={@live_action == :edit} id="car-modal" show on_cancel={JS.patch(~p"/cars/#{@car}")}>
      <.live_component
        module={WasherWeb.CarLive.FormComponent}
        id={@car.id}
        title={@page_title}
        action={@live_action}
        car={@car}
        patch={~p"/cars/#{@car}"}
      />
    </.modal>

    <.modal
      :if={@live_action in [:new_service, :edit_service]}
      id="service-modal"
      show
      on_cancel={JS.patch(~p"/cars/#{@car}")}
    >
      <.live_component
        module={WasherWeb.ServiceLive.FormComponent}
        id={@service.id || :new}
        title={@page_title}
        action={@live_action}
        service={@service}
        car={@car}
        current_user={@current_user}
        branch={@car.branch}
        patch={~p"/cars/#{@car}/"}
      />
    </.modal>
    """
  end
end

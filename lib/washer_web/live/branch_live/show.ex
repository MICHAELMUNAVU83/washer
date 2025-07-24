defmodule WasherWeb.BranchLive.Show do
  use WasherWeb, :system_live_view

  alias Washer.Branches
  alias Washer.Services

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:current_page, "branches")}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    branch_workers = Branches.list_branch_workers(id)
    branch_cars = Branches.list_branch_cars(id)

    branch_analytics = %{
      workers_count: Enum.count(branch_workers),
      cars_count: Enum.count(branch_cars),
      monthly_revenue: Services.list_paid_services_by_branch_total_amount(id)
    }

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:branch, Branches.get_branch!(id))
     |> assign(:branch_workers, branch_workers)
     |> assign(:branch_cars, branch_cars)
     |> assign(:branch_analytics, branch_analytics)}
  end

  defp page_title(:show), do: "Show Branch"
  defp page_title(:edit), do: "Edit Branch"

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
                  d="M4 4a2 2 0 00-2 2v8a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2H4zm2 6a2 2 0 114 0 2 2 0 01-4 0zm8 0a2 2 0 114 0 2 2 0 01-4 0z"
                  clip-rule="evenodd"
                />
              </svg>
            </div>
            <div>
              <h1 class="text-2xl font-bold text-gray-900">{@branch.name}</h1>
              <div class="flex items-center space-x-2 mt-1">
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
                    d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"
                  />
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"
                  />
                </svg>
                <span class="text-gray-600">{@branch.location}</span>
              </div>
            </div>
          </div>
          <div class="flex items-center space-x-3">
            <.link patch={~p"/branches/#{@branch}/show/edit"} phx-click={JS.push_focus()}>
              <.button class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg font-medium transition-colors duration-200 flex items-center space-x-2">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                  />
                </svg>
                <span>Edit Branch</span>
              </.button>
            </.link>
            <.link
              navigate={~p"/branches"}
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
              <span>Back to Branches</span>
            </.link>
          </div>
        </div>
      </div>
      
    <!-- Analytics Cards -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Revenue Card -->
        <div class="bg-gradient-to-r from-red-500 to-red-600 rounded-lg shadow-sm p-6 text-white">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-red-100 text-sm font-medium">Total Revenue</p>
              <p class="text-3xl font-bold">KES {@branch_analytics.monthly_revenue || "0"}</p>
              <p class="text-red-100 text-sm">
                Paid Revenue
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
        
    <!-- Workers Card -->
        <div class="bg-white border-2 border-red-200 rounded-lg shadow-sm p-6">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-gray-600 text-sm font-medium">Active Workers</p>
              <p class="text-3xl font-bold text-gray-900">{@branch_analytics.workers_count || 0}</p>
              <p class="text-gray-500 text-sm">
                {if @branch_analytics.workers_count > 0, do: "Team members", else: "No workers yet"}
              </p>
            </div>
            <div class="bg-red-100 p-3 rounded-lg">
              <svg class="w-8 h-8 text-red-600" fill="currentColor" viewBox="0 0 20 20">
                <path d="M9 6a3 3 0 11-6 0 3 3 0 016 0zM17 6a3 3 0 11-6 0 3 3 0 016 0zM12.93 17c.046-.327.07-.66.07-1a6.97 6.97 0 00-1.5-4.33A5 5 0 0119 16v1h-6.07zM6 11a5 5 0 015 5v1H1v-1a5 5 0 015-5z" />
              </svg>
            </div>
          </div>
        </div>
        
    <!-- Cars Card -->
        <div class="bg-white border-2 border-red-200 rounded-lg shadow-sm p-6">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-gray-600 text-sm font-medium">Registered Cars</p>
              <p class="text-3xl font-bold text-gray-900">{@branch_analytics.cars_count || 0}</p>
              <p class="text-gray-500 text-sm">
                {if @branch_analytics.cars_count > 0, do: "Customer vehicles", else: "No cars yet"}
              </p>
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
      </div>
      
    <!-- Workers Section -->
      <div class="bg-white rounded-lg shadow-sm border border-gray-200">
        <div class="px-6 py-4 border-b border-gray-200 flex items-center justify-between">
          <div class="flex items-center space-x-3">
            <svg class="w-6 h-6 text-red-600" fill="currentColor" viewBox="0 0 20 20">
              <path d="M9 6a3 3 0 11-6 0 3 3 0 016 0zM17 6a3 3 0 11-6 0 3 3 0 016 0zM12.93 17c.046-.327.07-.66.07-1a6.97 6.97 0 00-1.5-4.33A5 5 0 0119 16v1h-6.07zM6 11a5 5 0 015 5v1H1v-1a5 5 0 015-5z" />
            </svg>
            <h2 class="text-lg font-semibold text-gray-900">Branch Workers</h2>
            <span class="text-sm text-gray-500">({length(@branch_workers)} total)</span>
          </div>
          <.link patch={~p"/workers/new?branch_id=#{@branch.id}"}>
            <.button class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg font-medium transition-colors duration-200 flex items-center space-x-2">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 6v6m0 0v6m0-6h6m-6 0H6"
                />
              </svg>
              <span>Add Worker</span>
            </.button>
          </.link>
        </div>

        <div class="p-6">
          <div :if={length(@branch_workers) > 0} class="space-y-4">
            <div
              :for={worker <- @branch_workers}
              class="flex items-center justify-between p-4 bg-gray-50 rounded-lg"
            >
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
                  <p class="font-semibold text-gray-900">{worker.name}</p>
                  <p class="text-sm text-gray-600">{worker.email}</p>
                  <p class="text-sm text-gray-500">{worker.phone_number}</p>
                </div>
              </div>
              <div class="flex items-center space-x-2">
                <.link
                  navigate={~p"/workers/#{worker}"}
                  class="text-gray-600 hover:text-gray-900 p-2 rounded-lg hover:bg-gray-100 transition-colors duration-200"
                  title="View worker"
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
                  patch={~p"/workers/#{worker}/edit"}
                  class="text-red-600 hover:text-red-800 p-2 rounded-lg hover:bg-red-50 transition-colors duration-200"
                  title="Edit worker"
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

          <div :if={length(@branch_workers) == 0} class="text-center py-8">
            <div class="bg-gray-100 rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4">
              <svg class="w-8 h-8 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                <path d="M9 6a3 3 0 11-6 0 3 3 0 016 0zM17 6a3 3 0 11-6 0 3 3 0 016 0zM12.93 17c.046-.327.07-.66.07-1a6.97 6.97 0 00-1.5-4.33A5 5 0 0119 16v1h-6.07zM6 11a5 5 0 015 5v1H1v-1a5 5 0 015-5z" />
              </svg>
            </div>
            <h3 class="text-lg font-medium text-gray-900 mb-2">No workers assigned</h3>
            <p class="text-gray-600 mb-4">This branch doesn't have any workers yet.</p>
            <.link patch={~p"/workers/new?branch_id=#{@branch.id}"}>
              <.button class="bg-red-600 hover:bg-red-700 text-white">
                Add First Worker
              </.button>
            </.link>
          </div>
        </div>
      </div>
      
    <!-- Cars Section -->
      <div class="bg-white rounded-lg shadow-sm border border-gray-200">
        <div class="px-6 py-4 border-b border-gray-200 flex items-center justify-between">
          <div class="flex items-center space-x-3">
            <svg class="w-6 h-6 text-red-600" fill="currentColor" viewBox="0 0 20 20">
              <path
                fill-rule="evenodd"
                d="M2 9.5A3.5 3.5 0 005.5 13H14.5a3.5 3.5 0 003.5-3.5A3.5 3.5 0 0014.5 6H5.5A3.5 3.5 0 002 9.5zM5.5 8a1.5 1.5 0 100 3 1.5 1.5 0 000-3zm9 0a1.5 1.5 0 100 3 1.5 1.5 0 000-3z"
                clip-rule="evenodd"
              />
            </svg>
            <h2 class="text-lg font-semibold text-gray-900">Registered Cars</h2>
            <span class="text-sm text-gray-500">({length(@branch_cars)} total)</span>
          </div>
          <.link patch={~p"/cars/new?branch_id=#{@branch.id}"}>
            <.button class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg font-medium transition-colors duration-200 flex items-center space-x-2">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 6v6m0 0v6m0-6h6m-6 0H6"
                />
              </svg>
              <span>Register Car</span>
            </.button>
          </.link>
        </div>

        <div class="p-6">
          <div :if={length(@branch_cars) > 0} class="grid grid-cols-1 lg:grid-cols-2 gap-4">
            <div
              :for={car <- @branch_cars}
              class="flex items-center justify-between p-4 bg-gray-50 rounded-lg"
            >
              <div class="flex items-center space-x-3">
                <div class="bg-red-100 p-2 rounded-lg">
                  <svg class="w-5 h-5 text-red-600" fill="currentColor" viewBox="0 0 20 20">
                    <path
                      fill-rule="evenodd"
                      d="M2 9.5A3.5 3.5 0 005.5 13H14.5a3.5 3.5 0 003.5-3.5A3.5 3.5 0 0014.5 6H5.5A3.5 3.5 0 002 9.5zM5.5 8a1.5 1.5 0 100 3 1.5 1.5 0 000-3zm9 0a1.5 1.5 0 100 3 1.5 1.5 0 000-3z"
                      clip-rule="evenodd"
                    />
                  </svg>
                </div>
                <div>
                  <p class="font-semibold text-gray-900 font-mono">{car.number_plate}</p>
                  <p class="text-sm text-gray-600">{car.name}</p>
                  <p class="text-sm text-gray-500">{car.phone_number}</p>
                </div>
              </div>
              <div class="flex items-center space-x-2">
                <.link
                  navigate={~p"/cars/#{car}"}
                  class="text-gray-600 hover:text-gray-900 p-2 rounded-lg hover:bg-gray-100 transition-colors duration-200"
                  title="View car"
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
                  patch={~p"/cars/#{car}/edit"}
                  class="text-red-600 hover:text-red-800 p-2 rounded-lg hover:bg-red-50 transition-colors duration-200"
                  title="Edit car"
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

            <div :if={length(@branch_cars) == 0} class="text-center py-8">
              <div class="bg-gray-100 rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4">
                <svg class="w-8 h-8 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                  <path
                    fill-rule="evenodd"
                    d="M2 9.5A3.5 3.5 0 005.5 13H14.5a3.5 3.5 0 003.5-3.5A3.5 3.5 0 0014.5 6H5.5A3.5 3.5 0 002 9.5zM5.5 8a1.5 1.5 0 100 3 1.5 1.5 0 000-3zm9 0a1.5 1.5 0 100 3 1.5 1.5 0 000-3z"
                    clip-rule="evenodd"
                  />
                </svg>
              </div>
              <h3 class="text-lg font-medium text-gray-900 mb-2">No cars registered</h3>
              <p class="text-gray-600 mb-4">
                No customer vehicles have been registered at this branch yet.
              </p>
              <.link patch={~p"/cars/new?branch_id=#{@branch.id}"}>
                <.button class="bg-red-600 hover:bg-red-700 text-white">
                  Register First Car
                </.button>
              </.link>
            </div>
          </div>
        </div>

        <div class="p-6">
          <div :if={length(@branch_cars) > 0} class="grid grid-cols-1 lg:grid-cols-2 gap-4">
            <div
              :for={car <- @branch_cars}
              class="flex items-center justify-between p-4 bg-gray-50 rounded-lg"
            >
              <div class="flex items-center space-x-3">
                <div class="bg-purple-100 p-2 rounded-lg">
                  <svg class="w-5 h-5 text-purple-600" fill="currentColor" viewBox="0 0 20 20">
                    <path
                      fill-rule="evenodd"
                      d="M2 9.5A3.5 3.5 0 005.5 13H14.5a3.5 3.5 0 003.5-3.5A3.5 3.5 0 0014.5 6H5.5A3.5 3.5 0 002 9.5zM5.5 8a1.5 1.5 0 100 3 1.5 1.5 0 000-3zm9 0a1.5 1.5 0 100 3 1.5 1.5 0 000-3z"
                      clip-rule="evenodd"
                    />
                  </svg>
                </div>
                <div>
                  <p class="font-semibold text-gray-900 font-mono">{car.number_plate}</p>
                  <p class="text-sm text-gray-600">{car.name}</p>
                  <p class="text-sm text-gray-500">{car.phone_number}</p>
                </div>
              </div>
              <div class="flex items-center space-x-2">
                <.link
                  navigate={~p"/cars/#{car}"}
                  class="text-gray-600 hover:text-gray-900 p-2 rounded-lg hover:bg-gray-100 transition-colors duration-200"
                  title="View car"
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
                  patch={~p"/cars/#{car}/edit"}
                  class="text-purple-600 hover:text-purple-800 p-2 rounded-lg hover:bg-purple-50 transition-colors duration-200"
                  title="Edit car"
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

          <div :if={length(@branch_cars) == 0} class="text-center py-8">
            <div class="bg-gray-100 rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4">
              <svg class="w-8 h-8 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                <path
                  fill-rule="evenodd"
                  d="M2 9.5A3.5 3.5 0 005.5 13H14.5a3.5 3.5 0 003.5-3.5A3.5 3.5 0 0014.5 6H5.5A3.5 3.5 0 002 9.5zM5.5 8a1.5 1.5 0 100 3 1.5 1.5 0 000-3zm9 0a1.5 1.5 0 100 3 1.5 1.5 0 000-3z"
                  clip-rule="evenodd"
                />
              </svg>
            </div>
            <h3 class="text-lg font-medium text-gray-900 mb-2">No cars registered</h3>
            <p class="text-gray-600 mb-4">
              No customer vehicles have been registered at this branch yet.
            </p>
            <.link patch={~p"/cars/new?branch_id=#{@branch.id}"}>
              <.button class="bg-red-600 hover:bg-red-700 text-white">
                Register First Car
              </.button>
            </.link>
          </div>
        </div>
      </div>
    </div>

    <!-- Edit Modal -->
    <.modal
      :if={@live_action == :edit}
      id="branch-modal"
      show
      on_cancel={JS.patch(~p"/branches/#{@branch}")}
    >
      <.live_component
        module={WasherWeb.BranchLive.FormComponent}
        id={@branch.id}
        title={@page_title}
        action={@live_action}
        branch={@branch}
        patch={~p"/branches/#{@branch}"}
      />
    </.modal>
    """
  end
end

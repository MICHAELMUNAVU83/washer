defmodule WasherWeb.ServiceLive.FormComponent do
  use WasherWeb, :live_component

  alias Washer.Services

  @impl true
  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <!-- Form Header -->
      <div class="border-b border-gray-200 pb-4">
        <div class="flex items-center space-x-3">
          <div class="bg-red-100 p-2 rounded-lg">
            <svg class="w-6 h-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"
              />
            </svg>
          </div>
          <div>
            <h2 class="text-xl font-semibold text-gray-900">{@title}</h2>
            <p class="text-sm text-gray-600">Record a new service for {@car.number_plate}</p>
          </div>
        </div>
      </div>
      
    <!-- Form Content -->
      <.simple_form
        for={@form}
        id="service-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="space-y-6"
      >
        <!-- Service Types Selection -->
        <div class="bg-red-50 rounded-lg p-4 space-y-4 border border-red-200">
          <div class="flex items-center space-x-2">
            <svg class="w-5 h-5 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
              />
            </svg>
            <h3 class="text-lg font-medium text-red-900">Service Types</h3>
          </div>
          
    <!-- Service Type Tabs -->
          <div class="space-y-3">
            <p class="text-sm text-red-700">
              Select the services to be performed (multiple selections allowed):
            </p>

            <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
              <!-- Car Wash -->
              <label class="relative">
                <input
                  type="checkbox"
                  class="sr-only peer"
                  phx-click={
                    JS.push("toggle_service_type", value: %{type: "Car Wash"}, target: @myself)
                  }
                  checked={String.contains?(@selected_types, "Car Wash")}
                />
                <div class="flex flex-col items-center p-4 bg-white border-2 border-gray-200 rounded-lg cursor-pointer transition-all duration-200 peer-checked:border-red-500 peer-checked:bg-red-50 hover:border-red-300">
                  <svg
                    class="w-8 h-8 text-gray-600 peer-checked:text-red-600 mb-2"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"
                    />
                  </svg>
                  <span class="text-sm font-medium text-gray-900">Car Wash</span>
                </div>
              </label>
              
    <!-- Buffing -->
              <label class="relative">
                <input
                  type="checkbox"
                  class="sr-only peer"
                  phx-click={
                    JS.push("toggle_service_type", value: %{type: "Buffing"}, target: @myself)
                  }
                  checked={String.contains?(@selected_types, "Buffing")}
                />
                <div class="flex flex-col items-center p-4 bg-white border-2 border-gray-200 rounded-lg cursor-pointer transition-all duration-200 peer-checked:border-red-500 peer-checked:bg-red-50 hover:border-red-300">
                  <svg
                    class="w-8 h-8 text-gray-600 peer-checked:text-red-600 mb-2"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M13 10V3L4 14h7v7l9-11h-7z"
                    />
                  </svg>
                  <span class="text-sm font-medium text-gray-900">Buffing</span>
                </div>
              </label>
              
    <!-- Tinting -->
              <label class="relative">
                <input
                  type="checkbox"
                  class="sr-only peer"
                  phx-click={
                    JS.push("toggle_service_type", value: %{type: "Tinting"}, target: @myself)
                  }
                  checked={String.contains?(@selected_types, "Tinting")}
                />
                <div class="flex flex-col items-center p-4 bg-white border-2 border-gray-200 rounded-lg cursor-pointer transition-all duration-200 peer-checked:border-red-500 peer-checked:bg-red-50 hover:border-red-300">
                  <svg
                    class="w-8 h-8 text-gray-600 peer-checked:text-red-600 mb-2"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v12a4 4 0 01-4 4zM21 5a2 2 0 00-2-2h-4a2 2 0 00-2 2v12a4 4 0 004 4 4 4 0 004-4V5z"
                    />
                  </svg>
                  <span class="text-sm font-medium text-gray-900">Tinting</span>
                </div>
              </label>
              
    <!-- Detailing -->
              <label class="relative">
                <input
                  type="checkbox"
                  class="sr-only peer"
                  phx-click={
                    JS.push("toggle_service_type", value: %{type: "Detailing"}, target: @myself)
                  }
                  checked={String.contains?(@selected_types, "Detailing")}
                />
                <div class="flex flex-col items-center p-4 bg-white border-2 border-gray-200 rounded-lg cursor-pointer transition-all duration-200 peer-checked:border-red-500 peer-checked:bg-red-50 hover:border-red-300">
                  <svg
                    class="w-8 h-8 text-gray-600 peer-checked:text-red-600 mb-2"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
                    />
                  </svg>
                  <span class="text-sm font-medium text-gray-900">Detailing</span>
                </div>
              </label>
              
    <!-- Waxing -->
              <label class="relative">
                <input
                  type="checkbox"
                  class="sr-only peer"
                  phx-click={
                    JS.push("toggle_service_type", value: %{type: "Waxing"}, target: @myself)
                  }
                  checked={String.contains?(@selected_types, "Waxing")}
                />
                <div class="flex flex-col items-center p-4 bg-white border-2 border-gray-200 rounded-lg cursor-pointer transition-all duration-200 peer-checked:border-red-500 peer-checked:bg-red-50 hover:border-red-300">
                  <svg
                    class="w-8 h-8 text-gray-600 peer-checked:text-red-600 mb-2"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z"
                    />
                  </svg>
                  <span class="text-sm font-medium text-gray-900">Waxing</span>
                </div>
              </label>
              
    <!-- Interior Cleaning -->
              <label class="relative">
                <input
                  type="checkbox"
                  class="sr-only peer"
                  phx-click={
                    JS.push("toggle_service_type",
                      value: %{type: "Interior Cleaning"},
                      target: @myself
                    )
                  }
                  checked={String.contains?(@selected_types, "Interior Cleaning")}
                />
                <div class="flex flex-col items-center p-4 bg-white border-2 border-gray-200 rounded-lg cursor-pointer transition-all duration-200 peer-checked:border-red-500 peer-checked:bg-red-50 hover:border-red-300">
                  <svg
                    class="w-8 h-8 text-gray-600 peer-checked:text-red-600 mb-2"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2H5a2 2 0 00-2-2z"
                    />
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M8 5a2 2 0 012-2h4a2 2 0 012 2v.01H8V5z"
                    />
                  </svg>
                  <span class="text-sm font-medium text-gray-900">Interior</span>
                </div>
              </label>
              
    <!-- Tire Service -->
              <label class="relative">
                <input
                  type="checkbox"
                  class="sr-only peer"
                  phx-click={
                    JS.push("toggle_service_type", value: %{type: "Tire Service"}, target: @myself)
                  }
                  checked={String.contains?(@selected_types, "Tire Service")}
                />
                <div class="flex flex-col items-center p-4 bg-white border-2 border-gray-200 rounded-lg cursor-pointer transition-all duration-200 peer-checked:border-red-500 peer-checked:bg-red-50 hover:border-red-300">
                  <svg
                    class="w-8 h-8 text-gray-600 peer-checked:text-red-600 mb-2"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                    />
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M9 12l2 2 4-4"
                    />
                  </svg>
                  <span class="text-sm font-medium text-gray-900">Tires</span>
                </div>
              </label>
              
    <!-- Engine Bay -->
              <label class="relative">
                <input
                  type="checkbox"
                  class="sr-only peer"
                  phx-click={
                    JS.push("toggle_service_type", value: %{type: "Engine Bay"}, target: @myself)
                  }
                  checked={String.contains?(@selected_types, "Engine Bay")}
                />
                <div class="flex flex-col items-center p-4 bg-white border-2 border-gray-200 rounded-lg cursor-pointer transition-all duration-200 peer-checked:border-red-500 peer-checked:bg-red-50 hover:border-red-300">
                  <svg
                    class="w-8 h-8 text-gray-600 peer-checked:text-red-600 mb-2"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"
                    />
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                    />
                  </svg>
                  <span class="text-sm font-medium text-gray-900">Engine Bay</span>
                </div>
              </label>
            </div>
            
    <!-- Hidden input to store selected types -->
            <.input field={@form[:types]} type="hidden" value={@selected_types} />
            
    <!-- Selected Services Display -->
            <div :if={@selected_types != ""} class="bg-red-100 rounded-lg p-3">
              <p class="text-sm font-medium text-red-900 mb-2">Selected Services:</p>
              <div class="flex flex-wrap gap-2">
                <span
                  :for={service_type <- String.split(@selected_types, ",", trim: true)}
                  class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium bg-red-600 text-white"
                >
                  {String.trim(service_type)}
                  <button
                    type="button"
                    phx-click={
                      JS.push("remove_service_type",
                        value: %{type: String.trim(service_type)},
                        target: @myself
                      )
                    }
                    class="ml-1.5 text-red-200 hover:text-white"
                  >
                    <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M6 18L18 6M6 6l12 12"
                      />
                    </svg>
                  </button>
                </span>
              </div>
            </div>
          </div>
        </div>
        
    <!-- Service Details Section -->
        <div class="bg-gray-50 rounded-lg p-4 space-y-4 border border-gray-200">
          <div class="flex items-center space-x-2">
            <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"
              />
            </svg>
            <h3 class="text-lg font-medium text-gray-900">Service Details</h3>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <!-- Date and Time -->
            <div class="space-y-2">
              <.input
                field={@form[:date]}
                type="date"
                label="Service Date"
                class="block w-full rounded-lg border-gray-300 shadow-sm focus:border-red-500 focus:ring-red-500"
                required
              />
            </div>

            <div class="space-y-2">
              <.input
                field={@form[:time]}
                type="time"
                label="Service Time"
                class="block w-full rounded-lg border-gray-300 shadow-sm focus:border-red-500 focus:ring-red-500"
                required
              />
            </div>
          </div>
          
    <!-- Worker Assignment -->
          <div class="space-y-2">
            <.input
              field={@form[:worker_id]}
              type="select"
              label="Assigned Worker"
              options={@workers}
              prompt="Select the worker who performed the service"
              class="block w-full rounded-lg border-gray-300 shadow-sm focus:border-red-500 focus:ring-red-500"
              required
            />
          </div>
          
    <!-- Service Description -->
          <div class="space-y-2">
            <.input
              field={@form[:description]}
              type="textarea"
              label="Service Notes"
              placeholder="Add any special notes about the service performed..."
              rows="3"
              class="block w-full rounded-lg border-gray-300 shadow-sm focus:border-red-500 focus:ring-red-500"
            />
            <p class="text-xs text-gray-600">
              Optional: Add details about the service, customer requests, or any issues encountered
            </p>
          </div>
        </div>
        
    <!-- Payment Information Section -->
        <div class="bg-green-50 rounded-lg p-4 space-y-4 border border-green-200">
          <div class="flex items-center space-x-2">
            <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"
              />
            </svg>
            <h3 class="text-lg font-medium text-green-900">Payment Information</h3>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <!-- Total Amount -->
            <div class="space-y-2">
              <.input
                field={@form[:total_amount]}
                type="number"
                label="Total Amount (KES)"
                placeholder="0.00"
                step="0.01"
                min="0"
                class="block w-full rounded-lg border-green-300 shadow-sm focus:border-red-500 focus:ring-red-500"
                required
              />
              <p class="text-xs text-green-700">Enter the total cost for all selected services</p>
            </div>
            
    <!-- Payment Method -->
            <div class="space-y-2">
              <.input
                field={@form[:payment_method]}
                type="select"
                label="Payment Method"
                options={[
                  {"Cash", "cash"},
                  {"Credit/Debit Card", "card"},
                  {"M-Pesa", "mpesa"},
                  {"Bank Transfer", "transfer"}
                ]}
                prompt="Select payment method"
                class="block w-full rounded-lg border-green-300 shadow-sm focus:border-red-500 focus:ring-red-500"
              />
            </div>
          </div>
          
    <!-- Payment Status -->
          <div class="flex items-center space-x-3">
            <.input
              field={@form[:payment_completed]}
              type="checkbox"
              label="Payment Completed"
              class="rounded border-green-300 text-red-600 focus:ring-red-500"
            />
            <p class="text-sm text-green-700">Check this box if payment has been received</p>
          </div>
        </div>
        
    <!-- Form Actions -->
        <:actions>
          <div class="flex items-center justify-end space-x-3 pt-6 border-t border-gray-200">
            <button
              type="button"
              phx-click={JS.exec("data-cancel", to: "#service-modal")}
              class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 transition-colors duration-200"
            >
              Cancel
            </button>
            <.button
              phx-disable-with="Saving Service..."
              class="px-6 py-2 bg-red-600 hover:bg-red-700 text-white font-medium rounded-lg transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 disabled:opacity-50 disabled:cursor-not-allowed flex items-center space-x-2"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                />
              </svg>
              <span>Save Service</span>
            </.button>
          </div>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  @impl true
  def update(%{service: service, branch: branch, car: car} = assigns, socket) do
    # Get existing types from the service or default to empty
    existing_types = if service.types, do: service.types, else: ""

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:workers, Washer.Workers.list_workers_by_branch_for_select(branch.id))
     |> assign(:selected_types, existing_types)
     |> assign_new(:form, fn ->
       to_form(Services.change_service(service))
     end)}
  end

  @impl true
  def handle_event("toggle_service_type", %{"type" => type}, socket) do
    current_types = socket.assigns.selected_types

    types_list =
      if current_types == "", do: [], else: String.split(current_types, ",", trim: true)

    updated_types =
      if type in types_list do
        # Remove the service type
        Enum.reject(types_list, &(&1 == type))
      else
        # Add the service type
        [type | types_list]
      end
      |> Enum.map(&String.trim/1)
      |> Enum.join(", ")

    # Update the form with new types
    changeset = Services.change_service(socket.assigns.service, %{"types" => updated_types})

    {:noreply,
     socket
     |> assign(:selected_types, updated_types)
     |> assign(:form, to_form(changeset, action: :validate))}
  end

  @impl true
  def handle_event("remove_service_type", %{"type" => type}, socket) do
    current_types = socket.assigns.selected_types
    types_list = String.split(current_types, ",", trim: true)

    updated_types =
      Enum.reject(types_list, &(String.trim(&1) == type))
      |> Enum.map(&String.trim/1)
      |> Enum.join(", ")

    # Update the form with new types
    changeset = Services.change_service(socket.assigns.service, %{"types" => updated_types})

    {:noreply,
     socket
     |> assign(:selected_types, updated_types)
     |> assign(:form, to_form(changeset, action: :validate))}
  end

  @impl true
  def handle_event("validate", %{"service" => service_params}, socket) do
    changeset = Services.change_service(socket.assigns.service, service_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  @impl true
  def handle_event("save", %{"service" => service_params}, socket) do
    # Ensure the selected types are included in the service params
    service_params =
      service_params
      |> Map.put("types", socket.assigns.selected_types)
      |> Map.put("branch_id", socket.assigns.branch.id)
      |> Map.put("car_id", socket.assigns.car.id)
      |> Map.put("user_id", socket.assigns.current_user.id)

    save_service(socket, socket.assigns.action, service_params)
  end

  defp save_service(socket, :edit_service, service_params) do
    case Services.update_service(socket.assigns.service, service_params) do
      {:ok, service} ->
        notify_parent({:saved, service})

        {:noreply,
         socket
         |> put_flash(:info, "Service updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_service(socket, :new_service, service_params) do
    case Services.create_service(service_params) do
      {:ok, service} ->
        notify_parent({:saved, service})

        {:noreply,
         socket
         |> put_flash(:info, "Service created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

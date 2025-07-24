defmodule WasherWeb.CarLive.FormComponent do
  alias Washer.Branches.Branch
  use WasherWeb, :live_component

  alias Washer.Cars
  alias Washer.Branches

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <!-- Form Header -->
      <div class="border-b border-gray-200 pb-4">
        <div class="flex items-center space-x-3">
          <div class="bg-red-100 p-2 rounded-lg">
            <svg class="w-6 h-6 text-red-600" fill="currentColor" viewBox="0 0 20 20">
              <path
                fill-rule="evenodd"
                d="M2 9.5A3.5 3.5 0 005.5 13H14.5a3.5 3.5 0 003.5-3.5A3.5 3.5 0 0014.5 6H5.5A3.5 3.5 0 002 9.5zM5.5 8a1.5 1.5 0 100 3 1.5 1.5 0 000-3zm9 0a1.5 1.5 0 100 3 1.5 1.5 0 000-3z"
                clip-rule="evenodd"
              />
              <path d="M6.5 15a2.5 2.5 0 000 5 2.5 2.5 0 000-5zM13.5 15a2.5 2.5 0 000 5 2.5 2.5 0 000-5z" />
            </svg>
          </div>
          <div>
            <h2 class="text-xl font-semibold text-gray-900">{@title}</h2>
            <p class="text-sm text-gray-600">Register a new customer vehicle for car wash services</p>
          </div>
        </div>
      </div>
      
    <!-- Form Content -->
      <.simple_form
        for={@form}
        id="car-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="space-y-6"
      >
        <!-- Vehicle Information Section -->
        <div class="bg-red-50 rounded-lg p-4 space-y-4 border border-red-200">
          <div class="flex items-center space-x-2">
            <svg class="w-5 h-5 text-red-600" fill="currentColor" viewBox="0 0 20 20">
              <path
                fill-rule="evenodd"
                d="M2 9.5A3.5 3.5 0 005.5 13H14.5a3.5 3.5 0 003.5-3.5A3.5 3.5 0 0014.5 6H5.5A3.5 3.5 0 002 9.5zM5.5 8a1.5 1.5 0 100 3 1.5 1.5 0 000-3zm9 0a1.5 1.5 0 100 3 1.5 1.5 0 000-3z"
                clip-rule="evenodd"
              />
            </svg>
            <h3 class="text-lg font-medium text-red-900">Vehicle Information</h3>
          </div>
          
    <!-- License Plate -->
          <div class="space-y-2">
            <.input
              field={@form[:number_plate]}
              type="text"
              label="License Plate Number"
              placeholder="ABC-1234 or ABC1234"
              class="block w-full rounded-lg border-red-300 shadow-sm focus:border-red-500 focus:ring-red-500 font-mono text-lg tracking-wider uppercase bg-white"
              style="text-transform: uppercase;"
              required
            />
            <p class="text-xs text-red-700">
              Enter the vehicle's license plate number (will be automatically formatted)
            </p>
          </div>
          
    <!-- Vehicle Registration Info -->
          <div class="bg-red-100 rounded-lg p-3">
            <div class="flex items-start space-x-2">
              <svg class="w-4 h-4 text-red-600 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                <path
                  fill-rule="evenodd"
                  d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z"
                  clip-rule="evenodd"
                />
              </svg>
              <p class="text-xs text-red-800">
                Make sure the license plate number is accurate - this will be used for service tracking
              </p>
            </div>
          </div>
        </div>
        
    <!-- Customer Information Section -->
        <div class="bg-blue-50 rounded-lg p-4 space-y-4 border border-blue-200">
          <div class="flex items-center space-x-2">
            <svg class="w-5 h-5 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
              <path
                fill-rule="evenodd"
                d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z"
                clip-rule="evenodd"
              />
            </svg>
            <h3 class="text-lg font-medium text-blue-900">Customer Information</h3>
          </div>
          
    <!-- Customer Name -->
          <div class="space-y-2">
            <.input
              field={@form[:name]}
              type="text"
              label="Customer Name"
              placeholder="Enter customer's full name"
              class="block w-full rounded-lg border-blue-300 shadow-sm focus:border-red-500 focus:ring-red-500 bg-white"
              required
            />
            <p class="text-xs text-blue-700">Full name of the vehicle owner or primary contact</p>
          </div>
          
    <!-- Contact Information Grid -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <!-- Email -->
            <div class="space-y-2">
              <.input
                field={@form[:email]}
                type="email"
                label="Email Address"
                placeholder="customer@example.com"
                class="block w-full rounded-lg border-blue-300 shadow-sm focus:border-red-500 focus:ring-red-500 bg-white"
                required
              />
              <p class="text-xs text-blue-700">For service notifications and receipts</p>
            </div>
            
    <!-- Phone Number -->
            <div class="space-y-2">
              <.input
                field={@form[:phone_number]}
                type="tel"
                label="Phone Number"
                placeholder="+1 (555) 123-4567"
                class="block w-full rounded-lg border-blue-300 shadow-sm focus:border-red-500 focus:ring-red-500 bg-white"
                required
              />
              <p class="text-xs text-blue-700">Primary contact number</p>
            </div>
          </div>
        </div>
        
    <!-- Registration Location Section -->
        <div class="bg-gray-50 rounded-lg p-4 space-y-4 border border-gray-200">
          <div class="flex items-center space-x-2">
            <svg class="w-5 h-5 text-gray-600" fill="currentColor" viewBox="0 0 20 20">
              <path
                fill-rule="evenodd"
                d="M4 4a2 2 0 00-2 2v8a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2H4zm2 6a2 2 0 114 0 2 2 0 01-4 0zm8 0a2 2 0 114 0 2 2 0 01-4 0z"
                clip-rule="evenodd"
              />
            </svg>
            <h3 class="text-lg font-medium text-gray-900">Registration Location</h3>
          </div>
          
    <!-- Branch Selection -->
          <div class="space-y-2">
            <.input
              field={@form[:branch_id]}
              type="select"
              label="Registration Branch"
              options={@branches}
              prompt="Select the branch where this vehicle is being registered"
              class="block w-full rounded-lg border-gray-300 shadow-sm focus:border-red-500 focus:ring-red-500 bg-white"
              required
            />
            <p class="text-xs text-gray-600">
              Choose the branch location where this customer will primarily receive services
            </p>
          </div>
          
    <!-- Registration Info -->
          <div class="bg-gray-100 rounded-lg p-3">
            <div class="flex items-start space-x-2">
              <svg class="w-4 h-4 text-gray-600 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                <path
                  fill-rule="evenodd"
                  d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z"
                  clip-rule="evenodd"
                />
              </svg>
              <div>
                <p class="text-xs text-gray-700 font-medium">
                  Registration will be timestamped automatically
                </p>
                <p class="text-xs text-gray-600">
                  Customers can receive services at any branch after registration
                </p>
              </div>
            </div>
          </div>
        </div>
        
    <!-- Form Actions -->
        <:actions>
          <div class="flex items-center justify-end space-x-3 pt-6 border-t border-gray-200">
            <button
              type="button"
              phx-click={JS.exec("data-cancel", to: "#car-modal")}
              class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 transition-colors duration-200"
            >
              Cancel
            </button>
            <.button
              phx-disable-with="Registering..."
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
              <span>Register Vehicle</span>
            </.button>
          </div>
        </:actions>
      </.simple_form>
      
    <!-- Important Information Section -->
      <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
        <div class="flex items-start space-x-3">
          <svg class="w-5 h-5 text-yellow-600 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
            <path
              fill-rule="evenodd"
              d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z"
              clip-rule="evenodd"
            />
          </svg>
          <div>
            <h4 class="text-sm font-medium text-yellow-900">Vehicle Registration Guidelines</h4>
            <ul class="mt-2 text-sm text-yellow-800 space-y-1">
              <li>• Double-check the license plate number for accuracy</li>
              <li>• Ensure customer contact information is current and valid</li>
              <li>
                • Vehicle registration enables service history tracking and customer loyalty programs
              </li>
              <li>
                • Customers will be able to view their service history and schedule appointments
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def update(%{car: car} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:branches, Branches.list_branches_for_select())
     |> assign_new(:form, fn ->
       to_form(Cars.change_car(car))
     end)}
  end

  @impl true
  def handle_event("validate", %{"car" => car_params}, socket) do
    changeset = Cars.change_car(socket.assigns.car, car_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"car" => car_params}, socket) do
    save_car(socket, socket.assigns.action, car_params)
  end

  defp save_car(socket, :edit, car_params) do
    case Cars.update_car(socket.assigns.car, car_params) do
      {:ok, car} ->
        notify_parent({:saved, car})

        {:noreply,
         socket
         |> put_flash(:info, "Car updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_car(socket, :new, car_params) do
    case Cars.create_car(car_params) do
      {:ok, car} ->
        notify_parent({:saved, car})

        {:noreply,
         socket
         |> put_flash(:info, "Car created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

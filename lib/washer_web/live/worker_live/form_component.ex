defmodule WasherWeb.WorkerLive.FormComponent do
  use WasherWeb, :live_component

  alias Washer.Workers
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
              <path d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" />
            </svg>
          </div>
          <div>
            <h2 class="text-xl font-semibold text-gray-900">{@title}</h2>
            <p class="text-sm text-gray-600">Add a new team member to your car wash workforce</p>
          </div>
        </div>
      </div>
      
    <!-- Form Content -->
      <.simple_form
        for={@form}
        id="worker-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="space-y-6"
      >
        <!-- Personal Information Section -->
        <div class="bg-gray-50 rounded-lg p-4 space-y-4">
          <div class="flex items-center space-x-2">
            <svg class="w-5 h-5 text-gray-600" fill="currentColor" viewBox="0 0 20 20">
              <path
                fill-rule="evenodd"
                d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z"
                clip-rule="evenodd"
              />
            </svg>
            <h3 class="text-lg font-medium text-gray-900">Personal Information</h3>
          </div>
          
    <!-- Worker Name -->
          <div class="space-y-2">
            <.input
              field={@form[:name]}
              type="text"
              label="Full Name"
              placeholder="Enter worker's full name"
              class="block w-full rounded-lg border-gray-300 shadow-sm focus:border-red-500 focus:ring-red-500"
              required
            />
            <p class="text-xs text-gray-500">Enter the worker's complete legal name</p>
          </div>
        </div>
        
    <!-- Contact Information Section -->
        <div class="bg-gray-50 rounded-lg p-4 space-y-4">
          <div class="flex items-center space-x-2">
            <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M3 8l7.89 4.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
              />
            </svg>
            <h3 class="text-lg font-medium text-gray-900">Contact Information</h3>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <!-- Email -->
            <div class="space-y-2">
              <.input
                field={@form[:email]}
                type="email"
                label="Email Address"
                placeholder="worker@example.com"
                class="block w-full rounded-lg border-gray-300 shadow-sm focus:border-red-500 focus:ring-red-500"
                required
              />
              <p class="text-xs text-gray-500">Primary email for work communications</p>
            </div>
            
    <!-- Phone Number -->
            <div class="space-y-2">
              <.input
                field={@form[:phone_number]}
                type="tel"
                label="Phone Number"
                placeholder="+1 (555) 123-4567"
                class="block w-full rounded-lg border-gray-300 shadow-sm focus:border-red-500 focus:ring-red-500"
                required
              />
              <p class="text-xs text-gray-500">Contact number for scheduling and emergencies</p>
            </div>
          </div>
        </div>
        
    <!-- Work Assignment Section -->
        <div class="bg-blue-50 rounded-lg p-4 space-y-4 border border-blue-200">
          <div class="flex items-center space-x-2">
            <svg class="w-5 h-5 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
              <path
                fill-rule="evenodd"
                d="M4 4a2 2 0 00-2 2v8a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2H4zm2 6a2 2 0 114 0 2 2 0 01-4 0zm8 0a2 2 0 114 0 2 2 0 01-4 0z"
                clip-rule="evenodd"
              />
            </svg>
            <h3 class="text-lg font-medium text-blue-900">Work Assignment</h3>
          </div>
          
    <!-- Branch Selection -->
          <div class="space-y-2">
            <.input
              field={@form[:branch_id]}
              type="select"
              label="Assigned Branch"
              options={@branches}
              prompt="Select the branch location"
              class="block w-full rounded-lg border-blue-300 shadow-sm focus:border-red-500 focus:ring-red-500 bg-white"
              required
            />
            <p class="text-xs text-blue-700">
              Choose which branch this worker will be primarily assigned to
            </p>
          </div>
          
    <!-- Branch Info Helper -->
          <div class="bg-blue-100 rounded-lg p-3">
            <div class="flex items-start space-x-2">
              <svg class="w-4 h-4 text-blue-600 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                <path
                  fill-rule="evenodd"
                  d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z"
                  clip-rule="evenodd"
                />
              </svg>
              <p class="text-xs text-blue-800">
                Workers can be reassigned to different branches later if needed
              </p>
            </div>
          </div>
        </div>
        
    <!-- Form Actions -->
        <:actions>
          <div class="flex items-center justify-end space-x-3 pt-6 border-t border-gray-200">
            <button
              type="button"
              phx-click={JS.exec("data-cancel", to: "#worker-modal")}
              class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 transition-colors duration-200"
            >
              Cancel
            </button>
            <.button
              phx-disable-with="Saving..."
              class="px-6 py-2 bg-red-600 hover:bg-red-700 text-white font-medium rounded-lg transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 disabled:opacity-50 disabled:cursor-not-allowed flex items-center space-x-2"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
                />
              </svg>
              <span>Save Worker</span>
            </.button>
          </div>
        </:actions>
      </.simple_form>
      
    <!-- Additional Help Section -->
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
            <h4 class="text-sm font-medium text-yellow-900">Important Notes</h4>
            <ul class="mt-2 text-sm text-yellow-800 space-y-1">
              <li>• Ensure all contact information is accurate for payroll and emergency purposes</li>
              <li>• Workers will receive login credentials after their account is created</li>
              <li>• Branch assignments can be changed later from the worker's profile page</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def update(%{worker: worker} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:branches, Branches.list_branches_for_select())
     |> assign_new(:form, fn ->
       to_form(Workers.change_worker(worker))
     end)}
  end

  @impl true
  def handle_event("validate", %{"worker" => worker_params}, socket) do
    changeset = Workers.change_worker(socket.assigns.worker, worker_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"worker" => worker_params}, socket) do
    save_worker(socket, socket.assigns.action, worker_params)
  end

  defp save_worker(socket, :edit, worker_params) do
    case Workers.update_worker(socket.assigns.worker, worker_params) do
      {:ok, worker} ->
        notify_parent({:saved, worker})

        {:noreply,
         socket
         |> put_flash(:info, "Worker updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_worker(socket, :new, worker_params) do
    case Workers.create_worker(worker_params) do
      {:ok, worker} ->
        notify_parent({:saved, worker})

        {:noreply,
         socket
         |> put_flash(:info, "Worker created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

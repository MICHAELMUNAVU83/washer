defmodule WasherWeb.BranchLive.FormComponent do
  use WasherWeb, :live_component

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
                d="M4 4a2 2 0 00-2 2v8a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2H4zm2 6a2 2 0 114 0 2 2 0 01-4 0zm8 0a2 2 0 114 0 2 2 0 01-4 0z"
                clip-rule="evenodd"
              />
            </svg>
          </div>
          <div>
            <h2 class="text-xl font-semibold text-gray-900">{@title}</h2>
            <p class="text-sm text-gray-600">Add a new branch location to your car wash network</p>
          </div>
        </div>
      </div>
      
    <!-- Form Content -->
      <.simple_form
        for={@form}
        id="branch-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="space-y-6"
      >
        <!-- Branch Name Input -->
        <div class="space-y-2">
          <.input
            field={@form[:name]}
            type="text"
            label="Branch Name"
            placeholder="Enter branch name (e.g., Downtown Location)"
            class="block w-full rounded-lg border-gray-300 shadow-sm focus:border-red-500 focus:ring-red-500"
            required
          />
          <p class="text-xs text-gray-500">
            Choose a descriptive name that helps identify this location
          </p>
        </div>
        
    <!-- Location Input -->
        <div class="space-y-2">
          <.input
            field={@form[:location]}
            type="text"
            label="Location Address"
            placeholder="Enter full address (e.g., 123 Main St, City, State)"
            class="block w-full rounded-lg border-gray-300 shadow-sm focus:border-red-500 focus:ring-red-500"
            required
          />
          <p class="text-xs text-gray-500">Provide the complete address for this branch location</p>
        </div>
        
    <!-- Form Actions -->
        <:actions>
          <div class="flex items-center justify-end space-x-3 pt-6 border-t border-gray-200">
            <button
              type="button"
              phx-click={JS.exec("data-cancel", to: "#branch-modal")}
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
                  d="M5 13l4 4L19 7"
                />
              </svg>
              <span>Save Branch</span>
            </.button>
          </div>
        </:actions>
      </.simple_form>
      
    <!-- Help Section -->
      <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
        <div class="flex items-start space-x-3">
          <svg class="w-5 h-5 text-blue-600 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
            <path
              fill-rule="evenodd"
              d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z"
              clip-rule="evenodd"
            />
          </svg>
          <div>
            <h4 class="text-sm font-medium text-blue-900">Branch Setup Tips</h4>
            <ul class="mt-2 text-sm text-blue-800 space-y-1">
              <li>• Use clear, recognizable names for easy identification</li>
              <li>• Include complete addresses for accurate location tracking</li>
              <li>• Consider adding landmarks or nearby references in the location</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def update(%{branch: branch} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Branches.change_branch(branch))
     end)}
  end

  @impl true
  def handle_event("validate", %{"branch" => branch_params}, socket) do
    changeset = Branches.change_branch(socket.assigns.branch, branch_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"branch" => branch_params}, socket) do
    save_branch(socket, socket.assigns.action, branch_params)
  end

  defp save_branch(socket, :edit, branch_params) do
    case Branches.update_branch(socket.assigns.branch, branch_params) do
      {:ok, branch} ->
        notify_parent({:saved, branch})

        {:noreply,
         socket
         |> put_flash(:info, "Branch updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_branch(socket, :new, branch_params) do
    case Branches.create_branch(branch_params) do
      {:ok, branch} ->
        notify_parent({:saved, branch})

        {:noreply,
         socket
         |> put_flash(:info, "Branch created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

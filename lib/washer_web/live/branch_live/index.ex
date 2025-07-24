defmodule WasherWeb.BranchLive.Index do
  use WasherWeb, :system_live_view

  alias Washer.Branches
  alias Washer.Branches.Branch

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Branches")
     |> assign(:current_page, "branches")
     |> stream(:branches, Branches.list_branches())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Branch")
    |> assign(:branch, Branches.get_branch!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Branch")
    |> assign(:branch, %Branch{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Branches")
    |> assign(:branch, nil)
  end

  @impl true
  def handle_info({WasherWeb.BranchLive.FormComponent, {:saved, branch}}, socket) do
    {:noreply, stream_insert(socket, :branches, branch)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    branch = Branches.get_branch!(id)
    {:ok, _} = Branches.delete_branch(branch)

    {:noreply, stream_delete(socket, :branches, branch)}
  end

  @impl true

  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <!-- Header Section -->
      <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-2xl font-bold text-gray-900">Branches</h1>
            <p class="text-gray-600 mt-1">Manage your car wash locations</p>
          </div>
          <.link patch={~p"/branches/new"}>
            <.button class="bg-red-600 hover:bg-red-700 text-white px-6 py-2 rounded-lg font-medium transition-colors duration-200 flex items-center space-x-2">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 6v6m0 0v6m0-6h6m-6 0H6"
                />
              </svg>
              <span>New Branch</span>
            </.button>
          </.link>
        </div>
      </div>
      
    <!-- Table using the new improved component -->
      <.table
        id="branches"
        rows={@streams.branches}
        row_click={fn {_id, branch} -> JS.navigate(~p"/branches/#{branch}") end}
      >
        <:col :let={branch} label="Branch Name">
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
              <p class="font-semibold text-gray-900">{branch.name}</p>
              <p class="text-sm text-gray-500">Branch Location</p>
            </div>
          </div>
        </:col>

        <:col :let={branch} label="Location">
          <div class="flex items-center space-x-2">
            <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
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
            <span>{branch.location}</span>
          </div>
        </:col>

        <:col :let={branch} label="Status" class="text-center">
          <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
            <span class="w-1.5 h-1.5 bg-green-400 rounded-full mr-1.5"></span> Active
          </span>
        </:col>

        <:action :let={branch}>
          <.table_action
            navigate={~p"/branches/#{branch}"}
            variant="secondary"
            title="View branch details"
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
          </.table_action>
        </:action>

        <:action :let={branch}>
          <.table_action patch={~p"/branches/#{branch}/edit"} variant="primary" title="Edit branch">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
              />
            </svg>
          </.table_action>
        </:action>

        <:action :let={branch}>
          <.table_action
            phx_click={JS.push("delete", value: %{id: branch.id})}
            data_confirm="Are you sure you want to delete this branch? This action cannot be undone."
            variant="danger"
            title="Delete branch"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
              />
            </svg>
          </.table_action>
        </:action>
      </.table>
    </div>

    <!-- Modal -->
    <.modal
      :if={@live_action in [:new, :edit]}
      id="branch-modal"
      show
      on_cancel={JS.patch(~p"/branches")}
    >
      <.live_component
        module={WasherWeb.BranchLive.FormComponent}
        id={@branch.id || :new}
        title={@page_title}
        action={@live_action}
        branch={@branch}
        patch={~p"/branches"}
      />
    </.modal>
    """
  end
end

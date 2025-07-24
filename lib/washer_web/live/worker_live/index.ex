defmodule WasherWeb.WorkerLive.Index do
  use WasherWeb, :system_live_view

  alias Washer.Workers
  alias Washer.Workers.Worker

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Workers")
     |> assign(:current_page, "workers")
     |> stream(:workers, Workers.list_workers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Worker")
    |> assign(:worker, Workers.get_worker!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Worker")
    |> assign(:worker, %Worker{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Workers")
    |> assign(:worker, nil)
  end

  @impl true
  def handle_info({WasherWeb.WorkerLive.FormComponent, {:saved, worker}}, socket) do
    {:noreply, stream_insert(socket, :workers, worker)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    worker = Workers.get_worker!(id)
    {:ok, _} = Workers.delete_worker(worker)

    {:noreply, stream_delete(socket, :workers, worker)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <!-- Header Section -->
      <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-2xl font-bold text-gray-900">Workers</h1>
            <p class="text-gray-600 mt-1">Manage your car wash team members</p>
          </div>
          <.link patch={~p"/workers/new"}>
            <.button class="bg-red-600 hover:bg-red-700 text-white px-6 py-2 rounded-lg font-medium transition-colors duration-200 flex items-center space-x-2">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 6v6m0 0v6m0-6h6m-6 0H6"
                />
              </svg>
              <span>New Worker</span>
            </.button>
          </.link>
        </div>
      </div>
      
    <!-- Table using the improved component -->
      <.table
        id="workers"
        rows={@streams.workers}
        row_click={fn {_id, worker} -> JS.navigate("/workers/#{worker.id}") end}
      >
        <:col :let={worker} label="Worker">
          <div class="flex items-center space-x-3">
            <div class="bg-red-100 p-2 rounded-lg">
              <svg class="w-5 h-5 text-red-600" fill="currentColor" viewBox="0 0 20 20">
                <path d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" />
              </svg>
            </div>
            <div>
              <p class="font-semibold text-gray-900">{worker.name}</p>
              <p class="text-sm text-gray-500">{worker.email}</p>
            </div>
          </div>
        </:col>

        <:col :let={worker} label="Contact">
          <div class="space-y-1">
            <div class="flex items-center space-x-2">
              <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M3 8l7.89 4.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
                />
              </svg>
              <span class="text-sm text-gray-700">{worker.email}</span>
            </div>
            <div class="flex items-center space-x-2">
              <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"
                />
              </svg>
              <span class="text-sm text-gray-700">{worker.phone_number}</span>
            </div>
          </div>
        </:col>

        <:col :let={worker} label="Branch">
          <div class="flex items-center space-x-2">
            <div class="bg-blue-100 p-1.5 rounded-lg">
              <svg class="w-4 h-4 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
                <path
                  fill-rule="evenodd"
                  d="M4 4a2 2 0 00-2 2v8a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2H4zm2 6a2 2 0 114 0 2 2 0 01-4 0zm8 0a2 2 0 114 0 2 2 0 01-4 0z"
                  clip-rule="evenodd"
                />
              </svg>
            </div>
            <div :if={worker.branch}>
              <p class="font-medium text-gray-900">{worker.branch && worker.branch.name}</p>
              <p class="text-xs text-gray-500">{worker.branch.location}</p>
            </div>
          </div>
        </:col>

        <:col :let={worker} label="Status">
          <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
            <span class="w-1.5 h-1.5 bg-green-400 rounded-full mr-1.5"></span> Active
          </span>
        </:col>

        <:action :let={worker}>
          <.table_action
            navigate={~p"/workers/#{worker}"}
            variant="secondary"
            title="View worker details"
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

        <:action :let={worker}>
          <.table_action patch={~p"/workers/#{worker}/edit"} variant="primary" title="Edit worker">
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

        <:action :let={worker}>
          <.table_action
            phx_click={JS.push("delete", value: %{id: worker.id})}
            data_confirm="Are you sure you want to remove this worker? This action cannot be undone."
            variant="danger"
            title="Remove worker"
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
      id="worker-modal"
      show
      on_cancel={JS.patch(~p"/workers")}
    >
      <.live_component
        module={WasherWeb.WorkerLive.FormComponent}
        id={@worker.id || :new}
        title={@page_title}
        action={@live_action}
        worker={@worker}
        patch={~p"/workers"}
      />
    </.modal>
    """
  end
end

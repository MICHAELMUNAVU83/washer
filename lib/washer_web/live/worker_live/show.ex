defmodule WasherWeb.WorkerLive.Show do
  use WasherWeb, :live_view

  alias Washer.Workers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:worker, Workers.get_worker!(id))}
  end

  defp page_title(:show), do: "Show Worker"
  defp page_title(:edit), do: "Edit Worker"
end

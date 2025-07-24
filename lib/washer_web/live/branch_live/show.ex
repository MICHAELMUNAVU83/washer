defmodule WasherWeb.BranchLive.Show do
  use WasherWeb, :live_view

  alias Washer.Branches

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:branch, Branches.get_branch!(id))}
  end

  defp page_title(:show), do: "Show Branch"
  defp page_title(:edit), do: "Edit Branch"
end

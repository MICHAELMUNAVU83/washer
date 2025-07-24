defmodule WasherWeb.HomeLive.Index do
  use WasherWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, push_redirect(socket, to: "/dashboard")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center h-screen bg-gray-100">
      <div class="text-center">
        <h1 class="text-4xl font-bold text-gray-900">Welcome to Washer</h1>
        <p class="mt-4 text-lg text-gray-600">Redirecting to your dashboard...</p>
      </div>
    </div>
    """
  end
end

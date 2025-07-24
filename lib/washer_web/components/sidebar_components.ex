defmodule WasherWeb.SidebarComponents do
  use Phoenix.Component

  attr :current_page, :string, default: "dashboard"
  attr :class, :string, default: ""

  def sidebar(assigns) do
    ~H"""
    <div class={"#{@class} bg-red-600 text-white h-screen w-64 fixed left-0 top-0 shadow-lg"}>
      <!-- Logo/Brand Section -->
      <div class="p-6 border-b border-red-500">
        <div class="flex items-center space-x-3">
          <div class="bg-white p-2 rounded-lg">
            <svg class="w-8 h-8 text-red-600" fill="currentColor" viewBox="0 0 20 20">
              <path d="M3 4a1 1 0 011-1h12a1 1 0 011 1v2a1 1 0 01-1 1H4a1 1 0 01-1-1V4zM3 10a1 1 0 011-1h6a1 1 0 011 1v6a1 1 0 01-1 1H4a1 1 0 01-1-1v-6zM14 9a1 1 0 00-1 1v6a1 1 0 001 1h2a1 1 0 001-1v-6a1 1 0 00-1-1h-2z" />
            </svg>
          </div>
          <div>
            <h1 class="text-xl font-bold text-white">CarWash Pro</h1>
            <p class="text-red-200 text-sm">Management System</p>
          </div>
        </div>
      </div>
      
    <!-- Navigation Menu -->
      <nav class="mt-6">
        <ul class="space-y-2 px-4">
          <!-- Dashboard -->
          <li>
            <.sidebar_link
              href="/dashboard"
              current_page={@current_page}
              page="dashboard"
              icon="dashboard"
            >
              Dashboard
            </.sidebar_link>
          </li>
          
    <!-- Branches -->
          <li>
            <.sidebar_link
              href="/branches"
              current_page={@current_page}
              page="branches"
              icon="branches"
            >
              Branches
            </.sidebar_link>
          </li>
          
    <!-- Workers -->
          <li>
            <.sidebar_link href="/workers" current_page={@current_page} page="workers" icon="workers">
              Workers
            </.sidebar_link>
          </li>
          
    <!-- Cars -->
          <li>
            <.sidebar_link href="/cars" current_page={@current_page} page="cars" icon="cars">
              Cars
            </.sidebar_link>
          </li>
        </ul>
      </nav>
      
    <!-- User Section -->
      <div class="absolute bottom-0 left-0 right-0 p-4 border-t border-red-500">
        <div class="flex items-center space-x-3">
          <div class="bg-white p-2 rounded-full">
            <svg class="w-6 h-6 text-red-600" fill="currentColor" viewBox="0 0 20 20">
              <path
                fill-rule="evenodd"
                d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z"
                clip-rule="evenodd"
              />
            </svg>
          </div>
          <div class="flex-1">
            <p class="text-white font-medium text-sm">Admin User</p>
            <p class="text-red-200 text-xs">admin@carwash.com</p>
          </div>
          <button class="text-red-200 hover:text-white transition-colors">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"
              />
            </svg>
          </button>
        </div>
      </div>
    </div>
    """
  end

  attr :href, :string, required: true
  attr :current_page, :string, required: true
  attr :page, :string, required: true
  attr :icon, :string, required: true
  slot :inner_block, required: true

  defp sidebar_link(assigns) do
    ~H"""
    <a
      href={@href}
      class={[
        "flex items-center space-x-3 px-4 py-3 rounded-lg transition-all duration-200 group",
        if(@current_page == @page,
          do: "bg-white text-red-600 shadow-md",
          else: "text-red-100 hover:bg-red-500 hover:text-white"
        )
      ]}
    >
      <div class={[
        "transition-colors duration-200",
        if(@current_page == @page, do: "text-red-600", else: "text-red-200 group-hover:text-white")
      ]}>
        <.icon name={@icon} />
      </div>
      <span class="font-medium">
        {render_slot(@inner_block)}
      </span>
      <!-- Active indicator -->
      <%= if @current_page == @page do %>
        <div class="ml-auto w-1 h-6 bg-red-600 rounded-full"></div>
      <% end %>
    </a>
    """
  end

  attr :name, :string, required: true

  defp icon(%{name: "dashboard"} = assigns) do
    ~H"""
    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
      <path d="M3 4a1 1 0 011-1h12a1 1 0 011 1v2a1 1 0 01-1 1H4a1 1 0 01-1-1V4zM3 10a1 1 0 011-1h6a1 1 0 011 1v6a1 1 0 01-1 1H4a1 1 0 01-1-1v-6zM14 9a1 1 0 00-1 1v6a1 1 0 001 1h2a1 1 0 001-1v-6a1 1 0 00-1-1h-2z" />
    </svg>
    """
  end

  defp icon(%{name: "branches"} = assigns) do
    ~H"""
    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
      <path
        fill-rule="evenodd"
        d="M4 4a2 2 0 00-2 2v8a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2H4zm2 6a2 2 0 114 0 2 2 0 01-4 0zm8 0a2 2 0 114 0 2 2 0 01-4 0z"
        clip-rule="evenodd"
      />
    </svg>
    """
  end

  defp icon(%{name: "workers"} = assigns) do
    ~H"""
    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
      <path d="M9 6a3 3 0 11-6 0 3 3 0 016 0zM17 6a3 3 0 11-6 0 3 3 0 016 0zM12.93 17c.046-.327.07-.66.07-1a6.97 6.97 0 00-1.5-4.33A5 5 0 0119 16v1h-6.07zM6 11a5 5 0 015 5v1H1v-1a5 5 0 015-5z" />
    </svg>
    """
  end

  defp icon(%{name: "cars"} = assigns) do
    ~H"""
    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
      <path
        fill-rule="evenodd"
        d="M2 9.5A3.5 3.5 0 005.5 13H14.5a3.5 3.5 0 003.5-3.5A3.5 3.5 0 0014.5 6H5.5A3.5 3.5 0 002 9.5zM5.5 8a1.5 1.5 0 100 3 1.5 1.5 0 000-3zm9 0a1.5 1.5 0 100 3 1.5 1.5 0 000-3z"
        clip-rule="evenodd"
      />
      <path d="M6.5 15a2.5 2.5 0 000 5 2.5 2.5 0 000-5zM13.5 15a2.5 2.5 0 000 5 2.5 2.5 0 000-5z" />
    </svg>
    """
  end
end

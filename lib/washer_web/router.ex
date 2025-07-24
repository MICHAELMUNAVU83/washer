defmodule WasherWeb.Router do
  use WasherWeb, :router

  import WasherWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {WasherWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WasherWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", WasherWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:washer, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: WasherWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", WasherWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{WasherWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", WasherWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{WasherWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end

    live_session :current_user,
      on_mount: [{WasherWeb.UserAuth, :mount_current_user}] do
      live "/branches", BranchLive.Index, :index
      live "/branches/new", BranchLive.Index, :new
      live "/branches/:id/edit", BranchLive.Index, :edit

      live "/branches/:id", BranchLive.Show, :show
      live "/branches/:id/show/edit", BranchLive.Show, :edit

      live "/workers", WorkerLive.Index, :index
      live "/workers/new", WorkerLive.Index, :new
      live "/workers/:id/edit", WorkerLive.Index, :edit

      live "/workers/:id", WorkerLive.Show, :show
      live "/workers/:id/show/edit", WorkerLive.Show, :edit

      live "/cars", CarLive.Index, :index
      live "/cars/new", CarLive.Index, :new
      live "/cars/:id/edit", CarLive.Index, :edit

      live "/cars/:id", CarLive.Show, :show
      live "/cars/:id/show/edit", CarLive.Show, :edit

      live "/services", ServiceLive.Index, :index
      live "/services/new", ServiceLive.Index, :new
      live "/services/:id/edit", ServiceLive.Index, :edit

      live "/services/:id", ServiceLive.Show, :show
      live "/services/:id/show/edit", ServiceLive.Show, :edit
    end
  end

  scope "/", WasherWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
  end
end

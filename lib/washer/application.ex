defmodule Washer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WasherWeb.Telemetry,
      Washer.Repo,
      {DNSCluster, query: Application.get_env(:washer, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Washer.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Washer.Finch},
      # Start a worker by calling: Washer.Worker.start_link(arg)
      # {Washer.Worker, arg},
      # Start to serve requests, typically the last entry
      WasherWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Washer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WasherWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule Speed.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Run Migrations
    # SQLite needs to run migrations within the app since it's not a standalone server like postgres
    Speed.Release.migrate()

    children = [
      # Start the Ecto repository
      Speed.Repo,
      # Start the Telemetry supervisor
      SpeedWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Speed.PubSub},
      # Start the Endpoint (http/https)
      SpeedWeb.Endpoint
      # Start a worker by calling: Speed.Worker.start_link(arg)
      # {Speed.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Speed.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SpeedWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

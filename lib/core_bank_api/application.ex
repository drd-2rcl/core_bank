defmodule CoreBankApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      CoreBankApi.Repo,
      # Start the Telemetry supervisor
      CoreBankApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: CoreBankApi.PubSub},
      # Start the Endpoint (http/https)
      CoreBankApiWeb.Endpoint
      # Start a worker by calling: CoreBankApi.Worker.start_link(arg)
      # {CoreBankApi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CoreBankApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CoreBankApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

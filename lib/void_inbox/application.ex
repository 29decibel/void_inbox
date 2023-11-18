defmodule VoidInbox.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      VoidInboxWeb.Telemetry,
      VoidInbox.Repo,
      {DNSCluster, query: Application.get_env(:void_inbox, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: VoidInbox.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: VoidInbox.Finch},
      # Start a worker by calling: VoidInbox.Worker.start_link(arg)
      # {VoidInbox.Worker, arg},
      # Start to serve requests, typically the last entry
      VoidInboxWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VoidInbox.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VoidInboxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule Scope.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Scope.Worker.start_link(arg)
      # {Scope.Worker, arg},
      # %{
      #   id: Phoenix.PubSub.PG2,
      #   start: {Phoenix.PubSub.PG2, :start_link, [:servers, []]}
      # },
      # supervisor(Phoenix.PubSub.PG2, [Scope.PubSub, []])
      { Messages.Repo, name: Messages.Repo },
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Scope.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

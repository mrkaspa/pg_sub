defmodule PgSub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    children = [
      worker(PgSub.Worker, [Test.Repo, "evt_test"], id: PgSub.Worker, restart: :transient)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PgSub.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

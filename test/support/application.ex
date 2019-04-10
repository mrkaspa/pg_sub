defmodule Test.Application do
  @moduledoc false

  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    config = Application.get_env(:pg_sub, PgSub.Worker, [])
    repo = Keyword.fetch!(config, :repo)
    event_name = Keyword.fetch!(config, :event_name)
    handler = Keyword.fetch!(config, :handler)

    # Define supervisors and child supervisors to be supervised
    children = [
      supervisor(Test.Repo, []),
      worker(PgSub.Worker, [repo, event_name, handler], id: PgSub.Worker, restart: :transient)
    ]

    opts = [strategy: :one_for_one, name: Test.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

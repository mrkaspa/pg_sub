defmodule PgSub.Worker do
  use GenServer
  require Logger

  def start_link(repo, event_name, handler) do
    GenServer.start_link(__MODULE__, [repo, event_name, handler], [])
  end

  @impl true
  def init([repo, event_name, handler]) do
    listen(repo, event_name)
    {:ok, %{repo: repo, event_name: event_name, handler: handler}}
  end

  @impl true
  def handle_info({:notification, _pid, _ref, event, payload}, %{handler: handler}) do
    with {:ok, data} <- Jason.decode(payload, keys: :atoms) do
      apply(handler, :handle, [event, data])

      {:noreply, :event_handled}
    else
      error -> {:stop, error, []}
    end
  end

  def listen(repo, event_name) do
    config = apply(repo, :config, [])

    with {:ok, pid} <- Postgrex.Notifications.start_link(config),
         {:ok, ref} <- Postgrex.Notifications.listen(pid, event_name) do
      {:ok, pid, ref}
    end
  end
end

defmodule Test.Handler do
  require Logger

  def handle(event, data) do
    Logger.info(event)
    data |> inspect() |> Logger.info()
  end
end

defmodule PgSubTest do
  use ExUnit.Case
  import Mock

  setup do
    Test.DB.setup()
    {:ok, %{}}
  end

  test "inserts an user" do
    current_self = self()

    with_mock(Test.Handler,
      handle: fn event_name, data ->
        send(current_self, {:data, data})
      end
    ) do
      Test.DB.insert_user()

      receive do
        {:data, data} ->
          assert %{operation: "INSERT", record: %{email: "demo", id: 1, pass: "demo00"}} = data
      end
    end
  end
end

defmodule Test.Repo do
  use Ecto.Repo, otp_app: :pg_sub, adapter: Ecto.Adapters.Postgres
end

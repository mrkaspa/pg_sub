use Mix.Config

config :pg_sub, Test.Repo,
  url: System.get_env("DB_URL"),
  timeout: 999_999,
  ownership_timeout: 999_999,
  pool: Ecto.Adapters.SQL.Sandbox

config :pg_sub, PgSub.Worker,
  repo: Test.Repo,
  event_name: "evt_test",
  handler: Test.Handler

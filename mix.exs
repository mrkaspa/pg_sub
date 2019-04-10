defmodule PgSub.MixProject do
  use Mix.Project

  def project do
    [
      app: :pg_sub,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    if Mix.env() == :test do
      [extra_applications: [:logger], mod: {Test.Application, []}]
    else
      [extra_applications: [:logger], mod: {PgSub.Application, []}]
    end
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ecto, "~> 3.1"},
      {:ecto_sql, "~> 3.1"},
      {:postgrex, "~> 0.14.1"},
      {:poolboy, "~> 1.5"},
      {:jason, "~> 1.1"},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end
end

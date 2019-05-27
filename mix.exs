defmodule DropAlley.Mixfile do
  use Mix.Project

  def project do
    [
      app: :drop_alley,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {DropAlley.Application, []},
      extra_applications: [:logger, :runtime_tools, :coherence, :gettext, :swoosh, :phoenix_swoosh, :arc_ecto, :faker_elixir_octopus, :edeliver]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:cowboy, "~> 1.0"},
      {:gettext, "~>0.15.0"},
      {:coherence, "~> 0.5"},
      {:coherence_assent, "~> 0.2"},
      {:swoosh, "~> 0.15"},
      {:phoenix_swoosh, "~> 0.2"},
      {:torch, "~> 2.0.0-rc.1"},
      # {:phoenix_oauth2_provider, "~> 0.3"},
      {:guardian, "~> 1.0"},
      {:cors_plug, "~> 1.5"},
      {:arc, "~> 0.10.0"},
      {:faker_elixir_octopus, "~> 1.0.2"},
      {:phoenix_swagger, "~> 0.8"},
      {:ex_json_schema, "~> 0.5"},
      {:edeliver, "~> 1.4.3"},
      {:distillery, "~> 1.4"},
      {:arc_ecto, "~> 0.10.0"}, #and this
      {:nimble_csv, "~> 0.3"},
      {:plug_cowboy, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end

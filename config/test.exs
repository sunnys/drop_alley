use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :drop_alley, DropAlleyWeb.Endpoint,
  http: [port: System.get_env("PORT")],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :drop_alley, DropAlley.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "drop_alley_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

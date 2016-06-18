use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cataloger, Cataloger.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :cataloger, Cataloger.Repo,
  adapter: Sqlite.Ecto,
  database: "db/cataloger_test.sqlite",
  pool: Ecto.Adapters.SQL.Sandbox

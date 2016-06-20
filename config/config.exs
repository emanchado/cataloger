# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :cataloger, Cataloger.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "NGSEqJgkYfI3dx9xXrN/8vS43BNis4CwliCen5x4BJpP6oz4iRfm77wdVcMGCfiR",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Cataloger.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :cataloger,
  store: [images: "./catalog_files/images"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

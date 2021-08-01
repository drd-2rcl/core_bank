# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :core_bank_api,
  ecto_repos: [CoreBankApi.Repo]

# Configures primary and foreign key with binary_id
config :core_bank_api, CoreBankApi.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

# Configures the Bamboo
config :core_bank_api, CoreBankApi.Mailer, adapter: Bamboo.LocalAdapter

# Configures the Guardian
config :core_bank_api, CoreBankApiWeb.Auth.Guardian,
  issuer: "core_bank_api",
  secret_key: "9DtTfpCXWSnEEsuy25eOCajja8/55Ot0EFYjrqGAAMKIjUzXoAHKStGNeZGte9OB"

# Configures the Pipeline to Guardian
config :core_bank_api, CoreBankApiWeb.Auth.Pipeline,
  module: CoreBankApiWeb.Auth.Guardian,
  error_handler: CoreBankApiWeb.Auth.ErrorHandler

# Configures the endpoint
config :core_bank_api, CoreBankApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "o4abuwQTxkeuxjy8mhrZvoFNOs0nOEV1Qz9MH6GifwHrHbIbZRQNhVCZoc9MvkT+",
  render_errors: [view: CoreBankApiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: CoreBankApi.PubSub,
  live_view: [signing_salt: "SFvmnvG8"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :core_bank_api, CoreBankApi.Repo,
  username: "postgres",
  password: "postgres",
  database: "core_bank_api_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox

if System.get_env("GITHUB_ACTIONS") do
  config :core_bank_api, CoreBankApi.Repo, hostname: "localhost"
end

# Configures the BambooTest
config :core_bank_api, CoreBankApi.Bamboo, adapter: Bamboo.TestAdapter

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :core_bank_api, CoreBankApiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

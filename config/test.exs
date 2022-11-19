import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :speed, Speed.Repo,
  database: Path.expand("../speed_test.db", Path.dirname(__ENV__.file)),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :speed, SpeedWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "rOOLTF6lBjCAfZnTAQvNy6MfmO5CNH1tbUdtfFutnriz810qv7mcnDwkyLTidsFN",
  server: false

# In test we don't send emails.
config :speed, Speed.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :speed, Speed.Findings.Clearbit,
  api_key: "CLEARBIT_API_KEY",
  domain_adapter: &Speed.Findings.ClearbitMock.domain/1,
  details_adapter: &Speed.Findings.ClearbitMock.details/1

import Config

config :mobilizon, Mobilizon.Web.Endpoint,
  http: [
    port: 4000
  ],
  url: [
    host: "mobilizon.local",
    scheme: "https",
    port: 443
  ]

# Do not print debug messages in production
config :logger, level: :info

# Load all locales in production
config :mobilizon, :cldr,
  locales: [
    "ca",
    "de",
    "en",
    "es",
    "fr",
    "gl",
    "it",
    "nl",
    "pl",
    "pt",
    "ru"
  ]

cond do
  System.get_env("INSTANCE_CONFIG") &&
      File.exists?("./config/#{System.get_env("INSTANCE_CONFIG")}") ->
    import_config System.get_env("INSTANCE_CONFIG")

  File.exists?("./config/prod.secret.exs") ->
    import_config "prod.secret.exs"

  true ->
    require Logger
    Logger.error("No configuration file found")
end

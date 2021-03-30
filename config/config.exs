# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

# General application configuration
config :mobilizon,
  ecto_repos: [Mobilizon.Storage.Repo],
  env: config_env()

config :mobilizon, Mobilizon.Storage.Repo, types: Mobilizon.Storage.PostgresTypes

config :mobilizon, :instance,
  name: "Vive el Valle",
  description: "Crea y organiza eventos dentro de la Sierra de la Demanda",
  hostname: "localhost",
  registrations_open: true,
  registration_email_allowlist: [],
  languages: [],
  default_language: "es",
  demo: false,
  repository: Mix.Project.config()[:source_url],
  allow_relay: true,
  federating: false,
  remote_limit: 100_000,
  upload_limit: 10_000_000,
  avatar_upload_limit: 2_000_000,
  banner_upload_limit: 4_000_000,
  remove_orphan_uploads: true,
  orphan_upload_grace_period_hours: 48,
  remove_unconfirmed_users: true,
  unconfirmed_user_grace_period_hours: 48,
  email_from: "vive@elvalledigital.es",
  email_reply_to: "vive@elvalledigital.es"

config :mobilizon, :groups, enabled: true

config :mobilizon, :events, creation: true

# Configures the endpoint
config :mobilizon, Mobilizon.Web.Endpoint,
  http: [
    transport_options: [socket_opts: [:inet6]]
  ],
  url: [
    host: "mobilizon.local",
    scheme: "https"
  ],
  secret_key_base: "1yOazsoE0Wqu4kXk3uC5gu3jDbShOimTCzyFL3OjCdBmOXMyHX87Qmf3+Tu9s0iM",
  render_errors: [view: Mobilizon.Web.ErrorView, accepts: ~w(html json)],
  pubsub_server: Mobilizon.PubSub,
  cache_static_manifest: "priv/static/manifest.json",
  has_reverse_proxy: true

config :mime, :types, %{
  "application/activity+json" => ["activity-json"],
  "application/ld+json" => ["activity-json"],
  "application/jrd+json" => ["jrd-json"]
}

# Upload configuration
config :mobilizon, Mobilizon.Web.Upload,
  uploader: Mobilizon.Web.Upload.Uploader.Local,
  filters: [
    Mobilizon.Web.Upload.Filter.Dedupe,
    Mobilizon.Web.Upload.Filter.Optimize
  ],
  allow_list_mime_types: ["image/gif", "image/jpeg", "image/png", "image/webp"],
  link_name: true,
  proxy_remote: false,
  proxy_opts: [
    redirect_on_failure: false,
    max_body_length: 25 * 1_048_576,
    http: [
      follow_redirect: true,
      pool: :upload
    ]
  ]

config :mobilizon, Mobilizon.Web.Upload.Uploader.Local, uploads: "uploads"

config :mobilizon, :media_proxy,
  enabled: true,
  proxy_opts: [
    redirect_on_failure: false,
    max_body_length: 25 * 1_048_576,
    # Note: max_read_duration defaults to Mobilizon.Web.ReverseProxy.max_read_duration_default/1
    max_read_duration: 30_000,
    http: [
      follow_redirect: true,
      pool: :media
    ]
  ]

# Configures Elixir's Logger
config :logger, :console,
  backends: [:console, Sentry.LoggerBackend],
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger, Sentry.LoggerBackend,
  level: :warn,
  capture_log_messages: true

config :mobilizon, Mobilizon.Web.Auth.Guardian, issuer: "mobilizon"

config :guardian, Guardian.DB,
  repo: Mobilizon.Storage.Repo,
  # default
  schema_name: "guardian_tokens",
  # store all token types if not set
  # token_types: ["refresh_token"],
  # default: 60 minutes
  sweep_interval: 60

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :mobilizon,
       Mobilizon.Service.Auth.Authenticator,
       Mobilizon.Service.Auth.MobilizonAuthenticator

config :ueberauth,
       Ueberauth,
       providers: []

config :mobilizon, :auth, oauth_consumer_strategies: []

# config :ueberauth,
#       Ueberauth,
#       providers: [
#         google: {Ueberauth.Strategy.Google, [default_scope: "email"]},
#         facebook: {Ueberauth.Strategy.Facebook, []}
#       ]

# config :mobilizon, :auth, oauth_consumer_strategies: [:google, :facebook]

# config :ueberauth, Ueberauth.Strategy.Google.OAuth,
#  client_id: "${GOOGLE_0AUTH_ID}",
#  client_secret: "${GOOGLE_0AUTH_SECRET}"

# config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
#  client_id: "${FACEBOOK_0AUTH_ID}",
#  client_secret: "${FACEBOOK_0AUTH_SECRET}"

config :geolix,
  databases: [
    %{
      id: :city,
      adapter: Geolix.Adapter.MMDB2,
      source: "priv/data/GeoLite2-City.mmdb"
    }
  ]

config :mobilizon, Mobilizon.Service.Formatter,
  class: false,
  rel: "noopener noreferrer ugc",
  new_window: true,
  truncate: false,
  strip_prefix: false,
  extra: true,
  validate_tld: :no_scheme

config :tesla, adapter: Tesla.Adapter.Hackney

config :phoenix, :format_encoders, json: Jason, "activity-json": Jason
config :phoenix, :json_library, Jason
config :phoenix, :filter_parameters, ["password", "token"]

config :ex_cldr,
  default_locale: "en",
  default_backend: Mobilizon.Cldr

config :http_signatures,
  adapter: Mobilizon.Federation.HTTPSignatures.Signature

config :mobilizon, :cldr,
  locales: [
    "es",
    "en"
  ]

config :mobilizon, :activitypub,
  # One day
  actor_stale_period: 3_600 * 48,
  actor_key_rotation_delay: 3_600 * 48,
  sign_object_fetches: true

config :mobilizon, Mobilizon.Service.Geospatial, service: Mobilizon.Service.Geospatial.Nominatim

config :mobilizon, Mobilizon.Service.Geospatial.Nominatim,
  endpoint: "https://nominatim.openstreetmap.org",
  api_key: nil

config :mobilizon, Mobilizon.Service.Geospatial.Addok,
  endpoint: "https://api-adresse.data.gouv.fr"

config :mobilizon, Mobilizon.Service.Geospatial.Photon, endpoint: "https://photon.komoot.de"

config :mobilizon, Mobilizon.Service.Geospatial.GoogleMaps,
  api_key: nil,
  fetch_place_details: true

config :mobilizon, Mobilizon.Service.Geospatial.MapQuest, api_key: nil

config :mobilizon, Mobilizon.Service.Geospatial.Mimirsbrunn, endpoint: nil

config :mobilizon, Mobilizon.Service.Geospatial.Pelias, endpoint: nil

config :mobilizon, :maps,
  tiles: [
    endpoint: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    attribution: "© The OpenStreetMap Contributors"
  ],
  routing: [
    type: :openstreetmap
  ]

config :mobilizon, :http_security,
  enabled: true,
  sts: false,
  sts_max_age: 31_536_000,
  csp_policy: [
    script_src: [],
    style_src: [],
    connect_src: [],
    font_src: [],
    img_src: ["*.tile.openstreetmap.org"],
    manifest_src: [],
    media_src: [],
    object_src: [],
    frame_src: [],
    frame_ancestors: []
  ],
  referrer_policy: "same-origin"

config :mobilizon, :anonymous,
  participation: [
    allowed: true,
    validation: %{
      email: [
        enabled: true,
        confirmation_required: true
      ],
      captcha: [enabled: false]
    }
  ],
  event_creation: [
    allowed: false,
    validation: %{
      email: [
        enabled: true,
        confirmation_required: true
      ],
      captcha: [enabled: false]
    }
  ],
  reports: [
    allowed: false
  ]

config :mobilizon, Oban,
  repo: Mobilizon.Storage.Repo,
  log: false,
  queues: [default: 10, search: 5, mailers: 10, background: 5, activity: 5],
  plugins: [
    {Oban.Plugins.Cron,
     crontab: [
       {"@hourly", Mobilizon.Service.Workers.BuildSiteMap, queue: :background},
       {"17 * * * *", Mobilizon.Service.Workers.RefreshGroups, queue: :background},
       # To be activated in Mobilizon 1.2
       # {"@hourly", Mobilizon.Service.Workers.CleanOrphanMediaWorker, queue: :background},
       {"@hourly", Mobilizon.Service.Workers.CleanUnconfirmedUsersWorker, queue: :background}
     ]},
    {Oban.Plugins.Pruner, max_age: 300}
  ]

config :mobilizon, :rich_media,
  parsers: [
    Mobilizon.Service.RichMedia.Parsers.OEmbed,
    Mobilizon.Service.RichMedia.Parsers.OGP,
    Mobilizon.Service.RichMedia.Parsers.TwitterCard,
    Mobilizon.Service.RichMedia.Parsers.Fallback
  ]

config :mobilizon, Mobilizon.Service.ResourceProviders,
  types: [pad: :etherpad, calc: :ethercalc, visio: :jitsi],
  providers: %{
    etherpad: "https://etherpad.wikimedia.org/p/",
    ethercalc: "https://ethercalc.net/",
    jitsi: "https://meet.jit.si/"
  }

config :mobilizon, :external_resource_providers, %{
  "https://drive.google.com/" => :google_drive,
  "https://docs.google.com/document/" => :google_docs,
  "https://docs.google.com/presentation/" => :google_presentation,
  "https://docs.google.com/spreadsheets/" => :google_spreadsheets
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

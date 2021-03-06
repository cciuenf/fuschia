import Config

config :tesla, :adapter, {Tesla.Adapter.Finch, name: HttpClientFinch}

# ---------------------------#
# Logger
# ---------------------------#
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  backends: [:console, Sentry.LoggerBackend]

# ---------------------------#
# Sentry
# ---------------------------#
config :sentry,
  dsn: System.get_env("SENTRY_DNS"),
  environment_name: config_env(),
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{
    env: "production"
  },
  included_environments: [System.get_env("SENTRY_ENV")]

# ---------------------------#
# Oban
# ---------------------------#
config :fuschia, Oban,
  repo: Fuschia.Repo,
  queues: [mailer: 5]

config :fuschia, :jobs, start: System.get_env("START_OBAN_JOBS", "true")

# ---------------------------#
# Mailer
# ---------------------------#
adapter =
  case System.get_env("MAIL_SERVICE", "local") do
    "gmail" -> Swoosh.Adapters.SMTP
    _ -> Swoosh.Adapters.Local
  end

if adapter == Swoosh.Adapters.Local and config_env() != :prod do
  config :swoosh, serve_mailbox: true, preview_port: 4001
end

config :fuschia, Fuschia.Mailer,
  adapter: adapter,
  relay: System.get_env("MAIL_SERVER", "smtp.gmail.com"),
  username: System.get_env("MAIL_USERNAME", "notificacoes-noreply@peapescarte.uenf.br"),
  password: System.get_env("MAIL_PASSWORD", ""),
  ssl: false,
  tls: :always,
  auth: :always,
  port: System.get_env("MAIL_PORT", "587")

config :fuschia, :pea_pescarte_contact,
  notifications_mail: "notifications-noreply@peapescarte.uenf.br",
  telephone: " 0800 026 2828"

# ---------------------------#
# Timex
# ---------------------------#
config :timex, timezone: System.get_env("TIMEZONE", "America/Sao_Paulo")

if System.get_env("PHX_SERVER") do
  config :fuschia, FuschiaWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise "DATABASE_URL not available"

  if System.get_env("ECTO_IPV6") do
    config :fuschia, Fuschia.Repo, socket_options: [:inet6]
  end

  config :fuschia, Fuschia.Repo,
    # fly.io don't need
    ssl: false,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise "SECRET_KEY_BASE not available"

  app_name =
    System.get_env("FLY_APP_NAME") ||
      raise "FLY_APP_NAME not available"

  config :fuschia, FuschiaWeb.Endpoint,
    url: [host: "#{app_name}.fly.dev", port: 443],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    secret_key_base: secret_key_base
end

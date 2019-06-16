# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :drop_alley,
  ecto_repos: [DropAlley.Repo]

# Configures the endpoint
config :drop_alley, DropAlleyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mOo9Bsu1D5YLvDZc6sH19BIDXgHk5qZOhsgMraUQ0ehmW5sUTQBOT1pH2ALokSJ+",
  render_errors: [view: DropAlleyWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: DropAlley.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: DropAlley.Coherence.User,
  repo: DropAlley.Repo,
  module: DropAlley,
  web_module: DropAlleyWeb,
  router: DropAlleyWeb.Router,
  messages_backend: DropAlleyWeb.Coherence.Messages,
  logged_out_url: "/",
  email_from_name: "Your Name",
  email_from_email: "yourname@example.com",
  opts: [:authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token, :confirmable, :registerable, :invitable]

config :coherence, DropAlleyWeb.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "Secrete_key"
# %% End Coherence Configuration %%

config :drop_alley, DropAlley.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "Secrete_key"

config :torch,
  otp_app: :drop_alley,
  template_format: "eex" || "slim"

# config :phoenix_oauth2_provider, PhoenixOauth2Provider,
#   module: DropAlley,
#   current_resource_owner: :current_user,
#   repo: DropAlley.Repo,
#   resource_owner: DropAlley.Coherencece.User

##### Guardian Configurations #########
# Configures Elixir's Guardian package for authentication
config :drop_alley, DropAlley.Auth.Guardian,
  issuer: "drop_alley",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: DropAlley.GuardianSerializer,
  secret_key: "TU9gi5B2tqO5IY8qvARHcNYzX2n6EatS6Xp6iTLE/4+hUMGnjJd"

config :drop_alley, DropAlley.Auth.AuthAccessPipeline,
  module: DropAlley.Auth.Guardian,
  error_handler: DropAlley.Auth.AuthErrorHandler,
  confirmable: true


config :drop_alley, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: DropAlleyWeb.Router,     # phoenix routes will be converted to swagger paths
      endpoint: DropAlleyWeb.Endpoint  # (optional) endpoint config used to set host, port and https schemes.
    ]
  }



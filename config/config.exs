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
  api_key: "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"
# %% End Coherence Configuration %%

config :drop_alley, DropAlley.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "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"

config :torch,
  otp_app: :drop_alley,
  template_format: "eex" || "slim"

config :coherence_assent, :providers, [
  github: [
    client_id: "2473782e816711935193",
    client_secret: "cfed959ab42a925f6af2ae438bddcbb0a15dceb7",
    strategy: CoherenceAssent.Strategy.Github
  ],
  facebook: [
    client_id: "1870582576567423",
    client_secret: "bdac38d5b3df57a541da8f3dc4a6ed69",
    strategy: CoherenceAssent.Strategy.Facebook
  ],
  twitter: [
    client_id: "jRbSRBGPvrFrO4QJIBHX0QgtW",
    client_secret: "8u7zgCvrAYXpAkBgrtN9Y05jm2LSmWqr6bgYFfPDgFXVwqAcc7",
    strategy: CoherenceAssent.Strategy.Twitter
  ],
  google: [
    client_id: "762029072380-444gurofrhj6ngqn9d5u5fh53smjg980.apps.googleusercontent.com",
    client_secret: "L0LlbnOvE1expwfrx5Ih3BUL",
    strategy: CoherenceAssent.Strategy.Google
  ]
]


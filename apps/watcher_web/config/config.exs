# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :watcher_web,
  ecto_repos: [WatcherWeb.Repo]

# Configures the endpoint
config :watcher_web, WatcherWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/9+7/L/5H52O8HZw0AWpi/2+p4kcgSLJ1j7g31GPrfX+ogH18HZtIvkYJZt71nZP",
  render_errors: [view: WatcherWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WatcherWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

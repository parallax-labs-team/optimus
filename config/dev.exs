import Config

config :logger,
  level: :debug

# Needed for when the lib is used by itself
#
config :optimus,
  email: "your@email.com",
  password: "your_password",
  # sandbox
  base_api_url: "https://sandbox.primetrust.com"

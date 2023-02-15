import Config

config :logger,
  level: :debug

config :optimus,
  email: "your@email.com",
  password: "your_password"

# sandbox
config :optimus, base_api_url: "https://sandbox.primetrust.com"

defmodule PrimeTrust do
  use Application

  @moduledoc """
  HTTP client implementation for Optimus.

  ## Configuration

  ### API Token

  All operations against the Prime Trust API require a JWT, which can be
  obtained by following their set up guide:

  https://documentation.primetrust.com/#tag/Setting-Up

  In config, set:
      ```
      config :optimus,
        base_api_url: "https://sandbox.primetrust.com/v2",
        email: email,
        password: password
      ```
  """

  @impl Application

  @spec start(any, [{:env, :test | :dev | :prod}, ...]) :: {:error, any} | {:ok, pid}
  def start(_type, env: env) do
    renew_time_interval = Application.get_env(:optimus, :renew_jwt_time_interval, 28_888_888)

    children =
      if env == :test,
        do: [],
        else: [
          {PrimeTrust.TokenManagement, renew_time_interval}
        ]

    opts = [strategy: :one_for_one, name: PrimeTrust.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defmodule MissingApiUrlError do
    defexception message: """
                 The `base_api_url` for the PrimeTrust API was not set. Please set one of the
                 following URLs in your `config.exs`, depending on what environment you
                 are using.

                 config :optimus, base_api_url: "https://sandbox.primetrust.com" # sandbox
                 config :optimus, base_api_url: "https://api.primetrust.com" # production
                 """
  end

  defmodule MissingApiTokenError do
    defexception message: """
                 The `credentials` for the PrimeTrust account. If using email/password authentication,
                 make sure your credentials are correct.

                   config :optimus,
                     email: email,
                     password: password

                 """
  end

  defmodule MissingCredentialsError do
    defexception message: """
                 The credentials for the PrimeTrust account were not set. Please configure
                 the email/password in your `runtime.exs` as secrets.

                   email = System.get_env("OPTIMUS_EMAIL")
                   password = System.get_env("OPTIMUS_PASSWORD")

                   config :optimus,
                      email: email
                      password: password

                 """
  end
end

defmodule PrimeTrust do
  @moduledoc """
  HTTP client implementation for Optimus.

  ## Configuration

  ### API Token

  All operations against the Prime Trust API require a JWT, which can be
  obtained by following their set up guide:

  https://documentation.primetrust.com/#tag/Setting-Up

  To get the JWT token, basic auth is always needed
  In config, set:
      ```
      config :optimus,
        base_api_url: "https://sandbox.primetrust.com/v2",  # or prod url
        email: email,
        password: password
      ```
  """

  defmodule MissingApiUrlError do
    defexception message: """
                 The `base_api_url` for the PrimeTrust API was not set. Please set one of the
                 following URLs in your `config.exs`, depending on what environment you
                 are using.

                 config :optimus, base_api_url: "https://sandbox.primetrust.com" # sandbox
                 config :optimus, base_api_url: "https://api.primetrust.com" # production
                 """
  end

  defmodule MissingCredentialsError do
    defexception message: """
                 The credentials for the PrimeTrust account were not set. Please configure
                 the email/password in your config

                   config :optimus,
                      email: email
                      password: password

                 """
  end
end

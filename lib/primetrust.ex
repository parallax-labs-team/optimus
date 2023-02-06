defmodule PrimeTrust do
  @moduledoc """
  HTTP client implementation for Optimus.

  ## Configuration

  ### API Token

  All operations against the Prime Trust API require a JWT, which can be
  obtained by following their set up guide:

  https://documentation.primetrust.com/#tag/Setting-Up

  In `config/config.exs` (or your env config file) set something like the
  following:

      config :optimus,
        api_token: "some-token-blah",
        api_url: "https://sandbox.primetrust.com/v2"
  """

  defmodule MissingApiUrlError do
    defexception message: """
                 The `base_api_url` for the PrimeTrust API was not set. Please set one of the
                 following URLs in your `config.exs`, depending on what environment you
                 are using.

                 config :optimus, api_url: "https://sandbox.primetrust.com" # sandbox
                 config :optimus, api_url: "https://api.primetrust.com" # production
                 """
  end

  defmodule MissingApiTokenError do
    defexception message: """
                 The `api_token` for the PrimeTrust API was not set. Please configure
                 the `api_token` in your `config.exs`.

                 config :optimus, api_token: "your primetrust token"
                 """
  end
end

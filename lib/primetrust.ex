defmodule Optimus do
  @moduledoc """
  HTTP client implementation for Optimus.

  ## Configuration

  ### API Token

  All operations against the Prime Trust API require a JWT, which can be
  obtained by following their set up guide:

  https://documentation.primetrust.com/#tag/Setting-Up

  In `config/config.exs` (or your env config file) set something like the
  following:

      config :optimus, api_token: "some-token-blah"
  """
end

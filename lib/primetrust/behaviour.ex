defmodule PrimeTrust.APIBehaviour do
  @moduledoc """
  Behaviour of the API client.
  """

  @type method :: :get | :post | :patch | :delete

  @doc """
  Make a request to the PrimeTrust API using `Basic` authentication.

  This is provided because there are a couple of out-of-band endpoints
  that don't use PrimeTrust Bearer auth or follow their REST format,
  like `/auth/jwts`.
  """
  @callback basic_req(
              method,
              resource :: String.t(),
              email :: binary,
              password :: binary,
              body :: map
            ) :: {:ok, map} | {:error, map}

  @doc """
  Make an authenticated request to the PrimeTrust API using standard `Bearer`
  token authentication.
  """
  @callback req(method, resource :: String.t(), options :: Keyword.t()) ::
              {:ok, map} | {:error, map}
end

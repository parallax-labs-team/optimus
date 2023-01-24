defmodule PrimeTrust.API do
  @moduledoc """
  The Prime Trust API~
  """

  # variant of valid methods against the API
  @type method :: :get | :post | :patch | :delete

  @doc """
  https://documentation.primetrust.com/#section/Getting-Started/Idempotent-Object-Creation
  """
  @idempotency_header "X-Idempotent-ID"
  @idempotency_header_v2 "X-Idempotent-ID-V2"

  @spec get_base_url() :: String.t()
  defp get_base_url() do
    #Config.resolve(:api_url)
    # TODO use config~
    "https://sandbox.primetrust.com/v2"
  end

  @spec get_api_token() :: String.t()
  defp get_api_token() do
    #Config.resolve(:api_token, "")
    # TODO ...use config
    System.get_env("PRIMETRUST_TOKEN")
  end

  @doc """
  Utility to generate the ID for requests using either `#{@idempotency_header}`
  or `#{@idempotency_header_v2}` headers.

  Per API documentation, this must be a valid UUIDv4.
  """
  @spec gen_idempotency_id() :: binary
  def gen_idempotency_id do
    UUID.uuid4(:default)
  end

  def make_request(:get, data, resource, headers \\ %{}, opts \\ []) do
    token = get_api_token()
    base_url = get_base_url()
    request_url = Path.join(base_url, resource)
    h = %{ :authorization => "bearer #{token}" }
    response = :hackney.get(request_url, h |> Map.to_list(), <<>>, [])
  end

  def make_request(method, data, resource, headers, opts) do
    token = get_api_token()
    base_url = get_base_url()
    request_data = Jason.encode!(data)
    request_url = Path.join(base_url, resource)
    response = :hackney.request(method, request_url, headers |> Map.to_list(), request_data, opts)
  end
end

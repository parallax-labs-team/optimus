defmodule PrimeTrust.API do
  @moduledoc """
  The Prime Trust API~
  """

  @doc """
  https://documentation.primetrust.com/#section/Getting-Started/Idempotent-Object-Creation
  """
  @idempotency_header "X-Idempotent-ID"
  @idempotency_header_v2 "X-Idempotent-ID-V2"

  @spec get_base_url() :: String.t()
  defp get_base_url() do
    Config.resolve(:api_url)
  end

  @spec get_api_token() :: String.t()
  defp get_api_token() do
    Config.resolve(:api_token, "")
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
end

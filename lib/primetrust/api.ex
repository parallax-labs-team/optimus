defmodule PrimeTrust.API do
  @moduledoc """
  The Prime Trust API~
  """

  # variant of valid methods against the API
  @type method :: :get | :post | :patch | :delete

  # https://documentation.primetrust.com/#section/Getting-Started/Idempotent-Object-Creation
  @idempotency_header "X-Idempotent-ID"
  @idempotency_header_v2 "X-Idempotent-ID-V2"

  @spec get_api_url() :: String.t()
  defp get_api_url() do
    case Application.get_env(:optimus, :api_url) do
      nil -> raise PrimeTrust.MissingApiUrlError
      url -> url
    end
  end

  @spec get_api_token() :: String.t()
  defp get_api_token() do
    case Application.get_env(:optimus, :api_token) do
      nil -> raise PrimeTrust.MissingApiTokenError
      token -> token
    end
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

  @doc """
  Make request to the PrimeTrust API.
  """
  @spec req(method, resource :: String.t(), headers :: map, body :: map | binary(), opts :: list) ::
          {:ok, map} | {:error, map}
  def req(:get, resource, headers, body, opts) do
    api_url = get_api_url()
    request_url = Path.join(api_url, resource)
    make_request(:get, request_url, body, headers, opts)
  end

  def req(method, resource, headers, body, opts) do
    {api_type, opts} = Keyword.pop(opts, :api_type)
    api_url = get_api_url()
    request_data = Jason.encode!(wrap(body, api_type))
    request_url = Path.join(api_url, resource)
    make_request(method, request_url, headers, request_data, opts)
  end

  # The request maker behind the throne
  @spec make_request(
          method,
          url :: String.t(),
          headers :: map(),
          body :: iodata(),
          opts :: list()
        ) ::
          {:ok, map} | {:error, map}
  defp make_request(method, url, headers, body, opts) do
    api_token = get_api_token()

    req_headers =
      headers
      |> build_headers(api_token)
      |> add_idempotency_header(method)
      |> Map.to_list()

    reify_response(:hackney.request(method, url, req_headers, body, opts))
  end

  @doc """
  A helper for nice-ifying keys in API responses, because Prime Trust
  uses hyphens rather than underscores for all their JSON.
  """
  @spec decode_key(binary) :: String.t()
  def decode_key(key) do
    key
    |> String.replace("-", "_")
  end

  @doc """
  A helper for transforming data from "normal" to Prime Trust-compatible.
  Just a fancy way of saying "replace _ with -" in map keys since Prime Trust's
  API deals with hyphens for JSON.

  Does recursive transformation of the keys as various endpoints take nested
  dicts.
  """
  @spec prep_data(map) :: map
  def prep_data(data) do
    Map.new(data, fn {k, v} ->
      v = if is_map(v), do: prep_data(v), else: v
      k = k |> to_string() |> String.replace("_", "-")
      {k, v}
    end)
  end

  @spec wrap(map | binary, binary) :: map
  defp wrap(<<>>, type) do
    %{data: %{type: type, attributes: %{}}}
  end

  defp wrap(m, type) do
    %{data: %{type: type, attributes: m}}
  end

  defp reify_response({:ok, status, headers, body}) when status >= 200 and status < 300 do
    {:ok, data} = :hackney.body(body)
    expanded_data = decompress_response(data, headers)
    {:ok, Jason.decode!(expanded_data, keys: &decode_key/1)}
  end

  defp reify_response({:ok, status, _headers, body}) when status >= 300 do
    {:ok, rsp} = :hackney.body(body)

    case Jason.decode(rsp, keys: &decode_key/1) do
      {:ok, %{"errors" => _} = err} -> err
      {:error, err} -> PrimeTrust.Error.from_api_error(status, err)
    end
  end

  defp add_idempotency_header(headers, method) when method in [:post] do
    Map.put_new(headers, @idempotency_header_v2, gen_idempotency_id())
  end

  defp add_idempotency_header(headers, _method) do
    headers
  end

  defp decompress_response(data, headers) do
    hm = :hackney_headers.new(headers)

    case :hackney_headers.get_value("Content-Encoding", hm) do
      "gzip" -> :zlib.gunzip(data)
      "deflate" -> :zlib.unzip(data)
      _ -> data
    end
  end

  defp build_headers(headers, api_token) do
    Map.merge(headers, %{
      Accept: "application/vnd.api+json",
      "Accept-Encoding": "deflate, gzip",
      Authorization: "Bearer #{api_token}",
      Connection: "keep-alive",
      "Content-Type": "application/json"
    })
  end
end

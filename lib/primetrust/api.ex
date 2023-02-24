defmodule PrimeTrust.API do
  @moduledoc """
  The Prime Trust API~
  """

  # variant of valid methods against the API
  @type method :: :get | :post | :patch | :delete

  # https://documentation.primetrust.com/#section/Getting-Started/Idempotent-Object-Creation
  @idempotency_header "X-Idempotent-ID"
  @idempotency_header_v2 "X-Idempotent-ID-V2"

  @api_version "v2"

  @spec get_base_api_url() :: String.t()
  defp get_base_api_url() do
    case Application.get_env(:optimus, :base_api_url) do
      nil -> raise PrimeTrust.MissingApiUrlError
      url -> url
    end
  end

  @spec get_api_url(boolean) :: String.t()
  defp get_api_url(use_api_version) do
    if use_api_version do
      Path.join(get_base_api_url(), @api_version)
    else
      get_base_api_url()
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
  Make request to the PrimeTrust API, using basic auth.

  This is provided because there are a couple of out-of-band endpoints
  that don't use PrimeTrust Bearer auth or follow their REST format,
  like `/auth/jwts`.
  """
  @spec basic_req(
          method,
          resource :: String.t(),
          email :: binary,
          password :: binary,
          body :: map
        ) ::
          {:ok, map} | {:error, map}
  def basic_req(method, resource, email, password, body \\ %{}) do
    api_url = get_base_api_url()
    request_url = Path.join(api_url, resource)

    req_headers =
      %{}
      |> build_headers()
      |> add_basic_auth_header(email, password)
      |> Map.to_list()

    request_data = Jason.encode!(body)
    reify_response(:hackney.request(method, request_url, req_headers, request_data, []))
  end

  @doc """
  Make request to the PrimeTrust API, using standard Bearer token
  authentication.
  """
  @spec req(method, resource :: String.t(), headers :: map, body :: map | binary(), opts :: list) ::
          {:ok, map} | {:error, map}
  def req(:get, resource, headers, body, opts) do
    {use_api_version, opts} = Keyword.pop(opts, :use_api_version, true)
    {includes, opts} = Keyword.pop(opts, :include)

    request_url =
      get_api_url(use_api_version)
      |> Path.join(resource)
      |> add_includes(includes)

    make_request(:get, request_url, headers, body, opts)
  end

  def req(method, resource, headers, body, opts) do
    {use_api_version, opts} = Keyword.pop(opts, :use_api_version, true)
    {api_type, opts} = Keyword.pop(opts, :api_type, <<>>)
    {includes, opts} = Keyword.pop(opts, :include)

    request_url =
      get_api_url(use_api_version)
      |> Path.join(resource)
      |> add_includes(includes)

    request_data =
      case blank?(body) do
        true ->
          <<>>

        _ ->
          wrap(body, api_type)
      end

    make_request(method, request_url, headers, request_data, opts)
  end

  # The request maker behind the throne
  @spec make_request(
          method,
          url :: String.t(),
          headers :: map(),
          body :: iodata() | {:multipart, list()},
          opts :: list()
        ) ::
          {:ok, map} | {:error, map}
  defp make_request(method, url, headers, body, opts) do
    api_token = get_api_token()

    req_headers =
      headers
      |> build_headers()
      |> add_idempotency_header(method)
      |> add_bearer_header(api_token)
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

  @spec blank?(map | binary()) :: boolean
  defp blank?(body) when is_map(body) do
    false
  end

  defp blank?(str_or_nil) do
    "" == str_or_nil |> to_string() |> String.trim()
  end

  @spec wrap(map | binary, binary) :: map | {:multipart, list()}
  defp wrap(%{file: file, contact_id: _} = m, "uploaded-documents") do
    form_data =
      m
      |> Map.delete(:file)
      |> Enum.map(fn {k, v} -> {to_string(k), v} end)

    {:multipart,
     [
       {:file, file, {["form-data"], [name: "file", filename: file]}, []}
       | form_data
     ]}
  end

  defp wrap(m, <<>>) do
    Jason.encode!(m)
  end

  defp wrap(<<>>, type) do
    %{data: %{type: type, attributes: %{}}}
    |> Jason.encode!()
  end

  defp wrap(m, type) do
    %{data: %{type: type, attributes: m}}
    |> Jason.encode!()
  end

  defp reify_response({:ok, status, headers, body}) when status >= 200 and status < 300 do
    {:ok, data} = :hackney.body(body)
    expanded_data = decompress_response(data, headers)
    {:ok, Jason.decode!(expanded_data, keys: &decode_key/1, floats: :decimals)}
  end

  defp reify_response({:ok, status, _headers, body}) when status >= 300 do
    {:ok, rsp} = :hackney.body(body)

    case Jason.decode(rsp, keys: &decode_key/1, floats: :decimals) do
      {:ok, %{"errors" => _} = err} -> err
      {:error, err} -> PrimeTrust.Error.from_api_error(status, err)
    end
  end

  defp add_includes(url, includes) when is_list(includes) do
    qs = Enum.join(includes, ",")
    "#{url}?include=#{qs}"
  end

  defp add_includes(url, includes) when is_binary(includes) do
    "#{url}?include=#{includes}"
  end

  defp add_includes(url, _) do
    url
  end

  defp add_idempotency_header(headers, method) when method in [:post, :patch] do
    Map.put_new(headers, @idempotency_header_v2, gen_idempotency_id())
  end

  defp add_idempotency_header(headers, _method) do
    headers
  end

  defp add_bearer_header(headers, api_token) do
    Map.put_new(headers, :Authorization, "Bearer #{api_token}")
  end

  defp add_basic_auth_header(headers, email, password) do
    coded = Base.encode64("#{email}:#{password}")
    Map.put_new(headers, :Authorization, "Basic #{coded}")
  end

  defp decompress_response(data, headers) do
    hm = :hackney_headers.new(headers)

    case :hackney_headers.get_value("Content-Encoding", hm) do
      "gzip" -> :zlib.gunzip(data)
      "deflate" -> :zlib.unzip(data)
      _ -> data
    end
  end

  defp build_headers(headers) do
    Map.merge(headers, %{
      Accept: "application/vnd.api+json",
      "Accept-Encoding": "deflate, gzip",
      Connection: "keep-alive",
      "Content-Type": "application/json"
    })
  end
end

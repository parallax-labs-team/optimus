defmodule PrimeTrust.Asset do
  @moduledoc """
  Work with the [`Assets`](https://documentation.primetrust.com/#tag/Assets)
  endpoint.
  """

  alias PrimeTrust.API

  @resource "assets"
  @api_type "assets"
  @doc """
  Fetches the `/assets` index.
  """
  @spec list(Keyword.t()) :: {:ok, map} | {:error | map}
  def list(opts \\ []) do
    API.req(:get, @resource, %{}, <<>>, opts)
  end

  @doc """
  Get an individual asset type by ID (UUIDv4).
  """
  @spec get(binary, Keyword.t()) :: {:ok, map} | {:error | map}
  def get(id, opts \\ []) do
    API.req(:get, @resource <> "/#{id}", %{}, <<>>, opts)
  end

  @doc """
  Create an asset type.
  """
  @spec create(map, Keyword.t()) :: {:ok, map} | {:error, map}
  def create(params, opts \\ []) do
    API.req(:post, @resource, %{}, params, [{:api_type, @api_type} | opts])
  end

  @doc """
  Update an asset by ID (UUIDv4)
  """
  @spec update(binary, map, Keyword.t()) :: {:ok, map} | {:error, map}
  def update(id, params, opts \\ []) do
    API.req(:patch, @resource <> "/#{id}", %{}, params, [{:api_type, @api_type} | opts])
  end
end

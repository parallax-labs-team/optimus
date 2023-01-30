defmodule PrimeTrust.AssetContribution do
  @moduledoc """
  Work with the [`Asset Contributions`](https://documentation.primetrust.com/#tag/Asset-Contributions)
  endpoint.
  """

  alias PrimeTrust.API

  @resource "asset-contributions"
  @api_type "asset-contributions"

  @doc """
  Fetches the `/asset-contributions` index.
  """
  @spec list(Keyword.t()) :: {:ok, map} | {:error | map}
  def list(opts \\ []) do
    API.req(:get, @resource, <<>>, %{}, opts)
  end

  @doc """
  Get an individual asset contribution by ID (UUIDv4).
  """
  @spec get(binary, Keyword.t()) :: {:ok, map} | {:error | map}
  def get(id, opts \\ []) do
    API.req(:get, @resource <> "/#{id}", <<>>, %{}, opts)
  end

  @doc """
  Create an asset contribution.
  """
  @spec create(map, Keyword.t()) :: {:ok, map} | {:error, map}
  def create(params, opts \\ []) do
    API.req(:post, @resource, params, %{}, [{:api_type, @api_type} | opts])
  end
end

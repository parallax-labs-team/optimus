defmodule PrimeTrust.AssetTransferMethod do
  @moduledoc """
  Work with the [`Asset Transfer Methods`](https://documentation.primetrust.com/#tag/Asset-Transfer-Methods) endpoint.
  """

  alias PrimeTrust.API

  @resource "asset-transfer-methods"
  @api_type "asset-transfer-methods"

  @doc """
  Fetches the `/asset-transfer-methods` index.
  """
  @spec list(Keyword.t()) :: {:ok, map} | {:error, map}
  def list(opts \\ []) do
    API.req(:get, @resource, opts)
  end

  @doc """
  Gets a single asset transfer method.
  """
  @spec get(binary, Keyword.t()) :: {:ok, map} | {:error, map}
  def get(id, opts \\ []) do
    API.req(:get, @resource <> "/#{id}", opts)
  end

  @doc """
  Create an asset transfer method.
  """
  @spec create(map, Keyword.t()) :: {:ok, map} | {:error, map}
  def create(params, opts \\ []) do
    opts =
      [
        {:api_type, @api_type},
        {:body, params}
      ] ++ opts

    API.req(:post, @resource, opts)
  end

  @doc """
  Update an asset transfer method.
  """
  @spec update(binary, map, Keyword.t()) :: {:ok, map} | {:error, map}
  def update(id, params, opts \\ []) do
    opts =
      [
        {:api_type, @api_type},
        {:body, params}
      ] ++ opts

    API.req(:patch, @resource <> "/#{id}", opts)
  end
end

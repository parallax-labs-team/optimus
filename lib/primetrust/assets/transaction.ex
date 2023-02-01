defmodule PrimeTrust.AssetTransaction do
  @moduledoc """
  Work with the [`Asset Transactions`](https://documentation.primetrust.com/#tag/Asset-Transactions)
  endpoint.
  """

  alias PrimeTrust.API

  @resource "asset-transactions"

  @doc """
  Fetches the `/asset-transactions` index.
  """
  @spec list(Keyword.t()) :: {:ok, map} | {:error, map}
  def list(opts \\ []) do
    API.req(:get, @resource, %{}, <<>>, opts)
  end

  @doc """
  Get an individual asset transaction by ID (UUIDv4).
  """
  @spec get(binary, Keyword.t()) :: {:ok, map} | {:error, map}
  def get(id, opts \\ []) do
    API.req(:get, @resource <> "/#{id}", %{}, <<>>, opts)
  end
end

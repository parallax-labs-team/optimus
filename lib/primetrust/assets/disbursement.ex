defmodule PrimeTrust.AssetDisbursement do
  @moduledoc """
  Work with the [`Asset Disbursements1](https://documentation.primetrust.com/#tag/Asset-Disbursements)
  endpoint.
  """

  alias PrimeTrust.API

  @resource "asset-disbursements"
  @api_type "asset-disbursements"

  @doc """
  Fetches the `/asset-disbursements` index.
  """
  @spec list(Keyword.t()) :: {:ok, map} | {:error | map}
  def list(opts \\ []) do
    API.req(:get, @resource, %{}, <<>>, opts)
  end

  @doc """
  Get an individual asset disbursement by ID (UUIDv4).
  """
  @spec get(binary, Keyword.t()) :: {:ok, map} | {:error | map}
  def get(id, opts \\ []) do
    API.req(:get, @resource <> "/#{id}", %{}, <<>>, opts)
  end

  @doc """
  Create an asset disbursement.
  """
  @spec create(map, Keyword.t()) :: {:ok, map} | {:error, map}
  def create(params, opts \\ []) do
    API.req(:post, @resource, %{}, params, [{:api_type, @api_type} | opts])
  end
end

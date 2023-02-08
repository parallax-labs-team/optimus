defmodule PrimeTrust.Contact do
  @moduledoc """
  Work with the PrimeTrust [`Contacts`](https://documentation.primetrust.com/#operation/POST__v2_contacts)
  endpoint.
  """

  alias PrimeTrust.API

  @resource "contacts"
  @api_type "contacts"

  @doc """
  Fetches the `/contacts` index
  """
  @spec list(Keyword.t()) :: {:ok, map} | {:error, map}
  def list(opts \\ []) do
    API.req(:get, @resource, %{}, <<>>, opts)
  end

  @doc """
  Fetches a single contact by its Contact ID (an UUIDv4).
  """
  @spec get(Keyword.t()) :: {:ok, map} | {:error, map}
  def get(id, opts \\ []) do
    API.req(:get, @resource <> "/#{id}", %{}, <<>>, opts)
  end

  @doc """
  Create a natural person contact.

  https://documentation.primetrust.com/#operation/POST__v2_contacts
  """
  @spec create(map, Keyword.t()) :: {:ok, map} | {:error, map}
  def create(%{account_id: _, name: _} = params, opts \\ []) do
    API.req(:post, @resource, %{}, params, [{:api_type, @api_type} | opts])
  end

  @doc """
  Deletes a contact by ID (an UUIDv4).
  """
  @spec delete(binary, Keyword.t()) :: {:ok, map} | {:error, map}
  def delete(id, opts \\ []) do
    API.req(:delete, @resource <> "/#{id}", %{}, <<>>, opts)
  end

  @doc """
  TODO figure out what this endpoint _actually_ does

  Sends a POST to the KYC Required Actions endpoint:
  https://documentation.primetrust.com/#operation/POST__v2_contacts_contact_id_kyc_required_actions
  """
  @spec required_kyc_actions(binary, Keyword.t()) :: {:ok, map} | {:error, map}
  def required_kyc_actions(id, opts \\ []) do
    API.req(:post, @resource <> "/#{id}/kyc-required-actions", %{}, <<>>, opts)
  end
end

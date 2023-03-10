defmodule PrimeTrust.Accounts do
  @moduledoc """
  Work with the [`Accounts`](https://documentation.primetrust.com/#tag/Accounts)
  endpoint.
  """

  alias PrimeTrust.API

  @resource "accounts"
  @api_type "account"

  @type address :: %{
          street_1: String.t(),
          street_2: String.t(),
          postal_code: String.t(),
          city: String.t(),
          region: String.t(),
          country: String.t()
        }

  @type phone_number :: %{
          country: String.t(),
          number: String.t(),
          sms: boolean
        }

  @type actions :: %{
          code: String.t(),
          description: String.t()
        }

  @type attrs :: %{
          name: String.t(),
          number: String.t(),
          created_at: DateTime.t(),
          updated_at: DateTime.t(),
          contributions_frozen: boolean,
          disbursements_frozen: boolean,
          organization_label: String.t(),
          statements: boolean,
          status: String.t(),
          # TODO what is this field for?
          solid_freeze: boolean,
          # TODO and what is this field for?
          offline_cold_storage: boolean | nil,
          freeze_required_actions: list(actions),
          freeze_not_required_actions: list(actions),
          uploaded_document_ids: list()
        }

  @type t :: %__MODULE__{
          id: String.t(),
          type: String.t(),
          attributes: attrs,
          links: map,
          relationships: map
        }

  defstruct [
    :type,
    :id,
    :attributes,
    :links,
    :relationships
  ]

  @doc """
  Fetches the `/accounts` index
  """
  def list(opts \\ []) do
    API.req(:get, @resource, opts)
  end

  @doc """
  Fetches a single account by its Prime Trust ID (an UUIDv4).
  """
  def get(id, opts \\ []) do
    API.req(:get, @resource <> "/#{id}", opts)
  end

  @doc """
  Create a Personal Custodial Account.
  """
  @spec create_personal(params :: map, opts :: Keyword.t()) :: {:ok, t} | {:error, map}
  def create_personal(%{name: _, authorized_signature: _, owner: _} = params, opts \\ []) do
    opts =
      [
        {:api_type, @api_type},
        {:body, params}
      ] ++ opts

    API.req(:post, @resource, opts)
  end
end

defmodule PrimeTrust.Accounts do
  @moduledoc """
  Work with the [`Accounts`](https://documentation.primetrust.com/#tag/Accounts)
  endpoint.
  """

  alias PrimeTrust.API

  @resource "accounts"

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
    type: String.t(),
    id: String.t(),
    attributes: attrs
  }

  defstruct [
    :type,
    :id,
    :attributes
  ]

  @doc """
  Fetches the `/accounts` index
  """
  def list(opts \\ []) do
    API.make_request(:get, nil, @resource)
  end

  def get(id) do
    API.make_request(:get, nil, @resource <> "/#{id}")
  end

  def create(opts \\ []) do
  end
end

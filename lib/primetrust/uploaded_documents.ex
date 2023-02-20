defmodule PrimeTrust.UploadedDocuments do
  @moduledoc """
  Work with the [`Uploaded Documents`] (https://documentation.primetrust.com/#tag/Uploaded-Documents)
  endpoint

  Only for kyc_documents at the moment.

  kyc_documents **needs** to be attached to a contact
  """

  alias PrimeTrust.API

  @resource "uploaded-documents"
  @api_type "uploaded-documents"

  @typedoc """
  kyc documents needs to be attached to contact.
  Not adding the other options purposefully for now.
  """
  @type uploaded_attachment_inputs :: %{
          # mandatory
          file: binary(),
          contact_id: String.t(),
          # optional
          allow_download: boolean(),
          public: boolean(),
          label: String.t(),
          description: String.t(),
          mime_type: String.t(),
          extension: String.t()
        }

  @type attrs :: %{
          # Doc says string, but it is a boolean.
          allow_download: boolean(),
          # Doc says string, looks the same as Accoutn created_at: "2023-02-19T20:32:57Z"
          created_at: DateTime.t(),
          label: String.t(),
          description: String.t(),
          extension: String.t(),
          file_url: String.t(),
          mime_type: String.t(),
          # Doc says string, but it is a boolean.
          public: boolean(),
          version_urls: String.t()
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
  Fetches the `/uploaded_documents` index
  """
  def list(opts \\ []) do
    API.req(:get, @resource, %{}, <<>>, opts)
  end

  @doc """
  Fetches a single account by its Prime Trust ID (an UUIDv4).
  """
  def get(id, opts \\ []) do
    API.req(:get, @resource <> "/#{id}", %{}, <<>>, opts)
  end

  @doc """
  Create an uploaded_document attached to a contact
  """
  @spec create_per_contact(params, Keyword.t()) :: {:ok, t} | {:error, map}
        when params: %{
               :file => String.t(),
               :contact_id => String.t()
             }
  def create_per_contact(%{file: _, contact_id: _} = params, opts \\ []) do
    API.req(:post, @resource, %{}, params, [{:api_type, @api_type} | opts])
  end
end

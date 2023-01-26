defmodule PrimeTrust.Error do
  @moduledoc """
  Defines the general error type for the errors the PrimeTrust API can return.
  """
  @type t :: %__MODULE__{
          status: integer,
          title: String.t(),
          source: map,
          detail: String.t()
        }

  defstruct [:status, :title, :source, :detail]

  @doc false
  def api_error(error_body) do
    Jason.decode!(error_body)
  end
end

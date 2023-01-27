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
  def from_api_error(status_code, errors) when status_code == 404 do
    %__MODULE__{
      status: status_code,
      title: "Resource not found",
      source: errors,
      detail: ""
    }
  end
end

defmodule PrimeTrust.Auth.JWT do
  @moduledoc """
  Work with PrimeTrust JWT.

  The JWT request end-point does not follow the same REST design as the majority
  of the PrimeTrust API, so `auth/jwts` is handled via Basic authentication
  and without going through the normal `PrimeTrust.API.req` method, which
  does additional things like specify API version in the URL.
  """
  alias PrimeTrust.API

  @resource "auth/jwts"

  @spec create_jwt(binary, binary) :: {:ok, map}
  def create_jwt(email, password) do
    API.basic_req(:post, @resource, email, password)
  end

  @doc """
  Utility to invalidate the current JWT.
  """
  @spec invalidate() :: {:ok, map} | {:error, map}
  def invalidate() do
    API.req(:post, @resource <> "/invalidate-session", %{}, <<>>, [])
  end

  @spec set_jwt :: :ok
  def set_jwt do
    email = Application.get_env(:optimus, :email) || raise PrimeTrust.MissingCredentialsError

    password =
      Application.get_env(:optimus, :password) || raise PrimeTrust.MissingCredentialsError

    {:ok, %{"token" => token}} = create_jwt(email, password)

    Application.put_env(:optimus, :api_token, token)
  end
end

defmodule PrimeTrust.APITest do
  use ExUnit.Case

  test "Client generates actual UUID4 idempotent keys" do
    idem = PrimeTrust.API.gen_idempotency_id()

    assert idem
    assert is_binary(idem)
    assert String.length(idem) == 36

    # in a UUID, the 1st character of the 3rd group
    # is the version identifier
    [_, _, tv, _, _] = String.split(idem, "-")
    assert String.at(tv, 0) == "4"
  end

  describe "PrimeTrust.API.req" do
    test "Unset API key raises MissingApiUrlError" do
      assert_raise PrimeTrust.MissingApiUrlError, fn ->
        PrimeTrust.API.req(:get, "", %{}, %{}, [])
      end
    end
  end

  describe "PrimeTrust.API.decode_key" do
    test "Decode API key correctly" do
      key = "account-type"
      assert PrimeTrust.API.decode_key(key) == "account_type"
    end
  end

  describe "PrimeTrust.API.prep_data" do
    test "Transform single layer map" do
      data = %{type: "custodial", account_name: "account"}
      proc = %{"type" => "custodial", "account-name" => "account"}
      assert Map.equal?(PrimeTrust.API.prep_data(data), proc)
    end

    test "Transform nested maps" do
      data = %{account_name: "account", more_info: %{more_data: "more!"}}
      proc = %{"account-name" => "account", "more-info" => %{"more-data" => "more!"}}
      assert Map.equal?(PrimeTrust.API.prep_data(data), proc)
    end
  end
end

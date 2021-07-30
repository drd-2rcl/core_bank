defmodule CoreBankApi.Accounts.GetTest do
  use CoreBankApi.DataCase, async: true

  alias CoreBankApi.Accounts.Get
  alias CoreBankApi.Account
  import CoreBankApi.Factory

  describe "call/1" do
    test "when the id is valid, returns the account" do
      user = insert(:user)
      insert(:account, %{user_id: user.id})

      response = Get.by_id("961070c5-9f77-4cd2-80af-8900386e10fb")

      assert {:ok,
              %Account{
                id: "96\1070c5-9f77-4cd2-80af-8900386e10fb",
                balance: _,
                user_id: "f2496b9e-2b97-4abe-9856-738abcdc3d91"
              }} = response
    end

    test "when the id is invalid, returns the error" do
      insert(:user)
      insert(:account, %{user_id: "f2496b9e-2b97-4abe-9856-738abcdc3d91"})

      response = Get.by_id("961070c5-9f77-4cd2-80af-8900386e10f")

      assert {:error, %{result: "Invalid ID format!", status: :bad_request}} = response
    end

    test "when not found the account, returns the error" do
      insert(:user)
      insert(:account, %{user_id: "f2496b9e-2b97-4abe-9856-738abcdc3d91"})

      response = Get.by_id("961070c5-9f77-4cd2-80af-8900386e10fc")

      assert {:error, %{result: "Account not found!", status: :not_found}} = response
    end
  end
end

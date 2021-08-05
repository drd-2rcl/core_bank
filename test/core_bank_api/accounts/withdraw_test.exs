defmodule CoreBankApi.Accounts.WithdrawTest do
  use CoreBankApi.DataCase, async: true
  import CoreBankApi.Factory

  alias CoreBankApi.Account
  alias CoreBankApi.Accounts.Withdraw

  describe "call/1" do
    test "when all params are valid, returns account balance updated" do
      user = insert(:user)
      account = insert(:account, %{user_id: user.id, balance: 100})
      params = build(:withdraw_params, %{"id" => account.id})

      {:ok, account} = Withdraw.call(params)

      assert account.balance == Decimal.new("90.0")

      assert %Account{
               id: "8ce40338-521f-4f6a-9c0e-a9022e81655e",
               balance: _
             } = account
    end

    test "when there are errors with ID" do
      params = %{
        "id" => "123123123",
        "value" => "20.0"
      }

      response = Withdraw.call(params)

      assert {:error, %{result: "Invalid ID format!", status: :bad_request}} = response
    end

    test "when there are errors with account not found" do
      params = %{
        "id" => "8ce40338-521f-4f6a-9c0e-a9022e81655e",
        "value" => "20.0"
      }

      response = Withdraw.call(params)

      assert {:error, %{result: "Account not found!", status: :not_found}} = response
    end

    test "when there are errors with invalid value" do
      user = insert(:user)
      account = insert(:account, %{user_id: user.id, balance: 100})

      params = %{
        "id" => account.id,
        "value" => "banana"
      }

      response = Withdraw.call(params)

      assert {:error, "Invalid value!"} = response
    end
  end
end

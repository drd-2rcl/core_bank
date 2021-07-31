defmodule CoreBankApi.Transfers.CreditTest do
  use CoreBankApi.DataCase, async: true
  import CoreBankApi.Factory

  alias CoreBankApi.Accounts.Get
  alias CoreBankApi.Transfers.Credit

  describe "call/1" do
    test "when receive valid params" do
      user = insert(:user)
      account = insert(:account_debit, %{user_id: user.id, balance: "10.0"})

      params = %{
        "id" => "#{account.id}",
        "value" => "10.0"
      }

      {:ok, account} = Credit.call(params)

      {:ok, updated_account} = Get.by_id(account.id)

      assert updated_account.balance == Decimal.new("20.0")
    end

    test "when receive invalid value" do
      user = insert(:user)
      account = insert(:account_credit, %{user_id: user.id})

      params = %{
        "id" => "#{account.id}",
        "value" => "banana"
      }

      response = Credit.call(params)

      assert {:error, %{result: "Invalid value!", status: :bad_request}} = response
    end

    test "when receive invalid id" do
      response =
        Credit.call(%{
          "id" => "12313123123",
          "value" => "20.0"
        })

      assert {:error,
              %{
                result: %{result: "Invalid ID format!", status: :bad_request}
              }} = response
    end
  end
end

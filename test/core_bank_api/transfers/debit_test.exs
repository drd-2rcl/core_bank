defmodule CoreBankApi.Transfers.DebitTest do
  use CoreBankApi.DataCase, async: true
  import CoreBankApi.Factory

  alias CoreBankApi.Accounts.Get
  alias CoreBankApi.Transfers.Debit

  describe "call/1" do
    test "when receive valid params" do
      user = insert(:user)
      account = insert(:account_debit, %{user_id: user.id, balance: "10.0"})

      params = %{
        "id" => "#{account.id}",
        "value" => "10.0"
      }

      {:ok, account} = Debit.call(params)

      {:ok, updated_account} = Get.by_id(account.id)

      assert updated_account.balance == Decimal.new("0.0")
    end

    test "when receive invalid value" do
      user = insert(:user)
      account = insert(:account_credit, %{user_id: user.id})

      params = %{
        "id" => "#{account.id}",
        "value" => "banana"
      }

      response = Debit.call(params)

      assert {:error, "Invalid value!"} = response
    end

    test "when receive invalid id" do
      response =
        Debit.call(%{
          "id" => "12313123123",
          "value" => "20.0"
        })

      assert {:error,
              %{
                result: "Invalid ID format!"
              }} = response
    end
  end
end

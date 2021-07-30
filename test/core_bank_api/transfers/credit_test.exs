defmodule CoreBankApi.Transfers.CreditTest do
  use CoreBankApi.DataCase, async: true
  import CoreBankApi.Factory

  alias CoreBankApi.Transfers.Credit

  describe "call/1" do
    test "when receive valid params" do
      user = insert(:user)
      account = insert(:account_credit, %{user_id: user.id})

      params = %{
        "id" => "#{account.id}",
        "value" => "20.0"
      }

      {:ok, account} = Credit.call(params)

      assert account.balance == Decimal.new(20)
    end

    test "when receive invalid value" do
      user = insert(:user)
      account = insert(:account_credit, %{user_id: user.id})

      params = %{
        "id" => "#{account.id}",
        "value" => "banana"
      }

      response = Credit.call(params)

      assert {:error, %{result: "Invalid transfer value!", status: :bad_request}} = response
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

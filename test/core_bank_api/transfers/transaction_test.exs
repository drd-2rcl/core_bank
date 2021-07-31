defmodule CoreBankApi.Transfers.TransactionTest do
  use CoreBankApi.DataCase, async: true
  import CoreBankApi.Factory

  alias CoreBankApi.Accounts.Get
  alias CoreBankApi.Transfer
  alias CoreBankApi.Transfers.Transaction

  describe "call/2" do
    test "when receive valid params" do
      user1 = insert(:user_without_account)

      user2 =
        insert(:user_without_account, %{
          id: "04130282-f694-4ff7-8586-a8e19c051000",
          email: "user2@teste.com"
        })

      from_account =
        insert(:account, %{
          id: "1553c177-ba55-46cc-8f0b-78d62fa1e257",
          balance: 100,
          user_id: user1.id
        })

      to_account =
        insert(:account, %{
          id: "88c8e964-fcb9-4238-a475-7b495f9a0ad8",
          balance: 100,
          user_id: user2.id
        })

      params = %{
        "from_account" => "#{from_account.id}",
        "to_account" => "#{to_account.id}",
        "value" => "20.0"
      }

      response = Transaction.call(params)
      {:ok, updated_from_account} = Get.by_id(from_account.id)
      {:ok, updated_to_account} = Get.by_id(to_account.id)

      assert {:ok,
              %{
                create_transaction: %Transfer{
                  amount: _,
                  from_account: "1553c177-ba55-46cc-8f0b-78d62fa1e257",
                  to_account: "88c8e964-fcb9-4238-a475-7b495f9a0ad8"
                }
              }} = response

      assert updated_from_account.balance == Decimal.new("80.0")
      assert updated_to_account.balance == Decimal.new("120.0")
    end

    test "when receive invalid value" do
      user1 = insert(:user_without_account)

      user2 =
        insert(:user_without_account, %{
          id: "04130282-f694-4ff7-8586-a8e19c051000",
          email: "user2@teste.com"
        })

      from_account =
        insert(:account, %{
          id: "1553c177-ba55-46cc-8f0b-78d62fa1e257",
          balance: 100,
          user_id: user1.id
        })

      to_account =
        insert(:account, %{
          id: "88c8e964-fcb9-4238-a475-7b495f9a0ad8",
          balance: 100,
          user_id: user2.id
        })

      params = %{
        "from_account" => "#{from_account.id}",
        "to_account" => "#{to_account.id}",
        "value" => "banana"
      }

      response = Transaction.call(params)

      assert {:error, %{result: "Invalid value!", status: :bad_request}} = response
    end

    test "when receive invalid id" do
      params = %{
        "from_account" => "123123123123",
        "to_account" => "123123123123",
        "value" => "20.0"
      }

      response = Transaction.call(params)

      assert {:error,
              %{
                result: %{result: "Invalid ID format!", status: :bad_request}
              }} = response
    end
  end
end

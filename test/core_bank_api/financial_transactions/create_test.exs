defmodule CoreBankApi.FinancialTransactions.CreateTest do
  use CoreBankApi.DataCase, async: true

  alias CoreBankApi.FinancialTransaction
  alias CoreBankApi.FinancialTransactions.Create
  import CoreBankApi.Factory

  describe "call/1" do
    test "when all params are valid, returns the financial transaction" do
      user = insert(:user)
      account = insert(:account, %{user_id: user.id})

      response = Create.call(account, "10.0", :credit)

      assert {:ok,
              %FinancialTransaction{
                account: _,
                account_id: "8ce40338-521f-4f6a-9c0e-a9022e81655e",
                date: _,
                id: _,
                type: :credit,
                value: _
              }} = response
    end

    test "when there are invalid params, returns the error" do
      user = insert(:user)
      account = insert(:account, %{user_id: user.id})

      {:error, response} = Create.call(account, "banana", :credit)

      expected_response = %{value: ["is invalid"]}

      assert errors_on(response) == expected_response
    end
  end
end

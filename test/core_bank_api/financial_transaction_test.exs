defmodule CoreBankApi.FinancialTransactionTest do
  use CoreBankApi.DataCase, async: true

  import CoreBankApi.Factory

  alias CoreBankApi.FinancialTransaction
  alias Ecto.Changeset

  describe "changeset/2" do
    test "when all params are valid, returns a valid changeset" do
      params = build(:financial_transaction_params)

      response = FinancialTransaction.changeset(params)

      assert %Changeset{
               changes: %{
                 account_id: "8ce40338-521f-4f6a-9c0e-a9022e81655e",
                 date: ~D[2021-08-01],
                 type: :credit,
                 value: _
               },
               valid?: true
             } = response
    end

    test "when there are some error, returns an invalid changeset with info error" do
      params =
        build(:financial_transaction_params, %{
          "type" => "",
          "date" => "",
          "value" => "",
          "account_id" => ""
        })

      response = FinancialTransaction.changeset(params)

      expected_response = %{
        type: ["can't be blank"],
        date: ["can't be blank"],
        value: ["can't be blank"],
        account_id: ["can't be blank"]
      }

      assert errors_on(response) == expected_response
    end
  end
end

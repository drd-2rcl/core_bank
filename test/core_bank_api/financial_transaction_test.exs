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

  describe "all_transactions/1" do
    test "when id is valid, returns the transactions" do
      today = Date.utc_today()
      beg_week = Date.beginning_of_week(today)
      end_week = Date.end_of_week(today)
      junho = ~D[2021-06-02]
      maio = ~D[2021-05-02]
      user = insert(:user)
      account = insert(:account, %{user_id: user.id, id: "41ac7822-5f62-4d49-b124-fe8db9a85dff"})
      insert(:financial_transaction, %{account_id: account.id})

      insert(:financial_transaction, %{
        account_id: account.id,
        date: end_week,
        value: "32.94",
        id: "afa26b99-3cf1-460b-9871-7bd3d768b9b4"
      })

      insert(:financial_transaction, %{
        account_id: account.id,
        date: beg_week,
        value: "127.22",
        id: "ccd030b6-5756-442e-981c-69bab8d985db"
      })

      insert(:financial_transaction, %{
        account_id: account.id,
        date: junho,
        value: "45.71",
        id: "9bb2e56e-64d5-46c5-9768-360747d0ff6a",
        type: :debit
      })

      insert(:financial_transaction, %{
        account_id: account.id,
        date: beg_week,
        value: "1.00",
        id: "19190250-887e-4769-8505-bf66a808f45f",
        type: :debit
      })

      insert(:financial_transaction, %{
        account_id: account.id,
        date: maio,
        value: "500.00",
        id: "8b9a8fa3-e6e6-4d13-9a2e-458599cf4166",
        type: :debit
      })

      insert(:financial_transaction, %{
        account_id: account.id,
        date: today,
        value: "236.70",
        id: "2adc3cb8-180a-4bc5-a47f-d4a07da1ae6c",
        type: :debit
      })

      _response = FinancialTransaction.verify_account_and_get_all_transactions(account.id)

      assert _response = [
               [
                 "R$ Entrada/dia",
                 "R$ Saída/dia",
                 "R$ Entrada/mês",
                 "R$ Saída/mês",
                 "R$ Entrada/ano",
                 "R$ Saída/ano"
               ],
               [
                 [Decimal.new("10.0")] ++
                   [Decimal.new("236.70")] ++
                   [Decimal.new("170.16")] ++
                   [Decimal.new("237.70")] ++ [Decimal.new("170.16")] ++ [Decimal.new("783.41")]
               ]
             ]
    end

    test "when there are some error, returns the error" do
      response =
        FinancialTransaction.verify_account_and_get_all_transactions(
          "fdb5d4c8-fba5-4655-bc99-59963c953b4c"
        )

      assert {:error, %{result: "Account not found!", status: :not_found}} == response
    end
  end
end

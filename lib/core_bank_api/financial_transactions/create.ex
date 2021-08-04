defmodule CoreBankApi.FinancialTransactions.Create do
  alias CoreBankApi.{FinancialTransaction, Repo}

  def call(account, value, operation) do
    params = %{
      type: operation,
      date: Date.utc_today(),
      value: value,
      account_id: account.id
    }

    params
    |> FinancialTransaction.changeset()
    |> Repo.insert()
  end
end

defmodule CoreBankApi.FinancialTransactions.Create do
  @moduledoc """
  This module is responsible for creating the financial transaction

  This can be used as:

      alias CoreBankApi.FinancialTransactions.Create
      Create.call(account, "10.0", :credit)
  """
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

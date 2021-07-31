defmodule CoreBankApi.Transfers.Credit do
  @moduledoc """
  This module is responsible for receiving amounts that will be credited to an account.

    This can be used as:

      alias CoreBankApi.Transfers.Credit
      Credit.call(%{"id" => "3ee6694d-518e-489f-987e-09325500e497", "value" => "10.0"})
  """
  alias CoreBankApi.Repo
  alias CoreBankApi.Transfers.Operation

  def call(params) do
    params
    |> Operation.call(:credit)
    |> run_transaction()
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, %{status: :bad_request, result: reason}}
      {:ok, %{account_credit: account}} -> {:ok, account}
    end
  end
end

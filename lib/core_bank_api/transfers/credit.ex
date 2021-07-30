defmodule CoreBankApi.Transfers.Credit do
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

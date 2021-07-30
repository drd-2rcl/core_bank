defmodule CoreBankApi.Transfers.Debit do
  alias CoreBankApi.Repo
  alias CoreBankApi.Transfers.Operation

  def call(params) do
    params
    |> Operation.call(:debit)
    |> run_transaction()
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} ->
        {:error, %{status: :bad_request, result: reason}}

      {:ok, %{account_debit: account}} ->
        {:ok, account}
        # Criar um registro na tabela de withdraw e enviar email
    end
  end
end

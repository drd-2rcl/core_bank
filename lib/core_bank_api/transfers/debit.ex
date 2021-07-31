defmodule CoreBankApi.Transfers.Debit do
  @moduledoc """
  This module is responsible for receiving amounts that will be debited from an account.

    This can be used as:

      alias CoreBankApi.Transfers.Debit
      Debit.call(%{"id" => "3ee6694d-518e-489f-987e-09325500e497", "value" => "10.0"})
  """
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

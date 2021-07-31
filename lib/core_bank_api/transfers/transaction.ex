defmodule CoreBankApi.Transfers.Transaction do
  @moduledoc """
  This module is responsible for carrying out transfers between accounts.

    This can be used as:

      alias CoreBankApi.Transfers.Transaction
      params = %{
        "from_account" => "3ee6694d-518e-489f-987e-09325500e497",
        "to_account" => "0eaddc71-87fb-435e-bac8-3e19de0f924f",
        "value" => "20.0"
      }
      Transaction.call(params)
  """
  alias CoreBankApi.{Repo, Transfer}
  alias CoreBankApi.Transfers.Operation
  alias Ecto.Multi

  def call(%{"from_account" => from_account, "to_account" => to_account, "value" => value}) do
    debit_params = build_params(from_account, value)
    credit_params = build_params(to_account, value)

    Multi.new()
    |> Multi.merge(fn _changes -> Operation.call(debit_params, :debit) end)
    |> Multi.merge(fn _changes -> Operation.call(credit_params, :credit) end)
    |> Multi.run(:create_transaction, fn repo, %{credit: to_account, debit: from_account} ->
      create_transfer(repo, to_account, from_account, value)
    end)
    |> run_transaction()
  end

  defp build_params(id, value), do: %{"id" => id, "value" => value}

  defp create_transfer(repo, to_account, from_account, value) do
    params = %{
      "from_account" => from_account.id,
      "to_account" => to_account.id,
      "amount" => value
    }

    params
    |> Transfer.changeset()
    |> repo.insert()
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} ->
        {:error, %{status: :bad_request, result: reason}}

      {:ok, %{create_transaction: transfer}} ->
        {:ok,
         %{
           create_transaction: %Transfer{
             from_account: transfer.from_account,
             to_account: transfer.to_account,
             amount: transfer.amount
           }
         }}
    end
  end
end

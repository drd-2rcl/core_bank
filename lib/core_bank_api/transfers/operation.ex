defmodule CoreBankApi.Transfers.Operation do
  @moduledoc """
  This module is responsible for operations with credit and debit to update account balance.
  The objective was to abstract the operations within the credit and debit modules that differ
  only in addition and subtraction. Because it behaves like an intermediate module, it will not
  return a final value, but anonymous functions that were executed and will be terminated
  in the modules that were called.
  """
  alias Ecto.Multi
  alias CoreBankApi.Account
  alias CoreBankApi.Accounts.Get, as: GetAccount

  def call(%{"id" => id, "value" => value}, operation) do
    operation_name = account_operation_name(operation)

    Multi.new()
    |> Multi.run(operation_name, fn _repo, _result -> GetAccount.by_id(id) end)
    |> Multi.run(operation, fn repo, changes ->
      account = Map.get(changes, operation_name)
      update_balance(repo, account, value, operation)
    end)
  end

  defp update_balance(repo, account, value, operation) do
    account
    |> operation(value, operation)
    |> update_account(repo, account)
  end

  defp operation(%Account{balance: balance}, value, operation) do
    value
    |> Decimal.cast()
    |> handle_cast(balance, operation)
  end

  defp handle_cast({:ok, value}, balance, :credit), do: Decimal.add(balance, value)
  defp handle_cast({:ok, value}, balance, :debit), do: Decimal.sub(balance, value)
  defp handle_cast(:error, _balance, _operation), do: {:error, "Invalid transfer value!"}

  defp update_account({:error, _reason} = error, _repo, _account), do: error

  defp update_account(value, repo, account) do
    params = %{balance: value}

    account
    |> Account.changeset(params)
    |> repo.update()
  end

  defp account_operation_name(operation) do
    "account_#{Atom.to_string(operation)}" |> String.to_atom()
  end
end

defmodule CoreBankApi.Accounts.Withdraw do
  @moduledoc """
  This module is responsible for create withdraw

  This can be used as:

      alias CoreBankApi.Accounts.Withdraw
      Withdraw.call(%{"id" => "5a7886b9-c3f8-4f40-b9b9-e6895410f7f1", "value" => "10.0"})
  """
  alias CoreBankApi.Transfers.Debit
  alias CoreBankApi.{Account, Repo, Withdraw}
  alias CoreBankApi.Accounts.WithdrawEmail

  def call(%{"id" => _id, "value" => value} = params) do
    case Debit.call(params) do
      {:error, reason} -> {:error, reason}
      {:ok, account} -> insert_withdraw(account, value)
    end
  end

  defp insert_withdraw(%Account{id: account_id}, value) do
    params = %{account_id: account_id, amount: value}

    params
    |> Withdraw.changeset()
    |> Repo.insert()
    |> handle_preload()
  end

  defp handle_preload({:error, error}), do: error

  defp handle_preload({:ok, withdraw}) do
    case Repo.get(Account, withdraw.account_id) do
      nil -> {:error, "Account not found!"}
      account -> send_email(account)
    end
  end

  defp send_email(account) do
    account
    |> WithdrawEmail.call()

    {:ok, account}
  end
end

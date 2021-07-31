defmodule CoreBankApi do
  @moduledoc """
  CoreBankApi keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias CoreBankApi.Accounts.Withdraw, as: WithdrawCreate
  alias CoreBankApi.Transfers.Transaction, as: TransferCreate
  alias CoreBankApi.Users.Create, as: UserCreate

  defdelegate create_user(params), to: UserCreate, as: :call
  defdelegate create_transfer(params), to: TransferCreate, as: :call
  defdelegate create_withdraw(params), to: WithdrawCreate, as: :call
end

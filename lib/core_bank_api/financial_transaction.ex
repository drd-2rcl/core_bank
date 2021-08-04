defmodule CoreBankApi.FinancialTransaction do
  @moduledoc """
  This module is responsible for validating the parameters needed to create a financial transaction

  This can be used as:

      alias CoreBankApi.FinancialTransaction
      params = %{
        type: "credit",
        date: ~D[2021-08-01],
        value: "10.0",
        account_id: "da4cf0808-c436-40df-887c-3de44fb25b5c"
      }
      FinancialTransaction.changeset(params)
  """
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias CoreBankApi.{Account, FinancialTransaction, Repo}
  alias CoreBankApi.Accounts.Get, as: GetAccount
  alias Ecto.Enum

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @financial_transaction_types [:credit, :debit]
  @required_params [:type, :date, :value, :account_id]

  schema "financial_transactions" do
    field :type, Enum, values: @financial_transaction_types
    field :date, :date
    field :value, :decimal
    belongs_to :account, Account

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end

  def all_transactions(id) do
    {:ok, account} = GetAccount.by_id(id)

    day_in = credit_transaction_group_by_day_by_account(account.id)
    day_out = debit_transaction_group_by_day_by_account(account.id)
    month_in = credit_transaction_group_by_month_by_account(account.id)
    month_out = debit_transaction_group_by_month_by_account(account.id)
    year_in = credit_transaction_group_by_year_by_account(account.id)
    year_out = debit_transaction_group_by_year_by_account(account.id)

    [["R$ Entrada/dia", "R$ Saída/dia", "R$ Entrada/mês", "R$ Saída/mês", "R$ Entrada/ano", "R$ Saída/ano"], day_in ++ day_out ++ month_in ++ month_out ++ year_in ++ year_out]
  end

  defp credit_transaction_group_by_day_by_account(id) do
    today = Date.utc_today()

    query =
      from ft in FinancialTransaction,
        join: a in Account,
        where:
          a.id == ft.account_id and
            a.id == ^id and
            ft.type == :credit and
            ft.date == ^today,
        select: sum(ft.value)

    Repo.all(query)
  end

  defp debit_transaction_group_by_day_by_account(id) do
    today = Date.utc_today()

    query =
      from ft in FinancialTransaction,
        join: a in Account,
        where:
          a.id == ft.account_id and
            a.id == ^id and
            ft.type == :debit and
            ft.date == ^today,
        select: sum(ft.value)

    Repo.all(query)
  end

  defp credit_transaction_group_by_month_by_account(id) do
    today = Date.utc_today()
    beginning_of_month = Date.beginning_of_month(today)
    end_of_month = Date.end_of_month(today)

    query =
      from ft in FinancialTransaction,
        join: a in Account,
        where:
          a.id == ft.account_id and
            a.id == ^id and
            ft.type == :credit and
            ft.date >= ^beginning_of_month and
            ft.date <= ^end_of_month,
        select: sum(ft.value)

    Repo.all(query)
  end

  defp debit_transaction_group_by_month_by_account(id) do
    today = Date.utc_today()
    beginning_of_month = Date.beginning_of_month(today)
    end_of_month = Date.end_of_month(today)

    query =
      from ft in FinancialTransaction,
        join: a in Account,
        where:
          a.id == ft.account_id and
            a.id == ^id and
            ft.type == :debit and
            ft.date >= ^beginning_of_month and
            ft.date <= ^end_of_month,
        select: sum(ft.value)

    Repo.all(query)
  end

  defp credit_transaction_group_by_year_by_account(id) do
    query =
      from ft in FinancialTransaction,
        join: a in Account,
        where:
          a.id == ft.account_id and
            a.id == ^id and
            ft.type == :credit,
        select: [fragment("to_char(?, 'YYYY') as year", ft.date), sum(ft.value)],
        group_by: fragment("year"),
        order_by: [desc: fragment("year")]

    result =
      query
      |> Repo.all()
      |> Map.new(fn [k, v] -> {k, v} end)

    [result["2021"]]
  end

  defp debit_transaction_group_by_year_by_account(id) do
    query =
      from ft in FinancialTransaction,
        join: a in Account,
        where:
          a.id == ft.account_id and
            a.id == ^id and
            ft.type == :debit,
        select: [fragment("to_char(?, 'YYYY') as year", ft.date), sum(ft.value)],
        group_by: fragment("year"),
        order_by: [desc: fragment("year")]

    result =
      query
      |> Repo.all()
      |> Map.new(fn [k, v] -> {k, v} end)

    [result["2021"]]
  end
end

defmodule CoreBankApi.Repo.Migrations.CreateFinancialTransactionsTable do
  use Ecto.Migration

  def change do
    create table(:financial_transactions) do
      add :type, :financial_transaction_type
      add :date, :date
      add :value, :decimal
      add :account_id, references(:accounts, type: :binary_id)

      timestamps()
    end
  end
end

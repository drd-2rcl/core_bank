defmodule CoreBankApi.Repo.Migrations.CreateAccountsTable do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :balance, :decimal, default: 1000.00
      add :user_id, references(:users, type: :binary_id)

      timestamps()
    end

    create constraint(:accounts, :balance_must_be_positive_or_zero, check: "balance >= 0")
  end
end

defmodule CoreBankApi.Repo.Migrations.CreateWithdrawsTable do
  use Ecto.Migration

  def change do
    create table(:withdraws) do
      add :amount, :decimal
      add :account_id, references(:accounts, type: :binary_id)

      timestamps()
    end
  end
end

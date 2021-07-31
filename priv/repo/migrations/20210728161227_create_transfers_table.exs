defmodule CoreBankApi.Repo.Migrations.CreateTransfersTable do
  use Ecto.Migration

  def change do
    create table("transfers") do
      add :from_account, :string
      add :to_account, :string
      add :amount, :decimal

      timestamps()
    end
  end
end

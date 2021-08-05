defmodule CoreBankApi.Repo.Migrations.CreateFinancialTransactionsType do
  use Ecto.Migration

  def change do
    up_query = "CREATE TYPE financial_transaction_type AS ENUM ('credit', 'debit')"
    down_query = "DROP TYPE financial_transaction_type"

    execute(up_query, down_query)
  end
end

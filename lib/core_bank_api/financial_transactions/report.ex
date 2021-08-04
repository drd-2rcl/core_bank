defmodule CoreBankApi.FinancialTransactions.Report do
  alias CoreBankApi.{FinancialTransaction}

  def call(id) do
    File.write("report.csv", FinancialTransaction.all_transactions(id))
  end
end

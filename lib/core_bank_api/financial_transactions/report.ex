defmodule CoreBankApi.FinancialTransactions.Report do
  @moduledoc """
  This module is responsible for creating the report with financial transactions

  This can be used as:

      alias CoreBankApi.FinancialTransactions.Report
      Report.call(account.id)
  """
  alias CoreBankApi.FinancialTransaction

  def call(id) do
    case File.write("report.csv", FinancialTransaction.all_transactions(id)) do
      :error -> {:error, %{result: "Error generating report.", status: :bad_request}}
      :ok -> {:ok, "Report generated successfully"}
    end
  end
end

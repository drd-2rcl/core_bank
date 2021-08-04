defmodule CoreBankApiWeb.Api.V1.AccountController do
  use CoreBankApiWeb, :controller

  alias CoreBankApi.Account
  alias CoreBankApiWeb.Api.V1.FallbackController
  alias CoreBankApi.FinancialTransaction

  action_fallback FallbackController

  def withdraw(conn, params) do
    with {:ok, %Account{} = account} <- CoreBankApi.create_withdraw(params) do
      conn
      |> put_status(:ok)
      |> render("update.json", account: account)
    end
  end

  def export(conn, %{"id" => id}) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"report.csv\"")
    |> send_resp(200, csv_content(id))
  end

  defp csv_content(id) do
    FinancialTransaction.all_transactions(id)
    |> CSV.encode
    |> Enum.to_list
    |> to_string
  end
end

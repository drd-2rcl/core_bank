defmodule CoreBankApiWeb.Api.V1.AccountController do
  use CoreBankApiWeb, :controller

  alias CoreBankApi.Account
  alias CoreBankApiWeb.Api.V1.FallbackController

  action_fallback FallbackController

  def withdraw(conn, params) do
    with {:ok, %Account{} = account} <- CoreBankApi.create_withdraw(params) do
      conn
      |> put_status(:ok)
      |> render("update.json", account: account)
    end
  end
end

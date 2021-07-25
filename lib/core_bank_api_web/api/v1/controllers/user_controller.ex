defmodule CoreBankApiWeb.Api.V1.UserController do
  use CoreBankApiWeb, :controller

  alias CoreBankApi.User
  alias CoreBankApiWeb.Api.V1.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- CoreBankApi.create_user(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end
end

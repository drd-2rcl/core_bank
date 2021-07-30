defmodule CoreBankApiWeb.Api.V1.TransferController do
  use CoreBankApiWeb, :controller

  alias CoreBankApi.Transfer
  alias CoreBankApiWeb.Api.V1.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, %{create_transaction: %Transfer{} = transfer}} <-
           CoreBankApi.create_transfer(params) do
      conn
      |> put_status(:created)
      |> render("create.json", transfer: transfer)
    end
  end
end

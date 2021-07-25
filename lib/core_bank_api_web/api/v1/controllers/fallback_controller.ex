defmodule CoreBankApiWeb.Api.V1.FallbackController do
  use CoreBankApiWeb, :controller

  alias CoreBankApiWeb.ErrorView

  def call(conn, {:error, %{status: status, result: result}}) do
    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render("error.json", result: result)
  end
end

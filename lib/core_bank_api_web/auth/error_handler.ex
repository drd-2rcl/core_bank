defmodule CoreBankApiWeb.Auth.ErrorHandler do
  @moduledoc """
  This module is responsible for handling authentication errors
  """
  alias CoreBankApiWeb.Auth.ErrorHandler
  alias Plug.Conn

  @behaviour ErrorHandler

  def auth_error(conn, {error, _reason}, _opts) do
    body = Jason.encode!(%{message: to_string(error)})

    Conn.send_resp(conn, 401, body)
  end
end

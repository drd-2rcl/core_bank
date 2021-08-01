defmodule CoreBankApiWeb.Auth.Pipeline do
  @moduledoc false
  use Guardian.Plug.Pipeline, otp_app: :core_bank_api

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end

defmodule CoreBankApi.Repo do
  use Ecto.Repo,
    otp_app: :core_bank_api,
    adapter: Ecto.Adapters.Postgres
end

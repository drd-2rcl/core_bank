defmodule CoreBankApiWeb.Api.V1.AccountView do
  use CoreBankApiWeb, :view

  def render("update.json", %{
        account: account
      }) do
    %{
      message: "Successful withdrawal!",
      account: %{
        id: account.id,
        balance: "R$ #{account.balance}"
      }
    }
  end
end

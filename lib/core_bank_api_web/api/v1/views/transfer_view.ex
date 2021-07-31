defmodule CoreBankApiWeb.Api.V1.TransferView do
  use CoreBankApiWeb, :view

  def render("create.json", %{
        transfer: transfer
      }) do
    %{
      message: "Transfer created!",
      transfer: %{
        from_account: transfer.from_account,
        to_account: transfer.to_account,
        amount: transfer.amount
      }
    }
  end
end

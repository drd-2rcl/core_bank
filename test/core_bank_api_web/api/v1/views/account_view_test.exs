defmodule CoreBankApiWeb.Api.V1.AccountViewTest do
  use CoreBankApiWeb.ConnCase, async: true

  import Phoenix.View
  import CoreBankApi.Factory

  alias CoreBankApiWeb.Api.V1.AccountView

  test "renders update.json" do
    account = build(:withdraw_account)

    response =
      render(AccountView, "update.json", %{
        account: account
      })

    assert %{
             account: %{balance: "R$ 210.0", id: "41ac7822-5f62-4d49-b124-fe8db9a85dff"},
             message: "Successful withdrawal!"
           } = response
  end
end

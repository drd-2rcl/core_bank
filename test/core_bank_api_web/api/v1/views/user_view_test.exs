defmodule CoreBankApiWeb.Api.V1.UserViewTest do
  use CoreBankApiWeb.ConnCase, async: true

  import Phoenix.View
  import CoreBankApi.Factory

  alias CoreBankApiWeb.Api.V1.UserView
  alias CoreBankApi.{Account, User}

  test "renders create.json" do
    user = build(:user)
    account = build(:account)

    response =
      render(UserView, "create.json", %{
        user: %User{
          account: %Account{id: user.account.id, balance: account.balance},
          id: user.id,
          name: user.name,
          email: user.email
        }
      })

    assert %{
             message: "User created!",
             user: %{
               account: %{balance: "R$ 10", id: "961070c5-9f77-4cd2-80af-8900386e10fb"},
               email: "barry_allen@teamflash.com",
               id: "f2496b9e-2b97-4abe-9856-738abcdc3d91",
               name: "Barry Allen"
             }
           } = response
  end
end

defmodule CoreBankApiWeb.Api.V1.UserViewTest do
  use CoreBankApiWeb.ConnCase, async: true

  import Phoenix.View
  import CoreBankApi.Factory

  alias CoreBankApiWeb.Api.V1.UserView

  test "renders create.json" do
    user = build(:user)

    response = render(UserView, "create.json", user: user)

    assert %{
             message: "User created!",
             user: %CoreBankApi.User{
               age: 23,
               email: "barry_allen@teamflash.com",
               id: "f2496b9e-2b97-4abe-9856-738abcdc3d91",
               inserted_at: nil,
               name: "Barry Allen",
               password: "123456",
               password_hash: nil,
               updated_at: nil
             }
           } = response
  end
end

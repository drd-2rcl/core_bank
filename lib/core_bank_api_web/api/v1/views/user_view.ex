defmodule CoreBankApiWeb.Api.V1.UserView do
  use CoreBankApiWeb, :view

  alias CoreBankApi.{Account, User}

  def render("create.json", %{
        user: %User{
          account: %Account{id: account_id, balance: balance},
          id: id,
          name: name,
          email: email
        }
      }) do
    %{
      message: "User created!",
      user: %{
        id: id,
        name: name,
        email: email,
        account: %{
          id: account_id,
          balance: "R$ #{balance}"
        }
      }
    }
  end
end

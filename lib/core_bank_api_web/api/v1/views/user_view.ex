defmodule CoreBankApiWeb.Api.V1.UserView do
  use CoreBankApiWeb, :view

  alias CoreBankApi.{Account, User}

  def render("create.json", %{
        token: token,
        user: %User{
          account: %Account{id: account_id, balance: balance},
          id: id,
          name: name,
          email: email
        }
      }) do
    %{
      message: "User created!",
      token: token,
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

  def render("sign_in.json", %{token: token}), do: %{token: token}
end

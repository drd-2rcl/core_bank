defmodule CoreBankApiWeb.Api.V1.UserView do
  use CoreBankApiWeb, :view

  alias CoreBankApi.User

  def render("create.json", %{user: %User{} = user}) do
    %{
      message: "User created!",
      user: user
    }
  end
end

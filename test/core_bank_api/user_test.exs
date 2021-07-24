defmodule CoreBankApi.UserTest do
  use CoreBankApi.DataCase, async: true

  alias Ecto.Changeset

  describe "changeset/2" do
    test "when all params are valid, returns a valid changeset" do
      params = %{
        name: "Teste",
        age: 23,
        email: "teste@teste.com",
        password_hash: "123456",
      }

      response = User.changeset(params)

      assert %Changeset{changes: %{name: "Caco"}, valid?: false} = response
    end
  end
end
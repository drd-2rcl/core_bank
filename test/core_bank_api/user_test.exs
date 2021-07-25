defmodule CoreBankApi.UserTest do
  use CoreBankApi.DataCase, async: true

  import CoreBankApi.Factory

  alias CoreBankApi.User
  alias Ecto.Changeset

  describe "changeset/2" do
    test "when all params are valid, returns a valid changeset" do
      params = build(:user_params)

      response = User.changeset(params)

      assert %Changeset{changes: %{name: "Barry Allen"}, valid?: true} = response
    end

    test "when there are some error, returns an invalid changeset with info error" do
      params =
        build(:user_params, %{"age" => 13, "email" => "testeteste.com", "password" => "123"})

      response = User.changeset(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["should be at least 6 character(s)"],
        email: ["has invalid format"]
      }

      assert errors_on(response) == expected_response
    end
  end
end

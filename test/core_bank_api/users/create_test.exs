defmodule CoreBankApi.Users.CreateTest do
  use CoreBankApi.DataCase, async: true

  alias CoreBankApi.User
  import CoreBankApi.Factory

  describe "call/1" do
    test "when all params are valid, returns the user" do
      params = build(:user_params)

      response = CoreBankApi.create_user(params)

      assert {:ok, %User{id: _id, age: 23, email: "barry_allen@teamflash.com"}} = response
    end

    test "when there are invalid params, returns the error" do
      params = build(:user_params, %{"age" => 13, "password" => "123"})

      response = CoreBankApi.create_user(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["should be at least 6 character(s)"]
      }

      assert {:error, %{status: :bad_request, result: changeset}} = response
      assert errors_on(changeset) == expected_response
    end
  end
end

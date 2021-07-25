defmodule CoreBankApiWeb.Api.V1.UserControllerTest do
  use CoreBankApiWeb.ConnCase, async: true

  import CoreBankApi.Factory

  describe "create/2" do
    test "when all params are valid, creates the user", %{conn: conn} do
      params = build(:user_params)

      response =
        conn
        |> post(Routes.user_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "message" => "User created!",
               "user" => %{
                 "email" => "barry_allen@teamflash.com",
                 "id" => _,
                 "name" => "Barry Allen"
               }
             } = response
    end

    test "when exist error, returns the error", %{conn: conn} do
      params = build(:user_params, %{"age" => 13, "password" => "123"})

      response =
        conn
        |> post(Routes.user_path(conn, :create, params))
        |> json_response(:bad_request)

      assert %{
               "message" => %{
                 "age" => ["must be greater than or equal to 18"],
                 "password" => ["should be at least 6 character(s)"]
               }
             } = response
    end
  end
end

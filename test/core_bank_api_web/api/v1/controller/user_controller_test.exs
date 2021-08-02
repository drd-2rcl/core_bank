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

  describe "sign_in/2" do
    test "when all params are valid, sign_in the user", %{conn: conn} do
      user = insert(:user)
      params = %{"id" => user.id, "password" => user.password}

      response =
        conn
        |> post(Routes.user_path(conn, :sign_in, params))
        |> json_response(:ok)

      assert %{"token" => _} = response
    end

    test "when params are invalid", %{conn: conn} do
      response =
        conn
        |> post(Routes.user_path(conn, :sign_in, %{}))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid or missing params"} = response
    end

    test "when credentials are invalid", %{conn: conn} do
      user = insert(:user)
      # params = %{"id" => "", "password" => "123"}
      params = %{"id" => user.id, "password" => "123"}

      response =
        conn
        |> post(Routes.user_path(conn, :sign_in, params))
        |> json_response(:unauthorized)

      assert %{"message" => "Please verify your credentials"} =
               response
    end

    test "when ID is invalid", %{conn: conn} do
      params = %{"id" => "", "password" => "123"}

      response =
        conn
        |> post(Routes.user_path(conn, :sign_in, params))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid ID format!"} = response
    end
  end
end

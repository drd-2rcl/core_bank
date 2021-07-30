defmodule CoreBankApi.Factory do
  @moduledoc """
  The factory module was created to help setup the tests

  To use it, define a function with the name of the module that will be tested and with the necessary parameters, for example:

  def user_params_factory do
    %{
      name: "Barry Allen",
      age: 23,
      email: "barry_allen@teamflash.com",
      password: "123456"
    }
  end
  """
  use ExMachina.Ecto, repo: CoreBankApi.Repo
  alias CoreBankApi.{Account, User}

  def user_params_factory do
    %{
      "name" => "Barry Allen",
      "age" => 23,
      "email" => "barry_allen@teamflash.com",
      "password" => "123456"
    }
  end

  def user_factory do
    %User{
      id: "f2496b9e-2b97-4abe-9856-738abcdc3d91",
      name: "Barry Allen",
      age: 23,
      email: "barry_allen@teamflash.com",
      password: "123456",
      account: %{
        id: "961070c5-9f77-4cd2-80af-8900386e10fb",
        balance: 10
      }
    }
  end

  def account_params_factory do
    %{"balance" => 1000.00}
  end

  def account_factory do
    %Account{
      balance: 10,
      user_id: "f2496b9e-2b97-4abe-9856-738abcdc3d91"
    }
  end

  def transfer_params_factory do
    %{
      "from_account" => "5ced2ecb-b184-4bf1-8e5e-0d2cf899ad76",
      "to_account" => "a9df546c-a02e-4490-b13d-e43a13d76baa",
      "amount" => 10
    }
  end

  def account_credit_factory(attrs) do
    value = Map.get(attrs, :balance, 10)

    %Account{
      id: "71a39068-2e18-4f85-853a-b8d19fa5b7ba",
      balance: value,
      user_id: "f2496b9e-2b97-4abe-9856-738abcdc3d91"
    }
  end

  def account_debit_factory(attrs) do
    value = Map.get(attrs, :balance, 10)

    %Account{
      id: "71a39068-2e18-4f85-853a-b8d19fa5b7ba",
      balance: value,
      user_id: "f2496b9e-2b97-4abe-9856-738abcdc3d91"
    }
  end
end

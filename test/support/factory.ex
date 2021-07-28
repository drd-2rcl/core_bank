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
  use ExMachina
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
      id: "961070c5-9f77-4cd2-80af-8900386e10fb",
      balance: 10,
      user_id: "dc21eaeb-07aa-4062-835a-328314da2147"
    }
  end
end

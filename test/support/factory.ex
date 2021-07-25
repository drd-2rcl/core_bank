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

  def user_params_factory do
    %{
      name: "Barry Allen",
      age: 23,
      email: "barry_allen@teamflash.com",
      password: "123456"
    }
  end
end

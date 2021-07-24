defmodule CoreBankApi.User do
  @moduledoc """
  This module is responsible for validating the parameters needed to create a user

  This can be used as:

      alias CoreBankApi.User
      params = %{
        name: "Teste",
        age: 23,
        email: "teste@teste.com",
        password: "123456"
      }
      User.changeset(params)
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_params [:name, :age, :email, :password]

  schema "users" do
    field :name, :string
    field :age, :integer
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:password, min: 6)
    |> validate_number(:age, greater_than_or_equal_to: 18)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint([:email])
  end
end

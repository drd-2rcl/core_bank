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
  alias CoreBankApi.Account
  alias Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_params [:name, :age, :email, :password]
  @derive {Jason.Encoder, only: [:id, :name, :email]}

  schema "users" do
    field :name, :string
    field :age, :integer
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_one :account, Account

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
    |> put_password_hash()
  end

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Pbkdf2.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end

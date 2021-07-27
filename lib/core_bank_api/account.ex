defmodule CoreBankApi.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias CoreBankApi.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_params [:user_id, :balance]

  schema "accounts" do
    field :balance, :decimal
    belongs_to :user, User

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> check_constraint(:balance, name: :balance_must_be_positive_or_zero)
  end
end
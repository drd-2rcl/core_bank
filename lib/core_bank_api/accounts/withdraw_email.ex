defmodule CoreBankApi.Accounts.WithdrawEmail do
  @moduledoc """
  This module is responsible for send email when a withdrawal is made

  This can be used as:

      alias CoreBankApi.Accounts.WithdrawEmail
      WithdrawEmail.call(%Account{})
  """
  alias Bamboo.Email
  alias CoreBankApi.Accounts.Email, as: AccountEmail
  alias CoreBankApi.{Mailer, Repo, User}

  def call(account) do
    account.user_id
    |> get_user_email()
    |> send_email()
  end

  defp get_user_email(user_id) do
    case Repo.get(User, user_id) do
      nil -> {:error, "User not found!"}
      user -> {:ok, user}
    end
  end

  defp send_email({:ok, user}) do
    user.email
    |> AccountEmail.create()
    |> Mailer.deliver_now!()
    |> handle_send()

    # |> IO.inspect()
  end

  defp handle_send({:error, _error}), do: {:error, "Falha ao enviar o email"}
  defp handle_send(%Email{}), do: {:ok, "Email enviado com sucesso"}
end

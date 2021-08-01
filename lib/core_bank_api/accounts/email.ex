defmodule CoreBankApi.Accounts.Email do
  @moduledoc """
  This module is responsible for creating the email and
  entering the necessary information when sending

  This can be used as:

      alias CoreBankApi.Accounts.Email
      Email.create(email)
  """
  import Bamboo.Email

  def create(email) do
    new_email(
      to: email,
      from: "support@bank.com",
      subject: "Solitação de saque.",
      html_body: "<strong>Obrigado por nos utilizar!</strong>",
      text_body: "Seu saque foi realizado!"
    )
  end
end

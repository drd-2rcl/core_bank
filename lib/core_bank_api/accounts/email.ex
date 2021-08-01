defmodule CoreBankApi.Accounts.Email do
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

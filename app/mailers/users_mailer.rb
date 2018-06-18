class UsersMailer < ApplicationMailer

  def confirm_email(token, user, email)
    @token = token
    @user = user
    @email = email

    mail to: @email
  end
end

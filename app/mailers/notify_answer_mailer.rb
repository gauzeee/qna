class NotifyAnswerMailer < ApplicationMailer
  def send_notification(user, answer)
    @answer = answer

    mail to: user.email
  end
end

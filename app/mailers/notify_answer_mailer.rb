class NotifyAnswerMailer < ApplicationMailer
  def send_notification(user, question, answer)
    @answer = answer
    @question = question

    mail to: user.email
  end
end

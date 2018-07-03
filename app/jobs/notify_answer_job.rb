class NotifyAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscribers.each do |user|
      NotifyAnswerMailer.send_notification(user, answer).try(:deliver_later) unless answer.user == user
    end
  end
end

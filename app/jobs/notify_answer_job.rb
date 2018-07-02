class NotifyAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    question = answer.question
    answer.question.subscribers.find_each.each do |user|
      NotifyAnswerMailer.send_notification(user, question, answer).deliver_later(wait: 5.seconds)
    end
  end
end

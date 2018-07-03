require 'rails_helper'

RSpec.describe NotifyAnswerJob, type: :job do
  let(:subscribed_users) { create_list(:user, 2) }
  let(:unsubscribed_users) { create_list(:user, 2) }
  let(:question) { create(:question, user: subscribed_users[0]) }
  let(:answer) {create(:answer, question: question) }

  it 'notify subscribed users' do
    question.subscribe(subscribed_users[1])
    subscribed_users.each do |user|
      expect(NotifyAnswerMailer).to receive(:send_notification).with(user, answer).and_call_original
    end
    NotifyAnswerJob.perform_now(answer)
  end

  it 'unsubscribed users do not get notify of new answer' do
    unsubscribed_users.each do |user|
      expect(NotifyAnswerMailer).to_not receive(:send_notification).with(user, answer)
    end
    NotifyAnswerJob.perform_now(answer)
  end
end

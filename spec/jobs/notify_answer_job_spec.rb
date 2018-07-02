require 'rails_helper'

RSpec.describe NotifyAnswerJob, type: :job do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) {create(:answer, question: question, user: user)}

  it 'user got notify of new answer' do
    question.unsubscribe(user)

    expect(NotifyAnswerMailer).to_not receive(:send_notification).with(user, question, answer).and_call_original

    NotifyAnswerJob.perform_now(answer)
  end
end

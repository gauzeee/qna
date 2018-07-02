require "rails_helper"

RSpec.describe NotifyAnswerMailer, type: :mailer do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question) }
  let(:mail) { NotifyAnswerMailer.send_notification(user, question, answer) }

    it "renders the headers" do
      expect(mail.to).to eq([user.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(question.title)
      expect(mail.body.encoded).to match(answer.body)
    end

end

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should validate_presence_of :body }

  describe 'update best answer' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    it 'when question have best answer' do
      best_answer = create(:answer, question: question, best: true)

      expect(best_answer).to eql question.current_best_answer

      answer.update_best

      expect(answer).to eql question.current_best_answer
      expect(best_answer).to_not eql question.current_best_answer
    end

    it 'when question have not best answer' do
      expect(question.current_best_answer).to eq nil

      answer.update_best

      expect(answer).to eql question.current_best_answer
    end
  end
end

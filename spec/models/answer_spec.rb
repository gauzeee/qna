require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should validate_presence_of :body }

  describe 'update best answer' do
    let(:question) { create(:question) }
    let(:new_answer) { create(:answer, question: question) }

    it 'already have best answer as current best answer' do
      best_answer = create(:answer, question: question, best: true)
      expect(best_answer).to eql question.current_best_answer
    end

    it 'set new answer as best answer of question' do
      new_answer.update_best

      expect(new_answer).to eql question.current_best_answer
    end

    it 'have not current best answer of question' do
      expect(question.current_best_answer).to eq nil
    end
  end
end

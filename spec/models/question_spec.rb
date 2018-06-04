require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }


  describe 'check best answer' do
  let(:question) { create(:question) }

    it 'current question already has best answer' do
      answer = create(:answer, question: question, best: true)
      expect(question).to be_got_best
    end

    it 'current question don`t have best answer yet' do
      expect(question).to_not be_got_best
    end
  end
end


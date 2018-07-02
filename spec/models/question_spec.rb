require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:likes).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  it_behaves_like 'likable'
  it_behaves_like 'commentable'


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

  describe 'subscriptions' do
    let(:user) { create(:user) }
    let(:new_user) { create(:user) }
    let(:question) { create(:question) }
    before { question.subscribe(user) }

    context '#subscribe(user' do
      it 'add subscriber' do
        question.subscribe(new_user)

        expect(question.subscribers).to include(new_user)
      end
    end

    context '#unsubscribe(user)' do
      it 'remove subscriber' do
        question.unsubscribe(user)

        expect(question.subscribers).to_not include(user)
      end
    end

    context '#subscribed?(user)' do
      it 'user subscriber' do
        expect(question).to_not be_subscribed(new_user)
      end

      it 'user not subscriber' do
        expect(question).to be_subscribed(user)
      end
    end
  end
end


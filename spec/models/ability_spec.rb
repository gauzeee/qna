require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all}
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create :question }
    let(:user_question) { create :question, user: user }
    let(:other_question) { create :question, user: other }
    let(:user_answer) { create :answer, user: user }
    let(:other_answer) { create :answer, question: user_question, user: other }
    let(:attachment) { create :attachment, attachable: user_question }
    let(:other_attachment) { create :attachment, attachable: other_question }
    let!(:like) { create(:like, likable: question, user: user) }
    let!(:like_answer) { create(:like, likable: other_answer, user: user) }
    let!(:other_like) { create(:like, likable: other_question, user: other) }
    let!(:other_like_answer) { create(:like, likable: user_answer, user: other) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, user_question, user: user }
    it { should_not be_able_to :update, other_question, user: user}

    it { should be_able_to :update, user_answer, user: user }
    it { should_not be_able_to :update, other_answer, user: user}

    it { should be_able_to :update, create(:comment, commentable: question, user: user), user: user }
    it { should_not be_able_to :update, create(:comment, commentable: question, user: other), user: user}

    it { should be_able_to :destroy, user_question, user: user }
    it { should be_able_to :destroy, user_answer, user: user }
    it { should be_able_to :destroy, attachment, user: user }

    it { should_not be_able_to :destroy, other_question, user: user }
    it { should_not be_able_to :destroy, other_answer, user: user }
    it { should_not be_able_to :destroy, other_attachment, user: user }

    it { should be_able_to [:rate_up, :rate_down], other_question, user: user }
    it { should be_able_to [:rate_up, :rate_down], other_answer, user: user }
    it { should_not be_able_to [:rate_up, :rate_down], user_question, user: user }
    it { should_not be_able_to [:rate_up, :rate_down], user_answer, user: user }

    it { should be_able_to :rate_revoke, question, user: user }
    it { should_not be_able_to :rate_revoke, other_question, user: user }

    it { should be_able_to :rate_revoke, other_answer, user: user }
    it { should_not be_able_to :rate_revoke, user_answer, user: user }

    it { should be_able_to :set_best, other_answer, user: user }
    it { should_not be_able_to :set_best, user_answer, user: other }

  end
end

require 'rails_helper'

RSpec.describe User do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'check author of item' do
    let(:user) { create(:user) }

    it 'current user is an author' do
      question = create(:question, user: user)

      expect(user.author_of?(question)).to be true
    end

    it 'current user is not an author' do
      question = create(:question)

      expect(user.author_of?(question)).to_not be true
    end
  end
end

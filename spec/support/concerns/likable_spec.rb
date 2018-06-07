require 'rails_helper'

RSpec.shared_examples_for 'likable' do
  let(:model) { described_class }
  let(:user) { create(:user) }
  let(:new_user) { create(:user) }

  it '#rate_up' do
    likable = create(model.to_s.underscore.to_sym)
    likable.rate_up(user)
    expect(Like.last.rating).to eq 1
    expect(Like.last.user).to eq user
    expect(Like.last.likable).to eq likable
  end

  it '#rate_down' do
    likable = create(model.to_s.underscore.to_sym)
    likable.rate_down(user)
    expect(Like.last.rating).to eq -1
    expect(Like.last.user).to eq user
    expect(Like.last.likable).to eq likable
  end

  it '#rating_sum' do
    likable = create(model.to_s.underscore.to_sym)
    likable.rate_up(user)
    likable.rate_up(new_user)
    expect(likable.rating_sum).to eq 2
  end

  it '#like_of' do
    before do
      @likable = create(model.to_s.underscore.to_sym)
      @likable.rate_up(user)
    end

    it 'true if resource has like from user' do
      expect(@likable).to be_like_of(user)
    end

    it 'false if resource has no like from user' do
      expect(@likable).to_not be_like_of(new_user)
    end
  end
end

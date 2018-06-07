require 'rails_helper'

RSpec.shared_examples_for 'likable' do
  let(:model) { described_class }
  let(:user) { create(:user) }

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
end

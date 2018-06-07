module Likable
  extend ActiveSupport::Concern

  included do
    has_many :likes, dependent: :destroy, as: :likable
  end

  def rate_up(user)
    like = likes.build(rating: 1)
    like.user = user
    like.save
  end

  def rate_down(user)
    like = likes.build(rating: -1)
    like.user = user
    like.save
  end
end

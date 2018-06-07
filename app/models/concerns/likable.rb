module Likable
  extend ActiveSupport::Concern

  included do
    has_many :likes, dependent: :destroy, as: :likable
  end

  def rate_up(user)
    likes.create!(user: user, rating: 1) unless like_of?(user)
  end

  def rate_down(user)
    likes.create!(user: user, rating: -1) unless like_of?(user)
  end

  def like_of?(user)
    likes.exists?(user: user)
  end

  def rating_sum
    likes.sum(:rating)
  end
end

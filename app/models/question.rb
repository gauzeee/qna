class Question < ApplicationRecord
  include Likable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachable
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  belongs_to :user
  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :today_new, -> { where(created_at: Date.today.all_day) }

  after_create { subscribe(user) }

  def current_best_answer
    self.answers.current_best.first
  end

  def got_best?
    self.answers.current_best.exists?
  end

  def subscribe(user)
    subscriptions.create(user: user)
  end

  def unsubscribe(user)
    subscriptions.find_by(user: user).destroy
  end

  def subscribed?(user)
    subscriptions.exists?(user: user)
  end
end

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, presence: true

  scope :current_best, -> { where(best: true) }
  scope :not_best, -> { where(best: false) }
end

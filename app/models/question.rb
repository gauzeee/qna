class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  validates :title, :body, presence: true

  def current_best_answer
    self.answers.current_best.first
  end

  def got_best?
    self.answers.current_best.exists?
  end
end

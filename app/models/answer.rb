class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, presence: true

  scope :current_best, -> { where(best: true) }
  scope :not_best, -> { where(best: false) }

  def update_best
    self.question.current_best_answer.update(best: false) if self.question.got_best?
    self.update(best: true)
  end
end

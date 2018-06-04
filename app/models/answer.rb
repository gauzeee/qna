class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, dependent: :destroy, as: :attachmentable

  validates :body, presence: true

  accepts_nested_attributes_for :attachments

  scope :current_best, -> { where(best: true) }
  scope :not_best, -> { where(best: false) }

  def update_best
    Answer.transaction do
      self.question.current_best_answer.update!(best: false) if self.question.got_best?
      self.update!(best: true)
    end
  end
end

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachable

  belongs_to :user
  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments

  def current_best_answer
    self.answers.current_best.first
  end

  def got_best?
    self.answers.current_best.exists?
  end
end

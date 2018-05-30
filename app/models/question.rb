class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  validates :title, :body, presence: true

  def best_answer
    self.answers.find_all{ |a| a.best == true }
  end
end

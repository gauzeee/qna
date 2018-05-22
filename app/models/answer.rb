class Answer < ApplicationRecord
  validates :title, :body, presence: true
  belongs_to :question
end

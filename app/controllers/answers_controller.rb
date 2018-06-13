class AnswersController < ApplicationController
  include Liked

  before_action :authenticate_user!, only: %i(update create destroy set_best rate_up rate_down rate_revoke)
  before_action :find_question, only: %i(create)
  before_action :find_answer, only: %i(update destroy set_best)
  after_action :publish_answer, only: [:create]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
    @comment = Comment.new
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @comment = Comment.new
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def set_best
    @answer.update_best if current_user.author_of?(@answer.question)
  end

  private

  def publish_answer
    return if @answer.errors.any?
    attachments = @answer.attachments.map do |a|
      { id: a.id, file_url: a.file.url, file_name: a.file.identifier }
    end

    ActionCable.server.broadcast("answers_of_question#{@question.id}", {
                                  answer: @answer,
                                  attachments: attachments,
                                  question: @question,
                                  rating: @answer.rating_sum
      })
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end


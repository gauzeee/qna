class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i(update create destroy set_best)
  before_action :find_question, only: %i(create)
  before_action :find_answer, only: %i(update destroy set_best)

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def set_best
    @answer.update_best if current_user.author_of?(@answer.question)
  end

  private

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


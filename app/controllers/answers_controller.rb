class AnswersController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :find_question, only: %i(new create)

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end


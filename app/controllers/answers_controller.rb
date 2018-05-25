class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i(create destroy)
  before_action :find_question, only: %i(new create)
  before_action :find_answer, only: :destroy

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user == @answer.user
      @answer.destroy
      flash[:notice] = 'Answer successfully deleted.'
    else
      flash[:alert] = 'You are not an author of this answer.'
    end
    redirect_to question_path(@answer.question)
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body).merge({ user_id: current_user.id })
  end
end


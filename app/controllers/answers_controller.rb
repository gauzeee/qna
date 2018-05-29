class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i(update create destroy)
  before_action :find_question, only: :create
  before_action :find_answer, only: %i(update destroy)

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    if current_user.author_of?(@answer)
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
    params.require(:answer).permit(:body)
  end
end


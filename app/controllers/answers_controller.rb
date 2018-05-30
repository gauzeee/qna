class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i(update create destroy set_best)
  before_action :find_question, only: :create
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
    if current_user.author_of?(@answer.question)
      got_best
      @answer.best = true
      @answer.save
    end
  end

  private

  def got_best
    answers = {}
    @answer.question.answers.each do |answer|
      answers.store(answer.id, answer.best)
    end
    if answers.value?(true)
      current_best_answer = Answer.find(answers.find{ |k,v| v == true }[0])
      current_best_answer.best = false
      current_best_answer.save
    end
  end

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


class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i(new edit update create destroy)
  before_action :find_question, only: %i(show edit update destroy)

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answers = Answer.all
  end

  def new
    @question = current_user.questions.build
  end

  def edit
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def best
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = 'Question successfully deleted.'
      redirect_to questions_path
    else
      flash[:alert] = 'Only author can delete this question.'
      redirect_to question_path(@question)
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

end

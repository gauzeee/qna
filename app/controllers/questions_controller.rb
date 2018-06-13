class QuestionsController < ApplicationController
  include Liked

  before_action :authenticate_user!, only: %i(new edit update create destroy rate_up rate_down rate_revoke)
  before_action :find_question, only: %i(show edit update destroy)

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answers = Answer.all
    @answer.attachments.build
    gon.current_user = current_user
    @comment = Comment.new
  end

  def new
    @question = current_user.questions.build
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      flash[:success] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:success] = 'Question successfully deleted.'
      redirect_to questions_path
    else
      flash[:alert] = 'Only author can delete this question.'
      redirect_to question_path(@question)
    end
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
        )
      )
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

end

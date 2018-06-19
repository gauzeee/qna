class QuestionsController < ApplicationController
  include Liked

  before_action :authenticate_user!, only: %i(new edit update create destroy rate_up rate_down rate_revoke)
  before_action :find_question, only: %i(show edit update destroy)
  before_action :create_answer, only: :show

  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    gon.current_user = current_user
    @answers = Answer.all
    respond_with @question
  end

  def new
    respond_with(@question = current_user.questions.build)
  end

  def edit
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    respond_with @question
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

  def create_answer
    @answer = Answer.new
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

end

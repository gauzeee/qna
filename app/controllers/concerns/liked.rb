module Liked
  extend ActiveSupport::Concern

  included do
    before_action :set_likable, only: %i(rate_up rate_down rate_revoke)
    before_action :find_like, only: %i(rate_revoke)
  end

  def rate_up
    unless current_user.author_of?(@likable)
      @likable.rate_up(current_user)
      redirect_to polymorphic_path(@likable)
    end
  end

  def rate_down
    unless current_user.author_of?(@likable)
      @likable.rate_down(current_user)
      redirect_to polymorphic_path(@likable)
    end
  end

  def rate_revoke
    @like = @likable.likes.find_by(user_id: current_user)
    @like.destroy if @like
    redirect_to polymorphic_path(@likable)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_likable
    @likable = model_klass.find(params[:id])
  end
end

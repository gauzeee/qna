module Liked
  extend ActiveSupport::Concern

  included do
    before_action :set_likable, only: %i(rate_up rate_down rate_revoke)
  end

  def rate_up
    unless current_user.author_of?(@likable)
      @likable.rate_up(current_user)
      render_json
    end
  end

  def rate_down
    unless current_user.author_of?(@likable)
      @likable.rate_down(current_user)
      render_json
    end
  end

  def rate_revoke
    @like = @likable.likes.find_by(user_id: current_user)
    @like.destroy if @like
    render_json
  end

  private

  def render_json
    render json: { rating: @likable.likes.pluck(:rating).sum, klass: @likable.class.to_s, id: @likable.id }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_likable
    @likable = model_klass.find(params[:id])
  end
end

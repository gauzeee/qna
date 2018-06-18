require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  before_action :gon_user
  before_action :check_email_update

  def gon_user
    gon.user_id = current_user.id if user_signed_in?

    gon.is_user_signed_in = user_signed_in?
  end

  def check_email_update
    if current_user&.no_email?
      return if ['confirmations', 'sessions'].include?(controller_name)
      redirect_to set_email_user_path(current_user)
    end
  end
end

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i(set_email confirm_email)
  before_action :check_email, only: %i(set_email confirm_email)
  skip_before_action :check_email_update, only: %i(set_email confirm_email)

  def set_email
  end

  def confirm_email
    if current_user.update_attribute('email', params[:user][:email])
      redirect_to set_email_user_path(current_user)
      flash[:notice] = 'Check your mailbox to confirm email'
    else
      render :set_email
    end
  end


  private

  def user_params
    params.require(:user).permit(:email)
  end

  def check_email
    unless current_user.no_email?
      redirect_to root_path, notice: 'You already have valid email adress'
    end
  end
end

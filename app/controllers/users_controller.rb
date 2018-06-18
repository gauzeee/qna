class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i(set_email update_email)
  before_action :check_email, only: %i(set_email update_email)

  def set_email
  end

  def confirm_email
    @user = current_user
    email = params[:email]
    flash[:alert] = "#{email}"
    @@confirm_email_token = Devise.friendly_token[0, 20]
    UsersMailer.confirm_email(@@confirm_email_token, @user, email).deliver_now
    redirect_to users_confirmation_path
  end

  def confirmation
  end

  def update_email
    token = params[:token]
    if token == @@confirm_email_token
      current_user.update_attribute('email', params[:email])
      redirect_to root_path
      flash[:notice] = 'You have successfully signed up and signed in, welcome!'
    else
      render :set_email
    end
  end

  private

  def check_email
    unless current_user.no_email?
      redirect_to root_path, notice: 'You already have valid email adress'
    end
  end
end

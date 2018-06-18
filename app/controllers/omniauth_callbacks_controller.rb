class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def vkontakte
    call('Vkontakte')
  end

  def twitter
    call('Twitter')
  end

  def github
    call('GitHub')
  end

  private

  def call(kind)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.no_email?
      sign_in @user
      redirect_to set_email_user_path(current_user)
    else
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    end
  end
end


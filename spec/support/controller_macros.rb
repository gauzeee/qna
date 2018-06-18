module ControllerMacros
  def sign_in_user
    before do
      @user = create(:user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end

  def sign_in_author
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in(author)
    end
  end

  def sign_in_new_user
    before do
      @user = create(:user, email: 'change@me.please')
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end
end

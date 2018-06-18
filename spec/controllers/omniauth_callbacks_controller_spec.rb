require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'vkontakte' do
    before do
      request.env["omniauth.auth"] = OmniAuth::AuthHash.new(
      provider: :vkontakte.to_s,
      uid: '1235456',
      info: {
          email: 'test@mail.com'
      }
    )
      get :vkontakte
    end

    it 'redirects to root_path' do
      expect(response).to redirect_to(root_path)
    end

    it 'returns User' do
      expect(controller.current_user).to be_a(User)
    end
  end

  describe 'github' do
    before do
      request.env["omniauth.auth"] = OmniAuth::AuthHash.new(
      provider: :github.to_s,
      uid: '1235456',
      info: {
          email: 'test@mail.com'
      }
    )
      get :github
     end

    it 'redirects to root_path' do
      expect(response).to redirect_to(root_path)
    end

    it 'returns User' do
      expect(controller.current_user).to be_a(User)
    end
  end
end

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #set_email' do
    context 'need change email' do
      sign_in_new_user
      before { get :set_email, params: { id: @user } }

      it 'renders set_email' do
        expect(response).to render_template :set_email
      end
    end

    context 'check email' do
      sign_in_user
      before { get :set_email, params: { id: @user } }

      it 'redirects to root with real email' do
        expect(response.location).to match(root_path)
      end
    end
  end

  describe 'POST #confirm_email' do
    context 'need change email' do
      sign_in_new_user

      it 'changes user email' do
        patch :confirm_email, params: { id: @user, user: { email: 'new@email.com'} }
        @user.reload

        expect(@user.unconfirmed_email).to eq 'new@email.com'
      end

      it 'renders set_email' do
        patch :confirm_email, params: { id: @user, user: { email: 'new@email.com'} }

        expect(response.location).to match(set_email_user_path(@user))
      end
    end

    context 'check email' do
      sign_in_user

      it 'redirects to verify user' do
        patch :confirm_email, params: { id: @user, user: { email: 'new@email.com'} }
        @user.reload

        expect(@user.unconfirmed_email).to_not eq 'new@email.com'
      end
    end
  end
end

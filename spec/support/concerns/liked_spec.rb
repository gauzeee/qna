require 'rails_helper'

RSpec.shared_examples 'liked' do
  let(:model) { described_class.controller_name.classify.constantize }
  let(:likable) { create(model.to_s.underscore.to_sym) }

  describe 'POST #rate_up' do

    context 'current user is not author of resource' do
      sign_in_user
      it 'assigns the requested resource to @likable' do
        post :rate_up, params: { id: likable }
        expect(assigns(:likable)).to eq likable
      end
      it 'set new like' do
        expect { post :rate_up, params: { id: likable } }.to change(likable.likes, :count).by(1)
      end

      it 'create two likes for one resource' do
        post :rate_down, params: { id: likable }
        expect { post :rate_down, params: { id: likable } }.to_not change(Like, :count)
      end
    end

    context 'current user is author of resource' do
      sign_in_user
      let!(:user_likable) { create(model.to_s.underscore.to_sym, user: @user) }
      it 'try to save new like' do
        expect { post :rate_up, params: { id: user_likable } }.to_not change(Like, :count)
      end
    end

    context 'Non-authenticated user delete resource' do
      it 'try to save new like' do
        expect { post :rate_up, params: { id: likable } }.to_not change(Like, :count)
      end
    end
  end

  describe 'POST #rate_down' do
    context 'current user is not author of resource' do
      sign_in_user
      it 'assigns the requested resource to @likable' do
        post :rate_down, params: { id: likable }
        expect(assigns(:likable)).to eq likable
      end
      it 'create new vote' do
        expect { post :rate_down, params: { id: likable } }.to change(likable.likes, :count).by(1)
      end

      it 'create two likes for one resource' do
        post :rate_down, params: { id: likable }
        expect { post :rate_down, params: { id: likable } }.to_not change(Like, :count)
      end
    end

    context 'current user is author of resource' do
      sign_in_user
      let!(:user_likable) { create(model.to_s.underscore.to_sym, user: @user) }
      it 'try to save new like' do
        expect { post :rate_down, params: { id: user_likable } }.to_not change(Like, :count)
      end
    end

    context 'Non-authenticated user' do
      it 'try to save new like' do
        expect { post :rate_down, params: { id: likable } }.to_not change(Like, :count)
      end
    end
  end

  describe 'DELETE #rate_revoke' do

    context 'current user revoke his like' do
      sign_in_user
      let!(:like) { create(:like, likable: likable, user: @user) }

      it 'assigns the requested resource to @likable' do
        delete :rate_revoke, params: { id: likable }
        expect(assigns(:likable)).to eq likable
      end
      it 'delete like' do
        expect { delete :rate_revoke, params: { id: likable } }.to change(likable.likes, :count).by(-1)
      end
    end

    context 'current user' do
      let(:new_user) { create(:user) }
      let!(:new_like) { create(:like, likable: likable, user: new_user) }

      it 'try to revoke like of other user' do
        expect { delete :rate_revoke, params: { id: likable } }.to_not change(Like, :count)
      end
    end

    context 'Non-authenticated user' do
      it 'try to revoke like' do
        expect { delete :rate_revoke, params: { id: likable } }.to_not change(Like, :count)
      end
    end
  end
end

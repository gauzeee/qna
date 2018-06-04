require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  describe "DELETE #destroy" do
    let(:question) { create(:question) }
    let!(:file) { create(:attachment, attachable: question) }

    context 'user is author of attachment' do
      sign_in_user

      let!(:new_question) { create(:question, user: @user) }
      let!(:new_file) { create(:attachment, attachable: new_question)}

      it 'delete attachment' do
        expect { delete :destroy, params: { id: new_file }, format: :js }.to change(Attachment, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: new_file }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'user is not author of attachment' do
      sign_in_user
      it 'delete attachment' do
        expect { delete :destroy, params: { id: file }, format: :js }.to_not change(Attachment, :count)
      end
    end

    context 'non-authenticated user delete attachment' do
      it 'delete attachment' do
        expect { delete :destroy, params: { id: file }, format: :js }.to_not change(Attachment, :count)
      end

      it 'redirect to new session view' do
        delete :destroy, params: { id: file }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end

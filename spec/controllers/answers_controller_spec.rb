require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do

    sign_in_user

    it 'assigns the request question to @questiuon' do
      post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
      expect(assigns(:question)).to eq question
    end

    context 'with valid attributes' do
      it 'saves the new answer' do
      expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
    end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end

      it 'created by current user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer).user_id).to eq @user.id
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js } }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:author) { create(:user) }
    let!(:answer) { create(:answer, question: question )}

    context 'User is author of answer' do
      sign_in_author

      let!(:author_answer) { create(:answer, question: question, user: author )}

      it 'delete answer' do
        expect { delete :destroy, params: { id: author_answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirect to question show view' do
        delete :destroy, params: { id: author_answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'User is not author of answer' do
      sign_in_user

      it 'delete answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirect to show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer) }

    context '' do
      sign_in_user

      it 'assigns the request answer to @answer' do
      patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
      expect(assigns(:answer)).to eq answer
    end

      it 'render update template' do
        patch :update, params: { id: answer, answer: { body: 'new body'}, format: :js }
        expect(response).to render_template :update
      end
    end

    context 'current user is author of answer' do
      @user = sign_in_user
      let!(:user_answer) { create(:answer, question: question, user: @user) }

      it 'change answer attributes' do
        patch :update, params: { id: user_answer, answer: { body: 'new body'}, format: :js }
        user_answer.reload
        expect(user_answer.body).to eq 'new body'
      end
    end

    context 'current user is not author of answer' do
    sign_in_user

      it 'change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body'}, format: :js }
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end

    context 'non-authenticated user edit question' do
      it 'change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body'}, format: :js }
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end
  end

end

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
        expect { delete :destroy, params: { id: author_answer }, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'User is not author of answer' do
      sign_in_user

      it 'delete answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end
    end

    context 'non-authenticated user delete question' do
      it 'deletes answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'redirect to new session view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #set_best' do
    let(:author) { create(:user) }
    let(:new_question) { create(:question, user: author)}
    let(:answer) { create(:answer, question: new_question) }

    context 'current user is author of question' do
      sign_in_author

      it 'assigns the request answer to @answer' do
        patch :set_best, params: { id: answer, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'render set_best template' do
        patch :set_best, params: { id: answer, answer: { body: 'new body'}, format: :js }
        expect(response).to render_template :set_best
      end

      it 'change answer attributes' do
        patch :set_best, params: { id: answer, answer: { best: true }, format: :js }
        answer.reload
        expect(answer.best).to eq true
      end
    end

    context 'current user is not author of question' do
      sign_in_user
      it 'change answer attributes' do
        patch :set_best, params: { id: answer, answer: { best: true }, format: :js }
        answer.reload
        expect(answer.best).to_not eq true
      end
    end

    context 'non-authenticated user try set best answer for question' do
      it 'change answer attributes' do
        patch :set_best, params: { id: answer, answer: { best: true }, format: :js }
        answer.reload
        expect(answer.best).to_not eq true
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer) }

    context 'current user is author of answer' do
      sign_in_user
      let!(:new_answer) { create(:answer, question: question, user: @user) }

      it 'assigns the request answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'render update template' do
        patch :update, params: { id: answer, answer: { body: 'new body'}, format: :js }
        expect(response).to render_template :update
      end

      it 'change answer attributes' do
        patch :update, params: { id: new_answer, answer: { body: 'new body'}, format: :js }
        new_answer.reload
        expect(new_answer.body).to eq 'new body'
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

    context 'non-authenticated user edit answer' do
      it 'change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body'}, format: :js }
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end
  end

  it_behaves_like 'liked'
end

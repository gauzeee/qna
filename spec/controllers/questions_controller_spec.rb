require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let!(:answers) { create_list(:answer, 2) }

    before { get :show, params: { id: question } }

    it 'assigns the requested questions to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assign a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'populates an array of all answers' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user

    before { get :edit, params: { id: question } }

    it 'assigns the requested questions to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new question' do
        expect { post :create, params: { user_id: author, question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'created by current user' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question).user_id).to eq @user.id
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'add subscription' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question).subscribers).to include @user
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    before { question }

    context 'user is author of question' do
      sign_in_author

      it 'delete question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'user is not author of question' do
      sign_in_user

      it 'delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect to show view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'GET #edit' do
    sign_in_user

    before { get :edit, params: { id: question } }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do

    describe 'current user is author of question' do
      @user = sign_in_user
      let!(:user_question) { create(:question, user: @user) }

      context 'valid attributes' do
        it 'assings the requested question to @question' do
          patch :update, params: { id: user_question, question: attributes_for(:question), format: :js }
          expect(assigns(:question)).to eq user_question
        end

        it 'changes question attributes' do
          patch :update, params: { id: user_question, question: { title: 'new title', body: 'new body'}, format: :js }
          user_question.reload
          expect(user_question.title).to eq 'new title'
          expect(user_question.body).to eq 'new body'
        end

        it 'redirects to the updated question' do
          patch :update, params: { id: user_question, question: attributes_for(:question), format: :js }
          expect(response).to redirect_to user_question
        end
      end

      context 'invalid attributes' do
        before { patch :update, params: { id: user_question, question: { title: 'new title', body: nil}, format: :js } }

        it 'does not change question attributes' do
          user_question.reload
          expect(user_question.title).to_not eq 'new title'
          expect(user_question.body).to_not eq 'new body'
        end

        it 'render update template' do
          expect(response).to render_template :update
        end
      end
    end

    describe 'current user is not author of question' do
      sign_in_user

      it 'change question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body'}, format: :js }
        question.reload
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end
    end

    describe 'non-authenticated user edit question' do
      it 'change question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body'}, format: :js }
        question.reload
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end
    end
  end

  it_behaves_like 'liked'
end

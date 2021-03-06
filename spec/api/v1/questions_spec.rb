require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:question) { create(:question) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answer) { create(:answer, question: question) }
      let(:user) { create(:user) }
      let!(:comment) { create(:comment, commentable: question, user: user) }
      let!(:attachment) { create(:attachment, attachable: question)}

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w[id title body created_at updated_at].each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("comments")
        end

        %w[id body created_at updated_at].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("attachments")
        end

        %w[id created_at updated_at].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
          end
        end

        it 'contains link' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/link")
        end
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("answers")
        end

        %w[id body created_at updated_at].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        it 'save new question' do
          expect { post "/api/v1/questions", params: { format: :json, question: attributes_for(:question), access_token: access_token.token } }.to change(Question, :count).by(1)
        end

        it 'create new question' do
          post "/api/v1/questions", params: { format: :json, question: attributes_for(:question), access_token: access_token.token }
          expect(response.status).to eq 201
        end

        it 'question has association with user' do
          expect { post "/api/v1/questions", params: { format: :json, question: attributes_for(:question), access_token: access_token.token } }.to change(user.questions, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not save question' do
          expect { post "/api/v1/questions", params: { format: :json, question: attributes_for(:invalid_question), access_token: access_token.token } }.to_not change(Question, :count)
          expect(response.status).to eq 422
        end

        it 'does not create question' do
          post "/api/v1/questions", params: { format: :json, question: attributes_for(:invalid_question), access_token: access_token.token }
          expect(response.status).to eq 422
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions", params: { format: :json }.merge(options)
    end
  end
end

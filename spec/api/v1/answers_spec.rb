require 'rails_helper'

describe 'Questions API' do
  let!(:question) { create(:question) }

  describe 'GET /index' do

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2)
      end

      %w[id body created_at updated_at].each do |attr|
        it "answer object contains #{attr}" do
          answer = answers.first
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end

    def do_request(options = {})
    get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end

  end

  describe 'GET /show' do
    let(:answer) { create(:answer) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let!(:comment) { create(:comment, commentable: answer, user: user) }
      let!(:attachment) { create(:attachment, attachable: answer)}

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w[id body created_at updated_at].each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
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
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        it 'save answer' do
          expect { post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: attributes_for(:answer), access_token: access_token.token } }.to change(question.answers, :count).by(1)
        end

        it 'create new answer' do
          post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: attributes_for(:answer), access_token: access_token.token }
          expect(response.status).to eq 201
        end

        it 'answer has association with user' do
          expect { post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: attributes_for(:answer), access_token: access_token.token } }.to change(user.answers, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not save answer' do
          expect { post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: attributes_for(:invalid_answer), access_token: access_token.token } }.to_not change(Answer, :count)
        end

        it 'does not create answer' do
          post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: attributes_for(:invalid_answer), access_token: access_token.token }
          expect(response.status).to eq 422
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end
end

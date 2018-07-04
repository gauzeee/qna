require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    Search::CATEGORIES.each do |resource|
      it "serching for #{resource}" do
        expect(Search).to receive(:find).with('some query', resource)
        get :index, params: { query: 'some query', resource: resource }
      end
    end
    it "renders index template" do
      get :index, params: { query: 'some query', resource: 'All' }
      expect(response).to render_template :index
    end
  end
end

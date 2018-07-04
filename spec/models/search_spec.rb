require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.find' do
    Search::CATEGORIES.each do |resource|
      it "return an array of #{resource}" do
        expect(Search).to receive(:find).with('some query', resource)
        Search.find('some query', "#{resource}")
      end
    end

    it 'return empty array if query is empty' do
      expect(Search).to receive(:find).with(' ', 'All').and_return([])
      Search.find(' ', 'All')
    end
  end
end

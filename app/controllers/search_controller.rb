class SearchController < ApplicationController
  def index
    @results = Search.find(params[:query], params[:resource])
  end
end

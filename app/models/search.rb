class Search < ApplicationRecord
  CATEGORIES = ['Questions', 'Answers', 'Comments', 'Users', 'All'].freeze

  def self.find(query, resource)
    query = ThinkingSphinx::Query.escape(query) if query.present?
    if resource == 'All'
      ThinkingSphinx.search(query)
    else
      resource.classify.constantize.search(query)
    end
  end
end

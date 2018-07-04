class Search < ApplicationRecord
  CATEGORIES = ['Questions', 'Answers', 'Comments', 'Users', 'All'].freeze

  def self.find(query, resource)
    if query.present?
      do_search(query, resource)
    else
      []
    end
  end

  def self.do_search(query, resource)
    query = ThinkingSphinx::Query.escape(query)
    if resource == 'All'
      ThinkingSphinx.search(query)
    else
      resource.classify.constantize.search(query)
    end
  end
end

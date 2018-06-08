require 'rails_helper'
Capybara.server = :puma
Capybara.javascript_driver = :webkit
RSpec.configure do |config|

  config.use_transactional_fixtures = false

  config.include FeaturesHelper, type: :feature

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end


end

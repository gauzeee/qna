require 'rails_helper'
Capybara.server = :puma
Capybara.javascript_driver = :webkit
OmniAuth.config.test_mode = true
RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.include FeaturesHelper, type: :feature
  config.include OmniauthMacros, type: :feature

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

  config.include SphinxHelpers, type: :feature

  config.before(:suite) do
    # Ensure sphinx directories exist for the test environment
    ThinkingSphinx::Test.init
    # Configure and start Sphinx, and automatically
    # stop Sphinx at the end of the test suite.
    ThinkingSphinx::Test.start_with_autostop
  end
end

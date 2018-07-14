source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.1'

gem 'rails', '~> 5.2.0'
gem 'pg'
gem 'puma', '~> 3.11'
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'slim-rails'
gem 'devise'
gem 'jquery-rails'
gem 'json'
gem 'carrierwave'
gem 'cocoon'
gem 'bootstrap'
gem 'gon'
gem 'skim'
gem 'sprockets'
gem 'responders', '~> 2.0'
gem 'omniauth'
gem 'omniauth-vkontakte'
gem 'omniauth-github'
gem 'cancancan'
gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'
gem 'dotenv'
gem 'dotenv-rails'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'doorkeeper', '4.2.6'
gem 'sidekiq'
gem 'mysql2'
gem 'thinking-sphinx'
gem 'whenever'
gem 'sinatra', '>= 1.3.0', require: nil
gem 'sidetiq'
gem 'unicorn'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'capybara-webkit'
  gem 'letter_opener'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'thinking-sphinx'
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
  gem 'shoulda-matchers'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'capybara-email'
  gem 'json_spec'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

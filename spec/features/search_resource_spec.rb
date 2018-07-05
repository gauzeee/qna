require_relative 'acceptance_helper'

feature 'Search', %q{
  In order to find some resources
  As a user
  I want to be able to use search
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer) }
  given!(:comment) { create(:comment, commentable: question, user: user) }
  given!(:new_question) { create(:question, title: 'find me') }
  given!(:new_answer) { create(:answer, body: 'find me') }
  given!(:new_comment) { create(:comment, commentable: question, user: user, body: 'find me') }
  given!(:new_user) { create(:user, email: 'find@me.com') }

  before do
    visit root_path
    click_on 'search-link'
  end

  scenario 'search for question', js: true, sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: question.title
      select('Questions', from: 'resource').select_option
      click_on 'Go!'
      expect(page).to have_content question.title
    end
  end
  scenario 'search for answer', js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: answer.body
      select('Answers', from: 'resource').select_option
      click_on 'Go!'
      expect(page).to have_content answer.body
    end
  end
  scenario 'search for comment', js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: comment.body
      select 'Comments', from: 'resource'
      click_on 'Go!'
      expect(page).to have_content comment.body
    end
  end
  scenario 'search for user', js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: user.email
      select 'Users', from: 'resource'
      click_on 'Go!'
      expect(page).to have_content user.email
    end
  end
  scenario 'search for all', js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: 'find me'
      select 'All', from: 'resource'
      click_on 'Go!'
      expect(page).to have_content new_question.title
      expect(page).to have_content new_answer.body
      expect(page).to have_content new_comment.body
      expect(page).to have_content new_user.email
    end
  end

  scenario 'empty search all', js: true, sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: ''
      select 'All', from: 'resource'
      click_on 'Go!'
      expect(page).to have_content 'We can`t find anything'
    end
  end
end

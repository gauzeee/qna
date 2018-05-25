require 'rails_helper'

feature 'User can view questions list', %q{
  In order to look for interesting question
  As an user
  I want to able to view all questions
} do
  given!(:questions) { create_list(:question, 2) }
  scenario 'All users can view questions list' do
    visit questions_path
    save_and_open_page
    expect(page).to have_content questions.first.title
    expect(page).to have_content questions.last.title
    expect(page).to have_content questions.first.body
    expect(page).to have_content questions.last.body
  end
end

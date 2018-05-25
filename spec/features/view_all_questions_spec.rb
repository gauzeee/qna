require 'rails_helper'

feature 'User can view questions list', %q{
  In order to look for interesting question
  As an user
  I want to able to view all questions
} do

  scenario 'All users can view questions list' do
    visit question_path

    expect(page).to have_content 'Questions'
  end
end

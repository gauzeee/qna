require 'rails_helper'

feature 'User can view question and answers', %q{
  In order to find problem solution
  As an user
  I want to be able to see question and answers for it
} do
  given(:question) { create(:question) }

  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'User can view question and answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content answers.first.body
    expect(page).to have_content answers.last.body
  end
end

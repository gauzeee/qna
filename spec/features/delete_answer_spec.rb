require_relative 'acceptance_helper'

feature 'User delete answer', %q{
  In order to be able to delte answer
  As an authenticated user
  I want to be able to delete answer
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: author) }

  before do
    question
    answer
  end

  scenario 'Author delete answer', js: true do
    sign_in(author)
    visit question_path(question)
    click_on 'Delete answer'
    expect(page).to_not have_content answer.body

  end

  scenario 'Not author delete answer' do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Non-authenticated user delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end

require_relative 'acceptance_helper'

feature 'User create answers for question', %q{
  In order to help with problem of question
  As an authenticated user
  I want to be able to create new answer
} do
  given(:user) { create(:user) }

  given(:question) { create(:question) }

  scenario 'Authenticated user create answer for question', js: true do
    sign_in(user)

    new_answer(question)

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'Answer text'
    end
  end

  scenario 'Authenticated user create answer with invalid attributes', js: true do
    sign_in(user)

    visit question_path(question)
    within('.answer-form') do
      click_on 'New answer'
    end

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Non-authenticated user try to create new answer' do
    new_answer(question)

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end

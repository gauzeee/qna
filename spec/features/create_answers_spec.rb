require 'rails_helper'

feature 'User create answers for question', %q{
  In order to help with problem of question
  As an authenticated user
  I want to be able to create new answer
} do
  given(:user) { create(:user) }

  given(:question) { create(:question) }

  scenario 'Authenticated user create answer for question' do
    sign_in(user)

    new_answer(question)

    expect(page).to have_content 'Answer text'
  end

  scenario 'Authenticated user create answer with invalid attributes' do
    sign_in(user)

    new_invalid_answer(question)

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Non-authenticated user try to create new answer' do
    new_answer(question)

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end

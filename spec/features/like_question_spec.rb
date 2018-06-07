require_relative 'acceptance_helper'

feature 'Like question', %q{
  In order to show that question is good
  As an authenticated user
  I'd like to be able to set like for question
} do

  given(:user) {  create(:user) }
  given(:question) { create(:question) }
  given(:user_question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'user set like', js: true do
    within('.question .rating') do
      click_on '+'
      expect(page).to have_content '1'
      expect(page).to have_content 'Revoke my like'
    end
  end

  scenario 'user set like again', js: true do
    within('.question .rating') do
      click_on '+'
      click_on '+'
      expect(page).to have_content '1'
    end
  end

  scenario 'user revoke his like', js: true do
    within('.question .rating') do
      click_on '+'
      click_on 'Revoke my like'
      expect(page).to have_content '0'
      expect(page).to_not have_content 'Revoke my like'
    end
  end

  scenario 'user set dislike', js: true do
    within('.question .rating') do
      click_on '-'
      expect(page).to have_content '-1'
    end
  end

  scenario 'Author of question try to set like' do
    visit question_path(user_question)
    expect(page).to_not have_link '+'
    expect(page).to_not have_link '-'
  end
end

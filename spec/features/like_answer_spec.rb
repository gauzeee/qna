require_relative 'acceptance_helper'

feature 'Like answer', %q{
  In order to show that answer is good
  As an authenticated user
  I'd like to be able to set like for answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:user_answer) { create(:answer, question: question, user: user) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'user set like', js: true do
    within(".answers .answer-#{answer.id}") do
      click_on '+'
      expect(page).to have_content '1'
      expect(page).to have_content 'Revoke my like'
    end
  end

  scenario 'user set like again', js: true do
    within(".answers .answer-#{answer.id}") do
      click_on '+'
      click_on '+'
      expect(page).to have_content '1'
    end
  end

  scenario 'user revoke his like', js: true do
    within(".answers .answer-#{answer.id}") do
      click_on '+'
      click_on 'Revoke my like'
      expect(page).to have_content '0'
      expect(page).to_not have_content 'Revoke my like'
    end
  end

    scenario 'user set dislike', js: true do
      within(".answers .answer-#{answer.id}") do
        click_on '-'
        expect(page).to have_content '-1'
      end
    end

  scenario 'author of answer try to set like' do
    within(".answers .answer-#{user_answer.id}") do
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
    end
  end
end

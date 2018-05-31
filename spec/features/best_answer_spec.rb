require_relative 'acceptance_helper'

feature 'Set best answer', %q{
  In order to choose answer that is the best
  As an authenticated user
  I want to be able to set best answer for my question
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Authenticated user try to set best answer' do
    describe 'User is an author of the question' do

      before do
        sign_in(author)
      end

      scenario 'author sees Set Best link', js: true do
        new_answer(question)
        expect(page).to have_link 'Set Best'
      end

      scenario 'can set best answer', js: true do
        new_answer(question)
        click_on 'Set Best'
        within('.best-answer') do
          expect(page).to have_content 'Answer text'
        end
      end

      scenario 'can set another answer as best', js: true do
        new_answer(question)

        click_on 'Set Best'
        within('.best-answer') do
          expect(page).to have_content 'Answer text'
        end
        one_more_answer(question)
        within('.answers') do
          click_on 'Set Best'
        end

        within('.best-answer') do
          expect(page).to_not have_content 'Answer text'
          expect(page).to have_content 'One more answer'
        end
      end
    end
  end
  scenario 'Non-authenticated user try to set best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Set Best'
  end
end

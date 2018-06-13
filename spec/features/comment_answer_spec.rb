require_relative 'acceptance_helper'

feature 'Add comment to answer', %q{
  In order to express my opinion on the answer
  As an authenticate user
  I'd  like to be able to comment on the answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticate user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'see link to New comment' do
      within('.answers') do
        expect(page).to have_link 'New comment'
      end
    end

    describe 'try to add comment to answer' do
      scenario 'with valid attributes', js: true do
        within('.answers') do
          click_on 'New comment'
          fill_in 'comment_body', with: 'New answer comment text'
          click_on 'Create Comment'
          expect(page).to have_content 'New answer comment text'
        end
      end

      scenario 'with invalid attributes', js: true do
        within('.answers') do
          click_on 'New comment'
          fill_in 'comment_body', with: nil
          click_on 'Create Comment'
          expect(page).to have_content "Body can't be blank"
        end
      end
    end
  end

  context 'multiple sessions' do
    scenario "answers's comment appear on another question user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within('.answers') do
          click_on 'New comment'
          fill_in 'comment_body', with: 'My comment text'
          click_on 'Create Comment'
          expect(page).to have_content 'My comment text'
        end
      end

      Capybara.using_session('guest') do
        within('.answers') do
          expect(page).to have_content 'My comment text'
        end
      end
    end
  end
end

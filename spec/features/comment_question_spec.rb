require_relative 'acceptance_helper'

feature 'Add comment to question', %q{
  In order to express my opinion on the question
  As an authenticate user
  I'd  like to be able to comment on the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticate user' do
    background do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'see link to New comment' do
      expect(page).to have_link 'New comment'
    end

    describe 'try to add comment to question' do
      scenario 'with valid attributes', js: true do
        within('.question') do
          click_on 'New comment'
          fill_in 'comment_body', with: 'New comment text'
          click_on 'Create Comment'
        end
        expect(page).to have_content 'New comment text'
      end

      scenario 'with invalid attributes', js: true do
        within('.question') do
          click_on 'New comment'
          fill_in 'comment_body', with: nil
          click_on 'Create Comment'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  context 'multiple sessions' do
    scenario "question's comment appear on another question user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within('.question') do
          click_on 'New comment'
          fill_in 'New commet', with: 'My comment'
          click_on 'Create Comment'
        end
        expect(page).to have_content 'My comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'My comment'
      end
    end
  end
end

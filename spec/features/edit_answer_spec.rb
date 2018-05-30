require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I want to be able to edit answer
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'sees link to Edit' do
      sign_in author
      visit question_path(question)
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'try to edit his answer', js: true do
      sign_in author
      visit question_path(question)
      within('.answers') do
        click_on 'Edit'
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

    scenario 'try to edit answer of other user' do
      sign_in(user)
      visit question_path(question)
      within('.answers') do
        expect(page).to_not have_link 'Edit'
      end
    end
end
